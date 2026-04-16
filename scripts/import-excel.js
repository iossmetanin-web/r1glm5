/**
 * Импорт данных из Excel файлов в Supabase
 * 
 * Запуск: node scripts/import-excel.js
 * 
 * Скрипт читает 6 Excel файлов, парсит данные и генерирует SQL файл
 * для выполнения в Supabase SQL Editor.
 * 
 * Генерирует: supabase/migrations/002_import_excel_data.sql
 */
const XLSX = require('xlsx');
const fs = require('fs');
const path = require('path');

// ─── Excel serial date → JS Date → SQL date ──────────────────────────
function excelDateToSQL(serialOrStr) {
  if (!serialOrStr) return null;
  
  // Already a date string like "29/08/2025" or "22.12.2025"
  if (typeof serialOrStr === 'string' && serialOrStr.length > 4) {
    // Try DD/MM/YYYY
    let m = serialOrStr.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/);
    if (m) return `${m[3]}-${m[2].padStart(2,'0')}-${m[1].padStart(2,'0')}`;
    
    // Try DD.MM.YYYY
    m = serialOrStr.match(/^(\d{1,2})\.(\d{1,2})\.(\d{4})$/);
    if (m) return `${m[3]}-${m[2].padStart(2,'0')}-${m[1].padStart(2,'0')}`;
    
    return null;
  }
  
  // Excel serial number (days since 1900-01-01)
  const serial = Number(serialOrStr);
  if (isNaN(serial) || serial < 10000) return null;
  
  const utc_days = Math.floor(serial - 25569); // 25569 = Unix epoch in Excel serial
  const ms = utc_days * 86400 * 1000;
  const d = new Date(ms);
  return d.toISOString().slice(0, 10);
}

