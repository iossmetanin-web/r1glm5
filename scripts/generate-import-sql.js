/**
 * generate-import-sql.js
 * 
 * Парсит все Excel файлы и генерирует SQL-миграцию для Supabase:
 * 1. CREATE TABLE (если нет)
 * 2. INSERT всех компаний, контактов, активностей, КП
 */
const XLSX = require('xlsx');
const fs = require('fs');
const path = require('path');

// ============================================================
// 1. CONFIG
// ============================================================
const MANAGER_EMAILS = {
  'Алик': 'palladium1@bk.ru',
  'Магел': null,   // Will be determined from users table
  'Рам': null,
  'Анар': 'iossmetanin@gmail.com',
};

const STATUS_MAP = {
  'входяшка': 'слабый интерес',
  'входящая заявка': 'слабый интерес',
  'входящий звонок': 'слабый интерес',
  'реактивация': 'надо залечивать',
  'надо залечивать': 'надо залечивать',
  'залечивать': 'надо залечивать',
  'кп отправлено': 'сделал запрос',
  'отправил кп': 'сделал запрос',
  'сделал запрос': 'сделал запрос',
  'запрос': 'сделал запрос',
  'в работе': 'в работе',
  'заказ': 'сделал заказ',
  'сделал заказ': 'сделал заказ',
  'не закупают': 'отказ',
  'отказ': 'отказ',
};

// ============================================================
// 2. HELPERS
// ============================================================