// ─── Parse "Компания и ИНН" field ───────────────────────────────────
function parseCompanyInn(raw) {
  if (!raw) return { name: '', inn: '', city: '' };
  const s = String(raw).trim();
  
  // Pattern: "ООО 'Название' ИНН: 1234567890"
  let m = s.match(/^(.+?)\s+ИНН[:\s]*(\d{10,})/i);
  if (m) return { name: m[1].trim(), inn: m[2].trim(), city: '' };
  
  // Pattern: "Название, 1234567890" or "Название 1234567890"
  m = s.match(/^(.+?)[,\s]+(\d{10,})$/);
  if (m) return { name: m[1].trim(), inn: m[2].trim(), city: '' };
  
  // Pattern: "Название" (no INN)
  return { name: s.replace(/"/g, '\'').trim(), inn: '', city: '' };
}

// ─── Parse "Контактные данные" → phone, email ───────────────────────
function parseContacts(raw) {
  if (!raw) return { phone: '', email: '', website: '' };
  const s = String(raw).trim();
  
  let phone = '';
  let email = '';
  let website = '';
  
  // Extract website
  const urlMatch = s.match(/(https?:\/\/[^\s]+|www\.[^\s]+)/i);
  if (urlMatch) website = urlMatch[1];
  
  // Extract email
  const emailMatch = s.match(/([\w.-]+@[\w.-]+\.\w{2,})/i);
  if (emailMatch) email = emailMatch[1];
  
  // Extract phone (Russian format)
  const phones = [];
  const phoneMatches = s.matchAll(/(\+7[\s()-]*\d{3}[\s()-]*\d{3}[\s()-]*\d{2}[\s()-]*\d{2}|\d[\s()-]*\d{3}[\s()-]*\d{3}[\s()-]*\d{2}[\s()-]*\d{2}|8\d{10})/g);
  for (const pm of phoneMatches) {
    let p = pm[1].replace(/\s/g, '').replace(/[()-]/g, '');
    if (p.length >= 10 && !p.includes('@') && !p.startsWith('http')) {
      phones.push(p);
    }
  }
  phone = phones[0] || '';
  
  return { phone, email, website };
}

// ─── Parse "ФИО и контакты ЛПР" → name, phone, email, position ─────
function parseLPR(raw) {
  if (!raw) return [];
  const s = String(raw).trim();
  if (!s || s === 'нету' || s === 'Нету') return [];
  
  const contacts = [];
  
  // Split by newlines (multiple LPR separated by newlines)
  const lines = s.split(/\n/).map(l => l.trim()).filter(Boolean);
  
  let currentName = '';
  let currentPhone = '';
  let currentEmail = '';
  let currentPosition = '';
  
  for (const line of lines) {
    // Check if this line is a phone
    if (/^(\+7|8)\d/.test(line.replace(/[\s()-]/g, '')) && line.replace(/[\s()-]/g, '').length >= 10) {
      currentPhone = line.replace(/[\s()-]/g, '');
      continue;
    }
    
    // Check if this line is an email
    if (/@/.test(line) && /\.\w{2,}$/.test(line)) {
      currentEmail = line.trim();
      continue;
    }
    
    // Check if this line is a position
    if (/^(закупщик|директор|главный|начальник|менеджер|инженер|руководитель|гл\.)|отдел/i.test(line)) {
      currentPosition = line.trim();
      continue;
    }
    
    // Otherwise it's a name or new contact
    if (currentName && (currentPhone || currentEmail)) {
      contacts.push({
        name: currentName,
        phone: currentPhone || null,
        email: currentEmail || null,
        position: currentPosition || null,
      });
      currentPhone = '';
      currentEmail = '';
      currentPosition = '';
    }
    
    // Clean name
    currentName = line
      .replace(/[\d+\s()-@.]/g, '') // remove numbers and special chars
      .replace(/тел/i, '')
      .replace(/добавочно\s*\d+/i, '')
      .trim();
    
    // Also try to extract phone/email from same line
    const phoneInLine = line.match(/(\+7[\s()-]*\d{3}[\s()-]*\d{3}[\s()-]*\d{2}[\s()-]*\d{2})/);
    if (phoneInLine) currentPhone = phoneInLine[1].replace(/[\s()-]/g, '');
    
    const emailInLine = line.match(/([\w.-]+@[\w.-]+\.\w{2,})/i);
    if (emailInLine) currentEmail = emailInLine[1];
  }
  
  // Push last contact
  if (currentName) {
    contacts.push({
      name: currentName,
      phone: currentPhone || null,
      email: currentEmail || null,
      position: currentPosition || null,
    });
  }
  
  return contacts.filter(c => c.name && c.name.length > 1);
}

// ─── SQL Escape ─────────────────────────────────────────────────────
function sqlEscape(str) {
  if (str === null || str === undefined) return 'NULL';
  return "'" + String(str).replace(/'/g, "''").replace(/\n/g, ' ').replace(/\r/g, '') + "'";
}

// ─── Main Import Logic ──────────────────────────────────────────────
function main() {
  const BASE = path.join(__dirname, '..', 'upload');
  
  // Manager IDs will be placeholder UUIDs — user needs to replace with real ones
  // Or we can look them up after import
  const MANAGER_MAP = {
    'алик': 'MANAGER_ALIK_ID',
    'магел': 'MANAGER_MAGEL_ID',
    'рам': 'MANAGER_RAM_ID',
    'анар': 'MANAGER_ANAR_ID',
  };
  
  const allCompanies = [];
  const allContacts = [];
  const allActivities = [];
  const allProposals = [];
  const allProposalItems = [];
  
  // ─── 1. АЛИК клиенты ──────────────────────────────────────────────
  console.log('Reading Алик клиенты...');
  const wb1 = XLSX.readFile(path.join(BASE, 'Алик клиенты_ (1).xlsx'));
  const rows1 = XLSX.utils.sheet_to_json(wb1.Sheets['перезвоны'], { defval: '' });
  
  rows1.forEach((row, idx) => {
    const companyRaw = String(row['Компания и инн'] || '').trim();
    if (!companyRaw) return;
    
    const { name, inn } = parseCompanyInn(companyRaw);
    if (!name) return;
    
    const contacts_raw = String(row['Контактные данные'] || '');
    const { phone, email, website } = parseContacts(contacts_raw);
    
    // Get last non-empty next contact date
    let nextContact = null;
    for (let d = 0; d <= 4; d++) {
      const key = d === 0 ? 'Дата следующего контакта' : `Дата следующего контакта_${d}`;
      const val = excelDateToSQL(row[key]);
      if (val) nextContact = val;
    }
    
    const firstContact = excelDateToSQL(row['Дата первого контакта']);
    const comments = String(row['Комментарии'] || '').trim();
    
    allCompanies.push({
      name, inn, phone, email, website,
      manager: 'алик',
      first_contact: firstContact,
      next_contact: nextContact,
      comments,
    });
    
    // Parse LPR
    const lprs = parseLPR(row['ФИО и контакты ЛПР']);
    lprs.forEach(lpr => {
      allContacts.push({ company_idx: allCompanies.length - 1, manager: 'алик', ...lpr, is_primary: lprs.indexOf(lpr) === 0 });
    });
    
    // Add comment as activity
    if (comments) {
      allActivities.push({
        company_idx: allCompanies.length - 1,
        manager: 'алик',
        type: 'заметка',
        content: comments,
        date: nextContact || firstContact,
      });
    }
  });
  
  // ─── 2. МАГЕЛ клиенты ─────────────────────────────────────────────
  console.log('Reading Магел клиенты...');
  const wb2 = XLSX.readFile(path.join(BASE, 'магел клиенты (1).xlsx'));
  const rows2 = XLSX.utils.sheet_to_json(wb2.Sheets['перезвоны'], { defval: '' });
  
  rows2.forEach((row) => {
    const companyRaw = String(row['Компания и инн'] || '').trim();
    if (!companyRaw) return;
    
    const { name, inn } = parseCompanyInn(companyRaw);
    if (!name) return;
    
    const { phone, email, website } = parseContacts(String(row['Контактные данные'] || ''));
    const nextContact = excelDateToSQL(row['Дата следующего контакта']);
    const firstContact = excelDateToSQL(row['Дата первого контакта']);
    const comments = String(row['Комментарии'] || '').trim();
    
    allCompanies.push({
      name, inn, phone, email, website,
      manager: 'магел',
      first_contact: firstContact,
      next_contact: nextContact,
      comments,
    });
    
    const lprs = parseLPR(row['ФИО и контакты ЛПР']);
    lprs.forEach(lpr => {
      allContacts.push({ company_idx: allCompanies.length - 1, manager: 'магел', ...lpr, is_primary: lprs.indexOf(lpr) === 0 });
    });
    
    if (comments) {
      allActivities.push({
        company_idx: allCompanies.length - 1,
        manager: 'магел',
        type: 'заметка',
        content: comments,
        date: nextContact || firstContact,
      });
    }
  });
  
  // ─── 3. РАМ клиенты ──────────────────────────────────────────────
  console.log('Reading Рам клиенты...');
  const wb3 = XLSX.readFile(path.join(BASE, 'рам клиенты (1).xlsx'));
  const rows3 = XLSX.utils.sheet_to_json(wb3.Sheets['перезвоны'], { defval: '' });
  
  rows3.forEach((row) => {
    const companyRaw = String(row['Компания и инн'] || '').trim();
    if (!companyRaw) return;
    
    const { name, inn } = parseCompanyInn(companyRaw);
    if (!name) return;
    
    const { phone, email, website } = parseContacts(String(row['Контактные данные'] || ''));
    const nextContact = excelDateToSQL(row['Дата контакта']);
    const comments = String(row['Комментарии'] || '').trim();
    
    allCompanies.push({
      name, inn, phone, email, website,
      manager: 'рам',
      first_contact: nextContact,
      next_contact: nextContact,
      comments,
    });
    
    const lprs = parseLPR(row['ФИО и контакты ЛПР']);
    lprs.forEach(lpr => {
      allContacts.push({ company_idx: allCompanies.length - 1, manager: 'рам', ...lpr, is_primary: lprs.indexOf(lpr) === 0 });
    });
    
    if (comments) {
      allActivities.push({
        company_idx: allCompanies.length - 1,
        manager: 'рам',
        type: 'заметка',
        content: comments,
        date: nextContact,
      });
    }
  });
  
  // ─── 4. РАМ2 — Лист1 + Лист2 ─────────────────────────────────────
  console.log('Reading Рам2...');
  const wb4 = XLSX.readFile(path.join(BASE, 'рам2.xlsx'));
  
  ['Лист1', 'Лист2'].forEach(sheetName => {
    const ws = wb4.Sheets[sheetName];
    if (!ws) return;
    const rows = XLSX.utils.sheet_to_json(ws, { defval: '' });
    
    rows.forEach((row) => {
      const companyRaw = String(row['Данные Компании'] || '').trim();
      if (!companyRaw) return;
      
      // Parse multiline: "ООО 'Название'\nИНН-1234567890\nГород"
      const lines = companyRaw.split('\n').map(l => l.trim()).filter(Boolean);
      let companyName = lines[0] || '';
      let inn = '';
      let city = '';
      
      for (const line of lines.slice(1)) {
        const innMatch = line.match(/ИНН[-:\s]*(\d{10,})/i);
        if (innMatch) { inn = innMatch[1]; continue; }
        // Last non-INN line is likely the city
        if (!innMatch && line.length < 40) city = line;
      }
      
      if (!companyName) return;
      
      const contactsRaw = String(row['Контакты'] || '');
      const { phone, email, website } = parseContacts(contactsRaw);
      const comments = String(row['Коментарий'] || '').trim();
      const dateVal = excelDateToSQL(row['Дата контакта'] || row['Дата первого контакта']);
      
      allCompanies.push({
        name: companyName.replace(/"/g, "'"), inn, city,
        phone, email, website,
        manager: 'рам',
        first_contact: dateVal,
        next_contact: dateVal,
        comments,
      });
      
      const lprs = parseLPR(row['ФИО и контакты\nЛПР'] || row['ФИО и контакты ЛПР']);
      lprs.forEach(lpr => {
        allContacts.push({ company_idx: allCompanies.length - 1, manager: 'рам', ...lpr, is_primary: lprs.indexOf(lpr) === 0 });
      });
      
      if (comments) {
        allActivities.push({
          company_idx: allCompanies.length - 1,
          manager: 'рам',
          type: 'заметка',
          content: comments,
          date: dateVal,
        });
      }
    });
  });
  
  // ─── 5. РАМ2 — Лист3 (Запросы/КП) ───────────────────────────────
  console.log('Reading Рам2 Запросы...');
  const rows4_3 = XLSX.utils.sheet_to_json(wb4.Sheets['Лист3'], { defval: '' });
  
  rows4_3.forEach((row) => {
    const companyRaw = String(row['Название компании'] || '').trim();
    if (!companyRaw) return;
    
    const lines = companyRaw.split('\n').map(l => l.trim()).filter(Boolean);
    let companyName = lines[0] || '';
    let inn = '';
    let city = '';
    
    for (const line of lines.slice(1)) {
      const innMatch = line.match(/(\d{10,})/);
      if (innMatch && !city) { inn = innMatch[1]; continue; }
      city = line;
    }
    
    const productRaw = String(row['Запрашеваемы товар'] || '').trim();
    const dateQuery = excelDateToSQL(row['дата запроса']);
    const dateReply = excelDateToSQL(row['дата ответа']);
    const priceRaw = String(row['цена за 1шт'] || '').trim();
    
    if (!companyName) return;
    
    // Find or remember this company for linking
    const existIdx = allCompanies.findIndex(c => 
      c.name.replace(/['"]/g, '').toLowerCase() === companyName.replace(/['"]/g, '').toLowerCase()
    );
    
    if (existIdx === -1) {
      allCompanies.push({
        name: companyName.replace(/"/g, "'"), inn, city,
        manager: 'рам',
        first_contact: dateQuery,
        next_contact: null,
        comments: 'Запрос: ' + productRaw.slice(0, 100),
      });
    }
    
    const companyIdx = existIdx === -1 ? allCompanies.length - 1 : existIdx;
    
    // Parse products (may be multiline)
    const productLines = productRaw.split('\n').map(l => l.trim()).filter(Boolean);
    
    if (productLines.length > 0) {
      // Create a proposal
      const proposalIdx = allProposals.length;
      let totalAmount = 0;
      
      const priceStr = priceRaw.replace(/\s/g, '').replace(/,/g, '');
      const hasPrice = priceStr && !isNaN(Number(priceStr));
      
      productLines.forEach((line, pi) => {
        // Try to extract: "ТСЛ 1250/20-10/0.4 Алюминь 1шт."
        // Or: "запрос 2ктп 3150 сухари"
        const qtyMatch = line.match(/(\d+)\s*шт/i);
        const qty = qtyMatch ? parseInt(qtyMatch[1]) : 1;
        const price = hasPrice ? Number(priceStr) : 0;
        
        allProposalItems.push({
          proposal_idx: proposalIdx,
          company_idx: companyIdx,
          product_name: line.replace(/\d+\s*шт\.?/gi, '').trim() || line,
          quantity: qty,
          price_per_unit: price,
          total_price: price * qty,
        });
        
        totalAmount += price * qty;
      });
      
      allProposals.push({
        company_idx: companyIdx,
        manager: 'рам',
        total_amount: totalAmount,
        date: dateQuery,
      });
    }
  });
  
  // ─── 6. АНАР клиенты ─────────────────────────────────────────────
  console.log('Reading Анар клиенты...');
  const wb5 = XLSX.readFile(path.join(BASE, 'Анар клиенты.xlsx'));
  const rows5 = XLSX.utils.sheet_to_json(wb5.Sheets['Лист1'], { defval: '' });
  
  rows5.forEach((row) => {
    const companyRaw = String(row['Компания и инн'] || '').trim();
    if (!companyRaw) return;
    
    const { name, inn } = parseCompanyInn(companyRaw);
    if (!name) return;
    
    const { phone, email, website } = parseContacts(String(row['Контактные данные'] || ''));
    const nextContact = excelDateToSQL(row['Дата следующего контакта']);
    const firstContact = excelDateToSQL(row['Дата первого контакта']);
    const comments = String(row['Комментарии'] || '').trim();
    
    allCompanies.push({
      name, inn, phone, email, website,
      manager: 'анар',
      first_contact: firstContact,
      next_contact: nextContact,
      comments,
    });
    
    const lprs = parseLPR(row['ФИО и контакты ЛПР']);
    lprs.forEach(lpr => {
      allContacts.push({ company_idx: allCompanies.length - 1, manager: 'анар', ...lpr, is_primary: lprs.indexOf(lpr) === 0 });
    });
    
    if (comments) {
      allActivities.push({
        company_idx: allCompanies.length - 1,
        manager: 'анар',
        type: 'заметка',
        content: comments,
        date: nextContact || firstContact,
      });
    }
  });
  
  // ─── Remove duplicates by name ───────────────────────────────────
  console.log(`Total raw companies: ${allCompanies.length}`);
  
  const seenNames = new Map();
  const uniqueCompanies = [];
  const oldToNewIdx = new Map();
  
  allCompanies.forEach((c, idx) => {
    const key = c.name.toLowerCase().replace(/['"]/g, '').replace(/\s+/g, ' ').trim();
    if (!key) return;
    
    if (seenNames.has(key)) {
      // Merge: keep existing, add new LPR/activities
      oldToNewIdx.set(idx, seenNames.get(key));
      
      // Re-map contacts and activities to the existing company
      allContacts.filter(cc => cc.company_idx === idx).forEach(cc => {
        cc.company_idx = seenNames.get(key);
        cc._remapped = true;
      });
      allActivities.filter(aa => aa.company_idx === idx).forEach(aa => {
        aa.company_idx = seenNames.get(key);
        aa._remapped = true;
      });
    } else {
      seenNames.set(key, uniqueCompanies.length);
      oldToNewIdx.set(idx, uniqueCompanies.length);
      uniqueCompanies.push({ ...c, _origIdx: idx });
    }
  });
  
  console.log(`Unique companies: ${uniqueCompanies.length}`);
  console.log(`Total LPR contacts: ${allContacts.length}`);
  console.log(`Total activities: ${allActivities.length}`);
  console.log(`Total proposals: ${allProposals.length}`);
  console.log(`Total proposal items: ${allProposalItems.length}`);
  
  // ─── Generate SQL ─────────────────────────────────────────────────
  let sql = '-- ================================================================\n';
  sql += '-- Импорт данных из Excel файлов\n';
  sql += '-- Дата генерации: ' + new Date().toISOString().slice(0, 10) + '\n';
  sql += '-- Компаний: ' + uniqueCompanies.length + '\n';
  sql += '-- Контактов ЛПР: ' + allContacts.length + '\n';
  sql += '-- Записей активности: ' + allActivities.length + '\n';
  sql += '-- КП: ' + allProposals.length + '\n';
  sql += '-- ================================================================\n\n';
  
  // IMPORTANT: Disable RLS temporarily for import
  sql += '-- ВРЕМЕННО отключаем RLS для импорта\n';
  sql += 'ALTER TABLE companies DISABLE ROW LEVEL SECURITY;\n';
  sql += 'ALTER TABLE company_contacts DISABLE ROW LEVEL SECURITY;\n';
  sql += 'ALTER TABLE activities DISABLE ROW LEVEL SECURITY;\n';
  sql += 'ALTER TABLE proposals DISABLE ROW LEVEL SECURITY;\n';
  sql += 'ALTER TABLE proposal_items DISABLE ROW LEVEL SECURITY;\n\n';
  
  // ─── INSERT COMPANIES ─────────────────────────────────────────────
  sql += '-- ═══ COMPANIES ═══\n';
  uniqueCompanies.forEach((c, idx) => {
    const managerId = MANAGER_MAP[c.manager] || 'NULL';
    const createdDate = c.first_contact || '2025-04-01';
    const status = c.comments && c.comments.includes('КП') ? 'сделал запрос' : 'слабый интерес';
    
    sql += `INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (\n`;
    sql += `  gen_random_uuid(),\n`;
    sql += `  ${sqlEscape(c.name)},\n`;
    sql += `  ${c.inn ? sqlEscape(c.inn) : 'NULL'},\n`;
    sql += `  ${c.city ? sqlEscape(c.city) : 'NULL'},\n`;
    sql += `  ${c.phone ? sqlEscape(c.phone) : 'NULL'},\n`;
    sql += `  ${c.email ? sqlEscape(c.email) : 'NULL'},\n`;
    sql += `  ${c.website ? sqlEscape(c.website) : 'NULL'},\n`;
    sql += `  ${sqlEscape('холодный обзвон')},\n`;
    sql += `  ${sqlEscape(status)},\n`;
    sql += `  ${managerId},\n`;
    sql += `  ${c.next_contact ? sqlEscape(c.next_contact) : 'NULL'},\n`;
    sql += `  ${sqlEscape(c.comments)},\n`;
    sql += `  ${sqlEscape(createdDate)},\n`;
    sql += `  ${sqlEscape(createdDate)}\n`;
    sql += `);\n\n`;
  });
  
  // ─── INSERT COMPANY CONTACTS (LPR) ────────────────────────────────
  sql += '-- ═══ COMPANY CONTACTS (ЛПР) ═══\n';
  allContacts.forEach((c) => {
    if (!c.name || c.name.length < 2) return;
    
    sql += `INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)\n`;
    sql += `SELECT gen_random_uuid(), comp.id, ${sqlEscape(c.name)}, ${c.position ? sqlEscape(c.position) : 'NULL'}, ${c.phone ? sqlEscape(c.phone) : 'NULL'}, ${c.email ? sqlEscape(c.email) : 'NULL'}, ${c.phone ? sqlEscape(c.phone) : 'NULL'}, NULL, ${c.is_primary ? 'true' : 'false'}, now()\n`;
    sql += `FROM companies comp WHERE comp.name = ${sqlEscape(uniqueCompanies[c.company_idx]?.name)} LIMIT 1;\n\n`;
  });
  
  // ─── INSERT ACTIVITIES ───────────────────────────────────────────
  sql += '-- ═══ ACTIVITIES ═══\n';
  allActivities.forEach((a, idx) => {
    const companyName = uniqueCompanies[a.company_idx]?.name;
    if (!companyName) return;
    
    const date = a.date || '2025-04-01';
    const content = a.content.slice(0, 500); // Limit length
    
    sql += `INSERT INTO activities (id, company_id, user_id, type, content, created_at)\n`;
    sql += `SELECT gen_random_uuid(), comp.id, usr.id, ${sqlEscape(a.type)}, ${sqlEscape(content)}, ${sqlEscape(date)}\n`;
    sql += `FROM companies comp CROSS JOIN users usr\n`;
    sql += `WHERE comp.name = ${sqlEscape(companyName)} AND usr.name ILIKE ${sqlEscape(a.manager + '%')} LIMIT 1;\n\n`;
  });
  
  // ─── INSERT PROPOSALS ────────────────────────────────────────────
  sql += '-- ═══ PROPOSALS (КП) ═══\n';
  allProposals.forEach((p, idx) => {
    const companyName = uniqueCompanies[p.company_idx]?.name;
    if (!companyName) return;
    
    const date = p.date || '2025-06-01';
    
    sql += `INSERT INTO proposals (id, company_id, manager_id, number, status, total_amount, valid_until, notes, created_at, updated_at)\n`;
    sql += `SELECT gen_random_uuid(), comp.id, usr.id, ${sqlEscape('КП-' + (idx + 1))}, ${sqlEscape('отправлено')}, ${p.total_amount || 0}, NULL, NULL, ${sqlEscape(date)}, ${sqlEscape(date)}\n`;
    sql += `FROM companies comp CROSS JOIN users usr\n`;
    sql += `WHERE comp.name = ${sqlEscape(companyName)} AND usr.name ILIKE ${sqlEscape(p.manager + '%')} LIMIT 1;\n\n`;
  });
  
  // Re-enable RLS
  sql += '-- Включаем RLS обратно\n';
  sql += 'ALTER TABLE companies ENABLE ROW LEVEL SECURITY;\n';
  sql += 'ALTER TABLE company_contacts ENABLE ROW LEVEL SECURITY;\n';
  sql += 'ALTER TABLE activities ENABLE ROW LEVEL SECURITY;\n';
  sql += 'ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;\n';
  sql += 'ALTER TABLE proposal_items ENABLE ROW LEVEL SECURITY;\n\n';
  
  sql += '-- ═══ ГОТОВО! ═══\n';
  sql += '-- Примечание: manager_id использует подстановочные UUID (MANAGER_ALIK_ID и т.д.)\n';
  sql += '-- Перед запуском замените их на реальные ID из таблицы users:\n';
  sql += '-- SELECT id, name, email FROM users;\n';
  sql += '-- Затем выполните: sed -i "s/MANAGER_ALIK_ID/реальный_uuid/g" этот_файл.sql\n';
  
  // Write SQL file
  const outputPath = path.join(__dirname, '..', 'supabase', 'migrations', '002_import_excel_data.sql');
  fs.writeFileSync(outputPath, sql, 'utf-8');
  
  console.log(`\n✅ SQL file generated: ${outputPath}`);
  console.log(`   Size: ${(sql.length / 1024).toFixed(1)} KB`);
  console.log(`\n📋 Next steps:`);
  console.log(`   1. Открой Supabase Dashboard → SQL Editor`);
  console.log(`   2. Выполни: SELECT id, name, email FROM users;`);
  console.log(`   3. Замени MANAGER_ALIK_ID, MANAGER_MAGEL_ID, MANAGER_RAM_ID, MANAGER_ANAR_ID`);
  console.log(`     на реальные UUID из таблицы users`);
  console.log(`   4. Скопируй и выполни SQL из файла 002_import_excel_data.sql`);
}

main();