function escapeSql(str) {
  if (str == null || str === undefined) return 'NULL';
  const s = String(str).replace(/'/g, "''");
  return `'${s}'`;
}

function escapeSqlOrNull(str) {
  if (!str || String(str).trim() === '' || String(str) === '-') return 'NULL';
  return escapeSql(str);
}

function excelDateToDate(excelDate) {
  if (!excelDate || typeof excelDate !== 'number') return null;
  // Excel serial date: days since 1899-12-30
  const epoch = new Date(1899, 11, 30);
  const date = new Date(epoch.getTime() + excelDate * 86400000);
  return date.toISOString().split('T')[0]; // YYYY-MM-DD
}

function parseCompanyInnField(raw) {
  /**
   * Parses the "Компания и инн" field which has various formats:
   * - "ООО 'ЭЛСНАБ' ИНН: 7719612213"
   * - "Ставропольэлектросеть, 2635244268"
   * - " 7817302964 https://izhek.ru/"
   * - "p-seti.ru" (just a website, no company name)
   * - "ООО 'ПЭП'   7801454062"
   * - Multi-line from рам2:
   *   "ООО «Центр Инжениринг» \nИНН-2373002283\nКраснодар"
   */
  if (!raw || typeof raw !== 'string') return { name: '', inn: '', city: '', website: '' };
  
  let text = raw.trim();
  let inn = '';
  let city = '';
  let website = '';
  let name = text;
  
  // Replace various quote types
  text = text.replace(/[\u00AB\u00BB\u201C\u201D\u201E\u201F]/g, '"').replace(/\u2018\u2019/g, "'");
  
  // Multi-line format from рам2 (name\nИНN-xxxx\nCity)
  if (text.includes('\n')) {
    const lines = text.split('\n').map(l => l.trim()).filter(l => l.length > 0);
    name = lines[0] || '';
    for (const line of lines.slice(1)) {
      const innMatch = line.match(/(?:ИНН[:\-\s]*)?(\d{10,12})/i);
      if (innMatch) {
        inn = innMatch[1];
        continue;
      }
      // Check if it's a city (not a number, not a URL, not an INN)
      if (!line.match(/^\d+$/) && !line.match(/^https?:\/\//) && !line.match(/@/) && line.length > 1 && line.length < 30) {
        city = line;
      }
    }
  } else {
    // Single line format
    // Extract INN (10-12 digit number)
    const innMatch = text.match(/(?:ИНН[:\-\s]*)?(\d{10,12})/i);
    if (innMatch) {
      inn = innMatch[1];
      name = text.replace(/ИНN[:\-\s]*\d{10,12}/i, '').replace(/,\s*\d{10,12}/, '').trim();
    }
    
    // Extract from comma format: "Company, INN" or "Company INN"
    if (!inn) {
      const commaMatch = text.match(/^(.+?),\s*(\d{10,12})\s*$/);
      if (commaMatch) {
        name = commaMatch[1].trim();
        inn = commaMatch[2].trim();
      } else {
        const spaceMatch = text.match(/^(.+?)\s+(\d{10,12})\s*$/);
        if (spaceMatch) {
          name = spaceMatch[1].trim();
          inn = spaceMatch[2].trim();
        }
      }
    }
    
    // Check if the "name" is actually a URL (like p-seti.ru)
    if (name.match(/^[a-z0-9\-]+\.[a-z]{2,}/i) && !name.match(/ООО|ИП|ЗАО|ОАО|АО|ПАО|ТД|НПО|ПКФ|ГК/i)) {
      website = name;
      name = '';
    }
  }
  
  // Clean up name
  name = name.replace(/\s+/g, ' ').trim();
  if (name === '' || name === '0' || name === '-') name = '';
  
  return { name, inn, city, website };
}

function parseContactsField(raw) {
  /**
   * Parses "Контактные данные" field:
   * - "www.gtenergo.ru"
   * - "+7 (4712) 40-01-50\n  esm-pol@energo.sovtest.ru"
   * - "+78123228659 Константин закупщик"
   * - "info@p-seti.ru 8 (800) 511-89-84"
   * - "+7-(861)-991-00-97\ninfo@centringen.ru"
   */
  if (!raw || typeof raw !== 'string') return { phone: '', email: '', website: '' };
  
  let text = raw.trim();
  let phone = '';
  let email = '';
  let website = '';
  
  // Extract email
  const emailMatch = text.match(/([a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,})/);
  if (emailMatch) email = emailMatch[1];
  
  // Extract phone (various formats)
  const phonePatterns = [
    /(?:\+?7|8)[\s\-\(]?\d{3}[\)\-\s]?\d{3}[\-\s]?\d{2}[\-\s]?\d{2}/,
    /8\d{10}/,
    /\d{3}[\-\s]\d{3}[\-\s]\d{4}/,
  ];
  for (const pattern of phonePatterns) {
    const m = text.match(pattern);
    if (m) {
      phone = m[0];
      break;
    }
  }
  
  // Check for website
  if (!website) {
    const webMatch = text.match(/(https?:\/\/[a-zA-Z0-9.\-]+[a-zA-Z0-9/._~:?#@!$&'()*+,;=%\-]*)|(?:[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(?:\/[^\s]*)?)/);
    if (webMatch && !email) {
      const url = webMatch[0];
      if (url.match(/^(?:www\.|[a-z]{2,}\.)/i) && !url.includes('@')) {
        website = url;
      }
    }
  }
  
  return { phone, email, website };
}

function parseLPRField(raw) {
  /**
   * Parses "ФИО и контакты ЛПР" field:
   * - "Гончар Родион Сергеевич Тел.: +7 (950) 791 14 16 \nE-mail: grs@tehold.ru"
   * - "Михаил, добавочно 405"
   * - "Артем\n закупщик\njoev.ar@gmail.com\n"
   * - "Отдел снабжения\n Виноградова Олеся Анатольевна\nomtc@shela71.ru\n+7 (920) 769-12-29"
   * - "Константин закупщик +79111114339"
   */
  if (!raw || typeof raw !== 'string' || raw.trim() === '' || raw.trim().toLowerCase() === 'нету' || raw.trim() === '-') {
    return [];
  }
  
  const contacts = [];
  const text = raw.trim();
  
  // Try to split by lines and detect person entries
  const lines = text.split('\n').map(l => l.trim()).filter(l => l.length > 0);
  
  // Collect all info from all lines
  let names = [];
  let positions = [];
  let phones = [];
  let emails = [];
  
  for (const line of lines) {
    // Extract email
    const emailMatch = line.match(/([a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,})/);
    if (emailMatch) emails.push(emailMatch[1]);
    
    // Extract phone
    const phoneMatch = line.match(/(?:\+?7|8)[\s\-\(]?\d{3}[\)\-\s]?\d{3}[\-\s]?\d{2}[\-\s]?\d{2}/) 
      || line.match(/8\d{10}/);
    if (phoneMatch) phones.push(phoneMatch[0]);
    
    // Check for position keywords
    const posKeywords = ['закупщик', 'закуп', 'директор', 'инженер', 'менеджер', 'снабжения', 'начальник', 'секретарь', 'отдел'];
    if (posKeywords.some(k => line.toLowerCase().includes(k)) && !line.match(/^[A-ZА-Я]/)) {
      positions.push(line);
    }
    
    // Check for name (starts with capital, contains only letters and spaces)
    if (line.match(/^[А-ЯЁA-Z][а-яёa-z]+(?:\s+[А-ЯЁA-Z][а-яёa-z]+)*/) && line.length < 60) {
      names.push(line);
    }
  }
  
  // Build contact entries
  if (names.length > 0) {
    // Try to associate names with their following details
    for (let i = 0; i < names.length; i++) {
      contacts.push({
        name: names[i],
        position: (positions[i] || positions[0] || '').replace(/^[,\s]+/, ''),
        phone: phones[i] || phones[0] || '',
        email: emails[i] || emails[0] || '',
      });
    }
  } else if (phones.length > 0 || emails.length > 0) {
    // No name found but has contact info
    contacts.push({
      name: '',
      position: positions[0] || '',
      phone: phones[0] || '',
      email: emails[0] || '',
    });
  } else if (positions.length > 0) {
    // Only position info
    contacts.push({
      name: '',
      position: positions[0] || '',
      phone: '',
      email: '',
    });
  }
  
  // Also try to parse from single-line format like "Константин закупщик +79111114339"
  if (contacts.length === 0 && text.length > 2) {
    // Try to find a name at the beginning
    const nameMatch = text.match(/^([А-ЯЁA-Z][а-яёa-z]+(?:\s+[А-ЯЁA-Z][а-яёa-z]+)?)/);
    const emailM = text.match(/([a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,})/);
    const phoneM = text.match(/(?:\+?7|8)[\s\-\(]?\d{3}[\)\s\-]?\d{3}[\-\s]?\d{2}[\-\s]?\d{2}/) || text.match(/8\d{10}/);
    
    if (nameMatch || emailM || phoneM) {
      contacts.push({
        name: nameMatch ? nameMatch[1] : '',
        position: '',
        phone: phoneM ? phoneM[0] : '',
        email: emailM ? emailM[1] : '',
      });
    }
  }
  
  return contacts;
}

function detectStatus(comments) {
  if (!comments || typeof comments !== 'string') return 'слабый интерес';
  const lower = comments.toLowerCase();
  
  for (const [key, status] of Object.entries(STATUS_MAP)) {
    if (lower.includes(key)) return status;
  }
  
  // Heuristic detection
  if (lower.includes('кп') || lower.includes('коммерческое') || lower.includes('запрос')) return 'сделал запрос';
  if (lower.includes('не закуп') || lower.includes('нет заказ') || lower.includes('не интерес')) return 'отказ';
  if (lower.includes('на связи') || lower.includes('хорошая') || lower.includes('интересн')) return 'надо залечивать';
  
  return 'слабый интерес';
}

function detectSource(comments) {
  if (!comments || typeof comments !== 'string') return 'холодный обзвон';
  const lower = comments.toLowerCase();
  
  if (lower.includes('входяшка') || lower.includes('входящ') || lower.includes('входящий')) return 'входящая заявка';
  if (lower.includes('реклама') || lower.includes('сайт')) return 'реклама';
  if (lower.includes('знаком') || lower.includes('личный') || lower.includes('рекоменд')) return 'личный контакт';
  
  return 'холодный обзвон';
}

// ============================================================
// 3. PARSE ALL FILES
// ============================================================

const allCompanies = []; // {name, inn, city, website, phone, email, source, status, manager, next_contact_date, notes, contacts:[]}
const allProposals = []; // {company_name, inn, items:[], date}
const seenINN = new Set();
const seenNames = new Set();

function addCompany(data) {
  if (!data.name && !data.inn) return;
  
  // Dedup by INN
  if (data.inn && seenINN.has(data.inn)) return;
  if (data.inn) seenINN.add(data.inn);
  
  // Also dedup by normalized name
  const normalizedName = data.name.toLowerCase().replace(/['"«»\s,.\-()]/g, '');
  if (normalizedName && seenNames.has(normalizedName)) return;
  if (normalizedName) seenNames.add(normalizedName);
  
  allCompanies.push(data);
}

// --- File 1: Алик клиенты ---
function parseAlik() {
  const wb = XLSX.readFile(path.join(__dirname, '../upload/Алик клиенты_ (1).xlsx'));
  const rows = XLSX.utils.sheet_to_json(wb.Sheets['перезвоны'], { defval: '' });
  
  for (const row of rows) {
    const companyField = String(row['Компания и инн'] || '').trim();
    if (!companyField) continue;
    
    const { name, inn, city, website: companyWebsite } = parseCompanyInnField(companyField);
    const contactsField = String(row['Контактные данные'] || '');
    const { phone, email, website } = parseContactsField(contactsField);
    const lprRaw = String(row['ФИО и контакты ЛПР'] || '');
    const contacts = parseLPRField(lprRaw);
    const comments = String(row['Комментарии'] || '').trim();
    
    // Next contact date (could be text like "не дозвонился 8 июля" or a date serial)
    let nextDate = null;
    const dateFields = ['Дата следующего контакта', 'Дата следующего контакта_1', 
                        'Дата следующего контакта_2', 'Дата следующего контакта_3', 'Дата следующего контакта_4'];
    for (const df of dateFields) {
      const val = row[df];
      if (typeof val === 'number' && val > 40000) {
        nextDate = excelDateToDate(val);
        break;
      }
    }
    
    addCompany({
      name,
      inn,
      city,
      website: website || companyWebsite,
      phone,
      email,
      source: detectSource(comments),
      status: detectStatus(comments),
      manager: 'Алик',
      next_contact_date: nextDate,
      notes: comments,
      contacts,
      created_from: 'Алик клиенты',
    });
  }
  console.log(`Алик: ${rows.length} rows parsed`);
}

// --- File 2: Магел клиенты ---
function parseMagel() {
  const wb = XLSX.readFile(path.join(__dirname, '../upload/магел клиенты (1).xlsx'));
  const rows = XLSX.utils.sheet_to_json(wb.Sheets['перезвоны'], { defval: '' });
  
  for (const row of rows) {
    const companyField = String(row['Компания и инн'] || '').trim();
    if (!companyField) continue;
    
    const { name, inn, city, website: companyWebsite } = parseCompanyInnField(companyField);
    const contactsField = String(row['Контактные данные'] || '');
    const { phone, email, website } = parseContactsField(contactsField);
    const lprRaw = String(row['ФИО и контакты ЛПР'] || '');
    const contacts = parseLPRField(lprRaw);
    const comments = String(row['Комментарии'] || '').trim();
    
    let nextDate = null;
    const nextContactVal = row['Дата следующего контакта'];
    if (typeof nextContactVal === 'number' && nextContactVal > 40000) {
      nextDate = excelDateToDate(nextContactVal);
    }
    
    addCompany({
      name,
      inn,
      city,
      website: website || companyWebsite,
      phone,
      email,
      source: detectSource(comments),
      status: detectStatus(comments),
      manager: 'Магел',
      next_contact_date: nextDate,
      notes: comments,
      contacts,
      created_from: 'Магел клиенты',
    });
  }
  console.log(`Магел: ${rows.length} rows parsed`);
}

// --- File 3: Рам клиенты ---
function parseRam() {
  const wb = XLSX.readFile(path.join(__dirname, '../upload/рам клиенты (1).xlsx'));
  const rows = XLSX.utils.sheet_to_json(wb.Sheets['перезвоны'], { defval: '' });
  
  for (const row of rows) {
    const companyField = String(row['Компания и инн'] || '').trim();
    if (!companyField) continue;
    
    const { name, inn, city, website: companyWebsite } = parseCompanyInnField(companyField);
    const contactsField = String(row['Контактные данные'] || '');
    const { phone, email, website } = parseContactsField(contactsField);
    const lprRaw = String(row['ФИО и контакты ЛПР'] || '');
    const contacts = parseLPRField(lprRaw);
    const comments = String(row['Комментарии'] || '').trim();
    
    let nextDate = null;
    const dateVal = row['Дата контакта'];
    if (typeof dateVal === 'number' && dateVal > 40000) {
      nextDate = excelDateToDate(dateVal);
    }
    
    addCompany({
      name,
      inn,
      city,
      website: website || companyWebsite,
      phone,
      email,
      source: detectSource(comments),
      status: detectStatus(comments),
      manager: 'Рам',
      next_contact_date: nextDate,
      notes: comments,
      contacts,
      created_from: 'Рам клиенты',
    });
  }
  console.log(`Рам: ${rows.length} rows parsed`);
}

// --- File 4: Рам2 (3 sheets) ---
function parseRam2() {
  const wb = XLSX.readFile(path.join(__dirname, '../upload/рам2.xlsx'));
  
  // Sheet 1: Main client data
  const rows1 = XLSX.utils.sheet_to_json(wb.Sheets['Лист1'], { defval: '' });
  for (const row of rows1) {
    const companyField = String(row['Данные Компании'] || '').trim();
    if (!companyField) continue;
    
    const { name, inn, city } = parseCompanyInnField(companyField);
    const contactsField = String(row['Контакты'] || '');
    const { phone, email, website } = parseContactsField(contactsField);
    const lprRaw = String(row['ФИО и контакты\nЛПР'] || '');
    const contacts = parseLPRField(lprRaw);
    const comments = String(row['Коментарий'] || '').trim();
    
    let nextDate = null;
    const dateVal = row['Дата контакта'];
    if (typeof dateVal === 'number' && dateVal > 40000) {
      nextDate = excelDateToDate(dateVal);
    }
    
    addCompany({
      name,
      inn,
      city,
      website,
      phone,
      email,
      source: detectSource(comments),
      status: detectStatus(comments),
      manager: 'Рам',
      next_contact_date: nextDate,
      notes: comments,
      contacts,
      created_from: 'Рам2-Лист1',
    });
  }
  console.log(`Рам2-Лист1: ${rows1.length} rows parsed`);
  
  // Sheet 2: More clients
  const rows2 = XLSX.utils.sheet_to_json(wb.Sheets['Лист2'], { defval: '' });
  for (const row of rows2) {
    const companyField = String(row['Данные Компании'] || '').trim();
    if (!companyField) continue;
    
    const { name, inn, city } = parseCompanyInnField(companyField);
    const contactsField = String(row['Контакты'] || '');
    const { phone, email, website } = parseContactsField(contactsField);
    const lprRaw = String(row['ФИО и контакты\nЛПР'] || '');
    const contacts = parseLPRField(lprRaw);
    const comments = String(row['Коментарий'] || '').trim();
    
    addCompany({
      name,
      inn,
      city,
      website,
      phone,
      email,
      source: detectSource(comments),
      status: detectStatus(comments),
      manager: 'Рам',
      next_contact_date: null,
      notes: comments,
      contacts,
      created_from: 'Рам2-Лист2',
    });
  }
  console.log(`Рам2-Лист2: ${rows2.length} rows parsed`);
  
  // Sheet 3: Commercial requests (КП)
  const rows3 = XLSX.utils.sheet_to_json(wb.Sheets['Лист3'], { defval: '' });
  for (const row of rows3) {
    const companyField = String(row['Название компании'] || '').trim();
    if (!companyField) continue;
    
    const { name, inn, city } = parseCompanyInnField(companyField);
    const productRaw = String(row['Запрашеваемы товар'] || '').trim();
    const queryDate = typeof row['дата запроса'] === 'number' ? excelDateToDate(row['дата запроса']) : null;
    const answerDate = typeof row['дата ответа'] === 'number' ? excelDateToDate(row['дата ответа']) : null;
    const priceRaw = String(row['цена за 1шт'] || '').trim();
    
    // Parse product items
    const items = [];
    if (productRaw) {
      const productLines = productRaw.split('\n').filter(l => l.trim());
      const priceLines = priceRaw ? priceRaw.split('\n').filter(l => l.trim()) : [];
      
      for (let i = 0; i < productLines.length; i++) {
        let itemText = productLines[i].trim();
        let qty = 1;
        let price = 0;
        
        // Try to extract quantity
        const qtyMatch = itemText.match(/(\d+)\s*шт/i);
        if (qtyMatch) qty = parseInt(qtyMatch[1]);
        
        // Try to extract price
        if (priceLines[i]) {
          price = parseInt(String(priceLines[i]).replace(/\s/g, '')) || 0;
        }
        
        // Clean item text
        itemText = itemText.replace(/Запрос\s*/i, '').replace(/\d+\s*шт\.?/i, '').trim();
        
        if (itemText) {
          items.push({
            product_name: itemText,
            quantity: qty,
            price_per_unit: price,
            total_price: qty * price,
          });
        }
      }
    }
    
    // Add as company too
    addCompany({
      name,
      inn,
      city,
      website: '',
      phone: '',
      email: '',
      source: 'входящая заявка',
      status: 'сделал запрос',
      manager: 'Рам',
      next_contact_date: answerDate || queryDate,
      notes: productRaw,
      contacts: [],
      created_from: 'Рам2-КП',
    });
    
    if (items.length > 0) {
      allProposals.push({
        company_name: name,
        inn,
        city,
        items,
        query_date: queryDate,
        answer_date: answerDate,
        manager: 'Рам',
      });
    }
  }
  console.log(`Рам2-КП: ${rows3.length} proposals parsed`);
}

// --- File 5: Анар клиенты ---
function parseAnar() {
  const wb = XLSX.readFile(path.join(__dirname, '../upload/Анар клиенты.xlsx'));
  const rows = XLSX.utils.sheet_to_json(wb.Sheets['Лист1'], { defval: '' });
  
  for (const row of rows) {
    const companyField = String(row['Компания и инн'] || '').trim();
    if (!companyField) continue;
    
    const { name, inn, city, website: companyWebsite } = parseCompanyInnField(companyField);
    const contactsField = String(row['Контактные данные'] || '');
    const { phone, email, website } = parseContactsField(contactsField);
    const lprRaw = String(row['ФИО и контакты ЛПР'] || '');
    const contacts = parseLPRField(lprRaw);
    const comments = String(row['Комментарии'] || '').trim();
    
    let nextDate = null;
    const nextContactVal = row['Дата следующего контакта'];
    if (typeof nextContactVal === 'number' && nextContactVal > 40000) {
      nextDate = excelDateToDate(nextContactVal);
    }
    
    addCompany({
      name,
      inn,
      city,
      website: website || companyWebsite,
      phone,
      email,
      source: detectSource(comments),
      status: detectStatus(comments),
      manager: 'Анар',
      next_contact_date: nextDate,
      notes: comments,
      contacts,
      created_from: 'Анар клиенты',
    });
  }
  console.log(`Анар: ${rows.length} rows parsed`);
}

// ============================================================
// 4. GENERATE SQL
// ============================================================

function generateSQL() {
  let sql = '';
  
  sql += `-- ================================================================\n`;
  sql += `-- PulseCRM — Complete Database Setup + Data Import\n`;
  sql += `-- Generated: ${new Date().toISOString()}\n`;
  sql += `-- Companies: ${allCompanies.length} | Proposals: ${allProposals.length}\n`;
  sql += `-- ================================================================\n\n`;
  
  // ---- CREATE TABLES ----
  sql += `-- ── 1. COMPANIES ─────────────────────────────────────────────\n`;
  sql += `CREATE TABLE IF NOT EXISTS companies (\n`;
  sql += `  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n`;
  sql += `  name TEXT NOT NULL,\n`;
  sql += `  inn TEXT,\n`;
  sql += `  city TEXT,\n`;
  sql += `  website TEXT,\n`;
  sql += `  contact_phone TEXT,\n`;
  sql += `  contact_email TEXT,\n`;
  sql += `  source TEXT DEFAULT 'холодный обзвон',\n`;
  sql += `  status TEXT DEFAULT 'слабый интерес',\n`;
  sql += `  manager_id UUID REFERENCES auth.users(id),\n`;
  sql += `  manager_name TEXT DEFAULT '',\n`;
  sql += `  next_contact_date DATE,\n`;
  sql += `  lost_reason TEXT,\n`;
  sql += `  notes TEXT,\n`;
  sql += `  created_at TIMESTAMPTZ DEFAULT now(),\n`;
  sql += `  updated_at TIMESTAMPTZ DEFAULT now()\n`;
  sql += `);\n\n`;
  
  sql += `CREATE INDEX IF NOT EXISTS idx_companies_inn ON companies(inn) WHERE inn IS NOT NULL;\n`;
  sql += `CREATE INDEX IF NOT EXISTS idx_companies_manager ON companies(manager_id);\n`;
  sql += `CREATE INDEX IF NOT EXISTS idx_companies_status ON companies(status);\n`;
  sql += `CREATE INDEX IF NOT EXISTS idx_companies_next_contact ON companies(next_contact_date) WHERE next_contact_date IS NOT NULL;\n\n`;
  
  sql += `-- ── 2. COMPANY CONTACTS (ЛПР) ────────────────────────────────\n`;
  sql += `CREATE TABLE IF NOT EXISTS company_contacts (\n`;
  sql += `  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n`;
  sql += `  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,\n`;
  sql += `  name TEXT NOT NULL DEFAULT '',\n`;
  sql += `  position TEXT,\n`;
  sql += `  phone TEXT,\n`;
  sql += `  email TEXT,\n`;
  sql += `  whatsapp TEXT,\n`;
  sql += `  notes TEXT,\n`;
  sql += `  is_primary BOOLEAN DEFAULT false,\n`;
  sql += `  created_at TIMESTAMPTZ DEFAULT now()\n`;
  sql += `);\n\n`;
  
  sql += `CREATE INDEX IF NOT EXISTS idx_contacts_company ON company_contacts(company_id);\n\n`;
  
  // Activities table already exists with old schema — drop and recreate
  sql += `-- ── 3. ACTIVITIES (recreate with new CRM schema) ────────────────\n`;
  sql += `DROP TABLE IF EXISTS activities CASCADE;\n`;
  sql += `CREATE TABLE activities (\n`;
  sql += `  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n`;
  sql += `  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,\n`;
  sql += `  contact_id UUID REFERENCES company_contacts(id) ON DELETE SET NULL,\n`;
  sql += `  user_id UUID REFERENCES auth.users(id),\n`;
  sql += `  type TEXT DEFAULT 'звонок',\n`;
  sql += `  content TEXT NOT NULL,\n`;
  sql += `  next_contact_date DATE,\n`;
  sql += `  created_at TIMESTAMPTZ DEFAULT now()\n`;
  sql += `);\n\n`;
  
  sql += `CREATE INDEX IF NOT EXISTS idx_activities_company ON activities(company_id);\n`;
  sql += `CREATE INDEX IF NOT EXISTS idx_activities_user ON activities(user_id);\n`;
  sql += `CREATE INDEX IF NOT EXISTS idx_activities_date ON activities(created_at DESC);\n\n`;
  
  sql += `-- ── 4. PROPOSALS (КП) ────────────────────────────────────────\n`;
  sql += `CREATE TABLE IF NOT EXISTS proposals (\n`;
  sql += `  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n`;
  sql += `  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,\n`;
  sql += `  manager_id UUID REFERENCES auth.users(id),\n`;
  sql += `  manager_name TEXT DEFAULT '',\n`;
  sql += `  number TEXT,\n`;
  sql += `  status TEXT DEFAULT 'отправлено',\n`;
  sql += `  total_amount BIGINT DEFAULT 0,\n`;
  sql += `  valid_until DATE,\n`;
  sql += `  notes TEXT,\n`;
  sql += `  created_at TIMESTAMPTZ DEFAULT now(),\n`;
  sql += `  updated_at TIMESTAMPTZ DEFAULT now()\n`;
  sql += `);\n\n`;
  
  sql += `CREATE INDEX IF NOT EXISTS idx_proposals_company ON proposals(company_id);\n\n`;
  
  sql += `-- ── 5. PROPOSAL ITEMS ────────────────────────────────────────\n`;
  sql += `CREATE TABLE IF NOT EXISTS proposal_items (\n`;
  sql += `  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),\n`;
  sql += `  proposal_id UUID NOT NULL REFERENCES proposals(id) ON DELETE CASCADE,\n`;
  sql += `  product_name TEXT NOT NULL,\n`;
  sql += `  description TEXT,\n`;
  sql += `  quantity INT DEFAULT 1,\n`;
  sql += `  unit TEXT DEFAULT 'шт.',\n`;
  sql += `  price_per_unit BIGINT DEFAULT 0,\n`;
  sql += `  total_price BIGINT DEFAULT 0,\n`;
  sql += `  created_at TIMESTAMPTZ DEFAULT now()\n`;
  sql += `);\n\n`;
  
  sql += `CREATE INDEX IF NOT EXISTS idx_proposal_items_proposal ON proposal_items(proposal_id);\n\n`;
  
  // ---- updated_at trigger ----
  sql += `-- ── 6. TRIGGERS ──────────────────────────────────────────────\n`;
  sql += `CREATE OR REPLACE FUNCTION update_updated_at()\n`;
  sql += `RETURNS TRIGGER AS $$\n`;
  sql += `BEGIN\n  NEW.updated_at = now(); RETURN NEW;\nEND;\n$$ LANGUAGE plpgsql;\n\n`;
  
  sql += `DROP TRIGGER IF EXISTS companies_updated_at ON companies;\n`;
  sql += `CREATE TRIGGER companies_updated_at BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION update_updated_at();\n`;
  sql += `DROP TRIGGER IF EXISTS proposals_updated_at ON proposals;\n`;
  sql += `CREATE TRIGGER proposals_updated_at BEFORE UPDATE ON proposals FOR EACH ROW EXECUTE FUNCTION update_updated_at();\n\n`;
  
  // ---- RLS (disable for import, will re-enable after) ----
  sql += `-- ── 7. DISABLE RLS FOR IMPORT ─────────────────────────────────\n`;
  sql += `ALTER TABLE companies ENABLE ROW LEVEL SECURITY;\n`;
  sql += `ALTER TABLE company_contacts ENABLE ROW LEVEL SECURITY;\n`;
  sql += `ALTER TABLE activities ENABLE ROW LEVEL SECURITY;\n`;
  sql += `ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;\n`;
  sql += `ALTER TABLE proposal_items ENABLE ROW LEVEL SECURITY;\n\n`;
  
  // Drop existing policies if they exist, then create permissive ones
  sql += `DO $$ BEGIN\n`;
  const rlsTables = ['companies', 'company_contacts', 'activities', 'proposals', 'proposal_items'];
  for (const t of rlsTables) {
    sql += `  DROP POLICY IF EXISTS "${t}_select" ON ${t};\n`;
    sql += `  DROP POLICY IF EXISTS "${t}_insert" ON ${t};\n`;
    sql += `  DROP POLICY IF EXISTS "${t}_update" ON ${t};\n`;
    sql += `  DROP POLICY IF EXISTS "${t}_delete" ON ${t};\n`;
  }
  sql += `EXCEPTION WHEN OTHERS THEN NULL;\nEND $$;\n\n`;
  
  // Service role bypasses RLS, so we just need basic policies for the app
  sql += `-- Allow authenticated users full access (permissive policies)\n`;
  sql += `CREATE POLICY "companies_select" ON companies FOR SELECT USING (true);\n`;
  sql += `CREATE POLICY "companies_insert" ON companies FOR INSERT WITH CHECK (true);\n`;
  sql += `CREATE POLICY "companies_update" ON companies FOR UPDATE USING (true);\n`;
  sql += `CREATE POLICY "companies_delete" ON companies FOR DELETE USING (true);\n\n`;
  
  sql += `CREATE POLICY "contacts_select" ON company_contacts FOR SELECT USING (true);\n`;
  sql += `CREATE POLICY "contacts_insert" ON company_contacts FOR INSERT WITH CHECK (true);\n`;
  sql += `CREATE POLICY "contacts_update" ON company_contacts FOR UPDATE USING (true);\n`;
  sql += `CREATE POLICY "contacts_delete" ON company_contacts FOR DELETE USING (true);\n\n`;
  
  sql += `CREATE POLICY "activities_select" ON activities FOR SELECT USING (true);\n`;
  sql += `CREATE POLICY "activities_insert" ON activities FOR INSERT WITH CHECK (true);\n\n`;
  
  sql += `CREATE POLICY "proposals_select" ON proposals FOR SELECT USING (true);\n`;
  sql += `CREATE POLICY "proposals_insert" ON proposals FOR INSERT WITH CHECK (true);\n`;
  sql += `CREATE POLICY "proposals_update" ON proposals FOR UPDATE USING (true);\n`;
  sql += `CREATE POLICY "proposals_delete" ON proposals FOR DELETE USING (true);\n\n`;
  
  sql += `CREATE POLICY "proposal_items_select" ON proposal_items FOR SELECT USING (true);\n`;
  sql += `CREATE POLICY "proposal_items_insert" ON proposal_items FOR INSERT WITH CHECK (true);\n`;
  sql += `CREATE POLICY "proposal_items_update" ON proposal_items FOR UPDATE USING (true);\n`;
  sql += `CREATE POLICY "proposal_items_delete" ON proposal_items FOR DELETE USING (true);\n\n`;
  
  // ---- INSERT COMPANIES ----
  sql += `-- ================================================================\n`;
  sql += `-- INSERT COMPANIES (${allCompanies.length} records)\n`;
  sql += `-- ================================================================\n\n`;
  
  for (let i = 0; i < allCompanies.length; i++) {
    const c = allCompanies[i];
    const alias = `c${i}`;
    
    sql += `-- Company: ${c.name || '(no name)'}${c.inn ? ' (ИНН: ' + c.inn + ')' : ''} | Manager: ${c.manager}\n`;
    sql += `INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (\n`;
    sql += `  ${escapeSql(c.name || '(без названия)')},\n`;
    sql += `  ${escapeSqlOrNull(c.inn)},\n`;
    sql += `  ${escapeSqlOrNull(c.city)},\n`;
    sql += `  ${escapeSqlOrNull(c.website)},\n`;
    sql += `  ${escapeSqlOrNull(c.phone)},\n`;
    sql += `  ${escapeSqlOrNull(c.email)},\n`;
    sql += `  ${escapeSql(c.source)},\n`;
    sql += `  ${escapeSql(c.status)},\n`;
    sql += `  ${escapeSql(c.manager)},\n`;
    sql += `  ${c.next_contact_date ? "'" + c.next_contact_date + "'" : 'NULL'},\n`;
    sql += `  ${escapeSqlOrNull(c.notes)}\n`;
    sql += `);\n\n`;
  }
  
  // ---- INSERT CONTACTS (ЛПР) ----
  let totalContacts = 0;
  sql += `-- ================================================================\n`;
  sql += `-- INSERT COMPANY CONTACTS (ЛПР)\n`;
  sql += `-- ================================================================\n\n`;
  
  for (let i = 0; i < allCompanies.length; i++) {
    const c = allCompanies[i];
    if (!c.contacts || c.contacts.length === 0) continue;
    
    for (let j = 0; j < c.contacts.length; j++) {
      const contact = c.contacts[j];
      if (!contact.name && !contact.phone && !contact.email) continue;
      
      totalContacts++;
      sql += `INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (\n`;
      sql += `  (SELECT id FROM companies WHERE inn ${c.inn ? '= ' + escapeSql(c.inn) : 'IS NULL'} AND name = ${escapeSql(c.name || '(без названия)')} LIMIT 1),\n`;
      sql += `  ${escapeSql(contact.name || '')},\n`;
      sql += `  ${escapeSqlOrNull(contact.position)},\n`;
      sql += `  ${escapeSqlOrNull(contact.phone)},\n`;
      sql += `  ${escapeSqlOrNull(contact.email)},\n`;
      sql += `  ${j === 0 ? 'true' : 'false'}\n`;
      sql += `);\n\n`;
    }
  }
  
  // ---- INSERT ACTIVITIES (from comments) ----
  sql += `-- ================================================================\n`;
  sql += `-- INSERT ACTIVITIES (from comments/notes)\n`;
  sql += `-- ================================================================\n\n`;
  
  for (let i = 0; i < allCompanies.length; i++) {
    const c = allCompanies[i];
    if (!c.notes || c.notes.length < 3) continue;
    
    // Determine activity type based on content
    let type = 'звонок';
    const lower = c.notes.toLowerCase();
    if (lower.includes('кп') || lower.includes('коммерческое') || lower.includes('предложение')) type = 'кп_отправлено';
    else if (lower.includes('встреча')) type = 'встреча';
    else if (lower.includes('письмо') || lower.includes('почта') || lower.includes('email')) type = 'письмо';
    else if (lower.includes('вatsapp') || lower.includes('whatsapp') || lower.includes('ватсап')) type = 'whatsapp';
    else if (lower.includes('на связи') || lower.includes('не дозвон')) type = 'звонок';
    else type = 'заметка';
    
    sql += `INSERT INTO activities (company_id, type, content, created_at) VALUES (\n`;
    sql += `  (SELECT id FROM companies WHERE inn ${c.inn ? '= ' + escapeSql(c.inn) : 'IS NULL'} AND name = ${escapeSql(c.name || '(без названия)')} LIMIT 1),\n`;
    sql += `  ${escapeSql(type)},\n`;
    sql += `  ${escapeSql(c.notes)},\n`;
    sql += `  now()\n`;
    sql += `);\n\n`;
  }
  
  // ---- INSERT PROPOSALS (КП from рам2 Sheet3) ----
  if (allProposals.length > 0) {
    sql += `-- ================================================================\n`;
    sql += `-- INSERT PROPOSALS (КП — коммерческие предложения)\n`;
    sql += `-- ================================================================\n\n`;
    
    for (let i = 0; i < allProposals.length; i++) {
      const p = allProposals[i];
      const totalAmount = p.items.reduce((sum, item) => sum + item.total_price, 0);
      
      sql += `INSERT INTO proposals (company_id, manager_name, number, status, total_amount, valid_until, notes, created_at) VALUES (\n`;
      sql += `  (SELECT id FROM companies WHERE inn ${p.inn ? '= ' + escapeSql(p.inn) : 'IS NULL'} AND name = ${escapeSql(p.company_name || '(без названия)')} LIMIT 1),\n`;
      sql += `  ${escapeSql(p.manager)},\n`;
      sql += `  ${escapeSql('КП-' + String(i + 1).padStart(3, '0'))},\n`;
      sql += `  'отправлено',\n`;
      sql += `  ${totalAmount},\n`;
      sql += `  ${p.answer_date ? "'" + p.answer_date + "'" : 'NULL'},\n`;
      sql += `  ${escapeSql('Запрос от ' + (p.query_date || 'неизвестно'))},\n`;
      sql += `  ${p.query_date ? "'" + p.query_date + "'" : 'now()'}\n`;
      sql += `);\n\n`;
      
      // Insert proposal items
      for (const item of p.items) {
        sql += `INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (\n`;
        sql += `  (SELECT id FROM proposals WHERE number = ${escapeSql('КП-' + String(i + 1).padStart(3, '0'))} LIMIT 1),\n`;
        sql += `  ${escapeSql(item.product_name)},\n`;
        sql += `  ${item.quantity},\n`;
        sql += `  'шт.',\n`;
        sql += `  ${item.price_per_unit},\n`;
        sql += `  ${item.total_price}\n`;
        sql += `);\n\n`;
      }
    }
  }
  
  // ---- UPDATE PIPELINE STAGES ----
  sql += `-- ================================================================\n`;
  sql += `-- UPDATE PIPELINE STAGES (if table exists)\n`;
  sql += `-- ================================================================\n\n`;
  sql += `DO $$ BEGIN\n`;
  sql += `  UPDATE pipeline_stages SET name='Слабый интерес', position=1, probability=10, color='#94a3b8' WHERE name='Lead';\n`;
  sql += `  UPDATE pipeline_stages SET name='Надо залечивать', position=2, probability=30, color='#f59e0b' WHERE name='Contact';\n`;
  sql += `  UPDATE pipeline_stages SET name='Запрос КП', position=3, probability=50, color='#3b82f6' WHERE name='Negotiation';\n`;
  sql += `  UPDATE pipeline_stages SET name='В работе', position=4, probability=70, color='#8b5cf6' WHERE name='Proposal';\n`;
  sql += `  UPDATE pipeline_stages SET name='Заказ', position=5, probability=100, color='#22c55e' WHERE name='Agreement';\n`;
  sql += `  UPDATE pipeline_stages SET name='Отказ', position=6, probability=0, color='#ef4444' WHERE name='Lost';\n`;
  sql += `EXCEPTION WHEN OTHERS THEN NULL;\n`;
  sql += `END $$;\n\n`;
  
  return sql;
}

// ============================================================
// 5. MAIN
// ============================================================

console.log('='.repeat(60));
console.log('PulseCRM — Excel Import Script');
console.log('='.repeat(60));

console.log('\nParsing Excel files...\n');
parseAlik();
parseMagel();
parseRam();
parseRam2();
parseAnar();

console.log(`\n--- Results ---`);
console.log(`Total unique companies: ${allCompanies.length}`);
console.log(`Total proposals (КП): ${allProposals.length}`);

// Count contacts
let totalContacts = 0;
allCompanies.forEach(c => { totalContacts += (c.contacts?.length || 0); });
console.log(`Total contacts (ЛПР): ${totalContacts}`);

// Count by manager
const byManager = {};
allCompanies.forEach(c => { byManager[c.manager] = (byManager[c.manager] || 0) + 1; });
console.log(`\nBy manager:`);
Object.entries(byManager).sort((a, b) => b[1] - a[1]).forEach(([m, n]) => console.log(`  ${m}: ${n}`));

// Count by status
const byStatus = {};
allCompanies.forEach(c => { byStatus[c.status] = (byStatus[c.status] || 0) + 1; });
console.log(`\nBy status:`);
Object.entries(byStatus).sort((a, b) => b[1] - a[1]).forEach(([s, n]) => console.log(`  ${s}: ${n}`));

// Count by source
const bySource = {};
allCompanies.forEach(c => { bySource[c.source] = (bySource[c.source] || 0) + 1; });
console.log(`\nBy source:`);
Object.entries(bySource).sort((a, b) => b[1] - a[1]).forEach(([s, n]) => console.log(`  ${s}: ${n}`));

// Show some without names
const noName = allCompanies.filter(c => !c.name);
console.log(`\nCompanies without name: ${noName.length}`);

// Show duplicates info
const withINN = allCompanies.filter(c => c.inn);
console.log(`Companies with INN: ${withINN.length}`);
const withoutINN = allCompanies.filter(c => !c.inn);
console.log(`Companies without INN: ${withoutINN.length}`);

console.log('\nGenerating SQL...');
const sql = generateSQL();
const outPath = path.join(__dirname, 'import-data.sql');
fs.writeFileSync(outPath, sql, 'utf-8');
console.log(`\nSQL file saved to: ${outPath}`);
console.log(`SQL file size: ${(sql.length / 1024).toFixed(1)} KB`);
console.log('\nDone! Run this SQL file in Supabase SQL Editor.');
