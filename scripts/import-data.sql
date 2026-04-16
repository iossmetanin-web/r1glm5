-- ================================================================
-- PulseCRM — Complete Database Setup + Data Import
-- Generated: 2026-04-16T23:15:28.372Z
-- Companies: 431 | Proposals: 5
-- ================================================================

-- ── 1. COMPANIES ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  inn TEXT,
  city TEXT,
  website TEXT,
  contact_phone TEXT,
  contact_email TEXT,
  source TEXT DEFAULT 'холодный обзвон',
  status TEXT DEFAULT 'слабый интерес',
  manager_id UUID REFERENCES auth.users(id),
  manager_name TEXT DEFAULT '',
  next_contact_date DATE,
  lost_reason TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_companies_inn ON companies(inn) WHERE inn IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_companies_manager ON companies(manager_id);
CREATE INDEX IF NOT EXISTS idx_companies_status ON companies(status);
CREATE INDEX IF NOT EXISTS idx_companies_next_contact ON companies(next_contact_date) WHERE next_contact_date IS NOT NULL;

-- ── 2. COMPANY CONTACTS (ЛПР) ────────────────────────────────
CREATE TABLE IF NOT EXISTS company_contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  name TEXT NOT NULL DEFAULT '',
  position TEXT,
  phone TEXT,
  email TEXT,
  whatsapp TEXT,
  notes TEXT,
  is_primary BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_contacts_company ON company_contacts(company_id);

-- ── 3. ACTIVITIES (recreate with new CRM schema) ────────────────
DROP TABLE IF EXISTS activities CASCADE;
CREATE TABLE activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  contact_id UUID REFERENCES company_contacts(id) ON DELETE SET NULL,
  user_id UUID REFERENCES auth.users(id),
  type TEXT DEFAULT 'звонок',
  content TEXT NOT NULL,
  next_contact_date DATE,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_activities_company ON activities(company_id);
CREATE INDEX IF NOT EXISTS idx_activities_user ON activities(user_id);
CREATE INDEX IF NOT EXISTS idx_activities_date ON activities(created_at DESC);

-- ── 4. PROPOSALS (КП) ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS proposals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  manager_id UUID REFERENCES auth.users(id),
  manager_name TEXT DEFAULT '',
  number TEXT,
  status TEXT DEFAULT 'отправлено',
  total_amount BIGINT DEFAULT 0,
  valid_until DATE,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_proposals_company ON proposals(company_id);

-- ── 5. PROPOSAL ITEMS ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS proposal_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proposal_id UUID NOT NULL REFERENCES proposals(id) ON DELETE CASCADE,
  product_name TEXT NOT NULL,
  description TEXT,
  quantity INT DEFAULT 1,
  unit TEXT DEFAULT 'шт.',
  price_per_unit BIGINT DEFAULT 0,
  total_price BIGINT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_proposal_items_proposal ON proposal_items(proposal_id);

-- ── 6. TRIGGERS ──────────────────────────────────────────────
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now(); RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS companies_updated_at ON companies;
CREATE TRIGGER companies_updated_at BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION update_updated_at();
DROP TRIGGER IF EXISTS proposals_updated_at ON proposals;
CREATE TRIGGER proposals_updated_at BEFORE UPDATE ON proposals FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ── 7. DISABLE RLS FOR IMPORT ─────────────────────────────────
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE company_contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_items ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  DROP POLICY IF EXISTS "companies_select" ON companies;
  DROP POLICY IF EXISTS "companies_insert" ON companies;
  DROP POLICY IF EXISTS "companies_update" ON companies;
  DROP POLICY IF EXISTS "companies_delete" ON companies;
  DROP POLICY IF EXISTS "company_contacts_select" ON company_contacts;
  DROP POLICY IF EXISTS "company_contacts_insert" ON company_contacts;
  DROP POLICY IF EXISTS "company_contacts_update" ON company_contacts;
  DROP POLICY IF EXISTS "company_contacts_delete" ON company_contacts;
  DROP POLICY IF EXISTS "activities_select" ON activities;
  DROP POLICY IF EXISTS "activities_insert" ON activities;
  DROP POLICY IF EXISTS "activities_update" ON activities;
  DROP POLICY IF EXISTS "activities_delete" ON activities;
  DROP POLICY IF EXISTS "proposals_select" ON proposals;
  DROP POLICY IF EXISTS "proposals_insert" ON proposals;
  DROP POLICY IF EXISTS "proposals_update" ON proposals;
  DROP POLICY IF EXISTS "proposals_delete" ON proposals;
  DROP POLICY IF EXISTS "proposal_items_select" ON proposal_items;
  DROP POLICY IF EXISTS "proposal_items_insert" ON proposal_items;
  DROP POLICY IF EXISTS "proposal_items_update" ON proposal_items;
  DROP POLICY IF EXISTS "proposal_items_delete" ON proposal_items;
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

-- Allow authenticated users full access (permissive policies)
CREATE POLICY "companies_select" ON companies FOR SELECT USING (true);
CREATE POLICY "companies_insert" ON companies FOR INSERT WITH CHECK (true);
CREATE POLICY "companies_update" ON companies FOR UPDATE USING (true);
CREATE POLICY "companies_delete" ON companies FOR DELETE USING (true);

CREATE POLICY "contacts_select" ON company_contacts FOR SELECT USING (true);
CREATE POLICY "contacts_insert" ON company_contacts FOR INSERT WITH CHECK (true);
CREATE POLICY "contacts_update" ON company_contacts FOR UPDATE USING (true);
CREATE POLICY "contacts_delete" ON company_contacts FOR DELETE USING (true);

CREATE POLICY "activities_select" ON activities FOR SELECT USING (true);
CREATE POLICY "activities_insert" ON activities FOR INSERT WITH CHECK (true);

CREATE POLICY "proposals_select" ON proposals FOR SELECT USING (true);
CREATE POLICY "proposals_insert" ON proposals FOR INSERT WITH CHECK (true);
CREATE POLICY "proposals_update" ON proposals FOR UPDATE USING (true);
CREATE POLICY "proposals_delete" ON proposals FOR DELETE USING (true);

CREATE POLICY "proposal_items_select" ON proposal_items FOR SELECT USING (true);
CREATE POLICY "proposal_items_insert" ON proposal_items FOR INSERT WITH CHECK (true);
CREATE POLICY "proposal_items_update" ON proposal_items FOR UPDATE USING (true);
CREATE POLICY "proposal_items_delete" ON proposal_items FOR DELETE USING (true);

-- ================================================================
-- INSERT COMPANIES (431 records)
-- ================================================================

-- Company: ГТтехнолоджис | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ГТтехнолоджис',
  NULL,
  NULL,
  'www.gtenergo',
  NULL,
  NULL,
  'входящая заявка',
  'слабый интерес',
  'Алик',
  NULL,
  'Входяшка.Отправил КП'
);

-- Company: ООО "ТрансЭнергоХолдинг" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТрансЭнергоХолдинг"',
  NULL,
  NULL,
  'www.tehold',
  NULL,
  NULL,
  'входящая заявка',
  'слабый интерес',
  'Алик',
  NULL,
  'Входяшка, звонил анар попутка по нашей теме отправилКП'
);

-- Company: ООО "СПЕЦЭКОНОМЭНЕРГО" 3528257419 (ИНН: 3528257419) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "СПЕЦЭКОНОМЭНЕРГО" 3528257419',
  '3528257419',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'надо залечивать',
  'Алик',
  NULL,
  'На связи с ним'
);

-- Company: ГлавЭлектроСнаб | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ГлавЭлектроСнаб',
  NULL,
  NULL,
  'gesnab.ru/',
  NULL,
  NULL,
  'холодный обзвон',
  'надо залечивать',
  'Алик',
  NULL,
  'На связи с ним'
);

-- Company: ООО "ПЭП" 7801454062 (ИНН: 7801454062) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПЭП" 7801454062',
  '7801454062',
  NULL,
  NULL,
  NULL,
  '4958999@pep-spb.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Сказал директор отправить на щакупшика на валентина с ним еще пообщаться надо'
);

-- Company: АртЭнерго строй | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АртЭнерго строй',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@aenergo.su',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'недозвон кп отправил'
);

-- Company: Инженерный центр Энергетики | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Инженерный центр Энергетики',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@ecenergy.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Пообшались сказали закупают кп отправил'
);

-- Company: ЭТС Энерго | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ЭТС Энерго',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'недозвон кп отправил'
);

-- Company: Олниса | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Олниса',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'кп отправил'
);

-- Company: Систем Электрик | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Систем Электрик',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'ОТправил кп сложно пробиться'
);

-- Company: Стройэнергоком | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Стройэнергоком',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Сказал закупили уже много чего в первом квартале, звонить в конце августа'
);

-- Company: ТрансЭлектромонтаж | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ТрансЭлектромонтаж',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Отправил КП, поговорил сказал перенабрать поговорить точечно а так закупают'
);

-- Company: Тверь Энергоактив | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Тверь Энергоактив',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отправил недозвон пока что с кем то разговаривал'
);

-- Company: ООО "Элмонт Энерго" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Элмонт Энерго"',
  NULL,
  NULL,
  NULL,
  NULL,
  'snab@elmont.su',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Попросил кп на почту снабженец'
);

-- Company: Сетьстрой | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Сетьстрой',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@setistroi.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отправил , сказал пока что вопрос по поставкам неакутальный, но будем пробивать его'
);

-- Company: МагистральЭнерго | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'МагистральЭнерго',
  NULL,
  NULL,
  NULL,
  NULL,
  'sklad-mag-energo@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отправил Занято'
);

-- Company: ЭнергоПромСТрой | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ЭнергоПромСТрой',
  NULL,
  NULL,
  NULL,
  NULL,
  'eps.llc@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отправил Занято'
);

-- Company: Норэнс Групп | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Норэнс Групп',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@norens.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отправил Занято'
);

-- Company: МосСитиСервис | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'МосСитиСервис',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@mss-24.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отправил сложно пробиться буду пробовать еще раз'
);

-- Company: ЭнергоСистемы | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ЭнергоСистемы',
  NULL,
  NULL,
  NULL,
  NULL,
  'Zayavka@e-systems.su',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Телефон не работает'
);

-- Company: Магистр | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Магистр',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@magistr3m.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Блять не понимаю че у них у всех с телефонами'
);

-- Company: Строймонтаж | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Строймонтаж',
  NULL,
  NULL,
  NULL,
  NULL,
  'snab@stroymontag.su',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Сказала отправляйте кп рассмотрим начальник отдела снабжения'
);

-- Company: ООО "СК ЭНЕРГЕТИК" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "СК ЭНЕРГЕТИК"',
  NULL,
  NULL,
  NULL,
  NULL,
  'sk.msk@inbox.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Ответила женщина сказала проекты есть направляйте кп для снаюжения еще раз перезвоним ей потом'
);

-- Company: СПМенерго | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'СПМенерго',
  NULL,
  NULL,
  NULL,
  NULL,
  'Spmenergo@gmail.com',
  'холодный обзвон',
  'в работе',
  'Алик',
  NULL,
  'пока что сказала ничего нет в работе'
);

-- Company: ВМЗ | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ВМЗ',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Мой клиент по основной работе, у них конкурсы черещ плошадку их собственную там надо регать компанию чтобы учавствовать'
);

-- Company: АО "НПОТЭЛ" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "НПОТЭЛ"',
  NULL,
  NULL,
  NULL,
  NULL,
  'kazakov.i@ural.tavrida.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Договорились тут на встречу классны типо закупают'
);

-- Company: ООО "УРАЛМАШ НГО ХОЛДИНГ" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "УРАЛМАШ НГО ХОЛДИНГ"',
  NULL,
  NULL,
  NULL,
  NULL,
  'info.urbo@uralmash-ngo.com',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Не дозвонился попробовать еще раз в снабжение/ не дозвон пока что'
);

-- Company: ООО "КАПРАЛ БРИДЖ" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "КАПРАЛ БРИДЖ"',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@cupralbridge.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Сказала закупают, направлю письмо сказщала посмотрит'
);

-- Company: ООО "ЭСК" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭСК"',
  NULL,
  NULL,
  NULL,
  NULL,
  'energysc@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Не дозвонился пока что до него, скинул, позже набрать/ на обеде сказал чуть позже набрать'
);

-- Company: ООО "СТРОЙТЕХУРАЛ" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "СТРОЙТЕХУРАЛ"',
  NULL,
  NULL,
  NULL,
  NULL,
  'amg_off@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Заинтересовался, попросил предложение на почту'
);

-- Company: ООО "АГРЕГАТЭЛЕКТРО" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "АГРЕГАТЭЛЕКТРО"',
  NULL,
  NULL,
  NULL,
  NULL,
  'agregatel@bk.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  '2025-06-11',
  'Номер щакупок выцепил пока что не отвечают, отправляю кп   89204505168 Роман Сергеевич agregatel1@bk.ru(11.06)'
);

-- Company: ООО "РЕГИОНИНЖИНИРИНГ" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "РЕГИОНИНЖИНИРИНГ"',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@pgregion.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Сказал зщакупают все ок запросы пришлет'
);

-- Company: ООО "ЭНЕРГОТЕХСЕРВИС" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОТЕХСЕРВИС"',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@tmenergo.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Вадим Логист, сказал перешлет письмо с инженерам с ним на коннекте'
);

-- Company: АО "ТД "ЭЛЕКТРОТЕХМОНТАЖ" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ТД "ЭЛЕКТРОТЕХМОНТАЖ"',
  NULL,
  NULL,
  NULL,
  NULL,
  'etm@etm.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Не дозвонился но кп отправил, пробовать снова'
);

-- Company: ООО "ОМСКЭЛЕКТРОМОНТАЖ" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ОМСКЭЛЕКТРОМОНТАЖ"',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@omskem.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'В вотсап написал 10 июля'
);

-- Company: ООО "ЭЛЕКТРОЩИТ" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛЕКТРОЩИТ"',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@elshkaf.ru',
  'холодный обзвон',
  'сделал заказ',
  'Алик',
  NULL,
  'Пока что нет ее на месте кп отправил перезвонить. ОТправил ей кп, сказала закупают рассмотрит/ короче ктп сами делают говорит в основном заказчик сам приорбретает трансформатор но если что то будет направит'
);

-- Company: ООО "ПРОМСОРТ-ТУЛА" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПРОМСОРТ-ТУЛА"',
  NULL,
  NULL,
  NULL,
  NULL,
  'tulasteel@tulachermet.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Нвправио кп в отдел снабжения'
);

-- Company: ООО НПК "ЭЛПРОМ" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО НПК "ЭЛПРОМ"',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал заказ',
  'Алик',
  NULL,
  'Короче они заказывают по ошибке реально они зщаказывали трансу другой компании короче надо внедриться к ним, не отвечает 11.06/ не отвечает пока что Юлия/stv@/Юлия не отвечает пока что 10/07'
);

-- Company: ООО "ПРОМКОМПЛЕКТАЦИЯ" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПРОМКОМПЛЕКТАЦИЯ"',
  NULL,
  NULL,
  NULL,
  NULL,
  'oleg.kadochkin@start-el.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Сказал закупают кп направляю'
);

-- Company: АО "ВНИИР ГИДРОЭЛЕКТРОАВТОМАТИКА" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ВНИИР ГИДРОЭЛЕКТРОАВТОМАТИКА"',
  NULL,
  NULL,
  NULL,
  NULL,
  'vniir@vniir.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Сказал скиньте инфу посмотрим'
);

-- Company: ООО "УВАДРЕВ-ХОЛДИНГ" 1831090774 (ИНН: 1831090774) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "УВАДРЕВ-ХОЛДИНГ" 1831090774',
  '1831090774',
  NULL,
  NULL,
  NULL,
  'office-st@hk-vostok.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Не отвечает пока что перезвонить кп направил'
);

-- Company: ООО "ЭЛЕКТРОЩИТ-УФА"0278151411 (ИНН: 0278151411) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛЕКТРОЩИТ-УФА"0278151411',
  '0278151411',
  NULL,
  NULL,
  NULL,
  'info@electroshield.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'не отвечает перезвонить/не отвечает не могу дозвонится пока что на обеде'
);

-- Company: ООО "РСК" 3848001367 (ИНН: 3848001367) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "РСК" 3848001367',
  '3848001367',
  NULL,
  NULL,
  NULL,
  'irk@rsktrade.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'не смог дозвониться, видимо все на обеде, чуть позже набрать но через добавочные на них можно выйти /недозвон'
);

-- Company: ООО "ГК АЛЬЯНС"7017409323 (ИНН: 7017409323) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ГК АЛЬЯНС"7017409323',
  '7017409323',
  NULL,
  NULL,
  NULL,
  '3822220075@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Сказал набрать в рабочее время перезвонить/Сказал направить на почту'
);

-- Company: ООО ПТК "ЭКРА-УРАЛ" 6685079144 (ИНН: 6685079144) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ПТК "ЭКРА-УРАЛ" 6685079144',
  '6685079144',
  NULL,
  NULL,
  NULL,
  'info@ekra-ural.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Все слиняли уже на рпаздники набрать после  / пока что не отвечают почему то по добавочному'
);

-- Company: ООО "ТЕКСИС ГРУП"7710620481 (ИНН: 7710620481) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТЕКСИС ГРУП"7710620481',
  '7710620481',
  NULL,
  NULL,
  NULL,
  'sales@texcisgroup.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отправил на Дмитрия/ передам инфу дмитрию и на этом все закончилось мерзкий секретарь 10/07'
);

-- Company: ООО "УРАЛЭНЕРГОЦЕНТР" | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "УРАЛЭНЕРГОЦЕНТР"',
  NULL,
  NULL,
  NULL,
  NULL,
  'trans74@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Сказал заявки есть и проекты тоже есть'
);

-- Company: ООО "РС"7704844420 (ИНН: 7704844420) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "РС"7704844420',
  '7704844420',
  NULL,
  NULL,
  NULL,
  'feedback@russvet.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Попробуем в русский свет пробиться'
);

-- Company: АО "ЭНЕРГОТЕХПРОЕКТ"6319171724 (ИНН: 6319171724) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ЭНЕРГОТЕХПРОЕКТ"6319171724',
  '6319171724',
  NULL,
  NULL,
  NULL,
  'azarova@etpsamara.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Юлия Азарова 2 ярда оборот'
);

-- Company: ООО "ТЭС НН"5258109139 (ИНН: 5258109139) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТЭС НН"5258109139',
  '5258109139',
  NULL,
  NULL,
  NULL,
  'info@tes.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Нет ответа мб уже на праздниках,кп отправил'
);

-- Company: ООО ПО "РОСЭНЕРГОРЕСУРС"5404223516 (ИНН: 5404223516) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ПО "РОСЭНЕРГОРЕСУРС"5404223516',
  '5404223516',
  NULL,
  NULL,
  NULL,
  '410.2@rernsk.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'сказал вышли кп посмотрю'
);

-- Company: ООО "ТЭМ" 6672271281 (ИНН: 6672271281) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТЭМ" 6672271281',
  '6672271281',
  NULL,
  NULL,
  NULL,
  'info@te-montage.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Сказала у них только с атестацией в Россетях но кп сказала направьте'
);

-- Company: ООО "ЭЛЕКТРОНМАШ ПРОМ" 7802447318 (ИНН: 7802447318) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛЕКТРОНМАШ ПРОМ" 7802447318',
  '7802447318',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Перенабрать еще раз не соединилось с отделом закупок'
);

-- Company: 5834121869 ООО "ЭВЕТРА ИНЖИНИРИНГ" (ИНН: 5834121869) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5834121869 ООО "ЭВЕТРА ИНЖИНИРИНГ"',
  '5834121869',
  NULL,
  NULL,
  NULL,
  'dsa@evetraeng.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Сказал закупаем переодически направляю кп'
);

-- Company: ООО "ЭНЕРГОТЕХСТРОЙ"5902126385 (ИНН: 5902126385) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОТЕХСТРОЙ"5902126385',
  '5902126385',
  NULL,
  NULL,
  NULL,
  'office@etsperm.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Тут надо выйти на отдел снабжения они этим занимаются, кп отправил'
);

-- Company: АО "ПО ЭЛТЕХНИКА"7825369360 (ИНН: 7825369360) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ПО ЭЛТЕХНИКА"7825369360',
  '7825369360',
  NULL,
  NULL,
  NULL,
  'info@elteh.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Тут надо выйти на снабжение не отвечали, попробовать дозвониться'
);

-- Company: 5190016541ООО "ТРАНСЭНЕРГО-СЕРВИС" (ИНН: 5190016541) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5190016541ООО "ТРАНСЭНЕРГО-СЕРВИС"',
  '5190016541',
  NULL,
  NULL,
  NULL,
  'info@newtes.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  '89210409085 Михаил'
);

-- Company: 7448200380ООО "КВАНТУМ ЭНЕРГО" (ИНН: 7448200380) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7448200380ООО "КВАНТУМ ЭНЕРГО"',
  '7448200380',
  NULL,
  NULL,
  NULL,
  'omts1@k-en.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Сказала присылайте посмотрим интерес есть'
);

-- Company: 5260342654ООО ТД "СПП" (ИНН: 5260342654) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5260342654ООО ТД "СПП"',
  '5260342654',
  NULL,
  NULL,
  NULL,
  'buh@td-cpp.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Направил кп, недозвон'
);

-- Company: 9102000126 ООО "СПЕЦЩИТКОМПЛЕКТ" (ИНН: 9102000126) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9102000126 ООО "СПЕЦЩИТКОМПЛЕКТ"',
  '9102000126',
  NULL,
  NULL,
  NULL,
  'info@russkomplekt.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Задача пообшаться С катей? обшался с Сергеем, сказал закупают трансформаторы'
);

-- Company: 7728679260 ООО "ПЕТРОИНЖИНИРИНГ" (ИНН: 7728679260) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7728679260 ООО "ПЕТРОИНЖИНИРИНГ"',
  '7728679260',
  NULL,
  NULL,
  NULL,
  'info@petroin.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Каталог отправил кп тоде дозвниться тут не смог'
);

-- Company: 6311115968 ООО "ТСК ВОЛГАЭНЕРГОПРОМ" (ИНН: 6311115968) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6311115968 ООО "ТСК ВОЛГАЭНЕРГОПРОМ"',
  '6311115968',
  NULL,
  NULL,
  NULL,
  'energy-sale@gcvep.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Будет на след неделе а так у них запросы есть, кп отправил в догонку'
);

-- Company: 6672180274 ООО "МОДУЛЬ" (ИНН: 6672180274) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6672180274 ООО "МОДУЛЬ"',
  '6672180274',
  NULL,
  NULL,
  NULL,
  'zakupki@bktp.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отпрапвил сотрудник на совещании перезвонить'
);

-- Company: 3664123615 ООО "ВЭЗ" (ИНН: 3664123615) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3664123615 ООО "ВЭЗ"',
  '3664123615',
  NULL,
  NULL,
  NULL,
  'info@vorez.org',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'До снабжения не дозвонился на обеде, ставлю перезвон, кп в догонку'
);

-- Company: 2126001172 ООО НПП "ЭКРА" (ИНН: 2126001172) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2126001172 ООО НПП "ЭКРА"',
  '2126001172',
  NULL,
  NULL,
  NULL,
  'ekra@ekra.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Обед, перезвонить, кп в догонку/ набрать в 3 по екб обед у них'
);

-- Company: 7733634963 ЗАО "СТРОЙЭНЕРГОКОМПЛЕКТ" (ИНН: 7733634963) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7733634963 ЗАО "СТРОЙЭНЕРГОКОМПЛЕКТ"',
  '7733634963',
  NULL,
  NULL,
  NULL,
  'sen-komplekt@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Перенабрать предложить сотрудничесво секретарь не втухает/перенабрал кп отправил'
);

-- Company: 7813192076 ООО "АТЭКС-ЭЛЕКТРО" (ИНН: 7813192076) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7813192076 ООО "АТЭКС-ЭЛЕКТРО"',
  '7813192076',
  NULL,
  NULL,
  NULL,
  'l11@atelex.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Татьяна закупщик сказала проекты бывают перешлет проектому отделу'
);

-- Company: 7710957615 ООО "ПРОМСТРОЙ" (ИНН: 7710957615) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7710957615 ООО "ПРОМСТРОЙ"',
  '7710957615',
  NULL,
  NULL,
  NULL,
  'info@promstroy-ooo.com',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Направил кп не дозвонился'
);

-- Company: 5404464448ООО "НТК" (ИНН: 5404464448) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5404464448ООО "НТК"',
  '5404464448',
  NULL,
  NULL,
  NULL,
  '2080808@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Не отвечабт скорее всего на обеде отправляю кп на отдел закупок'
);

-- Company: 7702080289 АО "СИЛОВЫЕ МАШИНЫ" (ИНН: 7702080289) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7702080289 АО "СИЛОВЫЕ МАШИНЫ"',
  '7702080289',
  NULL,
  NULL,
  NULL,
  'thermal@power-m.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Для Марии направил письмо'
);

-- Company: 5914007456 ООО "ПРОМЫШЛЕННАЯ ГРУППА ПРОГРЕССИЯ" (ИНН: 5914007456) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5914007456 ООО "ПРОМЫШЛЕННАЯ ГРУППА ПРОГРЕССИЯ"',
  '5914007456',
  NULL,
  NULL,
  NULL,
  'info@pgp-perm.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Закупают кп отправил для них, но нужно узнат имя человека который акупает трансы'
);

-- Company: 4205152361 ООО "ЗЭМ" (ИНН: 4205152361) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4205152361 ООО "ЗЭМ"',
  '4205152361',
  NULL,
  NULL,
  NULL,
  'info@z-em.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Не отвечабт мб на обеде перезвонить с утра'
);

-- Company: 6731035472 ООО "ТД "АВТОМАТИКА" (ИНН: 6731035472) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6731035472 ООО "ТД "АВТОМАТИКА"',
  '6731035472',
  NULL,
  NULL,
  NULL,
  'info@td-automatika.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп направил ему сказал рассмотрит'
);

-- Company: 6670316434 ООО "ЭЗОИС-УРАЛ" (ИНН: 6670316434) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6670316434 ООО "ЭЗОИС-УРАЛ"',
  '6670316434',
  NULL,
  NULL,
  NULL,
  'info@ezois-ural.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'не дозвонился до него нало перещзвонить видимо не на месте/ дозвонился кп отправил'
);

-- Company: 6150045308 ООО "АВИААГРЕГАТ-Н" (ИНН: 6150045308) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6150045308 ООО "АВИААГРЕГАТ-Н"',
  '6150045308',
  NULL,
  NULL,
  NULL,
  'Ogk@avem.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Закупабт тут технари а не отдел снабжения заявку сказал сейчас пришел'
);

-- Company: 5190044620 АО "ТЕХНОГРУПП" (ИНН: 5190044620) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5190044620 АО "ТЕХНОГРУПП"',
  '5190044620',
  NULL,
  NULL,
  NULL,
  'info@technogroupp.com',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'тут не пробился пробовать еще'
);

-- Company: 7814461557 ООО "НТТ-ИК" (ИНН: 7814461557) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7814461557 ООО "НТТ-ИК"',
  '7814461557',
  NULL,
  NULL,
  NULL,
  'info@ferroma.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Закупают трансформаторы сами производят сухие, кп отправил'
);

-- Company: 0571014706 ООО "СПЕЦСТРОЙМОНТАЖ" (ИНН: 0571014706) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0571014706 ООО "СПЕЦСТРОЙМОНТАЖ"',
  '0571014706',
  NULL,
  NULL,
  NULL,
  'specmount05@gmail.com',
  'холодный обзвон',
  'надо залечивать',
  'Алик',
  NULL,
  'Интересно ему ждем от него сообщение в вотсапе'
);

-- Company: 5029227275 ООО "ЭТК" (ИНН: 5029227275) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5029227275 ООО "ЭТК"',
  '5029227275',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Списались в вотсапе'
);

-- Company: 2130100264ООО "НИП" (ИНН: 2130100264) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2130100264ООО "НИП"',
  '2130100264',
  NULL,
  NULL,
  NULL,
  'info@nipdoc.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отправил'
);

-- Company: 7701389420 ООО "АТЕРГО" (ИНН: 7701389420) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7701389420 ООО "АТЕРГО"',
  '7701389420',
  NULL,
  NULL,
  NULL,
  'info@atergo.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Перезвонить Юлии, уточнить акупают ли они трансы представиться как ХЭНГ она закупщица/ Ответил тип какой то выйти на Юоию надо'
);

-- Company: 7736606442 ООО "ТЕХСТРОЙМОНТАЖ" (ИНН: 7736606442) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7736606442 ООО "ТЕХСТРОЙМОНТАЖ"',
  '7736606442',
  NULL,
  NULL,
  NULL,
  'Snab@thsmont.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Закупают кп на почту отправил'
);

-- Company: 6674353123 ООО "АЛЬЯНС РИТЭЙЛ" (ИНН: 6674353123) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6674353123 ООО "АЛЬЯНС РИТЭЙЛ"',
  '6674353123',
  NULL,
  NULL,
  NULL,
  'op@unicumg.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Не отвечали направляю кп'
);

-- Company: 3810051697 ООО ЭНЕРГЕТИЧЕСКАЯ КОМПАНИЯ "РАДИАН" (ИНН: 3810051697) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3810051697 ООО ЭНЕРГЕТИЧЕСКАЯ КОМПАНИЯ "РАДИАН"',
  '3810051697',
  NULL,
  NULL,
  NULL,
  'op@unicumg.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Иркутск кп отправил с утра набрать'
);

-- Company: 6671406440 ООО ИК "ЭНЕРГОСОФТ" (ИНН: 6671406440) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6671406440 ООО ИК "ЭНЕРГОСОФТ"',
  '6671406440',
  NULL,
  NULL,
  NULL,
  'info@s-s-pro.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отправил на него ждем запросы'
);

-- Company: 7820307592 ООО "ЭНЕРГОСТАР" (ИНН: 7820307592) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7820307592 ООО "ЭНЕРГОСТАР"',
  '7820307592',
  NULL,
  NULL,
  NULL,
  'info@starenergo.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Направил кп секретарь сложный'
);

-- Company: 5404396621 ООО НПП "МИКРОПРОЦЕССОРНЫЕ ТЕХНОЛОГИИ" (ИНН: 5404396621) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5404396621 ООО НПП "МИКРОПРОЦЕССОРНЫЕ ТЕХНОЛОГИИ"',
  '5404396621',
  NULL,
  NULL,
  NULL,
  'omts@i-mt.net',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отправил'
);

-- Company: 5903148303 ООО "БЛЮМХЕН" (ИНН: 5903148303) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5903148303 ООО "БЛЮМХЕН"',
  '5903148303',
  NULL,
  NULL,
  NULL,
  'corp.blumchen@gmail.com',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'кп отправил по номерам не дозвониться'
);

-- Company: 1657048240 ООО "УК "КЭР-ХОЛДИНГ" (ИНН: 1657048240) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1657048240 ООО "УК "КЭР-ХОЛДИНГ"',
  '1657048240',
  NULL,
  NULL,
  NULL,
  'office@ker-holding.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Кп отправил'
);

-- Company: 0277071467 ООО "БАШКИРЭНЕРГО" (ИНН: 0277071467) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0277071467 ООО "БАШКИРЭНЕРГО"',
  '0277071467',
  NULL,
  NULL,
  NULL,
  'secr@bashkirenergo.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Пробуем пробиться в башкирэнерго'
);

-- Company: 3446034468ООО "ЭНЕРГИЯ ЮГА" (ИНН: 3446034468) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3446034468ООО "ЭНЕРГИЯ ЮГА"',
  '3446034468',
  NULL,
  NULL,
  NULL,
  'kdv@energy-yug.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'кп отправил на линии занято'
);

-- Company: 7451227920ООО "ЭЛЕКТРОСТРОЙ" (ИНН: 7451227920) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7451227920ООО "ЭЛЕКТРОСТРОЙ"',
  '7451227920',
  NULL,
  NULL,
  NULL,
  'elektrostroy2008@yandex.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'не отвечабт кп направил'
);

-- Company: 0268027020ООО "ЭНЕРГОПРОМСЕРВИС" (ИНН: 0268027020) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0268027020ООО "ЭНЕРГОПРОМСЕРВИС"',
  '0268027020',
  NULL,
  NULL,
  NULL,
  'info@epservice.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'кп направил не отвечают'
);

-- Company: 6166107912 ООО "РОСТЕХЭНЕРГО" (ИНН: 6166107912) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6166107912 ООО "РОСТЕХЭНЕРГО"',
  '6166107912',
  NULL,
  NULL,
  NULL,
  'snab@rte.su',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Отправил ему письмо жду заявку, перенабрать ему тоже надо'
);

-- Company: 6686078707 ООО "ПЭМ" (ИНН: 6686078707) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6686078707 ООО "ПЭМ"',
  '6686078707',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Мы с ним на вотсапе попросил инфу'
);

-- Company: 2116491707 ООО "ИЗВА" (ИНН: 2116491707) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2116491707 ООО "ИЗВА"',
  '2116491707',
  NULL,
  NULL,
  NULL,
  'oz3@izva.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'КП направил она не отвечает перезвонить ей'
);

-- Company: 2502047535 ООО "ВОСТОКЭНЕРГО" (ИНН: 2502047535) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2502047535 ООО "ВОСТОКЭНЕРГО"',
  '2502047535',
  NULL,
  NULL,
  NULL,
  'vostok-elten@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Алик',
  NULL,
  'Отправил кп не дозвонился'
);

-- Company: 5260401638 ООО "КРЭС" (ИНН: 5260401638) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5260401638 ООО "КРЭС"',
  '5260401638',
  NULL,
  NULL,
  '+7 831 202-26-29',
  'info@kresnn.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'сказали обед перезвонить отдел снабжения'
);

-- Company: 7453260063 ООО "СТРОЙЭНЕРГОРЕСУРС" (ИНН: 7453260063) | Manager: Алик
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7453260063 ООО "СТРОЙЭНЕРГОРЕСУРС"',
  '7453260063',
  NULL,
  NULL,
  NULL,
  'electrotmp@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Алик',
  NULL,
  'Антон, главный инженер сказал направбте на мое имя, нужно еще в отдел закупок доб 1'
);

-- Company: Ставропольэлектросеть (ИНН: 2635244268) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Ставропольэлектросеть',
  '2635244268',
  NULL,
  NULL,
  '88652748801',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Будут кидать нам запросы для выход на торги'
);

-- Company: 7817302964 https://izhek.ru/ (ИНН: 7817302964) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7817302964 https://izhek.ru/',
  '7817302964',
  NULL,
  NULL,
  '+78123228659',
  NULL,
  'холодный обзвон',
  'надо залечивать',
  'Магел',
  NULL,
  'Связь с закупчиком хорошая'
);

-- Company: ГОУП «Кировская горэлектросеть» | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ГОУП «Кировская горэлектросеть»',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  NULL
);

-- Company: Евросибэнерго | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Евросибэнерго',
  NULL,
  NULL,
  NULL,
  '83952792233',
  NULL,
  'реклама',
  'слабый интерес',
  'Магел',
  NULL,
  'Поговорил со стасом. Надо регаться на сайте https://td.enplus.ru/ru/zakupki-tovarov/ Можно работать. У нас общие китайцы. Второй звонок'
);

-- Company: ООО ХК "СДС - ЭНЕРГО" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ХК "СДС - ЭНЕРГО"',
  NULL,
  NULL,
  NULL,
  '83842574202',
  'v.nikolaev@sdsenergo.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Готовы брать из наличия. По торгам у них выступает другое юр лицо. Торговый дом sds treid. искать на госзакупках'
);

-- Company: АО "ОБЪЕДИНЕННЫЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ОБЪЕДИНЕННЫЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ"',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'начальник снажения. контакт хороший.жду обратную связь'
);

-- Company: ООО "САМЭСК" 6319231042 (ИНН: 6319231042) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "САМЭСК" 6319231042',
  '6319231042',
  NULL,
  NULL,
  '+7 846 276-60-71',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'работают только через торги. смотреть гос.закупки'
);

-- Company: АО "КРАСЭКО" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "КРАСЭКО"',
  NULL,
  NULL,
  NULL,
  '73912286207',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Поговорил с закупщиком КТП. Женщина. Говорит что закупают напрямую. Просит давать самое выгодное предложение сразу, время торговаться нету. газпром росселторг'
);

-- Company: Энергонефть Томск http://energoneft-tomsk.ru/index.php?id=13 | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Энергонефть Томск http://energoneft-tomsk.ru/index.php?id=13',
  NULL,
  NULL,
  NULL,
  '83825966004',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Не могу дозвониться. надо пробовать.21.05.25. Дозвонился до отдела закупок. Торгуются на площадке газпрома.'
);

-- Company: ЗАО "ЭИСС" 6320005633 (ИНН: 6320005633) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ЗАО "ЭИСС" 6320005633',
  '6320005633',
  NULL,
  NULL,
  '88482637900',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Берут БКТП и трансформаторы. Связаться после среды.'
);

-- Company: АО "Варьегоэнергонефть" https://oaoven.ru/kont.html | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "Варьегоэнергонефть" https://oaoven.ru/kont.html',
  NULL,
  NULL,
  NULL,
  '83466840108',
  NULL,
  'холодный обзвон',
  'надо залечивать',
  'Магел',
  NULL,
  'Связался с начальником ПТО. Тендерная система. Закрытые закупки. Китайцы интересны. По техническим моментам (40140)/ 29.08.2025 заявок нет'
);

-- Company: АО "Пензенская горэлектросеть | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "Пензенская горэлектросеть',
  NULL,
  NULL,
  NULL,
  '88412290679',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Павел не решает. До александра не дозвонился. 5 августа 2025 - заявок нет// 25 августа 2025 года - заявок нет// 17 сентября - заявок нет//'
);

-- Company: АО "ОРЭС-ПРИКАМЬЯ" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ОРЭС-ПРИКАМЬЯ"',
  NULL,
  NULL,
  NULL,
  '83422181631',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  '26.03.2026. заявок нет'
);

-- Company: https://eskchel.ru/ ТМК Энерго | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'https://eskchel.ru/ ТМК Энерго',
  NULL,
  NULL,
  NULL,
  NULL,
  'Gennadiy.Savinov@tmk-group.com',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Заинтересовал снабженца Китаем. Попросил скинуть ему на почту инфу о нас. Говорит, что будет закупка - будет и пища)'
);

-- Company: ООО "ПРОМЭНЕРГОСБЫТ" 7107064602 (ИНН: 7107064602) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПРОМЭНЕРГОСБЫТ" 7107064602',
  '7107064602',
  NULL,
  NULL,
  NULL,
  'endin_ae@promenergosbyt.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'не дохвонился, а надо'
);

-- Company: ПКГУП "КЭС" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ПКГУП "КЭС"',
  NULL,
  NULL,
  NULL,
  '83426140910',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Выбил комер закупщика. Поговорил. Отправят запрос на КТП'
);

-- Company: Акционерное общество «Витимэнерго» | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Акционерное общество «Витимэнерго»',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Набрал в общий отдел. Дали этот номер. Сегодня там   выходной. Набрать завтра. Спросить снабжение'
);

-- Company: Черкессие городские сети 0901048801 (ИНН: 0901048801) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Черкессие городские сети 0901048801',
  '0901048801',
  NULL,
  NULL,
  '88782282251',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Связался с секретарем. Дали комер отдела закупок. Не взяли. Пробовать еще раз.'
);

-- Company: Щекинская ГОРОДСКАЯ ЭЛЕКТРОСЕТЬ | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Щекинская ГОРОДСКАЯ ЭЛЕКТРОСЕТЬ',
  NULL,
  NULL,
  NULL,
  '84875152656',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Поговорил с закупщиком. Женщина в возрасте. Работают под росстеями под торги. Торги проходят на площадке РАД. Будут торги на трансформаторы 250,400,630 после майских'
);

-- Company: ООО "ИНТЕГРАЦИЯ" 1658191691 (ИНН: 1658191691) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ИНТЕГРАЦИЯ" 1658191691',
  '1658191691',
  NULL,
  NULL,
  '88432125300',
  'ustinov@integration-kzn.ru',
  'личный контакт',
  'сделал запрос',
  'Магел',
  NULL,
  'Познакомился с закупщиком. Нашего профиля маловато, но будут скидывать запросы, потому что хорошо поговорили.'
);

-- Company: ООО "НЭСК" 5256133344 (ИНН: 5256133344) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "НЭСК" 5256133344',
  '5256133344',
  NULL,
  NULL,
  '88312990507',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Не дозвонился до инженера. Пробовать еще. в этом году не будет закупок. звонок юыд 14 -7 2025'
);

-- Company: ООО "Электросети" 7024035693 (ИНН: 7024035693) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Электросети" 7024035693',
  '7024035693',
  NULL,
  NULL,
  '83823774986',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Кое-как нашел номер приемной но не дозвонился.11 сенября 2025 вытащил номер главного инженера. было занято/// 18.09.2025. поговорил с инженером. закупки проходят по 223 фз. прямых нет. попросил кп.'
);

-- Company: ООО "ВЭС-СНТ" 3443139342 (ИНН: 3443139342) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ВЭС-СНТ" 3443139342',
  '3443139342',
  NULL,
  NULL,
  '88442561567',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Работают через торги. Наш профиль. Площадка: ЭТП ГПБ.'
);

-- Company: ООО "ЭУ" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭУ"',
  NULL,
  NULL,
  NULL,
  '83436541456',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Берут только измерительные трансы нтми.'
);

-- Company: АО "ХГЭС" 2702032110 (ИНН: 2702032110) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ХГЭС" 2702032110',
  '2702032110',
  NULL,
  NULL,
  '84212479013',
  'zakupki@khges.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Пообщался с закупщицей. Очень хорошо поговорили. Есть и прямые закупки до 1.5 млн. Берут и трансы и ктп. РТС тендер. скоро закупка. Отправил КП'
);

-- Company: МУП "Электросервис" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'МУП "Электросервис"',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  '21.05.2025. Дозовнился до отдела закупок. торгуются на площадке ТЕГТОРГ. Прямых на подстанции и трансы не бывает.'
);

-- Company: АО "ДВ РСК" 2531006580 (ИНН: 2531006580) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ДВ РСК" 2531006580',
  '2531006580',
  NULL,
  NULL,
  '84233148584',
  'buxdvrsk@yandex.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Пообщался со старым) Нормальный перец. будут брать,думаю/ 29.08.2025 не берет'
);

-- Company: АО "УСТЬ-СРЕДНЕКАНСКАЯ ГЭС ИМ. А.Ф. ДЬЯКОВА" 4909095293 (ИНН: 4909095293) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "УСТЬ-СРЕДНЕКАНСКАЯ ГЭС ИМ. А.Ф. ДЬЯКОВА" 4909095293',
  '4909095293',
  NULL,
  NULL,
  '84134346968',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Поговорил с секретарем. Снабженцы сидят на Колымской ГЭС. Дала номер, но там пищат что-то. пробовать позже/29.08.2025. Не дозвон.'
);

-- Company: АО "УССУРИЙСК-ЭЛЕКТРОСЕТЬ" 2511121619 (ИНН: 2511121619) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "УССУРИЙСК-ЭЛЕКТРОСЕТЬ" 2511121619',
  '2511121619',
  NULL,
  NULL,
  '84234322742',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Узнал номер снабжения безхитростным путем. Но там сука не берут. Пытаться еще/29.08.2025. Не дозвон.'
);

-- Company: АО "СЭС" 2510003066 (ИНН: 2510003066) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "СЭС" 2510003066',
  '2510003066',
  NULL,
  NULL,
  '84235223514',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Поговорил с закупщиком. Он сказал, что больших закупок пока не будет, но будут разовые. Китай интересен. 29.08.2025. Не дозвон.'
);

-- Company: АО "КЭС" 4101090167 (ИНН: 4101090167) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "КЭС" 4101090167',
  '4101090167',
  NULL,
  NULL,
  '84152228000',
  'kam.el.sety@yandex.ru',
  'холодный обзвон',
  'сделал заказ',
  'Магел',
  NULL,
  'Поговорил с девочкой. Пока заказов нет, но просит отправить инфу. Контакт хороший'
);

-- Company: ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "ТЕХЦЕНТР" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "ТЕХЦЕНТР"',
  NULL,
  NULL,
  NULL,
  '89242352243',
  NULL,
  'холодный обзвон',
  'сделал заказ',
  'Магел',
  NULL,
  'Руслан хороший парень. Сразу скентовались с ним) Уже есть заказ'
);

-- Company: ООО "ТД "ЭЛЕКТРОСИСТЕМЫ" 2724182990 (ИНН: 2724182990) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТД "ЭЛЕКТРОСИСТЕМЫ" 2724182990',
  '2724182990',
  NULL,
  NULL,
  '84212417002',
  '252@dc-electro.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Поговорил с закупщицей. Рассмотрят наше предложение//29.08.2025  Сказала не занимаются трансами. пиздит возможно'
);

-- Company: ООО "АСК" 2901295280 (ИНН: 2901295280) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "АСК" 2901295280',
  '2901295280',
  NULL,
  NULL,
  '89210795185',
  '103@2488.ru',
  'холодный обзвон',
  'надо залечивать',
  'Магел',
  NULL,
  'Поговорили с Игорем. Интересно ему. Скинет заявку.Поговорил с игорем 14 07 25. не получил заявку'
);

-- Company: Енисей сеть сервис 2465302760 (ИНН: 2465302760) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Енисей сеть сервис 2465302760',
  '2465302760',
  NULL,
  NULL,
  '88182248833',
  'e.e.servis@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'отправил кп на почту/ 29.08.2025 Секретарь ебет мозга'
);

-- Company: Акционерное общество "Городские электрические сети" (АО "Горэлектросеть") 8603004190 (ИНН: 8603004190) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Акционерное общество "Городские электрические сети" (АО "Горэлектросеть") 8603004190',
  '8603004190',
  NULL,
  NULL,
  '83466635907',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Позвонил в отдел снабжения. Поговорил с парнем. Торгуются на РТС. Прямых нет.'
);

-- Company: АО "СИНТЕЗ ГРУПП" 7719609274 (ИНН: 7719609274) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "СИНТЕЗ ГРУПП" 7719609274',
  '7719609274',
  NULL,
  NULL,
  '84951145005',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Разговаривал с закупщиком. Строгий дядя) Но попросил КП.'
);

-- Company: ООО "ПКБ "РЭМ" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПКБ "РЭМ"',
  NULL,
  NULL,
  NULL,
  '88124381622',
  'orlov@pkbrem.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Поговори с начальником снабжения. Скинул КП'
);

-- Company: ООО "ЦЭК" 7714426397 (ИНН: 7714426397) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЦЭК" 7714426397',
  '7714426397',
  NULL,
  NULL,
  NULL,
  'office@celscom.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Отправил снабженцу кп'
);

-- Company: ООО "ПРИЗМА" 2124019520 (ИНН: 2124019520) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПРИЗМА" 2124019520',
  '2124019520',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'отправил кп на почту. звонил. 29.08.2025 сказал на пол года проекты расписаны. отравить кп. Набрать после майских 2026'
);

-- Company: ООО "ГОРСЕТИ" 7017081040 (ИНН: 7017081040) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ГОРСЕТИ" 7017081040',
  '7017081040',
  NULL,
  NULL,
  '83822999513',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'связался с закупками. работают через торги 223 фз. 29.08.2025 закупщица сказала, что не сказала бы что закупка проводится'
);

-- Company: ООО "Томские электрические сети" 7017380970 (ИНН: 7017380970) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Томские электрические сети" 7017380970',
  '7017380970',
  NULL,
  NULL,
  NULL,
  'tes012016@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'поговорил с секретарем. сказала пока не даст номер снабженца и имя не скажет. но ключевое слово пока))'
);

-- Company: "СибБурЭнерго" 7017097931 (ИНН: 7017097931) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"СибБурЭнерго" 7017097931',
  '7017097931',
  NULL,
  NULL,
  NULL,
  'shkv@sibburenergo.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'не прошел секретаря. отдать алику на доработку'
);

-- Company: АО "КЭСР" 1001012723 (ИНН: 1001012723) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "КЭСР" 1001012723',
  '1001012723',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'не дозвон'
);

-- Company: АО "ТЭТ-РС" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ТЭТ-РС"',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'снабженца нет на месте пока. перезвоню'
);

-- Company: ЗАО "ТЭСА" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ЗАО "ТЭСА"',
  NULL,
  NULL,
  NULL,
  '88123226799',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Поговорил со снбаженцем. Пока что мнется, но сказал набрать попозже. может, что появится. у секретаря сразу просить соеденить со снабжением.'
);

-- Company: ООО "КЭС" 5018187729 (ИНН: 5018187729) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "КЭС" 5018187729',
  '5018187729',
  NULL,
  NULL,
  '+7 916 725-52-63',
  'info@korolevseti.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'отправил кп на почту.'
);

-- Company: ООО "НОРДГРОН" 2466250680 (ИНН: 2466250680) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "НОРДГРОН" 2466250680',
  '2466250680',
  NULL,
  NULL,
  '83912001232',
  'info@nordgron.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Заинтересовались. отправил кп'
);

-- Company: ООО "ЭнергоИнжиниринг" (ИНН: 2466169359) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭнергоИнжиниринг"',
  '2466169359',
  NULL,
  NULL,
  NULL,
  'info@eepro.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'отправил кп.'
);

-- Company: ООО ТСК "ЭНЕРГОАЛЬЯНС" 2411027355 (ИНН: 2411027355) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ТСК "ЭНЕРГОАЛЬЯНС" 2411027355',
  '2411027355',
  NULL,
  NULL,
  '89029433265',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'поговорил со светланой. интерес по трансам. скинул цены на вотсапп. 8.04.2026 заявок нет'
);

-- Company: ООО "Энергосибинжиниринг" 2460107451 (ИНН: 2460107451) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Энергосибинжиниринг" 2460107451',
  '2460107451',
  NULL,
  NULL,
  '89232876163',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'поговорил с натальей. хочет россети. скинул инфу на вотсапп. но разговор хороший. будет отправлять заявки.'
);

-- Company: ООО "ЭКРА-ВОСТОК" 2721206795 (ИНН: 2721206795) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭКРА-ВОСТОК" 2721206795',
  '2721206795',
  NULL,
  NULL,
  NULL,
  'vostok@ekra.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Контакт хороший, но не могу отправить письмо. надо норм почту.'
);

-- Company: "КЭС ОРЕНБУРЖЬЯ" 5609088434 (ИНН: 5609088434) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"КЭС ОРЕНБУРЖЬЯ" 5609088434',
  '5609088434',
  NULL,
  NULL,
  '89128497489',
  'kes_2021@bk.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'поговорил со снабженцем. получил заявку'
);

-- Company: МП "ВПЭС" 4703005850 (ИНН: 4703005850) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'МП "ВПЭС" 4703005850',
  '4703005850',
  NULL,
  NULL,
  NULL,
  'ahd.dvg@vsevpes.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Рамочный договор на год. Поговорил с Дашей. Будут иметь нас ввиду.'
);

-- Company: "БОГОРОДСКАЯ ЭЛЕКТРОСЕТЬ" 5031095604 (ИНН: 5031095604) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"БОГОРОДСКАЯ ЭЛЕКТРОСЕТЬ" 5031095604',
  '5031095604',
  NULL,
  NULL,
  '84965101121',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Не поговорил со снабжением. Перезвонить'
);

-- Company: ООО "СИСТЕМА" 9725034250 (ИНН: 9725034250) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "СИСТЕМА" 9725034250',
  '9725034250',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'отправил кп на почту. звонил.'
);

-- Company: ООО "ОЭС" 7727691900 (ИНН: 7727691900) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ОЭС" 7727691900',
  '7727691900',
  NULL,
  NULL,
  '84985683837',
  'info@oesystems.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Набрал. Спецы были заняты. отправил кп. связаться позже'
);

-- Company: ООО "МЭС" 7415041790 (ИНН: 7415041790) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "МЭС" 7415041790',
  '7415041790',
  NULL,
  NULL,
  NULL,
  'mes74@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Поговорил С ЛПР. Китай не инетересен.только подстанции'
);

-- Company: "ЗАПАДНАЯ ЭНЕРГЕТИЧЕСКАЯ КОМПАНИЯ" 3906970638 (ИНН: 3906970638) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ЗАПАДНАЯ ЭНЕРГЕТИЧЕСКАЯ КОМПАНИЯ" 3906970638',
  '3906970638',
  NULL,
  NULL,
  NULL,
  'wpc@inbox.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Поговорил с закупщицей.Попросила скинуть инфу. Будут в понедельник.'
);

-- Company: ОАО "СКЭК". 4205153492 (ИНН: 4205153492) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ОАО "СКЭК". 4205153492',
  '4205153492',
  NULL,
  NULL,
  '83842680851',
  'abzalov@skek.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Не дозвон. Отправил КП.'
);

-- Company: "ФАБИ" 5005005770 (ИНН: 5005005770) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ФАБИ" 5005005770',
  '5005005770',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'выбил номер снабжения. перезвонить через час'
);

-- Company: "ИНТЕР РАО - ИНЖИНИРИНГ" 5036101347 (ИНН: 5036101347) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ИНТЕР РАО - ИНЖИНИРИНГ" 5036101347',
  '5036101347',
  NULL,
  NULL,
  NULL,
  'lukyanov_av@interrao.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'НАРЫЛ НОМЕР ЗАКУПЩИКА. У НИХ ЕСТЬ ГКПЗ. СКАЗАЛ УЧАВСТОВАТЬ В ЗАКУПКАХ НА ОБЩИХ ОСНОВАНИЯХ. ПОКА ВЯЛО. НО НАДО ПРОБИВАТЬ. ОН БЫЛ ОЧЕНЬ УСТАВШИМ. ТОРГУЮТСЯ НА СОБСТВЕННОЙ ПЛОЩАДКЕ: https://interrao-zakupki.ru/purchases/'
);

-- Company: ООО "БГК" 0277077282 (ИНН: 0277077282) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "БГК" 0277077282',
  '0277077282',
  NULL,
  NULL,
  '83472228625',
  'office@bgkrb.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Отправил письмо на ген дира.'
);

-- Company: ООО "МЕРИДИАН ЭНЕРГО" 7743795832 (ИНН: 7743795832) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "МЕРИДИАН ЭНЕРГО" 7743795832',
  '7743795832',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'секретарь сука. не могу пробить.'
);

-- Company: АО "ГОРЭЛЕКТРОСЕТЬ" 7456038645 (ИНН: 7456038645) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ГОРЭЛЕКТРОСЕТЬ" 7456038645',
  '7456038645',
  NULL,
  NULL,
  '83519293083',
  'ges@gesmgn.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'торгуются на ртс тендере.'
);

-- Company: АО "ЭЛЕКТРОУРАЛМОНТАЖ" 6660003489 (ИНН: 6660003489) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ЭЛЕКТРОУРАЛМОНТАЖ" 6660003489',
  '6660003489',
  NULL,
  NULL,
  '83433857000',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'перезвонить завтра. Дозвонился до закупок 5 июня. просят аттестацию россетей. берут 110 трансы и 220 чаще.'
);

-- Company: "СПЕЦЭНЕРГОГРУПП" 7743211928 (ИНН: 7743211928) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"СПЕЦЭНЕРГОГРУПП" 7743211928',
  '7743211928',
  NULL,
  NULL,
  NULL,
  'info@segrup.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Перезвонить завтра. Битва с закупщиком'
);

-- Company: АО "ДРСК" 2801108200 (ИНН: 2801108200) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ДРСК" 2801108200',
  '2801108200',
  NULL,
  NULL,
  '84162397367',
  'doc@drsk.ru',
  'холодный обзвон',
  'надо залечивать',
  'Магел',
  NULL,
  'не дозвонился до закупок. Российский акционный дом торговая площадка. Интересны китайцы. Прямых нет'
);

-- Company: АО "ПО КХ Г.О. ТОЛЬЯТТИ" 6324014124 (ИНН: 6324014124) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ПО КХ Г.О. ТОЛЬЯТТИ" 6324014124',
  '6324014124',
  NULL,
  NULL,
  '88482772594',
  'info@ao-pokh.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'не дозвонился'
);

-- Company: "ТРАНСНЕФТЬЭЛЕКТРОСЕТЬСЕРВИС" 6311049306 (ИНН: 6311049306) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ТРАНСНЕФТЬЭЛЕКТРОСЕТЬСЕРВИС" 6311049306',
  '6311049306',
  NULL,
  NULL,
  '84952529180',
  'ES-INFO@transneft.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'не дозвонится'
);

-- Company: АО "РСК" 6670018981 (ИНН: 6670018981) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "РСК" 6670018981',
  '6670018981',
  NULL,
  NULL,
  '8343 3794377',
  'rsk@sv-rsk.ru',
  'холодный обзвон',
  'сделал заказ',
  'Магел',
  NULL,
  'Юрий Григорьевич сказал выходить на торги. Заказ РФ.'
);

-- Company: ООО "ЭЛВЕСТ" 6670162424 (ИНН: 6670162424) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛВЕСТ" 6670162424',
  '6670162424',
  NULL,
  NULL,
  '83433834618',
  'tender@elvest-ek.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'дозвониться завтра'
);

-- Company: "ЭНЕРГОУПРАВЛЕНИЕ"6603023425 (ИНН: 6603023425) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ЭНЕРГОУПРАВЛЕНИЕ"6603023425',
  '6603023425',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  NULL
);

-- Company: ООО "НТЭАЗ Электрик"6615010205 https://www.vsoyuz.com/ru/kontakty/sluzhba-zakupok.htm (ИНН: 6615010205) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "НТЭАЗ Электрик"6615010205 https://www.vsoyuz.com/ru/kontakty/sluzhba-zakupok.htm',
  '6615010205',
  NULL,
  NULL,
  '83432532180',
  'bekseleev@nteaz.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'снабженка в отпуске. набрать через неделю'
);

-- Company: "АРТЭНЕРГОСТРОЙ" 5835133183 (ИНН: 5835133183) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"АРТЭНЕРГОСТРОЙ" 5835133183',
  '5835133183',
  NULL,
  NULL,
  NULL,
  'info@aenergo.su',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'заинтересовались. с китаем работали. нужно представительсво. оно есть. ждем запрос. набрать после уточнения наших цен'
);

-- Company: ООО «КУЗНЕЦК ЭЛЕКТРО» | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО «КУЗНЕЦК ЭЛЕКТРО»',
  NULL,
  NULL,
  NULL,
  NULL,
  '993220@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'поговорил с человеком. вроде интерес есть'
);

-- Company: "РЕГИОНЭНЕРГОСЕТЬ"5948063201 (ИНН: 5948063201) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"РЕГИОНЭНЕРГОСЕТЬ"5948063201',
  '5948063201',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'снабжения нет на месте'
);

-- Company: АКЦИОНЕРНОЕ ОБЩЕСТВО "ГИДРОЭЛЕКТРОМОНТАЖ" 2801085955 (ИНН: 2801085955) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АКЦИОНЕРНОЕ ОБЩЕСТВО "ГИДРОЭЛЕКТРОМОНТАЖ" 2801085955',
  '2801085955',
  NULL,
  NULL,
  '84162399821',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'не дозвонился'
);

-- Company: АО "УЭСК" 5903047697 (ИНН: 5903047697) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "УЭСК" 5903047697',
  '5903047697',
  NULL,
  NULL,
  '83433856771',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'перезвонить позже'
);

-- Company: ООО “АвтоматикаСтройСервис” | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО “АвтоматикаСтройСервис”',
  NULL,
  NULL,
  NULL,
  '+7(343)382-52-33',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Все предложения через руководителя. попросили направить кп на его имя. Попробовать связаться позже'
);

-- Company: "СК "ЭВЕРЕСТ" 1215214540 (ИНН: 1215214540) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"СК "ЭВЕРЕСТ" 1215214540',
  '1215214540',
  NULL,
  NULL,
  '89371119441',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'было занято. перезвонить'
);

-- Company: ООО ПКП "ФИНСТРОЙИНВЕСТ" 7448114740 (ИНН: 7448114740) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ПКП "ФИНСТРОЙИНВЕСТ" 7448114740',
  '7448114740',
  NULL,
  NULL,
  '83512254729',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'не прошел секретаря. пробовать позже'
);

-- Company: АО "ОЗЭМИ" 5614001069 (ИНН: 5614001069) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ОЗЭМИ" 5614001069',
  '5614001069',
  NULL,
  NULL,
  '83537376112',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'перезвонить. на отгрузке.'
);

-- Company: Общество с ограниченной ответственностью «ЭнергоПрогресс» | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Общество с ограниченной ответственностью «ЭнергоПрогресс»',
  NULL,
  NULL,
  NULL,
  '+7 922 633 50 00',
  'kravchenko@e-pro74.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Поговорил с директором. Пока проектов нет. но будут иметь нас в ввиду. отправил кп'
);

-- Company: ООО "ЭНЕРГО-ИМПУЛЬС +" 2724091687 (ИНН: 2724091687) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГО-ИМПУЛЬС +" 2724091687',
  '2724091687',
  NULL,
  NULL,
  NULL,
  'smakova@energoimpulse.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Поговорил с Еленой. есть хороший контакт.'
);

-- Company: ООО "ПК ЭЛЕКТРУМ" 6315597656 (ИНН: 6315597656) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПК ЭЛЕКТРУМ" 6315597656',
  '6315597656',
  NULL,
  NULL,
  '88462020037',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'поговорил с ларисой. замотал ее. будет отправлять заявки'
);

-- Company: ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ " НИИЭФА - ЭНЕРГО " 7817035596 (ИНН: 7817035596) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ " НИИЭФА - ЭНЕРГО " 7817035596',
  '7817035596',
  NULL,
  NULL,
  NULL,
  'info@nfenergo.ru',
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Поговорил со снабженкой. была не в настроении. попросила кп. перезвонить завтра.'
);

-- Company: АКЦИОНЕРНОЕ ОБЩЕСТВО "ПОДОЛЬСКИЙ ЗАВОД ЭЛЕКТРОМОНТАЖНЫХ ИЗДЕЛИЙ" 5036003332 (ИНН: 5036003332) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АКЦИОНЕРНОЕ ОБЩЕСТВО "ПОДОЛЬСКИЙ ЗАВОД ЭЛЕКТРОМОНТАЖНЫХ ИЗДЕЛИЙ" 5036003332',
  '5036003332',
  NULL,
  NULL,
  '84957980046',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'поговорил. девушка в отпуске до 1 июля'
);

-- Company: 5249058696 АО "НИПОМ" (ИНН: 5249058696) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5249058696 АО "НИПОМ"',
  '5249058696',
  NULL,
  NULL,
  '88001004344',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Не дозвонился до начальника. пробовать завтра'
);

-- Company: ООО "ЭЛЕКТРООПТИМА" 1659161058 (ИНН: 1659161058) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛЕКТРООПТИМА" 1659161058',
  '1659161058',
  NULL,
  NULL,
  '88432101515',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Поговорил с начальником снабжения. контакт хороший. скину кп на почту'
);

-- Company: михайловск ставрополь | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'михайловск ставрополь',
  NULL,
  NULL,
  NULL,
  '88652315646',
  'stemk@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  NULL
);

-- Company: "ЗАВОД "СИБЭНЕРГОСИЛА" | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ЗАВОД "СИБЭНЕРГОСИЛА"',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'не берут'
);

-- Company: "ЭЛЕКТРОФФ-ИНЖИНИРИНГ" 7726590962 (ИНН: 7726590962) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ЭЛЕКТРОФФ-ИНЖИНИРИНГ" 7726590962',
  '7726590962',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'сказать в отдел закупок. в понедельник'
);

-- Company: 3702015155 "СПЕЦЭНЕРГО" (ИНН: 3702015155) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3702015155 "СПЕЦЭНЕРГО"',
  '3702015155',
  NULL,
  NULL,
  NULL,
  'info@specenergo.com',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'сказать в отдел закупок. поговорил. рассматривают предложение'
);

-- Company: ООО "ЗИТ" 2115905070 (ИНН: 2115905070) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЗИТ" 2115905070',
  '2115905070',
  NULL,
  NULL,
  '8-800-333-23-58',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'звонил 3.07. выбил номер снабжения. пока не получил обратную связь'
);

-- Company: ООО "ЭНЕРГОЭРА" 7817331267 (ИНН: 7817331267) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОЭРА" 7817331267',
  '7817331267',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'перевели и сбросили. перезвонить'
);

-- Company: ООО "НПП ЭЛТЕХНИКА" 7811687676 (ИНН: 7811687676) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "НПП ЭЛТЕХНИКА" 7811687676',
  '7811687676',
  NULL,
  NULL,
  '88123299797',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Никита Евгеньевич. Отправил кп. созвониться на след неделе'
);

-- Company: АО "ПРОГРЕСС" 5037004040 (ИНН: 5037004040) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ПРОГРЕСС" 5037004040',
  '5037004040',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  NULL
);

-- Company: "ЭТЗ "ЭНЕРГОРЕГИОН" 1832104733 (ИНН: 1832104733) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ЭТЗ "ЭНЕРГОРЕГИОН" 1832104733',
  '1832104733',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  NULL
);

-- Company: "ЭЛЕКТРОНМАШ" 7814104690 (ИНН: 7814104690) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ЭЛЕКТРОНМАШ" 7814104690',
  '7814104690',
  NULL,
  NULL,
  '88127021262',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Поговорил с закупщицей очень хорошо. Скинет заявку'
);

-- Company: ООО "ПП ШЭЛА" 7128014313 (ИНН: 7128014313) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПП ШЭЛА" 7128014313',
  '7128014313',
  NULL,
  NULL,
  NULL,
  'omtc@shela71.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'все поставщики расписаны на год. была не в настроении. перезвонить через пару недель.'
);

-- Company: 7722286859 ООО СК "БЕТТА" (ИНН: 7722286859) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7722286859 ООО СК "БЕТТА"',
  '7722286859',
  NULL,
  NULL,
  '84955974115',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'снабженка не могла говорить. перезвонить днем.'
);

-- Company: ООО "ЗАВОД ЭЛПРО" 3663146899 (ИНН: 3663146899) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЗАВОД ЭЛПРО" 3663146899',
  '3663146899',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'не было на месте спеца'
);

-- Company: ООО ПКФ "ЭЛЕКТРОЩИТ" 3663048933 (ИНН: 3663048933) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ПКФ "ЭЛЕКТРОЩИТ" 3663048933',
  '3663048933',
  NULL,
  NULL,
  '84732394600',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'ольга скинула трубку перезвонить. Поговорил со снабжением 15.07.2025. Скинул кп. Рассматривают предложение.'
);

-- Company: ООО "ИНИЦИАТИВА" 7716050936 (ИНН: 7716050936) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ИНИЦИАТИВА" 7716050936',
  '7716050936',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'поговорил со снабженцем. отправил кп'
);

-- Company: ООО ФИРМА "ПРОМСВЕТ" 5262046636 (ИНН: 5262046636) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ФИРМА "ПРОМСВЕТ" 5262046636',
  '5262046636',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'надо залечивать',
  'Магел',
  NULL,
  'Поговорил с коммерческим директором. интересно но говорит про нац режим.'
);

-- Company: ООО "КЭР-ИНЖИНИРИНГ" 1658099230 (ИНН: 1658099230) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "КЭР-ИНЖИНИРИНГ" 1658099230',
  '1658099230',
  NULL,
  NULL,
  '88432678777',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'Поговорил с коллегой Айрата.Он сказал что посмотрит кп. перезвонить завтра'
);

-- Company: ООО "ЭЛЕКТРОПРОФИ" 5407222077 (ИНН: 5407222077) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛЕКТРОПРОФИ" 5407222077',
  '5407222077',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'скинул кп на потчу'
);

-- Company: ООО "ЭЛЕКТРОСТРОЙ" 3257028275 (ИНН: 3257028275) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛЕКТРОСТРОЙ" 3257028275',
  '3257028275',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'отправил кп. пока не звонил'
);

-- Company: ООО КОМПАНИЯ "ИНТЕГРАТОР" 7604175817 (ИНН: 7604175817) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО КОМПАНИЯ "ИНТЕГРАТОР" 7604175817',
  '7604175817',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'отправил кп на почту'
);

-- Company: "ЭЛЕККОМ ЛОГИСТИК" 2130133291 (ИНН: 2130133291) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ЭЛЕККОМ ЛОГИСТИК" 2130133291',
  '2130133291',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Магел',
  NULL,
  'отправил кп. закуп не ответили.'
);

-- Company: ООО "РИМ-РУС". 6234126190 (ИНН: 6234126190) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "РИМ-РУС". 6234126190',
  '6234126190',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'у них сидит менеджер, который отмсматривает заявки и связывается с поставщиками. будут иметь нас ввиду.'
);

-- Company: ООО "ЭНЕРГОТРАНЗИТ" 5404079654 (ИНН: 5404079654) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОТРАНЗИТ" 5404079654',
  '5404079654',
  NULL,
  NULL,
  '83843925050',
  'voronina@nken.org',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'поговорил с ольгой. закупают только энергоэффективные трансформаторы. Площадка сбербанк АСТ. участие бесплатное. Условия договорные.'
);

-- Company: 8911033894 АКЦИОНЕРНОЕ ОБЩЕСТВО "ПУРОВСКИЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ" (ИНН: 8911033894) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8911033894 АКЦИОНЕРНОЕ ОБЩЕСТВО "ПУРОВСКИЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ"',
  '8911033894',
  NULL,
  NULL,
  '83499765212',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Валера в отпуске до моего др. набрать позже'
);

-- Company: ООО "ЭНСИ" 2309132239 (ИНН: 2309132239) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНСИ" 2309132239',
  '2309132239',
  NULL,
  NULL,
  '88612506768',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'пока не дозвон. человека не было на месте.'
);

-- Company: АКЦИОНЕРНОЕ ОБЩЕСТВО "ТЕПЛОКОММУНЭНЕРГО" 6165199445 (ИНН: 6165199445) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АКЦИОНЕРНОЕ ОБЩЕСТВО "ТЕПЛОКОММУНЭНЕРГО" 6165199445',
  '6165199445',
  NULL,
  NULL,
  NULL,
  '742899@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'звонил в коммерческий отдел. сказали будут скидывать заявки'
);

-- Company: ООО "ЭЛЕКТРОКОНТАКТ" 6311174120 (ИНН: 6311174120) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛЕКТРОКОНТАКТ" 6311174120',
  '6311174120',
  NULL,
  NULL,
  NULL,
  'info_elkont@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'поговорил со старым. хорошо пообщались. Потенциал'
);

-- Company: ООО "ЭТП" 6671408085 (ИНН: 6671408085) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭТП" 6671408085',
  '6671408085',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Не дозвонился до Игоря. скорее всего, добавочный 135 но не факт. пробовать еще. 18.09.2025. Поговорил с Игорем. Работают с Россетями. пробить не вышло.'
);

-- Company: ЗАО "РЕКОНЭНЕРГО" 3666089896 (ИНН: 3666089896) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ЗАО "РЕКОНЭНЕРГО" 3666089896',
  '3666089896',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'не дозвонился'
);

-- Company: ООО "ЭНЕРГОКАПИТАЛ" 5402462822 (ИНН: 5402462822) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОКАПИТАЛ" 5402462822',
  '5402462822',
  NULL,
  NULL,
  '+79130686615',
  NULL,
  'личный контакт',
  'сделал запрос',
  'Магел',
  NULL,
  '16.09.2025 не дозвон. 17.09.2025 Познакомился с Татьяной. рассматривают кп'
);

-- Company: ООО "Импульс" 6658394193 (ИНН: 6658394193) | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Импульс" 6658394193',
  '6658394193',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'не дозвон'
);

-- Company: Самара ВЭМ | Manager: Магел
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Самара ВЭМ',
  NULL,
  NULL,
  NULL,
  '88462601947',
  'sev@samaravem.ru',
  'холодный обзвон',
  'слабый интерес',
  'Магел',
  NULL,
  'Работал с мужиком. он теперь там не работает. Отвечает Елена'
);

-- Company: ООО "Электростроймонтаж" 4632061580 (ИНН: 4632061580) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Электростроймонтаж" 4632061580',
  '4632061580',
  NULL,
  NULL,
  NULL,
  'esm-pol@energo.sovtest.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-28',
  'Не дозвон, КП отправил на почту. / 29.04.25 - через секретаря связь с артемом, попросил информационное, обещал завтра скинуть заявку / не доходят сообщения! / 14.05.25 секретарь дал 2 почты закупщика Артема, при звонке не был на месте / все равно письма не доходят! / 20.05.25 - дозванился до Артема, актуализировал его почту, заявок нет говорит /'
);

-- Company: «Липецкэлектро» | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '«Липецкэлектро»',
  NULL,
  NULL,
  NULL,
  '+7 474 222 77 22',
  'domornikov_e@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-03-20',
  'Вышел на закупщика Юрий, попросил инф письмо./ 23.04.25- магел звонил, повторное коммерческое/ 29.04.25 - Алик - запросы есть внес в базу поставщиков / 14.05.25 - Юрий говорит мало заказов, освежил КП /'
);

-- Company: ООО "КАСКАД-ЭНЕРГО" 4028033363 (ИНН: 4028033363) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "КАСКАД-ЭНЕРГО" 4028033363',
  '4028033363',
  NULL,
  NULL,
  NULL,
  'secretar@kenergo.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-10',
  'Отправил КП Герасимову / 28.04.25 - звонок Герасимову, не ответ, КП на почту / 14.05.25 -  нет на месте, ответила марина, наш товар интересен, попросила КП, сказала будут отправлять заказы / 15.05..25 - письмо не доставлено герасимову, надо с ним созваниться / 20.05.25 - Герасимов не ответ, все ссылаються нанего /'
);

-- Company: "ИНТЭКО" (ИНН: 7104018870) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ИНТЭКО"',
  '7104018870',
  NULL,
  NULL,
  NULL,
  'energia@inteko-tula.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-15',
  '15.04Отправил КП / 28.03.25-не дозвон / 21.05.25 - актуализировал номер, надо прозвонить /'
);

-- Company: "ФЕНИКС-ЭНЕРГИЯ" 7736273017 (ИНН: 7736273017) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ФЕНИКС-ЭНЕРГИЯ" 7736273017',
  '7736273017',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-03-20',
  '/20.03звонокРаботают с атестованными в россетях/ 28.04.25 - не дозвон. Серт нужен - Алик \'
);

-- Company: "ЭМПИН" (ИНН: 7743910877) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ЭМПИН"',
  '7743910877',
  'Москва',
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-03-20',
  '/Тяжело идет на контакт, отправил кп /23.04.25 магел звнок- тяжело идет но пробиваем/Короче Артем его зовут но он ни разу не закупщик надо зайти с иторией чтобы перевели на закупщика!!!! - завтра на брать- Алик 29.04 c Артемом бесполезно говорить он вафля! / 21.05.25 - артем запросил КП /'
);

-- Company: АО "ЭМС" (ИНН: 7810241335) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ЭМС"',
  '7810241335',
  'Санкт-Петербур',
  NULL,
  NULL,
  'info@electromontazh.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-10',
  'Отправил КП / 23.04.25-не ответ /28.04.25 - ответил вредный секритарь, попросил информационное письмо / 29.04 не дозвон - алик'
);

-- Company: ЗАО "КАПЭ" 6911004716 | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ЗАО "КАПЭ" 6911004716',
  NULL,
  'Тверь',
  NULL,
  '+7-960-704-21-11',
  'info@konenergo.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-10',
  'Отправил КП / 28.04.25 - не ответ, повторное КП / не дозвон - алик 29.04'
);

-- Company: ООО "АСМ" 3250519725 | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "АСМ" 3250519725',
  NULL,
  'Брянсск',
  NULL,
  NULL,
  'office@acm32.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-10',
  'Отправил кп / 28.04.25 - не ответ, повторное КП на почту / номер не досутпен 29.04 алик'
);

-- Company: ООО "ИК СИТИЭНЕРГО" 7720748931 (ИНН: 7720748931) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ИК СИТИЭНЕРГО" 7720748931',
  '7720748931',
  NULL,
  NULL,
  NULL,
  'info@cityengin.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-10',
  'Отправил кп / 28.04.25 - секретарь попросил инф письмо на снабжение / сказали отдел снабжения свяжется, если нет придумать историю с курьером'
);

-- Company: ООО "КАТЭН" 7720674630 (ИНН: 7720674630) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "КАТЭН" 7720674630',
  '7720674630',
  NULL,
  NULL,
  NULL,
  'office@caten-company.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-10',
  'Отправил кп / 28.04.25 - не ответ, повторное КП / 14.05.25 - не ответ /'
);

-- Company: ООО "ПЕТЕРБУРГ-ЭЛЕКТРО" 7804339445 (ИНН: 7804339445) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПЕТЕРБУРГ-ЭЛЕКТРО" 7804339445',
  '7804339445',
  NULL,
  NULL,
  NULL,
  'info@peterburg-electro.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-10',
  'Отправил КП / 28.04.25 - не ответ, КП повторно на почту / 14.05.25 - не ответ / 15.04.25 - не ответ / 20.05.25 - не ответ /Секретярь соединяет но номер не ответил'
);

-- Company: ООО "ПЭС" 7814677411 (ИНН: 7814677411) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПЭС" 7814677411',
  '7814677411',
  NULL,
  NULL,
  '+7-812-386-33-33',
  '3863333spb@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-10',
  'Отправил КП / 29.04.25 - не интересно работают на довальчиском сырье ( Алик это пиздабольский отмаз?)  / 20.05.25 - Секретарь попросила КП /'
);

-- Company: ООО "РУСЭЛ" 5256149506 (ИНН: 5256149506) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "РУСЭЛ" 5256149506',
  '5256149506',
  NULL,
  NULL,
  NULL,
  'info@rus-el.org',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-03-18',
  'Не дозвон/ не дозвон-20.03.25 / 14.05.25 - не дозвон /15.05.25 - не отвечают / 20.05.25 - не ответ /'
);

-- Company: ООО "ЦЕНТРЭЛЕКТРОМОНТАЖ" 3663049140 (ИНН: 3663049140) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЦЕНТРЭЛЕКТРОМОНТАЖ" 3663049140',
  '3663049140',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-10',
  'Отправил кп / 14.05.25 - попросили КП на почту / 15.05.25. - закупщицу зовут Дарья, сказала подстанции производят сами, трансформаторы интересны / 20.05.25 - секретарь соеденял с дарьей, ответила Татьяна, заявок нет, попросила КП на почту / ИСПОЛЬЗУЮТ РЕДКО ТРАНСЫ'
);

-- Company: ООО "Эйч Энерджи Трейд" 2128010302 (ИНН: 2128010302) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Эйч Энерджи Трейд" 2128010302',
  '2128010302',
  NULL,
  NULL,
  '88005001616',
  'info@energy-h.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-15',
  'Отправил КП/ тут секретарь сложный надо какие то данные предоставить лиретора пробить по инн, вытаскивать номер закупщика / 20.05.25- секретарь запросил письмо КП, перезвонить 23.05.25 / 11,08,25-секретарь говорит отправь кп если интересно то свяжуться'
);

-- Company: ООО "ЭЛЕКТРОГАРАНТ" (ИНН: 7708783560) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛЕКТРОГАРАНТ"',
  '7708783560',
  NULL,
  NULL,
  '+7-900-014-66-45',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-03-04',
  'Рам есть контакт. Максим +7-963-154-62-84 (надо доработать )  / 14.05.25 - не ответ / 15.05.25- -Он сказал только атестованные в россетях поставляем /'
);

-- Company: ООО "ЭНЕРГО-ДОН" | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГО-ДОН"',
  NULL,
  NULL,
  NULL,
  '+7 863 201-78-84',
  'energo-don@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-03-20',
  'Профильная компания/ 01.04 звонок, отправилКП / 29.04.25 - секретарь пытался соединь с отделом закупок, никто не ответил, попросила перезвонить после празников / 14.05.25 - наш товар редкий, Ольга закупщик запросила КП /'
);

-- Company: ООО "ЭНЕРГОМИКС" 3906264262 (ИНН: 3906264262) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОМИКС" 3906264262',
  '3906264262',
  NULL,
  NULL,
  NULL,
  'info@energomiks39.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-10',
  'Отправил КП / 15.05.25 - ответил секретарь, говорит не интересно, но еомпания профильная, возможно не правильно поняла /Короче тут сказали свяжутся серкетярь, попробую выйти на закупки - алик 22 мая'
);

-- Company: ООО "Энергоспецснаб" 7701112033 (ИНН: 7701112033) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Энергоспецснаб" 7701112033',
  '7701112033',
  NULL,
  NULL,
  NULL,
  'mail@energossnab.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-15',
  'Отправил КП / 29.04.25 - не ответ / 15.05.25 - не ответ /'
);

-- Company: ООО «РСТ-ЭНЕРГО» | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО «РСТ-ЭНЕРГО»',
  NULL,
  NULL,
  NULL,
  '8 800 551 16 56',
  'sale@rst-energo.com',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-03-20',
  'Вредный секретарь, отправил КП / 14.05.25 - не ответ, повторное КП /нет ответа алик 22 мая'
);

-- Company: ООО ПРП "Татэнергоремонт" 1661009491 (ИНН: 1661009491) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ПРП "Татэнергоремонт" 1661009491',
  '1661009491',
  NULL,
  NULL,
  NULL,
  'office@tatenergo.ru',
  'реклама',
  'сделал запрос',
  'Рам',
  '2025-04-15',
  'Отправил КП / 15.05.25 - ответил секритарь, закупают через площадку на сайте tatenergo.ru, нужно найти выход на закупщика /'
);

-- Company: ООО РЕНОВАЦИЯ | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО РЕНОВАЦИЯ',
  NULL,
  NULL,
  NULL,
  NULL,
  'office@renovationspb.ru',
  'реклама',
  'сделал запрос',
  'Рам',
  '2025-03-10',
  'Отправил КП / 15.05.25 - говорит не пользуеться спросом наша продукция, пиздит на сайте другая инфа /'
);

-- Company: Энергосервис 6215016322 (ИНН: 6215016322) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Энергосервис 6215016322',
  '6215016322',
  NULL,
  NULL,
  NULL,
  'info@energo62.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-15',
  '/ 15.05.25 - Связался с Николаем на сотовый, попросил КП на почту / 20.05.25 - николай был не в настроение, разговор не пошел, не помнит о нас /'
);

-- Company: ООО «Техносервис» | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО «Техносервис»',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@technoservis.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-18',
  'Отправил КП / 15.05.25 - Секретарь попросил КП / 20.05.25 - позвонить 21.05.25  Юлии Юрьевне 8(812)612-12-02 /'
);

-- Company: ООО "Завод БКТП" 4710028086 (ИНН: 4710028086) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Завод БКТП" 4710028086',
  '4710028086',
  NULL,
  NULL,
  NULL,
  'office@zpuerus.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  NULL,
  'не актуальный номер'
);

-- Company: Минимакс 7810216924 (ИНН: 7810216924) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Минимакс 7810216924',
  '7810216924',
  NULL,
  NULL,
  NULL,
  'minimaks@minimaks.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-28',
  'Профильная компания, запросили КП. / 15.04.25 -  нужно искать закупщика /
22.05.2025 - не ответ, это интернет магазин /'
);

-- Company: ООО "Энерком-строй" 2901089400 (ИНН: 2901089400) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Энерком-строй" 2901089400',
  '2901089400',
  NULL,
  NULL,
  NULL,
  'info@enercom29.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-28',
  'Занимаються строительством ЛЭП. отпрвил КП / 15.05.25 - секретарь говорит снабженцы отсутствуют на месте, поросила КП на почту / пробил секретаря, постоянно пиздит нет снабженце, снабженец ответил сказал не интерестно и бросил трубку /'
);

-- Company: ООО Элстар (ИНН: 3255054223) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО Элстар',
  '3255054223',
  NULL,
  NULL,
  NULL,
  'elstar06@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-28',
  'В основном низковольтное, высоковольтное редко, отправил КП.'
);

-- Company: ООО Строй-Энерго 5751200700 (ИНН: 5751200700) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО Строй-Энерго 5751200700',
  '5751200700',
  NULL,
  NULL,
  NULL,
  'st-energo57@yandex.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-28',
  'Наши изделия используют редко, запросили информационное письмо.'
);

-- Company: ООО "Резерв-Электро 21 век" 7703663861 (ИНН: 7703663861) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Резерв-Электро 21 век" 7703663861',
  '7703663861',
  NULL,
  NULL,
  NULL,
  'rezel@rezel.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-28',
  'Профильная компания запросили информационное письмо. / 15.05.25 - секретарь связал с закупщиком, просят реестр минпромторга, изделия интересны, надо общаться / 22.05.2025 - Григорий говорит нет заказов, залечил его, просит звоонить переодически /'
);

-- Company: ООО СТКОМ 2634076606 (ИНН: 2634076606) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО СТКОМ 2634076606',
  '2634076606',
  NULL,
  NULL,
  NULL,
  'ctkom@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-04-28',
  'Грубят, наш клиент, попросили информационное письмо.  / 15.05.25 - не ответ /'
);

-- Company: ООО НПЦ "Электропроект М" 1326183263 (ИНН: 1326183263) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО НПЦ "Электропроект М" 1326183263',
  '1326183263',
  NULL,
  NULL,
  NULL,
  'elektropro@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-04-28',
  'Берут наш товар мало, попросили информационное письмо.'
);

-- Company: ООО ЭЛЕКТРО 7610080930 (ИНН: 7610080930) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ЭЛЕКТРО 7610080930',
  '7610080930',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-04-28',
  'Запросили информационно письмо. / 15.05.25 - владимир не на месте/ 22.05.2025 - ответил Александр, у них торговая организация, говорят что внесли нас в список поставщиков, при звонке узнают Рамиля, заявок пока нет, долбить его не часто /'
);

-- Company: ООО "ТехМир" 1841084642 | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТехМир" 1841084642',
  NULL,
  'Ижевск',
  NULL,
  '8 999 281 22 90',
  'zakaz@tm-ktp.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-14',
  '/Не дозвон, КПотправил на почту. / 02.06.2025 - Поросили КП на Сергея/'
);

-- Company: ООО "ЭнергоТехСервис" 1840031750 | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭнергоТехСервис" 1840031750',
  NULL,
  'Ижевск',
  NULL,
  NULL,
  'zakup@18ets.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-14',
  'Не дозвон, КПотправил на почту. / 02.06.25- не дозвон, /'
);

-- Company: ООО "БЭСК Инжиниринг" (ИНН: 0275038560) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "БЭСК Инжиниринг"',
  '0275038560',
  'Уфа',
  NULL,
  NULL,
  'office@besk-ec.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-05-14',
  '/Приняли письмо, секретарь оправила начальнику, просила связаться 16.06.25 /'
);

-- Company: АО "НПП ЭНЕРГИЯ". (ИНН: 7720613010) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "НПП ЭНЕРГИЯ".',
  '7720613010',
  NULL,
  NULL,
  NULL,
  'sales@npp-energy.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-15',
  'не ответ, КП на почту /'
);

-- Company: "Объединенная Энергия" (ИНН: 7720097038) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"Объединенная Энергия"',
  '7720097038',
  NULL,
  NULL,
  NULL,
  'jp@jpc.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-15',
  'Секретарь пытался соеденить с отделом закупок не вышло, отправил КП на почту / 22.05.2025 - серетарь не смогла соеденить с отделом закупок не ответ /'
);

-- Company: ООО "СИСТЕМОТЕХНИКА" (ИНН: 7714826109) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "СИСТЕМОТЕХНИКА"',
  '7714826109',
  '"Дженерал Пауэр"',
  NULL,
  NULL,
  'dgu@sstmk.ru',
  'личный контакт',
  'сделал запрос',
  'Рам',
  '2025-05-15',
  'Ответил секретарь, попросила КП для ознакомления. / 15.05.25 - секритарь прислал на почту что мы молодая компания и они нас боятьс, вопрос на контроле у Магела / 22.05.2025 - анна секретарь напиздела что не берут наш продукт /'
);

-- Company: АО "ЭНЕРГОСЕРВИС" (ИНН: 5902131473) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ЭНЕРГОСЕРВИС"',
  '5902131473',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-19',
  '/ не дозвон,КП на почту/'
);

-- Company: ЭнергоТренд (ИНН: 6658491415) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ЭнергоТренд',
  '6658491415',
  NULL,
  NULL,
  NULL,
  'info@entrend.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ Профильная компания, секретарь запросил КП на почту /'
);

-- Company: ООО "ПРОГРЕССЭНЕРГО" (ИНН: 2130065323) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПРОГРЕССЭНЕРГО"',
  '2130065323',
  'Чебоксары',
  NULL,
  NULL,
  '104@progenerg.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ Профильная компания, секретарь запросил КП на почту / 22.05.2025 - ответил павел закуп, готовы расмотреть нашу продукцию под выйгранные торги, запросил КП /'
);

-- Company: ООО "ЭНЕРГО ЦЕНТР" (ИНН: 3328492856) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГО ЦЕНТР"',
  '3328492856',
  NULL,
  NULL,
  NULL,
  '33energo@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ Профильная компания, секретарь запросил КП на почту /'
);

-- Company: л | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'л',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@unenergo.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ в основном низвольтное оборудование, наше редко берут, отправил КП /'
);

-- Company: ООО "Энерго Пром Сервис" (ИНН: 5053025953) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Энерго Пром Сервис"',
  '5053025953',
  NULL,
  NULL,
  '+74965742848',
  'infoeps@eps-group.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ секретарь запросил КП /'
);

-- Company: АО "ЭНЕРГОСЕРВИСНАЯ КОМПАНИЯ ЛЕНЭНЕРГО" (ИНН: 7810846884) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ЭНЕРГОСЕРВИСНАЯ КОМПАНИЯ ЛЕНЭНЕРГО"',
  '7810846884',
  NULL,
  NULL,
  NULL,
  'office@lenserv.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ не ответ, КП на почту /'
);

-- Company: ООО "ЭНЕРГОКОМПЛЕКТ" (ИНН: 7734362487) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОКОМПЛЕКТ"',
  '7734362487',
  NULL,
  NULL,
  '+74957999013',
  'enk7250415@yandex.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ не ответ, КП на почту /'
);

-- Company: ПКФ "МЕТЭК-ЭНЕРГО" (ИНН: 5260158510) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ПКФ "МЕТЭК-ЭНЕРГО"',
  '5260158510',
  NULL,
  NULL,
  NULL,
  'cable@metek-energo.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ профильная компания, запросили КП на почту /'
);

-- Company: ООО "Энергопоставка" (ИНН: 5003037311) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Энергопоставка"',
  '5003037311',
  NULL,
  NULL,
  NULL,
  'info@energopostavka.com',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ не ответ, КП на почту /'
);

-- Company: ООО "Энергосистемы" (ИНН: 5044089069) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Энергосистемы"',
  '5044089069',
  NULL,
  NULL,
  NULL,
  'zayavka@e-systems.su',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ секретарь поросил КП на почту /'
);

-- Company: АО "МНПО "ЭНЕРГОСПЕЦТЕХНИКА" (ИНН: 5024014330) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "МНПО "ЭНЕРГОСПЕЦТЕХНИКА"',
  '5024014330',
  NULL,
  NULL,
  NULL,
  'zakaz@spectech.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ производители дизель станций, попросили КП /'
);

-- Company: ООО "ЭнергоСоюз" (ИНН: 1840004147) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭнергоСоюз"',
  '1840004147',
  NULL,
  NULL,
  NULL,
  'info@smu-energo.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ не ответ, КП на почту /'
);

-- Company: АО ПИК "ЭНЕРГОТРАСТ" (ИНН: 7709153722) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО ПИК "ЭНЕРГОТРАСТ"',
  '7709153722',
  NULL,
  NULL,
  '+7-495-602-09-60',
  'energotrust@energotrust.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ не ответ, КП на почту /'
);

-- Company: ООО "ЭНЕРГО СТРОЙ" (ИНН: 7813479840) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГО СТРОЙ"',
  '7813479840',
  NULL,
  NULL,
  NULL,
  '6102112@bk.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ секретарь связала с Александрой, она попросила КП на почту /'
);

-- Company: ООО "ЭНЕРГОКОМ" (ИНН: 3257025820) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОКОМ"',
  '3257025820',
  NULL,
  NULL,
  NULL,
  'energokom32@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ не ответ на основной КП на почту /'
);

-- Company: ООО "ТД "ЭнергоПромМаш" (ИНН: 7706596941) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТД "ЭнергоПромМаш"',
  '7706596941',
  NULL,
  NULL,
  NULL,
  'Info@td-epm.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ не ответ на основной КП на почту /'
);

-- Company: ООО "Энергостройуниверсал" (ИНН: 2635095256) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Энергостройуниверсал"',
  '2635095256',
  NULL,
  NULL,
  NULL,
  'info@energosu.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-20',
  '/ Альберт нач отдела снаб, попросил КП на почту /'
);

-- Company: ООО "Энергоиндустрия" (ИНН: 7702810351) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Энергоиндустрия"',
  '7702810351',
  NULL,
  NULL,
  '+7(495)721-29-10',
  'sales@energo-ind.su',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-21',
  '/  Попросили КП на почту /'
);

-- Company: ООО "Сельхозэнерго" (ИНН: 2104000577) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Сельхозэнерго"',
  '2104000577',
  NULL,
  NULL,
  '+7-900-333-30-20',
  'vur_she@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-21',
  '/ не ответ, отправил КП на почту /'
);

-- Company: ООО "БЭЛС-Энергосервис" (ИНН: 5012026637) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "БЭЛС-Энергосервис"',
  '5012026637',
  NULL,
  NULL,
  '8 498 520-79-63',
  'bes04@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-21',
  '/ не ответ КП на почту /'
);

-- Company: ООО "МОНТАЖЭНЕРГОПРОФ" (ИНН: 7810762585) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "МОНТАЖЭНЕРГОПРОФ"',
  '7810762585',
  NULL,
  NULL,
  NULL,
  'mep-prof@mail.ru',
  'холодный обзвон',
  'сделал заказ',
  'Рам',
  '2025-05-21',
  '/ Ксения секретарь - говорит нет заказов. Протолкнул ей КП на почту /'
);

-- Company: ООО "ЭНЕРГОАЛЬЯНС" (ИНН: 7839427766) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОАЛЬЯНС"',
  '7839427766',
  NULL,
  NULL,
  NULL,
  'info@eaenergo.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-21',
  '/ ответил Павел, попросил КП на расмотрение / 02.06.25 - не ответ/'
);

-- Company: ООО "Стандартэнерго" (ИНН: 7717735629) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Стандартэнерго"',
  '7717735629',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-05-21',
  '/ Нужны бетонные КТП и атестация в россети /'
);

-- Company: ООО "Альянс-Энерджи" (ИНН: 7709843116) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Альянс-Энерджи"',
  '7709843116',
  NULL,
  NULL,
  '+7(499)649-12-69',
  'info@al-ng.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-21',
  '/ производят генераторы, запросили кп на тех отдел /'
);

-- Company: АО "ЭНЕРГОПРОЕКТ-ИНЖИНИРИНГ" (ИНН: 7725592815) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ЭНЕРГОПРОЕКТ-ИНЖИНИРИНГ"',
  '7725592815',
  NULL,
  NULL,
  NULL,
  'info@etpsamara.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-05-21',
  '/ Клиент Анара, держать на контроле /'
);

-- Company: ООО "ЭНЕРГОКОМПЛЕКТ КРЫМ" (ИНН: 9102011960) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОКОМПЛЕКТ КРЫМ"',
  '9102011960',
  NULL,
  NULL,
  NULL,
  'telecom.help@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-21',
  '/ Яна секретарь запросила КП /'
);

-- Company: ООО "ЭНЕРГОГРУПП" (ИНН: 9705088145) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОГРУПП"',
  '9705088145',
  NULL,
  NULL,
  NULL,
  'info@en-gr.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-21',
  '/ профильная компания, запросили КП на почту /'
);

-- Company: ООО ТК "ЭНЕРГОКОМПЛЕКС" (ИНН: 7810397798) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ТК "ЭНЕРГОКОМПЛЕКС"',
  '7810397798',
  'Питер',
  NULL,
  '8 812 500 08 09',
  'info@nrg2b.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-21',
  '/ кузнецов Андрей закупщик, отправил КП, его не было на месте /'
);

-- Company: ООО "ПСК "Тепло Центр Строй" (ИНН: 7727155923) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПСК "Тепло Центр Строй"',
  '7727155923',
  NULL,
  NULL,
  NULL,
  'tcs@tcs-group.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-21',
  '/ секретарь запросил КП организация профильная /'
);

-- Company: ООО "ЭНЕРГОТРЕСТ" (ИНН: 7725346376) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОТРЕСТ"',
  '7725346376',
  NULL,
  NULL,
  NULL,
  'info@energo-trest.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-21',
  '/ не ответ, КП на почту /'
);

-- Company: ООО "Гарантэнерго" (ИНН: 7702350129) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Гарантэнерго"',
  '7702350129',
  NULL,
  NULL,
  NULL,
  'info@garantenergo.su',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-21',
  '/ не ответ, КП на почту /'
);

-- Company: ООО Связь Энергострой (ИНН: 2801246747) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО Связь Энергострой',
  '2801246747',
  'Благовещенск',
  NULL,
  NULL,
  'doc@ses-dv.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-22',
  '/ ответил Георгий, попросил КП на ватсап/'
);

-- Company: ООО "ССМНУ-58" (ИНН: 5045019586) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ССМНУ-58"',
  '5045019586',
  NULL,
  NULL,
  NULL,
  'SSMNU-58@ssmnu-58.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-22',
  '/ не ответ, КП на почту /'
);

-- Company: ООО "НОРДГРИД" (ИНН: 7842489681) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "НОРДГРИД"',
  '7842489681',
  NULL,
  NULL,
  NULL,
  'mail@nordgrid.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-22',
  '/ответил секретарь, проф организация, запросила КП на Вадима /'
);

-- Company: ООО "КНГ - ЭНЕРГО (ИНН: 3662287110) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "КНГ - ЭНЕРГО',
  '3662287110',
  'воронеж',
  NULL,
  NULL,
  'office@kngenergo.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-05-22',
  '/ не ответ, КП на почту / 14.07.25 - закупщик грубит не заебывать часто /'
);

-- Company: ООО "Центр Инжениринг" (ИНН: 2373002283) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Центр Инжениринг"',
  '2373002283',
  'Краснодар',
  NULL,
  NULL,
  'info@centringen.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-06-10',
  '/Через секретаря связался с менеджером Антоном, в ходе разговора он понял значемость и передаст КП директору, сказал директор свяжеться с нами/ 10.06.25 -  попросил позвонить 16.06.25 -14:00 / 16.06.25 - попросил набрать 23.06.25 / 25.06.25 - Антон попросил КП на ватсапп и пошол к диру на разговор / Просят атестацию в россети /'
);

-- Company: "ГРУППА КОМПАНИЙ ПРОФИТРЕЙД" (ИНН: 7722756818) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ГРУППА КОМПАНИЙ ПРОФИТРЕЙД"',
  '7722756818',
  'Москва',
  NULL,
  '+7 499 450-53-99',
  'info@profitreid.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-06-10',
  '/ отправил КП не прошол секретаря / 22.07.25-секретарь говорит наше предложение не актуально /'
);

-- Company: ООО "ЭМКОМ" 7802335484 | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭМКОМ" 7802335484',
  NULL,
  'Питер',
  NULL,
  NULL,
  'sale@emkom.spb.ru',
  'холодный обзвон',
  'сделал заказ',
  'Рам',
  '2025-06-17',
  '/ пока не требуеться / 22.07.25 - пока не требуеться / 11.08.25 - пока нет заказов, набрать 11.09.25 /'
);

-- Company: ООО "Завод "Энергетик" (ИНН: 0224011030) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Завод "Энергетик"',
  '0224011030',
  'Уфа',
  NULL,
  NULL,
  'enzavod@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-06-21',
  '/ секретарь попросила КП, и перезвонить 04.07.25 позвать виталия игоривича / 04.07.25.- Виталий говорит берут масло до 630ква, интерестно что когда будет у нас на складе, взял мой номер / 11.08.25 - Виталий не ответил / 08.09.25- запросили цены, набрать 15.09.25 / Виталий говорит интерестно на складе, ждать долго, разговор не о чем, набрать в конце сентября /'
);

-- Company: АО "МЕРИНГ ИНЖИНИРИНГ (ИНН: 6950049622) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "МЕРИНГ ИНЖИНИРИНГ',
  '6950049622',
  'С-Петербург',
  NULL,
  NULL,
  'info@meringe-pro.ru',
  'личный контакт',
  'сделал заказ',
  'Рам',
  '2025-06-23',
  '/ Вышел на нач закуп Лев, заинтересовал, взял личный номер, отправил инфу в ватсапп / 30.06.25 - Лев помнит про нас, сейчас нет заказов, ждет новые проекты / 10.07.25 - Лев помнит про нас, ждет заказы / 09.09.25 - написал ему в ватс ап сросил актуальные заказы / 16.04.26 - пока нет действующих проектов /'
);

-- Company: "Озёрский завод энергоустановок" (ИНН: 7422036304) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"Озёрский завод энергоустановок"',
  '7422036304',
  'Челябинск',
  NULL,
  '+7 351 307 33 63',
  'sales@ozeu.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-06-25',
  '/ попросили КП на отдел снабжения для Екатерины / 03.07.25 - екатерина не получила наш КП, попросила повторно,  перезвонить 25.07.25  / 11.08.25 - заявок нет, перезвонить в начале сентября / ПИЗДИТ ЧТО НЕ ИСПОЛЬЗУЮТ /'
);

-- Company: ООО "ТД "ПРОМЫШЛЕННОЕ ОБОРУДОВАНИЕ" (ИНН: 7704372086) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТД "ПРОМЫШЛЕННОЕ ОБОРУДОВАНИЕ"',
  '7704372086',
  'Москва',
  NULL,
  NULL,
  'info@td-po.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-06-28',
  '/Секретарь передаст письмо генеральному директору/ 16.06.25 - не пробиваемый секретарь, просит КП / 25.06.25 - не дозвон / 30.06.25 - секретарь не помнит про нас, прислал на почту секретаря КП (дохлый номер) / 22.07.25 - не заинтересовало /'
);

-- Company: ООО "АС-ЭНЕРГО" (ИНН: 2312118185) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "АС-ЭНЕРГО"',
  '2312118185',
  'Краснодар',
  NULL,
  NULL,
  'info@as-energo.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-01',
  '/ не пробил, КП отправил / 02.07.25 - секретарь пыталась направить в отдел снабжения не ответ / 03.07.25 - Попал на николая, ему интерестно, дал свой сотовый. отправил инфу на ватсапп / 14.07.25 - цена дорогая на масло, про нас помнит, не задрачивать его /'
);

-- Company: ООО НПП "220 Вольт" (ИНН: 0264080182) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО НПП "220 Вольт"',
  '0264080182',
  'УФА',
  NULL,
  NULL,
  'pto@220ufa.com',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-03',
  '/ отправил КП на ватсапп / 25.08..25 - Елена не ответ /  ответила Эльмира, Елена в отпуске до 15.09.25 /'
);

-- Company: ЗАО "ЭЛСИЭЛ" (ИНН: 7722105693) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ЗАО "ЭЛСИЭЛ"',
  '7722105693',
  'г.Москва',
  NULL,
  NULL,
  'info@elsiel.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-06',
  '/ попросили инф письмо и перезвонить / 10.07.25 - отдел закупок запросил повторно КП, по необходимости свяжуться сами / 25.08.25 - не нужно /'
);

-- Company: ООО "Энергии Технологии" (ИНН: 7743639382) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Энергии Технологии"',
  '7743639382',
  'Москва',
  NULL,
  NULL,
  'info@ener-t.ru',
  'холодный обзвон',
  'сделал заказ',
  'Рам',
  '2025-07-07',
  '/ Секретарь попросила инф письмо на гл инженера / 25.06.25 - Шитов расмотрел КП все понравилось попросилконтактные данные, говорит пока нет заказов, по необходимости свяжеться / 11.08.25 - Павел в отпуске до 25.08.25 / Павел говорит нет заказов, набрать в след году (мажеться урод) /'
);

-- Company: ООО "СНАБЭНЕРГОРЕСУРС" (ИНН: 2310212721) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "СНАБЭНЕРГОРЕСУРС"',
  '2310212721',
  'Краснодар',
  NULL,
  NULL,
  'info@snabenergo23.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-07-07',
  '/ Переодически его задрочил/ добавил мой номер в ЧС /'
);

-- Company: ООО "Энергопроф" (ИНН: 7720679090) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Энергопроф"',
  '7720679090',
  'Москва',
  NULL,
  NULL,
  'info@enprof.net',
  'холодный обзвон',
  'сделал заказ',
  'Рам',
  '2025-07-07',
  '/Секретарь попросил КП и презвонить в 16:00 по мск Владимиру Анатольевичу / 25.06.25 - Состоялся диалог с Владимиром, заинтересован, будет присылать заказы / 14.07.25 - Владимир не на месте / 25.08.25 - не дозвон /  Владимир говорит пока нет заявок на трансы и ктп, основное это щитовое оборудование набрать 19.09.25  /'
);

-- Company: ПКФ"ЭЛЕКТРОКОМПЛЕКС" (ИНН: 6679125667) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ПКФ"ЭЛЕКТРОКОМПЛЕКС"',
  '6679125667',
  'Екатеринбург',
  NULL,
  NULL,
  'zakaz@uralenergoteh.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-07',
  '/ не представился но есть интерес, попросил КП с ценами/ 16.05.25 - о нас помнит, ждет заказы, напоминать о себе переодически / 14.07.25 - Андрей просит набрать 16.07 / 11.08.25 - скоро будет запрос / набрать 17.09.25 я затупил не правельно шашел /'
);

-- Company: "РЕСУРССПЕЦМОНАЖ" (ИНН: 7801703745) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"РЕСУРССПЕЦМОНАЖ"',
  '7801703745',
  'Петербург',
  NULL,
  NULL,
  'resurs.cm@gmail.com',
  'личный контакт',
  'сделал заказ',
  'Рам',
  '2025-07-07',
  '/монтажная организация, попросил кп на личный номер ватсапп, перезвонить 27.06.25 / 30.06.25 - Игорь говорит не пока заказов, просил набрать 07.07.25 / 10.07.25 - игорь попросил перезвонить 11.07.25 в 17:00 / 14.07 - пока нет заказов, Игорю интерестно представительство в СПБ, думает в тчечении недели и должен набрать до 18.07.25 / 22.07.25 - не ответ / 11.08.25 - нет заинтересованости, не знает кому предложить /'
);

-- Company: Завод производитель трансформаторных подстанций "МИН" (ИНН: 7806202005) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Завод производитель трансформаторных подстанций "МИН"',
  '7806202005',
  'Петербург',
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-07',
  '/ не ответ, КП на почту / 02.07.25 - попросили КП на почту и перезвонить 04.07.25 / 04.07.25 - не ответ / 14.07.25 - КП не получили отправил повторно (набрать 23.07) / 24.07.25- сказали не актуально /'
);

-- Company: "Мосэлектрощит" (ИНН: 7831000122) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"Мосэлектрощит"',
  '7831000122',
  'Москва',
  NULL,
  NULL,
  'info@moselectroshield.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-07-07',
  '/ отдел закупок не отвечает / 02.07.25 - не овет / 14.07 - не ответ / 09.09.25 - не ответ /'
);

-- Company: ООО "МЭК" (ИНН: 2623024116) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "МЭК"',
  '2623024116',
  'Ставрополь',
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-07',
  '/ отправил КП, не очень интерестно / 09.09.25 - не ответ /'
);

-- Company: ООО "Электрощит"-ЭТС (ИНН: 6313132888) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Электрощит"-ЭТС',
  '6313132888',
  'Самара',
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-07',
  '/ закуп евгений, норм диалог, попросил КП / 14.07.25 - не дозвон / 22.07.25 - рынок стоит. пока не актуально. перезвонить 20.08.25 / 25.08.25 - заявок нет пока набрать в начале сентября / 09.09.25 - не ответ /'
);

-- Company: ООО "Ринэко" (ИНН: 5405495093) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Ринэко"',
  '5405495093',
  'новосиб',
  NULL,
  NULL,
  'sales@rineco.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-07',
  '/ не ответ, КП на почту / 11.08.25 - запрос КП / 25.08.25 - секретарь не смог соединить с закупом, никто не ответил, попросила инф письмо на почту / 08.09.25 попросили инф письмо на закупки /'
);

-- Company: ООО "КИМ" (ИНН: 5101311690) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "КИМ"',
  '5101311690',
  'Мурманск',
  NULL,
  NULL,
  'info@kim51.ru',
  'холодный обзвон',
  'сделал заказ',
  'Рам',
  '2025-07-07',
  '/ интересны КТП, пока нет заказов / 08.09.25 - тока пришла с отпуска не заявок набрать после 20.09.25 /'
);

-- Company: ООО "Комплексные энергетические решения" (ИНН: 5038057975) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Комплексные энергетические решения"',
  '5038057975',
  'Москва',
  NULL,
  NULL,
  'info@energy-solution.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-07',
  '/ секретарь получил КП / 14.07.25 - компания монтажники, работы нет, просит прозванивать раз в месяц /'
);

-- Company: ООО "ЭЛЭНЕРГО" (ИНН: 7707836184) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛЭНЕРГО"',
  '7707836184',
  'Москва',
  NULL,
  NULL,
  'info@el-energo.com',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-08',
  '/ Запросил КП / 14.07.25 - Иван не получил КП, дал свой номер и КП на ватсапп / 11.08.25 - Иван не ответ / 08.09.25 - работают с россети, попросил инф письмо на почту, звонить на городской позвать нач закупок, набрать 11.09.25 /'
);

-- Company: ООО "ЧЭТА" (ИНН: 2129042924) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЧЭТА"',
  '2129042924',
  'Чувашия',
  NULL,
  NULL,
  'cheta@cheta.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-07',
  '/ секретарь приняла КП, дала номер отдела закупок / 11.08.25 - Кравченко Игорь Александрович закуп, запросил КП на почту / 08.09.25 - нашли сами китайцев, пока думают, набрать после 20.09.25.'
);

-- Company: Электрощит (ИНН: 6672222750) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Электрощит',
  '6672222750',
  'екатеринбург',
  NULL,
  NULL,
  'info@specenprom.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-10',
  '/ не ответ, отправил КП на почту / 10.07.25 - Секретарь получила КП, перезвонить 15.07.25 / 24.07.25 - решение еще не принято, набрать 30.07.25 / 11.08.25 - не дозвон /'
);

-- Company: "СТРОЙЭНЕРГОСИСТЕМЫ" (ИНН: 7716701049) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"СТРОЙЭНЕРГОСИСТЕМЫ"',
  '7716701049',
  'Москва',
  NULL,
  '+7 499 550 96 99',
  'info@sesistems.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-14',
  '/ Кирил, получил КП  / 11.08.25 -  не актуально /'
);

-- Company: ООО ПО "Радиан" (ИНН: 3810310687) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ПО "Радиан"',
  '3810310687',
  'Иркутск',
  NULL,
  '8(395)244 45 22',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-14',
  '/ Евгений Генадьевичь нач снаб, заинтересован, отправил КП / 14.07.25 - не дозвон ИРКУТСК! / Работает Анар / 16.09.25 -  набрать в конце сентября /'
);

-- Company: ООО "ЭЛЕКТРОМАКС" (ИНН: 5404329400) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛЕКТРОМАКС"',
  '5404329400',
  'Новосиб',
  NULL,
  NULL,
  'zakaz@electromax-tk.com',
  'холодный обзвон',
  'сделал заказ',
  'Рам',
  '2025-07-14',
  '/ Ответил Павел он получил КП и просил перезвонить 15.07.25 / 15.07.25 - говорит рынок стоит, набрать 29.07.25 / 11.08.25 - пока нет заказов, звонить в сентябре / 01.09.25 - перезвонить 04.09.25 /  09.09.25 - пока нет заказов, набрать в конце сентября /'
);

-- Company: ООО "МАКСИМУМ" (ИНН: 2312135208) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "МАКСИМУМ"',
  '2312135208',
  'Краснодар',
  NULL,
  '+7(967)300-65-60',
  'torg_maximum@list.ru',
  'холодный обзвон',
  'сделал заказ',
  'Рам',
  '2025-07-14',
  '/ профильная компания, заказы с торгов будут присылать/ 14.07.25 - заинтересовал ивана нашими трансами, он в размышлениях, покажет руководству всю инфу  / 24.07.25 - говорит нет заказов набрать к концу августа / 11.08.25 - не ответ / 08.09.25 - Говорит помнит про нас лучше не названивать /'
);

-- Company: ООО "ТСН" (ИНН: 7825051584) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТСН"',
  '7825051584',
  'Питер',
  NULL,
  '+7-812-718-35-85',
  'tsn@tsn-group.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-14',
  'Рам 04.03 - Профельная компания не получиось обойти секретаря. отправил КП надо прожимать / 14.05.25 - забыли про нас, попросили инф письмо / 20.05.25 -  Секретарь сново попросил КП / 24.07.25 - директор по снабжению в отпуске / 11.08.25 - секретарь не помнит о нас запросила КП, набрать 25.08.25 / 09.09.25 попросила инф письмо, не пробиваемы секритарь, звонить в конце сентября  /'
);

-- Company: ООО ЕТекс (ИНН: 0269044244) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ЕТекс',
  '0269044244',
  'Башкирия',
  NULL,
  NULL,
  'info@eteh-energo.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-07-14',
  '/ Эмиль заинтересовался, нужно добивать, набрать 28.07.25 / 11.08.25 - пока рынок стоит, о нас помнит, набрать 25.08.25 / 29.08.25 - Эмиль спросил цену 400ква тмг, сколький тип /'
);

-- Company: ООО "БТ Энерго" 7811573630 | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "БТ Энерго" 7811573630',
  NULL,
  'Питер',
  NULL,
  NULL,
  'sale@btenergospb.ru',
  'холодный обзвон',
  'сделал заказ',
  'Рам',
  '2025-07-14',
  'Отправил, КП. Берут под торги, нужно прожимать / 09.09.25 - нет заказов /'
);

-- Company: (ООО "Челябинский завод "Подстанция") 7451263799 (ИНН: 7451263799) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '(ООО "Челябинский завод "Подстанция") 7451263799',
  '7451263799',
  NULL,
  NULL,
  '+7(351)778-50-72',
  'ch-z-p@yandex.ru',
  'холодный обзвон',
  'сделал заказ',
  'Рам',
  '2025-07-14',
  '/ Отправил на ватсапп инфу, заказов нет / 09.09.25 - не ответ александр /'
);

-- Company: ООО НПК "ТехноПром" (ИНН: 7718289053) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО НПК "ТехноПром"',
  '7718289053',
  NULL,
  NULL,
  NULL,
  'infoinfo@texnoprom.com',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-14',
  'Василий попросил КП, и перезвонить 28.07.25 / 09.09.25 - не ответ /'
);

-- Company: ООО "Управляющая компания "Уралэнерго (ИНН: 1840010380) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Управляющая компания "Уралэнерго',
  '1840010380',
  'Ижевск',
  NULL,
  '8 341 270 00 74',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-21',
  '/ Азат запросил инф письмо и перезвонить 24.07.25 / 24.07.25 - пока не интересно, набрать к коцу августа / 29.08.25 - спорили с азатом по цене, запросил прайс, след созвон 10-15 сентября / 09.09.25 - не ответ /'
);

-- Company: ООО "Инженерный центр "Энергосервис" (ИНН: 7722330113) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Инженерный центр "Энергосервис"',
  '7722330113',
  'Москва',
  NULL,
  NULL,
  'info@ens.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-07-21',
  '/ Секретарь получила инф письмо / 09.09.25- не ответ /'
);

-- Company: ООО "ИЦ ЭНЕРГЕТИКИ" (ИНН: 7107550225) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ИЦ ЭНЕРГЕТИКИ"',
  '7107550225',
  'Москва',
  NULL,
  NULL,
  'info@ecenergy.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-07-21',
  '/ инф письмо на почту, проверить рассмотрение / 24.07.25 - если не связались значит нет надобности, набрать в середине августа / 29.08.25 - повторно инф письмо попросили и набрать 5 сентября / 09.09 25 - не помнят про нас, попросили повторное инф письмо /'
);

-- Company: ООО ТПК "ЭНЕРГЕТИЧЕСКАЯ СИСТЕМА" (ИНН: 5040148531) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ТПК "ЭНЕРГЕТИЧЕСКАЯ СИСТЕМА"',
  '5040148531',
  'Москва',
  NULL,
  NULL,
  'info@energ-sys.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-07-21',
  '/ не ответ инф письмо на почту / 24.07.25 - попросили повторное КП, если интерестно свяжуться  /'
);

-- Company: АО "ОВЛ-ЭНЕРГО" (ИНН: 7722621137) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО "ОВЛ-ЭНЕРГО"',
  '7722621137',
  'Москва',
  NULL,
  '+7(495)134-92-00',
  'ovl@ovl-energo.com',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-07-21',
  '/ трудные, инф на почту /'
);

-- Company: ООО "Группа Электроэнергетика" (ИНН: 7718914758) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Группа Электроэнергетика"',
  '7718914758',
  'Москва',
  NULL,
  '8 495 926 09 46',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-07-21',
  '/ Работают с россетями, поговорит с начальством набрать  24.07.25 / 24.07.25 - александр дал свой номер отправил ему инфу и видео на ватсапп, сказал обсудит с начальством и перезвонит / 24.07.25 - не заинтересованы, работают с россети /'
);

-- Company: ООО " ЛЕРОН " 7803010217 | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО " ЛЕРОН " 7803010217',
  NULL,
  'Питер',
  NULL,
  NULL,
  'leron.spb@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-08-05',
  'Ответил гореев рассул  инфу принял, интерестно, набрать 01.09.25 / 09.09.25 - Сергей занят, набрать 11.09.25 /'
);

-- Company: ООО "ЭНЕРГО ЦЕНТР" 3328492856 | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГО ЦЕНТР" 3328492856',
  NULL,
  'Владимир',
  NULL,
  '+7(920)933-44-47',
  '33energo@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-08-11',
  '/ запросили КП и набрать 15.08.25 / 08.09.25 - нет заказов /'
);

-- Company: ООО РЭСЭНЕРГОСИСТЕМЫ (ИНН: 7804382585) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО РЭСЭНЕРГОСИСТЕМЫ',
  '7804382585',
  'Питер',
  NULL,
  NULL,
  'info@etm-res.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-08-11',
  '/ мария запросила КП на общую почту / 09.09.25 - закуп не ответ /'
);

-- Company: ООО ВП "НТБЭ (ИНН: 6658012599) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ВП "НТБЭ',
  '6658012599',
  'Екатеринбург',
  NULL,
  NULL,
  'info@ntbe.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-08-29',
  '/ ответил Александр, запросил инф письмо / 09.09.25 - пока нет потребности, 22.09.25 /'
);

-- Company: ООО "ЭНЕРГОСТРОЙМОНТАЖ" 7203311501 | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОСТРОЙМОНТАЖ" 7203311501',
  NULL,
  'Тюмень',
  NULL,
  '+7-345-267-06-77',
  'esm@esm-t.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-09-09',
  '/ Владиславу интерестно из наличия, заявки есть постоянно у них, запросил инф письмо, нужно доробатывать,   набрать 15.09.25 /'
);

-- Company: ООО "ЭНЕРГОИНВЕСТ" (ИНН: 8901029539) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОИНВЕСТ"',
  '8901029539',
  'Ямал',
  NULL,
  '+7 349 922-11-63',
  'info@89energo.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-09-09',
  '/ Секретарь запросила инф письмо, работают на довальческом, уточнить расмотрение 15.09.25 /'
);

-- Company: "ЭНЕРГ-ОН" (ИНН: 7816600118) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ЭНЕРГ-ОН"',
  '7816600118',
  'Санкт-Петербур',
  NULL,
  '+7(800)550-9738',
  'info@energ-on.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  '2025-09-16',
  '/ 16.09.25 - наш товар редкий, основное это щитовое, запрос инф на почту /'
);

-- Company: ООО "НПО "ЛЕНЭНЕРГОМАШ" 7802753273 (ИНН: 7802753273) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "НПО "ЛЕНЭНЕРГОМАШ" 7802753273',
  '7802753273',
  NULL,
  NULL,
  NULL,
  'info@npolem.ru',
  'холодный обзвон',
  'слабый интерес',
  'Рам',
  '2025-09-30',
  '/30.09.25 инф письмо на почту /'
);

-- Company: ООО ЭТЗ "ИВАРУС" (ИНН: 7415078430) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ЭТЗ "ИВАРУС"',
  '7415078430',
  'Челябинск',
  NULL,
  '8 499 406-10-24',
  'zakaz@iv74.ru',
  'личный контакт',
  'сделал запрос',
  'Рам',
  NULL,
  '/Алексей закупщик, заинтересован, попросил КП с ценами/ 16.06.25 - Александр Сухоруков, попросил КП, Алексей в опуске / 19.06.25 - прислапли на почту заявку на тсл 3150 / 26.06.25 - Яков мажеться, говорит некогда,прислал на почту запрос от СБ  / 01.07.25 - отправленные пояснения и бизнес карта / 09.07.25 - нет на месте / 14.07.25 - Яков просит позвонит 16.07.25 / 18.07.25 - Яков скинул заявку на сухие трансы, кп отправленно 21.07.25 / 22.07.25 - яков попросил цены на масло от 630 до 2500 ква в ознакомительных целях, задал эмми вопрос по доставке и диллерству / 11.08.25 - не дозвон / 30.09.25 - Яков просит набрать 08.10.25 обсудить конкретику /'
);

-- Company: ЗАО "Энергомашкомплект" (ИНН: 5948025911) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ЗАО "Энергомашкомплект"',
  '5948025911',
  'Пермь',
  NULL,
  NULL,
  'info@snabenergo23.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  NULL,
  '/Вышел на закуп, отправил КП/ Пришла заявка на транс тока, запрос отправил ерболу/ 04.07.25 - не ответ / 11.08.25 - пока нет заказов /'
);

-- Company: ООО "ЦРЗЭ" (ИНН: 6670227858) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЦРЗЭ"',
  '6670227858',
  'Екатеринбург',
  NULL,
  '+7 343 278-92-16',
  'CRZE@BK.RU',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  NULL,
  '/ Хороший заход, запросили КП на почту / 14.07.25- Сергей не на месте, набрать 15.07.25 / 22.07.25 - пока нет заказов, но интерестно, скинет на почту пример для просчета / 24.07.25 - отправил каталог / 11.08.25 - прислали опросник на тсл 2000 ответ на почту / 28.08.25 - в ответ на кп прислал запрос на 1250 сухой медь / 30.09.25 - пока нет запросов про нас помнит, сильно не задрачивать /'
);

-- Company: ООО "Энергетический Стандарт" (ИНН: 7706684490) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Энергетический Стандарт"',
  '7706684490',
  'Москва',
  NULL,
  '+7(499)286-22-33',
  'info@enstd.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  NULL,
  '/ не ответ инф на почту / 24.07.25 - Александру очень интерестно поставки из китая, дал свой номер и запросил инфу на ватсапп / 09.09.25 - занят на пергаворах / 16.09.25 - интересны от 110 кв, о нас ппомнит сильно не задрачивать, звонок начало октября /'
);

-- Company: ООО "РиМтехэнерго" (ИНН: 5402543239) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "РиМтехэнерго"',
  '5402543239',
  'Новосиб',
  NULL,
  NULL,
  'feedback@rimteh.com',
  'холодный обзвон',
  'сделал заказ',
  'Рам',
  NULL,
  '/ Берут наш товар, Евгений попросил КП на почту / 02.06.25 - нет заявок, попросил набрать в конце месяца/  05.08.25.- евгений попросил инфу на ватс апп и обещал заявку / 30.09.25 - попросил почту, есть заказ на ктп /'
);

-- Company: "ЭНЕРГОПРОМ-АЛЬЯНС" (ИНН: 7726384409) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ЭНЕРГОПРОМ-АЛЬЯНС"',
  '7726384409',
  'Москва',
  NULL,
  NULL,
  'office@epatrade.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  NULL,
  '/ закуп Сергей, плотно поговорили про китай и энергоэфективность .КП отправил/ 19.06 - он не получил инфу про нас, отправил повторно, долго тележили за китай, он пытался навялить что херня / 30.06.25 - Сергей запросил больше информации о трансформаторах, расширенный протокол испытаний (вопрос ерболу) / 10.07.25 - расширенные испытания отправленны, сергей не отвечает на телефон / 14.07.25 - Сергей в отпуске до 25.07.25 / 11.08.25 - мозгоеб про то что трансы не соответствуют ГОСТ, просит набрать 14.08.25 /'
);

-- Company: ООО "НПО АР-ТЕХНОЛОГИИ" (ИНН: 5032304480) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "НПО АР-ТЕХНОЛОГИИ"',
  '5032304480',
  'Москва',
  NULL,
  '+7 499 450-85-33',
  'info@npoar.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  NULL,
  '/ Андрей нач снаб, заинтересован в трансах / 30.06.25 - КП на рассмотрении ТЕХ отдела, просил набрать 14.07.25 / 14.07.25 - Андрей говорит тех отдел пока не рассмотрел наше предложение, наберт сам, если долго не выйдет на связь прожать его / 11.08.25 - пока нет заказ, набрать 25.08.25 / 25.08.25 - Андрей запросил 1250 сухой /'
);

-- Company: ООО "ПКФ "ТСК" (ИНН: 6316213310) | Manager: Рам
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПКФ "ТСК"',
  '6316213310',
  'Москва',
  NULL,
  NULL,
  'info@pkftsk.ru',
  'холодный обзвон',
  'сделал запрос',
  'Рам',
  NULL,
  '/ 16.09.25 - не дозвон инф на почту / 30.09.25 - Александр попросил инф на почту / 22.12.25 - прислал запрос на тмг 2500 и 630'
);

-- Company: ООО "ЭЛСНАБ" ИНН: 7719612213 (ИНН: 7719612213) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭЛСНАБ" ИНН: 7719612213',
  '7719612213',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  '2025-03-25',
  'Жду опросный лист БКТП. Свяжеться сам Вышел на ЛПР .'
);

-- Company: ООО "ПАРТНЕР ТТ" ИНН: 5405498048 (ИНН: 5405498048) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПАРТНЕР ТТ" ИНН: 5405498048',
  '5405498048',
  NULL,
  NULL,
  NULL,
  'partnertt@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  '2025-03-20',
  'Отправил после звонка КП на почту. Не прошел секретаря'
);

-- Company: ООО "КУБАНЬГАЗЭНЕРГОСЕРВИС" 2309073209 (ИНН: 2309073209) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "КУБАНЬГАЗЭНЕРГОСЕРВИС" 2309073209',
  '2309073209',
  NULL,
  NULL,
  '+7-481-230-40-53',
  'info@kgpes.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Отправил КП на почту . Не прошел секретаря'
);

-- Company: ООО "Коксохим-Электромонтаж" 7705975665 (ИНН: 7705975665) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Коксохим-Электромонтаж" 7705975665',
  '7705975665',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'отказ',
  'Анар',
  NULL,
  'НЕ ЗАКУПАЮТ'
);

-- Company: ООО «Солар Системс» | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО «Солар Системс»',
  NULL,
  NULL,
  NULL,
  NULL,
  'mail@solarsystems.msk.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  '2025-03-20',
  'Отправил на имя генерального директора ком перд на почту. Не прошел секретаря'
);

-- Company: Инжиниринговая Компания ТЭЛПРО | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Инжиниринговая Компания ТЭЛПРО',
  NULL,
  NULL,
  NULL,
  NULL,
  'ssa@telpro-ing.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Отрпавил информацию в whats app. Сказал вышлет пару опросных на подстанции.'
);

-- Company: SciTex Group | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'SciTex Group',
  NULL,
  NULL,
  NULL,
  NULL,
  'project@scitex.group',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  '2025-03-20',
  'Продукция интересует. Отправил на почту коммерческое предложение.'
);

-- Company: МУП ЖМЛКОМСЕРВИС | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'МУП ЖМЛКОМСЕРВИС',
  NULL,
  NULL,
  NULL,
  NULL,
  'mup@sosnovoborsk.krskcit.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Потенциально могут закупать трансформаторы.'
);

-- Company: ООО "СибЭлектроМонтаж" | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "СибЭлектроМонтаж"',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@sibem24.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Знают про СВЕРДЛОВЭЛЕКТРОЩИТ. Потербности нет.'
);

-- Company: ООО «Кайрос Инжиниринг» | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО «Кайрос Инжиниринг»',
  NULL,
  NULL,
  NULL,
  '+7 342 299 99 41',
  'perm@kairoseng.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Отправил информацию в отдел снабжения через секретаря. Возможно заинтересуются'
);

-- Company: ООО "ГК "НЗО" | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ГК "НЗО"',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  '2025-03-20',
  'Перезвонить, потенциально могут закупать'
);

-- Company: ООО «СИРИУС-МК» | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО «СИРИУС-МК»',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'личный контакт',
  'слабый интерес',
  'Анар',
  NULL,
  'Потенциальный клиент, вышел на личный контакт whatsapp, обратится при потребности'
);

-- Company: ООО НПП «Элекор» | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО НПП «Элекор»',
  NULL,
  NULL,
  NULL,
  NULL,
  'nppelekor@yandex.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Есть интерес в закупке НОВЫХ трансформаторов. Покупают у энетры и в брянске. ОТПРАВИТЬ КП на почту.'
);

-- Company: ооо пкф спектор | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ооо пкф спектор',
  NULL,
  NULL,
  NULL,
  NULL,
  'pkfspectr@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Дозвонится'
);

-- Company: ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ (ИНН: 7802536127) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ',
  '7802536127',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  '2025-03-25',
  'Дальний восток, связаться , потеницально могут закупать. Не ответил'
);

-- Company: Крия Инжиниринг | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Крия Инжиниринг',
  NULL,
  NULL,
  NULL,
  '80057769780',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Отправил информацию на почту, переодически есть потребность , можем сработать в будущем.'
);

-- Company: Общество с ограниченной ответственностью "Самур" | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Общество с ограниченной ответственностью "Самур"',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Не довзонился. Отправил предложение на почту в отдел закупок.'
);

-- Company: Акционерное общество "Дальневосточная электротехническая компания" | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Акционерное общество "Дальневосточная электротехническая компания"',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Написал на почту. Позвонить. Дальний восток.'
);

-- Company: ООО НСК | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО НСК',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Заполнил форму обратной связи. Выслал КП. Можно позвонить днем.'
);

-- Company: ООО МНПП «АНТРАКС» | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО МНПП «АНТРАКС»',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Отправил форму обратной связи . Можно позвонить'
);

-- Company: ООО РУСТРЕЙДКОМ | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО РУСТРЕЙДКОМ',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Непрофильно, но участвуют в торгах. Отправил КП. Можно позвонить'
);

-- Company: ООО «Сибтэк» | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО «Сибтэк»',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  '2025-03-26',
  'Направил информацию на почту. Телефон не доступен.'
);

-- Company: АО Дюртюлинские ЭиТС | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО Дюртюлинские ЭиТС',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  '2025-03-26',
  'ЗВОНИЛ, СКАЗАЛИ ВСЕ ТОЛЬКО ЧЕРЕЗ ТОРГИ. ОТПРАВИЛ КП НА ПОЧТУ'
);

-- Company: Группа компаний «РИНАКО» | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Группа компаний «РИНАКО»',
  NULL,
  NULL,
  NULL,
  NULL,
  'bsk@bsk-rinako.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Отправил КП на почту. Не прошел секретаря.'
);

-- Company: ООО «Энергоремонт» | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО «Энергоремонт»',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Закупают только через тендерные площадки. Можно попробовать пробится к ЛПР.'
);

-- Company: ООО "СТАРТ" | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "СТАРТ"',
  NULL,
  NULL,
  NULL,
  '+7 831 211-27-79',
  'ruslanb4shirov@yandex.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Закупают трансформаторы. Хорошо разбирается в рынке, представился как диллер уральского силового'
);

-- Company: ООО "ТЭХ" | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТЭХ"',
  NULL,
  NULL,
  NULL,
  '+7 495 780-72-18',
  'ooo_teck@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Закупают трансформаторы. На лпр не вышел, но добавили в список поставщиков.'
);

-- Company: ООО "ТРИНИТАС" | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТРИНИТАС"',
  NULL,
  NULL,
  NULL,
  '+7 922 632-71-00',
  'ulanov2212@list.ru',
  'холодный обзвон',
  'отказ',
  'Анар',
  NULL,
  'не закупают'
);

-- Company: ООО "ПТМ" ИНН 6623071272 (ИНН: 6623071272) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПТМ" ИНН 6623071272',
  '6623071272',
  NULL,
  NULL,
  '+7 922 139-80-98',
  'mr.ptm@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Строительно-монтажные работы, потенциально сильный клиент. Не ответил.'
);

-- Company: ООО "ПРОИЗВОДСТВЕННО-СТРОИТЕЛЬНАЯ КОМПАНИЯ "ТАГИЛЭНЕРГОКОМПЛЕКТ" ИНН 6623051325 (ИНН: 6623051325) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ПРОИЗВОДСТВЕННО-СТРОИТЕЛЬНАЯ КОМПАНИЯ "ТАГИЛЭНЕРГОКОМПЛЕКТ" ИНН 6623051325',
  '6623051325',
  NULL,
  NULL,
  '+7 343 521-55-43',
  'tek-nt@inbox.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Используют давальческий материал.'
);

-- Company: "ЭЛЕКТРИЧЕСКИЕ СЕТИ" 0257009703 (ИНН: 0257009703) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '"ЭЛЕКТРИЧЕСКИЕ СЕТИ" 0257009703',
  '0257009703',
  NULL,
  NULL,
  '+7 347 843-30-41',
  'office@bashenergo.com',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Закупают через B2B'
);

-- Company: Энергопрайм | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'Энергопрайм',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Закупают трансы. Можно пробивать. Отправил КП УСТ на почту'
);

-- Company: ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "Энерготранзит" | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "Энерготранзит"',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Не дозвонился. Сетевая компания. Проводят торги. Скинул КП на почту от УралСилТранс'
);

-- Company: ООО СКАТ ИНН 254 314 48 34 | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО СКАТ ИНН 254 314 48 34',
  NULL,
  NULL,
  NULL,
  '79024820722',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  '2025-04-16',
  'Созвонился. Есть дейсвтующий партнер - завод. Новых не рассматривает. Возможно пробить в будущем'
);

-- Company: ООО КЕДР 2312271472 (ИНН: 2312271472) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО КЕДР 2312271472',
  '2312271472',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Аварийная служба. Есть форма для поставщиков. Заполнил, отправил. Можно позвонить'
);

-- Company: ООО "ФАЗА" ИНН 6449032030 (ИНН: 6449032030) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ФАЗА" ИНН 6449032030',
  '6449032030',
  NULL,
  NULL,
  '+7 845 116-24-22',
  'audit9664@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Номера не доступны'
);

-- Company: ООО "КАВКАЗТРАНСМОНТАЖ" ИНН 2631041620 (ИНН: 2631041620) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "КАВКАЗТРАНСМОНТАЖ" ИНН 2631041620',
  '2631041620',
  NULL,
  NULL,
  '+7 938 350-96-88',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Отправил информацию по уралсилтранс в ватсапп. Пока нет ответа'
);

-- Company: ООО "ЭНЕРГОПРОМ-МОНТАЖ" 2632107016 (ИНН: 2632107016) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОПРОМ-МОНТАЖ" 2632107016',
  '2632107016',
  NULL,
  NULL,
  '+7 963 171-93-33',
  NULL,
  'холодный обзвон',
  'отказ',
  'Анар',
  NULL,
  'не закупают'
);

-- Company: ООО "ЮГ-ТРАНСЭНЕРГО" ИНН 2312278950 (ИНН: 2312278950) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЮГ-ТРАНСЭНЕРГО" ИНН 2312278950',
  '2312278950',
  NULL,
  NULL,
  '+7 962 856-08-20',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Набрать !'
);

-- Company: ООО "СТАНДАРТ" ИНН 0274956285 (ИНН: 0274956285) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "СТАНДАРТ" ИНН 0274956285',
  '0274956285',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  NULL
);

-- Company: ООО ПРОФЭНЕРГО | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ПРОФЭНЕРГО',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@prof.energy',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  NULL
);

-- Company: ООО "ЛИТВЕС" 2302053490 (ИНН: 2302053490) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЛИТВЕС" 2302053490',
  '2302053490',
  NULL,
  NULL,
  '+7 918 362-78-37',
  'ivanasp@yandex.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  '2025-04-16',
  'Отправил КП на почту. Завтра набрать или в ватсапп написать'
);

-- Company: ООО "ГЕОЗЕМКАДАСТР " 7105034112 (ИНН: 7105034112) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ГЕОЗЕМКАДАСТР " 7105034112',
  '7105034112',
  NULL,
  NULL,
  '+7 487 225-90-00',
  'info@gzk71.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Выполняют кадастровые работы. Вряд ли связаны с оборудованием, но можно пробовать.'
);

-- Company: ООО "РСО-ЭНЕРГО" 3661054875 (ИНН: 3661054875) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "РСО-ЭНЕРГО" 3661054875',
  '3661054875',
  NULL,
  NULL,
  '+7 473 211-01-52',
  'rso-e@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Не пробил серетаря.'
);

-- Company: ООО "ЭНЕРГОИНЖИНИРИНГ" 3663143778 (ИНН: 3663143778) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭНЕРГОИНЖИНИРИНГ" 3663143778',
  '3663143778',
  NULL,
  NULL,
  '+7 473 210-66-37',
  'energoinginiring36@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Отправил КП на почту, набрать. Сотрудничают через почту'
);

-- Company: ООО "ИВЭНЕРГОРЕМОНТ" | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ИВЭНЕРГОРЕМОНТ"',
  NULL,
  NULL,
  NULL,
  '+7 910 696-06-88',
  'si_makeeva@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Отправил КП на почту. Занимаются ремонтом, могут купить теоритически. Написать в ватсапп, набрать'
);

-- Company: ООО "ТПК ДВ ЭНЕРГОСЕРВИС" | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ТПК ДВ ЭНЕРГОСЕРВИС"',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  '2025-04-21',
  'Направил КП на почту. Заполнил форму обратной связи. Можно прозвонить'
);

-- Company: БЕЛЭНЕРГОПРОМ | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'БЕЛЭНЕРГОПРОМ',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  '2025-04-21',
  'Направил кп на почту. можно набрать. собирают ктп'
);

-- Company: ООО ИНЭСК | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ИНЭСК',
  NULL,
  NULL,
  NULL,
  NULL,
  'snab@inesk.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  '2025-04-21',
  'Направил КП на почту. Собирают подстанции. Можно набрать'
);

-- Company: ООО ТК ЭНЕРГООБОРУДОВАНИЕ | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ТК ЭНЕРГООБОРУДОВАНИЕ',
  NULL,
  NULL,
  NULL,
  '+7 343 288-70-50',
  'tk@tkenergo.com',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  '2025-04-21',
  'Направил кп на почту. Торговая компания. Обязательно набрать.  Диллеры завода СЗТТ'
);

-- Company: ООО АРКТИК ЭНЕРГОСТРОЙ | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО АРКТИК ЭНЕРГОСТРОЙ',
  NULL,
  NULL,
  NULL,
  NULL,
  'ulyanova@realty.open.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  '2025-04-21',
  'Направил КП. Занимаются монтажом энергообъектов'
);

-- Company: АО ИНЖЕНЕРНО-ТЕХНИЧЕСКИЙ ЦЕНТР НИИ ЭЛЕКТРОМАШИНОСТРОЕНИЯ | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО ИНЖЕНЕРНО-ТЕХНИЧЕСКИЙ ЦЕНТР НИИ ЭЛЕКТРОМАШИНОСТРОЕНИЯ',
  NULL,
  NULL,
  NULL,
  '+79147949853',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  '2025-04-23',
  'Созвонился. Закупают. Целевой. Отправил КП  Совзонится в  среду.'
);

-- Company: ООО "ХИМРЕМОНТ" 0268052524 (ИНН: 0268052524) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ХИМРЕМОНТ" 0268052524',
  '0268052524',
  NULL,
  NULL,
  '+79874836909',
  'boytsov.dv@him-rem.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  '2025-04-21',
  'НАПРАВИЛ КП В ВАТСАПП И ПОЧТУ. ЖДУ ОБРАТКУ'
);

-- Company: ООО РНК КЭПИТАЛ 0326577315 (ИНН: 0326577315) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО РНК КЭПИТАЛ 0326577315',
  '0326577315',
  NULL,
  NULL,
  NULL,
  'rnkcapital@yandex.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'НАПРАВИЛ НА ПОЧТУ. мЕЛКАЯ КОМПАНИЯ НО УЧАСТВУЕТ В ТОРГАХ.'
);

-- Company: ИП Тарасова Екатерина Анатольевна 780513013333 (ИНН: 780513013333) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ИП Тарасова Екатерина Анатольевна 780513013333',
  '780513013333',
  NULL,
  NULL,
  NULL,
  't.ekaterina1980@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Направил на почту коммерческое предложение. Телефона нет.'
);

-- Company: ООО "Инфинити Инвест Групп" | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "Инфинити Инвест Групп"',
  NULL,
  NULL,
  NULL,
  NULL,
  'info@steelequipment.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Очень редко берут трансформаторы. Можно периодически выходить на связь.'
);

-- Company: ООО СТРОЙПРОЕКТ 7704703740 (ИНН: 7704703740) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО СТРОЙПРОЕКТ 7704703740',
  '7704703740',
  NULL,
  NULL,
  NULL,
  '8181918@mail.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Созвонился, закупают. Передаст КП менеджерам. Отправляю СЭЩ. Можно позже Уралсилтранс'
);

-- Company: ООО "КОНТРАКТ КОМПЛЕКТ 21" 7717582411 (ИНН: 7717582411) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "КОНТРАКТ КОМПЛЕКТ 21" 7717582411',
  '7717582411',
  NULL,
  NULL,
  NULL,
  'info@k-komplekt.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Набрал. Пока заявок, но закупают, можно сотрудничать. Отправил КП на почту. Переодически набирать. СЭЩ отправил, потом пробью СилТрансом'
);

-- Company: ООО "ЭТС" 6670292367 (ИНН: 6670292367) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО "ЭТС" 6670292367',
  '6670292367',
  NULL,
  NULL,
  NULL,
  'olhen1276@gmail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Аварийная служба. Есть форма для поставщиков. Заполнил, отправил. Можно позвонить. Отправил от СИЛТРАНСА'
);

-- Company: ООО ТД СЕВЕРНАЯ ЭНЕРГИЯ 4345509318 (ИНН: 4345509318) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ТД СЕВЕРНАЯ ЭНЕРГИЯ 4345509318',
  '4345509318',
  NULL,
  NULL,
  '+79229957146',
  'KGA43@MAIL.RU',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Дозвонился. Закупают. Выслал инфу на почту с 2мя предложениями.'
);

-- Company: ООО ТРАНСКОМ 7721482650 (ИНН: 7721482650) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ТРАНСКОМ 7721482650',
  '7721482650',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  '2025-04-24',
  'Закупают у табриза и поставляют ему. Можно позже пробивать от силтранса и предлагать китай'
);

-- Company: ООО КПМ 7806381442 (ИНН: 7806381442) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО КПМ 7806381442',
  '7806381442',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  NULL
);

-- Company: ООО МОНТАЖНИКПЛЮС 6950210582 (ИНН: 6950210582) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО МОНТАЖНИКПЛЮС 6950210582',
  '6950210582',
  NULL,
  NULL,
  NULL,
  'montazhplus69@mail.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Не дозвонился. Отправить на почту.'
);

-- Company: ООО ЭЛЕКТРОКОМПЛЕКТ 9728003860 (ИНН: 9728003860) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ЭЛЕКТРОКОМПЛЕКТ 9728003860',
  '9728003860',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  NULL
);

-- Company: ООО ВАВИЛОН 6316275330 (ИНН: 6316275330) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ВАВИЛОН 6316275330',
  '6316275330',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  NULL
);

-- Company: ООО НПО ЭЛРУ 040000861 | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО НПО ЭЛРУ 040000861',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  NULL
);

-- Company: ООО ВОСТОКЭНЕРГО 2508129512 (ИНН: 2508129512) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ВОСТОКЭНЕРГО 2508129512',
  '2508129512',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  NULL
);

-- Company: АО ДЭТК 2723051681 (ИНН: 2723051681) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО ДЭТК 2723051681',
  '2723051681',
  NULL,
  NULL,
  NULL,
  'admin@dv-electro.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  '2025-04-24',
  'Набрать по их времене. Скорее всего закупают.'
);

-- Company: ООО АЛГОРИТМ 7751279140 (ИНН: 7751279140) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО АЛГОРИТМ 7751279140',
  '7751279140',
  NULL,
  NULL,
  NULL,
  '1218091@list.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Не закупают, но запросил КП , отправил ему на почту . Можно пробивать'
);

-- Company: ИП ЗАЦЕПИН РОМАН НИКОЛАЕВИЧ 680904311399 (ИНН: 680904311399) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ИП ЗАЦЕПИН РОМАН НИКОЛАЕВИЧ 680904311399',
  '680904311399',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  NULL
);

-- Company: ООО СИБЭЛЕКТРОМОНТАЖ 2460218225 (ИНН: 2460218225) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО СИБЭЛЕКТРОМОНТАЖ 2460218225',
  '2460218225',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  NULL
);

-- Company: ООО МИР-ЭНЕРГО 5404177588 (ИНН: 5404177588) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО МИР-ЭНЕРГО 5404177588',
  '5404177588',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Знает Табриза. Очень редко закупают. Можно бить от уралсилтранса'
);

-- Company: ООО АЭКЛ 7705813030 (ИНН: 7705813030) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО АЭКЛ 7705813030',
  '7705813030',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  NULL
);

-- Company: ЗАО ТДМ ЦЕНТР 7725569968 (ИНН: 7725569968) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ЗАО ТДМ ЦЕНТР 7725569968',
  '7725569968',
  NULL,
  NULL,
  '+79299217652',
  'info@solef-electro.ru',
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Пока нет потребности, но в будущем может быть'
);

-- Company: АО ИНТЕР РАО ЭЛЕКТРОГЕНЕРАЦИЯ 7704784450 (ИНН: 7704784450) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО ИНТЕР РАО ЭЛЕКТРОГЕНЕРАЦИЯ 7704784450',
  '7704784450',
  NULL,
  NULL,
  NULL,
  'li_zm@interrao.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Не дозвонился. Отправить КП на почту. Дозвонится'
);

-- Company: АО СОЛАР СЕРВИС 9727075358 (ИНН: 9727075358) | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'АО СОЛАР СЕРВИС 9727075358',
  '9727075358',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  NULL
);

-- Company: ООО ЛИСЕТ | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО ЛИСЕТ',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  'Анар',
  NULL,
  'Есть в будущем заявка на 2000 ква'
);

-- Company: ООО «Тексис Груп» | Manager: Анар
INSERT INTO companies (name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ООО «Тексис Груп»',
  NULL,
  NULL,
  NULL,
  NULL,
  'sales@texcisgroup.ru',
  'холодный обзвон',
  'сделал запрос',
  'Анар',
  NULL,
  'Поставляют оборудование. Скинул КП на рассмотерние'
);

-- ================================================================
-- INSERT COMPANY CONTACTS (ЛПР)
-- ================================================================

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ГТтехнолоджис' LIMIT 1),
  '',
  NULL,
  '89057065957',
  'stepanuk_EN@gtenergo.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ТрансЭнергоХолдинг"' LIMIT 1),
  'Гончар Родион Сергеевич Тел.: +7 (950) 791 14 16',
  NULL,
  NULL,
  'grs@tehold.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '3528257419' AND name = 'ООО "СПЕЦЭКОНОМЭНЕРГО" 3528257419' LIMIT 1),
  'Богдан на связи +7 911 548-67-17',
  NULL,
  '+7 911 548-67-17',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ГлавЭлектроСнаб' LIMIT 1),
  'Никита',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7801454062' AND name = 'ООО "ПЭП" 7801454062' LIMIT 1),
  'Валентин',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Олниса' LIMIT 1),
  'Евгения z35@olnisa.ru 88003331959 доб 63',
  NULL,
  '88003331959',
  'z35@olnisa.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Систем Электрик' LIMIT 1),
  '',
  NULL,
  '8 800 200 64 46',
  'support@systeme.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ЭнергоПромСТрой' LIMIT 1),
  '',
  NULL,
  '+7 496 639-46-64',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "СК ЭНЕРГЕТИК"' LIMIT 1),
  '',
  NULL,
  '+7 985 762-30-35',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'СПМенерго' LIMIT 1),
  '',
  NULL,
  '84992882894',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "НПОТЭЛ"' LIMIT 1),
  'Илья',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "КАПРАЛ БРИДЖ"' LIMIT 1),
  'Мария',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭСК"' LIMIT 1),
  '',
  NULL,
  '89274098725',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "СТРОЙТЕХУРАЛ"' LIMIT 1),
  'Никита',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "АГРЕГАТЭЛЕКТРО"' LIMIT 1),
  '',
  NULL,
  '+7(920)557-11-75',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "РЕГИОНИНЖИНИРИНГ"' LIMIT 1),
  'Евгений закупщик +7 863 269-79-60',
  NULL,
  '+7 863 269-79-60',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭНЕРГОТЕХСЕРВИС"' LIMIT 1),
  'Вадим 89199202784',
  NULL,
  '89199202784',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ОМСКЭЛЕКТРОМОНТАЖ"' LIMIT 1),
  'Евгений ведущий инженер на бонусе',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭЛЕКТРОЩИТ"' LIMIT 1),
  'Мария Генадьевна закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО НПК "ЭЛПРОМ"' LIMIT 1),
  'Юлия Снабженец +7 861 260-09-96',
  NULL,
  '+7 861 260-09-96',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ПРОМКОМПЛЕКТАЦИЯ"' LIMIT 1),
  'Олег Закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "ВНИИР ГИДРОЭЛЕКТРОАВТОМАТИКА"' LIMIT 1),
  'Михаи закупщик, Регина тоде закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '1831090774' AND name = 'ООО "УВАДРЕВ-ХОЛДИНГ" 1831090774' LIMIT 1),
  'Сергей Павлович 83412220015',
  NULL,
  '83412220015',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '0278151411' AND name = 'ООО "ЭЛЕКТРОЩИТ-УФА"0278151411' LIMIT 1),
  'Цепелев доб 1022 отдел снабжения +7 (846) 278-55-55',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7017409323' AND name = 'ООО "ГК АЛЬЯНС"7017409323' LIMIT 1),
  '',
  NULL,
  '+7 905 089-99-30',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6685079144' AND name = 'ООО ПТК "ЭКРА-УРАЛ" 6685079144' LIMIT 1),
  'Доб 113 у снабжения',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7710620481' AND name = 'ООО "ТЕКСИС ГРУП"7710620481' LIMIT 1),
  'Дмитрий',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "УРАЛЭНЕРГОЦЕНТР"' LIMIT 1),
  'Данил закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7704844420' AND name = 'ООО "РС"7704844420' LIMIT 1),
  '',
  NULL,
  '88002227880',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5258109139' AND name = 'ООО "ТЭС НН"5258109139' LIMIT 1),
  '',
  NULL,
  '+7 831 429-29-29',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5404223516' AND name = 'ООО ПО "РОСЭНЕРГОРЕСУРС"5404223516' LIMIT 1),
  'Евгений милюшкин занимается нашим сказал вышли кп посмотрю',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6672271281' AND name = 'ООО "ТЭМ" 6672271281' LIMIT 1),
  'Закупщица анна',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5834121869' AND name = '5834121869 ООО "ЭВЕТРА ИНЖИНИРИНГ"' LIMIT 1),
  'Сергей закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5190016541' AND name = '5190016541ООО "ТРАНСЭНЕРГО-СЕРВИС"' LIMIT 1),
  'Михаил пока что недоступен',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7448200380' AND name = '7448200380ООО "КВАНТУМ ЭНЕРГО"' LIMIT 1),
  'Екатерина начальник отдела снабжения',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '9102000126' AND name = '9102000126 ООО "СПЕЦЩИТКОМПЛЕКТ"' LIMIT 1),
  'Закупщик екатерина',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6311115968' AND name = '6311115968 ООО "ТСК ВОЛГАЭНЕРГОПРОМ"' LIMIT 1),
  'Антон закупщик доб 429',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '3664123615' AND name = '3664123615 ООО "ВЭЗ"' LIMIT 1),
  '',
  '+7(473)300-32-62 отдел снб доб 1',
  '+7(473)300-32-62',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7733634963' AND name = '7733634963 ЗАО "СТРОЙЭНЕРГОКОМПЛЕКТ"' LIMIT 1),
  '',
  NULL,
  '+7 495 740-40-91',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7813192076' AND name = '7813192076 ООО "АТЭКС-ЭЛЕКТРО"' LIMIT 1),
  'Татьяна закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7702080289' AND name = '7702080289 АО "СИЛОВЫЕ МАШИНЫ"' LIMIT 1),
  '',
  NULL,
  '88123362476',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5914007456' AND name = '5914007456 ООО "ПРОМЫШЛЕННАЯ ГРУППА ПРОГРЕССИЯ"' LIMIT 1),
  'Светалана снабженец',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6731035472' AND name = '6731035472 ООО "ТД "АВТОМАТИКА"' LIMIT 1),
  'Андрей директор +7 910 787-47-98',
  NULL,
  '+7 910 787-47-98',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6670316434' AND name = '6670316434 ООО "ЭЗОИС-УРАЛ"' LIMIT 1),
  'Андрей Микишев технич директор доб 318 7 (343) 363-05-93',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7814461557' AND name = '7814461557 ООО "НТТ-ИК"' LIMIT 1),
  'Сергей',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '0571014706' AND name = '0571014706 ООО "СПЕЦСТРОЙМОНТАЖ"' LIMIT 1),
  'Магомед',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5029227275' AND name = '5029227275 ООО "ЭТК"' LIMIT 1),
  'Андрей',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7701389420' AND name = '7701389420 ООО "АТЕРГО"' LIMIT 1),
  '',
  NULL,
  '+7 499 213-32-10',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7736606442' AND name = '7736606442 ООО "ТЕХСТРОЙМОНТАЖ"' LIMIT 1),
  'Елена закупщица',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6671406440' AND name = '6671406440 ООО ИК "ЭНЕРГОСОФТ"' LIMIT 1),
  'Владимир Иванович  руководитель',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6166107912' AND name = '6166107912 ООО "РОСТЕХЭНЕРГО"' LIMIT 1),
  'Павел Алексеевич рук отдела закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6686078707' AND name = '6686078707 ООО "ПЭМ"' LIMIT 1),
  'Евгений',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2116491707' AND name = '2116491707 ООО "ИЗВА"' LIMIT 1),
  'Татьяна занимается трансформаторами',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7817302964' AND name = '7817302964 https://izhek.ru/' LIMIT 1),
  'Константин закупщик +79111114339',
  NULL,
  '+79111114339',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО ХК "СДС - ЭНЕРГО"' LIMIT 1),
  'Вадим николаев',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "ОБЪЕДИНЕННЫЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ"' LIMIT 1),
  'Панкратов Алексей Викторович',
  NULL,
  NULL,
  'oho2@oes37.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6319231042' AND name = 'ООО "САМЭСК" 6319231042' LIMIT 1),
  'Отдел закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "КРАСЭКО"' LIMIT 1),
  'Отдел закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Энергонефть Томск http://energoneft-tomsk.ru/index.php?id=13' LIMIT 1),
  'Начальник снабжения',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6320005633' AND name = 'ЗАО "ЭИСС" 6320005633' LIMIT 1),
  'Екатерина Юрьевна',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "Варьегоэнергонефть" https://oaoven.ru/kont.html' LIMIT 1),
  'Азат Аскатович начальник ПТО',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "Пензенская горэлектросеть' LIMIT 1),
  '',
  NULL,
  NULL,
  'nazarov@pges.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "ОРЭС-ПРИКАМЬЯ"' LIMIT 1),
  'Евгений Васильевич Начальник снабжения',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ПКГУП "КЭС"' LIMIT 1),
  'Анастасия игоревна закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Акционерное общество «Витимэнерго»' LIMIT 1),
  'Секретарь',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Щекинская ГОРОДСКАЯ ЭЛЕКТРОСЕТЬ' LIMIT 1),
  'Попросить перевести на отдел закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '1658191691' AND name = 'ООО "ИНТЕГРАЦИЯ" 1658191691' LIMIT 1),
  'Александр Устинов',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '3443139342' AND name = 'ООО "ВЭС-СНТ" 3443139342' LIMIT 1),
  'Горьковская Евгения Александровна начальник снбаж',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭУ"' LIMIT 1),
  'Мужик какой-то',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2702032110' AND name = 'АО "ХГЭС" 2702032110' LIMIT 1),
  'Закупщица Татьяна',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2531006580' AND name = 'АО "ДВ РСК" 2531006580' LIMIT 1),
  'Бухматов Владимир Александрович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2510003066' AND name = 'АО "СЭС" 2510003066' LIMIT 1),
  'Имя не узнал',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2724182990' AND name = 'ООО "ТД "ЭЛЕКТРОСИСТЕМЫ" 2724182990' LIMIT 1),
  'Не спросил',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2901295280' AND name = 'ООО "АСК" 2901295280' LIMIT 1),
  'Игорь Николаевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2465302760' AND name = 'Енисей сеть сервис 2465302760' LIMIT 1),
  'Секретарь',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ПКБ "РЭМ"' LIMIT 1),
  'Евгений Орлов',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7714426397' AND name = 'ООО "ЦЭК" 7714426397' LIMIT 1),
  'Сергей Станиславович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2124019520' AND name = 'ООО "ПРИЗМА" 2124019520' LIMIT 1),
  'Сергей Алексеевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7017081040' AND name = 'ООО "ГОРСЕТИ" 7017081040' LIMIT 1),
  'Отдел закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2466250680' AND name = 'ООО "НОРДГРОН" 2466250680' LIMIT 1),
  'Елена Грибова',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2460107451' AND name = 'ООО "Энергосибинжиниринг" 2460107451' LIMIT 1),
  'Наталья начальник снабж',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2721206795' AND name = 'ООО "ЭКРА-ВОСТОК" 2721206795' LIMIT 1),
  'Вадим Валерьевич снабж',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5609088434' AND name = '"КЭС ОРЕНБУРЖЬЯ" 5609088434' LIMIT 1),
  'Руслан Амварович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '4703005850' AND name = 'МП "ВПЭС" 4703005850' LIMIT 1),
  'Дарья Жукова',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7415041790' AND name = 'ООО "МЭС" 7415041790' LIMIT 1),
  'Андрей Борисович Петров',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '4205153492' AND name = 'ОАО "СКЭК". 4205153492' LIMIT 1),
  'Абзалов Кирилл Ильдарович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5005005770' AND name = '"ФАБИ" 5005005770' LIMIT 1),
  'Снабжение',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7743211928' AND name = '"СПЕЦЭНЕРГОГРУПП" 7743211928' LIMIT 1),
  'Не спросил',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6670018981' AND name = 'АО "РСК" 6670018981' LIMIT 1),
  'Юрий Григорьевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7448114740' AND name = 'ООО ПКП "ФИНСТРОЙИНВЕСТ" 7448114740' LIMIT 1),
  'Анатолий александрович начальник снабжения',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Общество с ограниченной ответственностью «ЭнергоПрогресс»' LIMIT 1),
  'Александр кравченко',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2724091687' AND name = 'ООО "ЭНЕРГО-ИМПУЛЬС +" 2724091687' LIMIT 1),
  'Елена Шмакова',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6315597656' AND name = 'ООО "ПК ЭЛЕКТРУМ" 6315597656' LIMIT 1),
  'Лариса',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5036003332' AND name = 'АКЦИОНЕРНОЕ ОБЩЕСТВО "ПОДОЛЬСКИЙ ЗАВОД ЭЛЕКТРОМОНТАЖНЫХ ИЗДЕЛИЙ" 5036003332' LIMIT 1),
  'Маргарита',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5249058696' AND name = '5249058696 АО "НИПОМ"' LIMIT 1),
  'Олег Николаевич Дадонов руководитель отедла закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '1659161058' AND name = 'ООО "ЭЛЕКТРООПТИМА" 1659161058' LIMIT 1),
  'Венера Гусмановна',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5037004040' AND name = 'АО "ПРОГРЕСС" 5037004040' LIMIT 1),
  'Светлана не дозвон',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7814104690' AND name = '"ЭЛЕКТРОНМАШ" 7814104690' LIMIT 1),
  'Анна николаевна',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7716050936' AND name = 'ООО "ИНИЦИАТИВА" 7716050936' LIMIT 1),
  'Вячеслав',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '1658099230' AND name = 'ООО "КЭР-ИНЖИНИРИНГ" 1658099230' LIMIT 1),
  'Айрат Зуфарович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '8911033894' AND name = '8911033894 АКЦИОНЕРНОЕ ОБЩЕСТВО "ПУРОВСКИЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ"' LIMIT 1),
  'Валерий Николаевич главный инженер',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6671408085' AND name = 'ООО "ЭТП" 6671408085' LIMIT 1),
  'Игорь',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '4632061580' AND name = 'ООО "Электростроймонтаж" 4632061580' LIMIT 1),
  'Артем',
  'закупщик',
  NULL,
  'joev.ar@gmail.com',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = '«Липецкэлектро»' LIMIT 1),
  'Юрий (закупщик) le48_yuri@mail.ru',
  NULL,
  NULL,
  'le48_yuri@mail.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '4028033363' AND name = 'ООО "КАСКАД-ЭНЕРГО" 4028033363' LIMIT 1),
  'Начальник отдела снабжения',
  NULL,
  NULL,
  'p.gerasimov@kenergo.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '4028033363' AND name = 'ООО "КАСКАД-ЭНЕРГО" 4028033363' LIMIT 1),
  'Герасимов Павел Викторович',
  NULL,
  NULL,
  'p.gerasimov@kenergo.ru',
  false
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7743910877' AND name = '"ЭМПИН"' LIMIT 1),
  'Артем',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7720748931' AND name = 'ООО "ИК СИТИЭНЕРГО" 7720748931' LIMIT 1),
  '',
  NULL,
  NULL,
  'snab@cityengin.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '3663049140' AND name = 'ООО "ЦЕНТРЭЛЕКТРОМОНТАЖ" 3663049140' LIMIT 1),
  'Дарья(закупщик)',
  NULL,
  NULL,
  'omts@cem.pro',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7708783560' AND name = 'ООО "ЭЛЕКТРОГАРАНТ"' LIMIT 1),
  'Максим +7-963-154-62-84',
  NULL,
  '+7-963-154-62-84',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭНЕРГО-ДОН"' LIMIT 1),
  'Ольга (закупщик)',
  NULL,
  NULL,
  'torgi2@energo-don.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6215016322' AND name = 'Энергосервис 6215016322' LIMIT 1),
  '',
  NULL,
  '8-910-568-39-80',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7703663861' AND name = 'ООО "Резерв-Электро 21 век" 7703663861' LIMIT 1),
  'Григорий закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7610080930' AND name = 'ООО ЭЛЕКТРО 7610080930' LIMIT 1),
  'Владимир',
  NULL,
  '8 485 528 03 05',
  'avan_76@mail.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2130065323' AND name = 'ООО "ПРОГРЕССЭНЕРГО"' LIMIT 1),
  'Отдел закупок:',
  NULL,
  NULL,
  '111@progenerg.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2130065323' AND name = 'ООО "ПРОГРЕССЭНЕРГО"' LIMIT 1),
  'Паввел',
  NULL,
  NULL,
  '111@progenerg.ru',
  false
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7813479840' AND name = 'ООО "ЭНЕРГО СТРОЙ"' LIMIT 1),
  'Александра',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2635095256' AND name = 'ООО "Энергостройуниверсал"' LIMIT 1),
  'Альберт нач.снаб.',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7702810351' AND name = 'ООО "Энергоиндустрия"' LIMIT 1),
  'Юрий Владимирович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7810397798' AND name = 'ООО ТК "ЭНЕРГОКОМПЛЕКС"' LIMIT 1),
  'Кузнецов Андрей(закупщик)',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7842489681' AND name = 'ООО "НОРДГРИД"' LIMIT 1),
  'Вадим Аскеров (закуп)',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '3662287110' AND name = 'ООО "КНГ - ЭНЕРГО' LIMIT 1),
  '',
  '+7 (473) 202-02-75 – отдел закупок',
  NULL,
  'snab@kngenergo.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2373002283' AND name = 'ООО "Центр Инжениринг"' LIMIT 1),
  'Антон',
  NULL,
  '89959615925',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭМКОМ" 7802335484' LIMIT 1),
  'Алексей Николаевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '0224011030' AND name = 'ООО "Завод "Энергетик"' LIMIT 1),
  'Виталий Игоревич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6950049622' AND name = 'АО "МЕРИНГ ИНЖИНИРИНГ' LIMIT 1),
  'Лев',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7422036304' AND name = '"Озёрский завод энергоустановок"' LIMIT 1),
  'Руских Наталья Викторовна нач снаб',
  NULL,
  '8 351 304 36 85',
  'omts4@ozeu.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7704372086' AND name = 'ООО "ТД "ПРОМЫШЛЕННОЕ ОБОРУДОВАНИЕ"' LIMIT 1),
  'Епифанов Роман Александрович(дир)',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2312118185' AND name = 'ООО "АС-ЭНЕРГО"' LIMIT 1),
  'Николай',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '0264080182' AND name = 'ООО НПП "220 Вольт"' LIMIT 1),
  'Елена (закуп)',
  NULL,
  NULL,
  '777@220ufa.com',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7722105693' AND name = 'ЗАО "ЭЛСИЭЛ"' LIMIT 1),
  '',
  'отдел снабжения доб. 620',
  NULL,
  '628@elsiel.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7743639382' AND name = 'ООО "Энергии Технологии"' LIMIT 1),
  'Гл. инженер',
  NULL,
  NULL,
  'shitov@ener-t.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7743639382' AND name = 'ООО "Энергии Технологии"' LIMIT 1),
  'Шитов Павел Федорович',
  NULL,
  NULL,
  'shitov@ener-t.ru',
  false
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2310212721' AND name = 'ООО "СНАБЭНЕРГОРЕСУРС"' LIMIT 1),
  'Владимир (снаб)',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7720679090' AND name = 'ООО "Энергопроф"' LIMIT 1),
  'Владимир Анатольевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6679125667' AND name = 'ПКФ"ЭЛЕКТРОКОМПЛЕКС"' LIMIT 1),
  'Андрей',
  NULL,
  NULL,
  'tk2@l-complex.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7801703745' AND name = '"РЕСУРССПЕЦМОНАЖ"' LIMIT 1),
  'Машуков Игорь',
  NULL,
  '8 921 950 99 09',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7806202005' AND name = 'Завод производитель трансформаторных подстанций "МИН"' LIMIT 1),
  '',
  'отдела закупок:',
  NULL,
  'snab@minspb.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2623024116' AND name = 'ООО "МЭК"' LIMIT 1),
  'Алексей',
  NULL,
  NULL,
  'mec26@mail.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2623024116' AND name = 'ООО "МЭК"' LIMIT 1),
  'Отдел снабжения',
  NULL,
  NULL,
  'mec26@mail.ru',
  false
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6313132888' AND name = 'ООО "Электрощит"-ЭТС' LIMIT 1),
  'ЕвгенийНикитин(закуп)',
  NULL,
  NULL,
  'enikitin@elsh.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5405495093' AND name = 'ООО "Ринэко"' LIMIT 1),
  '',
  NULL,
  NULL,
  'zakupki@rineco.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5101311690' AND name = 'ООО "КИМ"' LIMIT 1),
  'Екатерина',
  NULL,
  NULL,
  'mto@kim51.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5038057975' AND name = 'ООО "Комплексные энергетические решения"' LIMIT 1),
  'Денис Суровый',
  NULL,
  NULL,
  'suroviy.d@energy-solution.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7707836184' AND name = 'ООО "ЭЛЭНЕРГО"' LIMIT 1),
  'Иван',
  NULL,
  '+7(968)0681333',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2129042924' AND name = 'ООО "ЧЭТА"' LIMIT 1),
  'Кравченко Игорь Александрович',
  'отдел закуп',
  NULL,
  'zakupki@cheta.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7716701049' AND name = '"СТРОЙЭНЕРГОСИСТЕМЫ"' LIMIT 1),
  'Кирил',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '3810310687' AND name = 'ООО ПО "Радиан"' LIMIT 1),
  'Боровнев ЕвгенийГенадьевич',
  NULL,
  NULL,
  'borovnev@radian-holding.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5404329400' AND name = 'ООО "ЭЛЕКТРОМАКС"' LIMIT 1),
  'Павел Данилов',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2312135208' AND name = 'ООО "МАКСИМУМ"' LIMIT 1),
  'Иван',
  NULL,
  NULL,
  '05maximum@list.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '0269044244' AND name = 'ООО ЕТекс' LIMIT 1),
  'Эмиль',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7451263799' AND name = '(ООО "Челябинский завод "Подстанция") 7451263799' LIMIT 1),
  'Курышкин Александр Сергеевич',
  '(Начальник коммерческого отдела)',
  '8-922-740-87-80',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7718289053' AND name = 'ООО НПК "ТехноПром"' LIMIT 1),
  'Василий Генадьевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '1840010380' AND name = 'ООО "Управляющая компания "Уралэнерго' LIMIT 1),
  'Азат доб 1310',
  NULL,
  NULL,
  'amavlin@u-energo.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7718914758' AND name = 'ООО "Группа Электроэнергетика"' LIMIT 1),
  'Александр',
  NULL,
  '8 936 245 17 04',
  'pto@elengroup.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО " ЛЕРОН " 7803010217' LIMIT 1),
  'Сергей Степанович',
  NULL,
  '8 981 985 81 95',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7804382585' AND name = 'ООО РЭСЭНЕРГОСИСТЕМЫ' LIMIT 1),
  'Мария',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6658012599' AND name = 'ООО ВП "НТБЭ' LIMIT 1),
  'Александр',
  NULL,
  NULL,
  'alex@ntbe.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭНЕРГОСТРОЙМОНТАЖ" 7203311501' LIMIT 1),
  'Владислав',
  NULL,
  NULL,
  'LVV@esm-t.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7415078430' AND name = 'ООО ЭТЗ "ИВАРУС"' LIMIT 1),
  'Алексей',
  'отдела снабжения',
  '7(351)700-70-36',
  '109@ktp74.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7415078430' AND name = 'ООО ЭТЗ "ИВАРУС"' LIMIT 1),
  'Васильков Яков Сергеевич',
  'отдела снабжения',
  '7(351)700-70-36',
  'snab@ktp74.ru',
  false
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5948025911' AND name = 'ЗАО "Энергомашкомплект"' LIMIT 1),
  'Новикиова Татьяна Сергеевна(закуп)',
  NULL,
  NULL,
  't.novikova@emk-perm.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6316213310' AND name = 'ООО "ПКФ "ТСК"' LIMIT 1),
  'Александр Мишалкин',
  NULL,
  '+7 937 184 93 64',
  'pkf45@pkftsk.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7719612213' AND name = 'ООО "ЭЛСНАБ" ИНН: 7719612213' LIMIT 1),
  'Михаил, добавочно 405',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Инжиниринговая Компания ТЭЛПРО' LIMIT 1),
  'Щупляков Сергей Алексеевич',
  NULL,
  '8-915-747-81-14',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'SciTex Group' LIMIT 1),
  'Не вышешл',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО «СИРИУС-МК»' LIMIT 1),
  '',
  NULL,
  '79876716497',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО НПП «Элекор»' LIMIT 1),
  'Вадим',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7802536127' AND name = 'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ' LIMIT 1),
  'Павел Васильевич +79294089979',
  NULL,
  '+79294089979',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Крия Инжиниринг' LIMIT 1),
  'Илья',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Акционерное общество "Дальневосточная электротехническая компания"' LIMIT 1),
  '',
  NULL,
  NULL,
  '142@dv-electro.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО РУСТРЕЙДКОМ' LIMIT 1),
  '',
  NULL,
  NULL,
  'info@rustradecom.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО «Сибтэк»' LIMIT 1),
  'Телефон: +7 (391) 280-77-11',
  NULL,
  NULL,
  'info@sibtek.su',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО Дюртюлинские ЭиТС' LIMIT 1),
  'Заместитель',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "СТАРТ"' LIMIT 1),
  '',
  NULL,
  '79960074186',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Энергопрайм' LIMIT 1),
  '',
  NULL,
  NULL,
  'info@energoprime.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '0268052524' AND name = 'ООО "ХИМРЕМОНТ" 0268052524' LIMIT 1),
  '',
  NULL,
  '+7 950 318-77-75',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "Инфинити Инвест Групп"' LIMIT 1),
  '',
  NULL,
  '78123091645',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7704703740' AND name = 'ООО СТРОЙПРОЕКТ 7704703740' LIMIT 1),
  '',
  NULL,
  '79268181918',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7717582411' AND name = 'ООО "КОНТРАКТ КОМПЛЕКТ 21" 7717582411' LIMIT 1),
  '',
  NULL,
  '79998800532',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '6670292367' AND name = 'ООО "ЭТС" 6670292367' LIMIT 1),
  '',
  NULL,
  '79120358786',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '4345509318' AND name = 'ООО ТД СЕВЕРНАЯ ЭНЕРГИЯ 4345509318' LIMIT 1),
  'Алексей',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7721482650' AND name = 'ООО ТРАНСКОМ 7721482650' LIMIT 1),
  '',
  NULL,
  '+7-903-770-70-75',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '7751279140' AND name = 'ООО АЛГОРИТМ 7751279140' LIMIT 1),
  '',
  NULL,
  '+79933606544',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '2460218225' AND name = 'ООО СИБЭЛЕКТРОМОНТАЖ 2460218225' LIMIT 1),
  '',
  NULL,
  '8-950-290-90-02',
  'dv@sibem24.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn = '5404177588' AND name = 'ООО МИР-ЭНЕРГО 5404177588' LIMIT 1),
  '',
  NULL,
  NULL,
  'mirenergo54@gmail.com',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО ЛИСЕТ' LIMIT 1),
  '',
  NULL,
  '79109323832',
  NULL,
  true
);

-- ================================================================
-- INSERT ACTIVITIES (from comments/notes)
-- ================================================================

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ГТтехнолоджис' LIMIT 1),
  'кп_отправлено',
  'Входяшка.Отправил КП',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ТрансЭнергоХолдинг"' LIMIT 1),
  'кп_отправлено',
  'Входяшка, звонил анар попутка по нашей теме отправилКП',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3528257419' AND name = 'ООО "СПЕЦЭКОНОМЭНЕРГО" 3528257419' LIMIT 1),
  'звонок',
  'На связи с ним',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ГлавЭлектроСнаб' LIMIT 1),
  'звонок',
  'На связи с ним',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7801454062' AND name = 'ООО "ПЭП" 7801454062' LIMIT 1),
  'заметка',
  'Сказал директор отправить на щакупшика на валентина с ним еще пообщаться надо',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АртЭнерго строй' LIMIT 1),
  'кп_отправлено',
  'недозвон кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Инженерный центр Энергетики' LIMIT 1),
  'кп_отправлено',
  'Пообшались сказали закупают кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ЭТС Энерго' LIMIT 1),
  'кп_отправлено',
  'недозвон кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Олниса' LIMIT 1),
  'кп_отправлено',
  'кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Систем Электрик' LIMIT 1),
  'кп_отправлено',
  'ОТправил кп сложно пробиться',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Стройэнергоком' LIMIT 1),
  'заметка',
  'Сказал закупили уже много чего в первом квартале, звонить в конце августа',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ТрансЭлектромонтаж' LIMIT 1),
  'кп_отправлено',
  'Отправил КП, поговорил сказал перенабрать поговорить точечно а так закупают',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Тверь Энергоактив' LIMIT 1),
  'кп_отправлено',
  'Кп отправил недозвон пока что с кем то разговаривал',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "Элмонт Энерго"' LIMIT 1),
  'кп_отправлено',
  'Попросил кп на почту снабженец',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Сетьстрой' LIMIT 1),
  'кп_отправлено',
  'Кп отправил , сказал пока что вопрос по поставкам неакутальный, но будем пробивать его',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'МагистральЭнерго' LIMIT 1),
  'кп_отправлено',
  'Кп отправил Занято',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ЭнергоПромСТрой' LIMIT 1),
  'кп_отправлено',
  'Кп отправил Занято',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Норэнс Групп' LIMIT 1),
  'кп_отправлено',
  'Кп отправил Занято',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'МосСитиСервис' LIMIT 1),
  'кп_отправлено',
  'Кп отправил сложно пробиться буду пробовать еще раз',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ЭнергоСистемы' LIMIT 1),
  'заметка',
  'Телефон не работает',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Магистр' LIMIT 1),
  'заметка',
  'Блять не понимаю че у них у всех с телефонами',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Строймонтаж' LIMIT 1),
  'кп_отправлено',
  'Сказала отправляйте кп рассмотрим начальник отдела снабжения',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "СК ЭНЕРГЕТИК"' LIMIT 1),
  'кп_отправлено',
  'Ответила женщина сказала проекты есть направляйте кп для снаюжения еще раз перезвоним ей потом',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'СПМенерго' LIMIT 1),
  'заметка',
  'пока что сказала ничего нет в работе',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ВМЗ' LIMIT 1),
  'заметка',
  'Мой клиент по основной работе, у них конкурсы черещ плошадку их собственную там надо регать компанию чтобы учавствовать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "НПОТЭЛ"' LIMIT 1),
  'заметка',
  'Договорились тут на встречу классны типо закупают',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "УРАЛМАШ НГО ХОЛДИНГ"' LIMIT 1),
  'звонок',
  'Не дозвонился попробовать еще раз в снабжение/ не дозвон пока что',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "КАПРАЛ БРИДЖ"' LIMIT 1),
  'письмо',
  'Сказала закупают, направлю письмо сказщала посмотрит',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭСК"' LIMIT 1),
  'звонок',
  'Не дозвонился пока что до него, скинул, позже набрать/ на обеде сказал чуть позже набрать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "СТРОЙТЕХУРАЛ"' LIMIT 1),
  'кп_отправлено',
  'Заинтересовался, попросил предложение на почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "АГРЕГАТЭЛЕКТРО"' LIMIT 1),
  'кп_отправлено',
  'Номер щакупок выцепил пока что не отвечают, отправляю кп   89204505168 Роман Сергеевич agregatel1@bk.ru(11.06)',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "РЕГИОНИНЖИНИРИНГ"' LIMIT 1),
  'заметка',
  'Сказал зщакупают все ок запросы пришлет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭНЕРГОТЕХСЕРВИС"' LIMIT 1),
  'письмо',
  'Вадим Логист, сказал перешлет письмо с инженерам с ним на коннекте',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "ТД "ЭЛЕКТРОТЕХМОНТАЖ"' LIMIT 1),
  'кп_отправлено',
  'Не дозвонился но кп отправил, пробовать снова',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ОМСКЭЛЕКТРОМОНТАЖ"' LIMIT 1),
  'заметка',
  'В вотсап написал 10 июля',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭЛЕКТРОЩИТ"' LIMIT 1),
  'кп_отправлено',
  'Пока что нет ее на месте кп отправил перезвонить. ОТправил ей кп, сказала закупают рассмотрит/ короче ктп сами делают говорит в основном заказчик сам приорбретает трансформатор но если что то будет направит',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ПРОМСОРТ-ТУЛА"' LIMIT 1),
  'кп_отправлено',
  'Нвправио кп в отдел снабжения',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО НПК "ЭЛПРОМ"' LIMIT 1),
  'заметка',
  'Короче они заказывают по ошибке реально они зщаказывали трансу другой компании короче надо внедриться к ним, не отвечает 11.06/ не отвечает пока что Юлия/stv@/Юлия не отвечает пока что 10/07',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ПРОМКОМПЛЕКТАЦИЯ"' LIMIT 1),
  'кп_отправлено',
  'Сказал закупают кп направляю',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "ВНИИР ГИДРОЭЛЕКТРОАВТОМАТИКА"' LIMIT 1),
  'заметка',
  'Сказал скиньте инфу посмотрим',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '1831090774' AND name = 'ООО "УВАДРЕВ-ХОЛДИНГ" 1831090774' LIMIT 1),
  'кп_отправлено',
  'Не отвечает пока что перезвонить кп направил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0278151411' AND name = 'ООО "ЭЛЕКТРОЩИТ-УФА"0278151411' LIMIT 1),
  'заметка',
  'не отвечает перезвонить/не отвечает не могу дозвонится пока что на обеде',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3848001367' AND name = 'ООО "РСК" 3848001367' LIMIT 1),
  'заметка',
  'не смог дозвониться, видимо все на обеде, чуть позже набрать но через добавочные на них можно выйти /недозвон',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7017409323' AND name = 'ООО "ГК АЛЬЯНС"7017409323' LIMIT 1),
  'заметка',
  'Сказал набрать в рабочее время перезвонить/Сказал направить на почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6685079144' AND name = 'ООО ПТК "ЭКРА-УРАЛ" 6685079144' LIMIT 1),
  'заметка',
  'Все слиняли уже на рпаздники набрать после  / пока что не отвечают почему то по добавочному',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7710620481' AND name = 'ООО "ТЕКСИС ГРУП"7710620481' LIMIT 1),
  'кп_отправлено',
  'Кп отправил на Дмитрия/ передам инфу дмитрию и на этом все закончилось мерзкий секретарь 10/07',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "УРАЛЭНЕРГОЦЕНТР"' LIMIT 1),
  'заметка',
  'Сказал заявки есть и проекты тоже есть',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7704844420' AND name = 'ООО "РС"7704844420' LIMIT 1),
  'заметка',
  'Попробуем в русский свет пробиться',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6319171724' AND name = 'АО "ЭНЕРГОТЕХПРОЕКТ"6319171724' LIMIT 1),
  'заметка',
  'Юлия Азарова 2 ярда оборот',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5258109139' AND name = 'ООО "ТЭС НН"5258109139' LIMIT 1),
  'кп_отправлено',
  'Нет ответа мб уже на праздниках,кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5404223516' AND name = 'ООО ПО "РОСЭНЕРГОРЕСУРС"5404223516' LIMIT 1),
  'кп_отправлено',
  'сказал вышли кп посмотрю',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6672271281' AND name = 'ООО "ТЭМ" 6672271281' LIMIT 1),
  'кп_отправлено',
  'Сказала у них только с атестацией в Россетях но кп сказала направьте',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7802447318' AND name = 'ООО "ЭЛЕКТРОНМАШ ПРОМ" 7802447318' LIMIT 1),
  'заметка',
  'Перенабрать еще раз не соединилось с отделом закупок',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5834121869' AND name = '5834121869 ООО "ЭВЕТРА ИНЖИНИРИНГ"' LIMIT 1),
  'кп_отправлено',
  'Сказал закупаем переодически направляю кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5902126385' AND name = 'ООО "ЭНЕРГОТЕХСТРОЙ"5902126385' LIMIT 1),
  'кп_отправлено',
  'Тут надо выйти на отдел снабжения они этим занимаются, кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7825369360' AND name = 'АО "ПО ЭЛТЕХНИКА"7825369360' LIMIT 1),
  'заметка',
  'Тут надо выйти на снабжение не отвечали, попробовать дозвониться',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5190016541' AND name = '5190016541ООО "ТРАНСЭНЕРГО-СЕРВИС"' LIMIT 1),
  'заметка',
  '89210409085 Михаил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7448200380' AND name = '7448200380ООО "КВАНТУМ ЭНЕРГО"' LIMIT 1),
  'заметка',
  'Сказала присылайте посмотрим интерес есть',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5260342654' AND name = '5260342654ООО ТД "СПП"' LIMIT 1),
  'кп_отправлено',
  'Направил кп, недозвон',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '9102000126' AND name = '9102000126 ООО "СПЕЦЩИТКОМПЛЕКТ"' LIMIT 1),
  'заметка',
  'Задача пообшаться С катей? обшался с Сергеем, сказал закупают трансформаторы',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7728679260' AND name = '7728679260 ООО "ПЕТРОИНЖИНИРИНГ"' LIMIT 1),
  'кп_отправлено',
  'Каталог отправил кп тоде дозвниться тут не смог',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6311115968' AND name = '6311115968 ООО "ТСК ВОЛГАЭНЕРГОПРОМ"' LIMIT 1),
  'кп_отправлено',
  'Будет на след неделе а так у них запросы есть, кп отправил в догонку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6672180274' AND name = '6672180274 ООО "МОДУЛЬ"' LIMIT 1),
  'кп_отправлено',
  'Кп отпрапвил сотрудник на совещании перезвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3664123615' AND name = '3664123615 ООО "ВЭЗ"' LIMIT 1),
  'кп_отправлено',
  'До снабжения не дозвонился на обеде, ставлю перезвон, кп в догонку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2126001172' AND name = '2126001172 ООО НПП "ЭКРА"' LIMIT 1),
  'кп_отправлено',
  'Обед, перезвонить, кп в догонку/ набрать в 3 по екб обед у них',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7733634963' AND name = '7733634963 ЗАО "СТРОЙЭНЕРГОКОМПЛЕКТ"' LIMIT 1),
  'кп_отправлено',
  'Перенабрать предложить сотрудничесво секретарь не втухает/перенабрал кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7813192076' AND name = '7813192076 ООО "АТЭКС-ЭЛЕКТРО"' LIMIT 1),
  'заметка',
  'Татьяна закупщик сказала проекты бывают перешлет проектому отделу',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7710957615' AND name = '7710957615 ООО "ПРОМСТРОЙ"' LIMIT 1),
  'кп_отправлено',
  'Направил кп не дозвонился',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5404464448' AND name = '5404464448ООО "НТК"' LIMIT 1),
  'кп_отправлено',
  'Не отвечабт скорее всего на обеде отправляю кп на отдел закупок',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7702080289' AND name = '7702080289 АО "СИЛОВЫЕ МАШИНЫ"' LIMIT 1),
  'письмо',
  'Для Марии направил письмо',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5914007456' AND name = '5914007456 ООО "ПРОМЫШЛЕННАЯ ГРУППА ПРОГРЕССИЯ"' LIMIT 1),
  'кп_отправлено',
  'Закупают кп отправил для них, но нужно узнат имя человека который акупает трансы',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '4205152361' AND name = '4205152361 ООО "ЗЭМ"' LIMIT 1),
  'заметка',
  'Не отвечабт мб на обеде перезвонить с утра',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6731035472' AND name = '6731035472 ООО "ТД "АВТОМАТИКА"' LIMIT 1),
  'кп_отправлено',
  'Кп направил ему сказал рассмотрит',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6670316434' AND name = '6670316434 ООО "ЭЗОИС-УРАЛ"' LIMIT 1),
  'кп_отправлено',
  'не дозвонился до него нало перещзвонить видимо не на месте/ дозвонился кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6150045308' AND name = '6150045308 ООО "АВИААГРЕГАТ-Н"' LIMIT 1),
  'заметка',
  'Закупабт тут технари а не отдел снабжения заявку сказал сейчас пришел',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5190044620' AND name = '5190044620 АО "ТЕХНОГРУПП"' LIMIT 1),
  'заметка',
  'тут не пробился пробовать еще',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7814461557' AND name = '7814461557 ООО "НТТ-ИК"' LIMIT 1),
  'кп_отправлено',
  'Закупают трансформаторы сами производят сухие, кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0571014706' AND name = '0571014706 ООО "СПЕЦСТРОЙМОНТАЖ"' LIMIT 1),
  'заметка',
  'Интересно ему ждем от него сообщение в вотсапе',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5029227275' AND name = '5029227275 ООО "ЭТК"' LIMIT 1),
  'заметка',
  'Списались в вотсапе',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2130100264' AND name = '2130100264ООО "НИП"' LIMIT 1),
  'кп_отправлено',
  'Кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7701389420' AND name = '7701389420 ООО "АТЕРГО"' LIMIT 1),
  'заметка',
  'Перезвонить Юлии, уточнить акупают ли они трансы представиться как ХЭНГ она закупщица/ Ответил тип какой то выйти на Юоию надо',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7736606442' AND name = '7736606442 ООО "ТЕХСТРОЙМОНТАЖ"' LIMIT 1),
  'кп_отправлено',
  'Закупают кп на почту отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6674353123' AND name = '6674353123 ООО "АЛЬЯНС РИТЭЙЛ"' LIMIT 1),
  'кп_отправлено',
  'Не отвечали направляю кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3810051697' AND name = '3810051697 ООО ЭНЕРГЕТИЧЕСКАЯ КОМПАНИЯ "РАДИАН"' LIMIT 1),
  'кп_отправлено',
  'Иркутск кп отправил с утра набрать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6671406440' AND name = '6671406440 ООО ИК "ЭНЕРГОСОФТ"' LIMIT 1),
  'кп_отправлено',
  'Кп отправил на него ждем запросы',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7820307592' AND name = '7820307592 ООО "ЭНЕРГОСТАР"' LIMIT 1),
  'кп_отправлено',
  'Направил кп секретарь сложный',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5404396621' AND name = '5404396621 ООО НПП "МИКРОПРОЦЕССОРНЫЕ ТЕХНОЛОГИИ"' LIMIT 1),
  'кп_отправлено',
  'Кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5903148303' AND name = '5903148303 ООО "БЛЮМХЕН"' LIMIT 1),
  'кп_отправлено',
  'кп отправил по номерам не дозвониться',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '1657048240' AND name = '1657048240 ООО "УК "КЭР-ХОЛДИНГ"' LIMIT 1),
  'кп_отправлено',
  'Кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0277071467' AND name = '0277071467 ООО "БАШКИРЭНЕРГО"' LIMIT 1),
  'заметка',
  'Пробуем пробиться в башкирэнерго',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3446034468' AND name = '3446034468ООО "ЭНЕРГИЯ ЮГА"' LIMIT 1),
  'кп_отправлено',
  'кп отправил на линии занято',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7451227920' AND name = '7451227920ООО "ЭЛЕКТРОСТРОЙ"' LIMIT 1),
  'кп_отправлено',
  'не отвечабт кп направил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0268027020' AND name = '0268027020ООО "ЭНЕРГОПРОМСЕРВИС"' LIMIT 1),
  'кп_отправлено',
  'кп направил не отвечают',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6166107912' AND name = '6166107912 ООО "РОСТЕХЭНЕРГО"' LIMIT 1),
  'письмо',
  'Отправил ему письмо жду заявку, перенабрать ему тоже надо',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6686078707' AND name = '6686078707 ООО "ПЭМ"' LIMIT 1),
  'заметка',
  'Мы с ним на вотсапе попросил инфу',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2116491707' AND name = '2116491707 ООО "ИЗВА"' LIMIT 1),
  'кп_отправлено',
  'КП направил она не отвечает перезвонить ей',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2502047535' AND name = '2502047535 ООО "ВОСТОКЭНЕРГО"' LIMIT 1),
  'кп_отправлено',
  'Отправил кп не дозвонился',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5260401638' AND name = '5260401638 ООО "КРЭС"' LIMIT 1),
  'заметка',
  'сказали обед перезвонить отдел снабжения',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7453260063' AND name = '7453260063 ООО "СТРОЙЭНЕРГОРЕСУРС"' LIMIT 1),
  'заметка',
  'Антон, главный инженер сказал направбте на мое имя, нужно еще в отдел закупок доб 1',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2635244268' AND name = 'Ставропольэлектросеть' LIMIT 1),
  'заметка',
  'Будут кидать нам запросы для выход на торги',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7817302964' AND name = '7817302964 https://izhek.ru/' LIMIT 1),
  'заметка',
  'Связь с закупчиком хорошая',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Евросибэнерго' LIMIT 1),
  'заметка',
  'Поговорил со стасом. Надо регаться на сайте https://td.enplus.ru/ru/zakupki-tovarov/ Можно работать. У нас общие китайцы. Второй звонок',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО ХК "СДС - ЭНЕРГО"' LIMIT 1),
  'заметка',
  'Готовы брать из наличия. По торгам у них выступает другое юр лицо. Торговый дом sds treid. искать на госзакупках',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "ОБЪЕДИНЕННЫЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ"' LIMIT 1),
  'заметка',
  'начальник снажения. контакт хороший.жду обратную связь',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6319231042' AND name = 'ООО "САМЭСК" 6319231042' LIMIT 1),
  'заметка',
  'работают только через торги. смотреть гос.закупки',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "КРАСЭКО"' LIMIT 1),
  'кп_отправлено',
  'Поговорил с закупщиком КТП. Женщина. Говорит что закупают напрямую. Просит давать самое выгодное предложение сразу, время торговаться нету. газпром росселторг',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Энергонефть Томск http://energoneft-tomsk.ru/index.php?id=13' LIMIT 1),
  'заметка',
  'Не могу дозвониться. надо пробовать.21.05.25. Дозвонился до отдела закупок. Торгуются на площадке газпрома.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6320005633' AND name = 'ЗАО "ЭИСС" 6320005633' LIMIT 1),
  'заметка',
  'Берут БКТП и трансформаторы. Связаться после среды.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "Варьегоэнергонефть" https://oaoven.ru/kont.html' LIMIT 1),
  'заметка',
  'Связался с начальником ПТО. Тендерная система. Закрытые закупки. Китайцы интересны. По техническим моментам (40140)/ 29.08.2025 заявок нет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "Пензенская горэлектросеть' LIMIT 1),
  'звонок',
  'Павел не решает. До александра не дозвонился. 5 августа 2025 - заявок нет// 25 августа 2025 года - заявок нет// 17 сентября - заявок нет//',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "ОРЭС-ПРИКАМЬЯ"' LIMIT 1),
  'заметка',
  '26.03.2026. заявок нет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'https://eskchel.ru/ ТМК Энерго' LIMIT 1),
  'заметка',
  'Заинтересовал снабженца Китаем. Попросил скинуть ему на почту инфу о нас. Говорит, что будет закупка - будет и пища)',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7107064602' AND name = 'ООО "ПРОМЭНЕРГОСБЫТ" 7107064602' LIMIT 1),
  'заметка',
  'не дохвонился, а надо',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ПКГУП "КЭС"' LIMIT 1),
  'заметка',
  'Выбил комер закупщика. Поговорил. Отправят запрос на КТП',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Акционерное общество «Витимэнерго»' LIMIT 1),
  'заметка',
  'Набрал в общий отдел. Дали этот номер. Сегодня там   выходной. Набрать завтра. Спросить снабжение',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0901048801' AND name = 'Черкессие городские сети 0901048801' LIMIT 1),
  'заметка',
  'Связался с секретарем. Дали комер отдела закупок. Не взяли. Пробовать еще раз.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Щекинская ГОРОДСКАЯ ЭЛЕКТРОСЕТЬ' LIMIT 1),
  'заметка',
  'Поговорил с закупщиком. Женщина в возрасте. Работают под росстеями под торги. Торги проходят на площадке РАД. Будут торги на трансформаторы 250,400,630 после майских',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '1658191691' AND name = 'ООО "ИНТЕГРАЦИЯ" 1658191691' LIMIT 1),
  'заметка',
  'Познакомился с закупщиком. Нашего профиля маловато, но будут скидывать запросы, потому что хорошо поговорили.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5256133344' AND name = 'ООО "НЭСК" 5256133344' LIMIT 1),
  'звонок',
  'Не дозвонился до инженера. Пробовать еще. в этом году не будет закупок. звонок юыд 14 -7 2025',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7024035693' AND name = 'ООО "Электросети" 7024035693' LIMIT 1),
  'кп_отправлено',
  'Кое-как нашел номер приемной но не дозвонился.11 сенября 2025 вытащил номер главного инженера. было занято/// 18.09.2025. поговорил с инженером. закупки проходят по 223 фз. прямых нет. попросил кп.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3443139342' AND name = 'ООО "ВЭС-СНТ" 3443139342' LIMIT 1),
  'заметка',
  'Работают через торги. Наш профиль. Площадка: ЭТП ГПБ.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭУ"' LIMIT 1),
  'заметка',
  'Берут только измерительные трансы нтми.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2702032110' AND name = 'АО "ХГЭС" 2702032110' LIMIT 1),
  'кп_отправлено',
  'Пообщался с закупщицей. Очень хорошо поговорили. Есть и прямые закупки до 1.5 млн. Берут и трансы и ктп. РТС тендер. скоро закупка. Отправил КП',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'МУП "Электросервис"' LIMIT 1),
  'заметка',
  '21.05.2025. Дозовнился до отдела закупок. торгуются на площадке ТЕГТОРГ. Прямых на подстанции и трансы не бывает.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2531006580' AND name = 'АО "ДВ РСК" 2531006580' LIMIT 1),
  'заметка',
  'Пообщался со старым) Нормальный перец. будут брать,думаю/ 29.08.2025 не берет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '4909095293' AND name = 'АО "УСТЬ-СРЕДНЕКАНСКАЯ ГЭС ИМ. А.Ф. ДЬЯКОВА" 4909095293' LIMIT 1),
  'звонок',
  'Поговорил с секретарем. Снабженцы сидят на Колымской ГЭС. Дала номер, но там пищат что-то. пробовать позже/29.08.2025. Не дозвон.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2511121619' AND name = 'АО "УССУРИЙСК-ЭЛЕКТРОСЕТЬ" 2511121619' LIMIT 1),
  'звонок',
  'Узнал номер снабжения безхитростным путем. Но там сука не берут. Пытаться еще/29.08.2025. Не дозвон.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2510003066' AND name = 'АО "СЭС" 2510003066' LIMIT 1),
  'звонок',
  'Поговорил с закупщиком. Он сказал, что больших закупок пока не будет, но будут разовые. Китай интересен. 29.08.2025. Не дозвон.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '4101090167' AND name = 'АО "КЭС" 4101090167' LIMIT 1),
  'заметка',
  'Поговорил с девочкой. Пока заказов нет, но просит отправить инфу. Контакт хороший',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "ТЕХЦЕНТР"' LIMIT 1),
  'заметка',
  'Руслан хороший парень. Сразу скентовались с ним) Уже есть заказ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2724182990' AND name = 'ООО "ТД "ЭЛЕКТРОСИСТЕМЫ" 2724182990' LIMIT 1),
  'кп_отправлено',
  'Поговорил с закупщицей. Рассмотрят наше предложение//29.08.2025  Сказала не занимаются трансами. пиздит возможно',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2901295280' AND name = 'ООО "АСК" 2901295280' LIMIT 1),
  'заметка',
  'Поговорили с Игорем. Интересно ему. Скинет заявку.Поговорил с игорем 14 07 25. не получил заявку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2465302760' AND name = 'Енисей сеть сервис 2465302760' LIMIT 1),
  'кп_отправлено',
  'отправил кп на почту/ 29.08.2025 Секретарь ебет мозга',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '8603004190' AND name = 'Акционерное общество "Городские электрические сети" (АО "Горэлектросеть") 8603004190' LIMIT 1),
  'заметка',
  'Позвонил в отдел снабжения. Поговорил с парнем. Торгуются на РТС. Прямых нет.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7719609274' AND name = 'АО "СИНТЕЗ ГРУПП" 7719609274' LIMIT 1),
  'кп_отправлено',
  'Разговаривал с закупщиком. Строгий дядя) Но попросил КП.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ПКБ "РЭМ"' LIMIT 1),
  'кп_отправлено',
  'Поговори с начальником снабжения. Скинул КП',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7714426397' AND name = 'ООО "ЦЭК" 7714426397' LIMIT 1),
  'кп_отправлено',
  'Отправил снабженцу кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2124019520' AND name = 'ООО "ПРИЗМА" 2124019520' LIMIT 1),
  'кп_отправлено',
  'отправил кп на почту. звонил. 29.08.2025 сказал на пол года проекты расписаны. отравить кп. Набрать после майских 2026',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7017081040' AND name = 'ООО "ГОРСЕТИ" 7017081040' LIMIT 1),
  'заметка',
  'связался с закупками. работают через торги 223 фз. 29.08.2025 закупщица сказала, что не сказала бы что закупка проводится',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7017380970' AND name = 'ООО "Томские электрические сети" 7017380970' LIMIT 1),
  'заметка',
  'поговорил с секретарем. сказала пока не даст номер снабженца и имя не скажет. но ключевое слово пока))',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7017097931' AND name = '"СибБурЭнерго" 7017097931' LIMIT 1),
  'заметка',
  'не прошел секретаря. отдать алику на доработку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '1001012723' AND name = 'АО "КЭСР" 1001012723' LIMIT 1),
  'звонок',
  'не дозвон',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО "ТЭТ-РС"' LIMIT 1),
  'заметка',
  'снабженца нет на месте пока. перезвоню',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ЗАО "ТЭСА"' LIMIT 1),
  'заметка',
  'Поговорил со снбаженцем. Пока что мнется, но сказал набрать попозже. может, что появится. у секретаря сразу просить соеденить со снабжением.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5018187729' AND name = 'ООО "КЭС" 5018187729' LIMIT 1),
  'кп_отправлено',
  'отправил кп на почту.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2466250680' AND name = 'ООО "НОРДГРОН" 2466250680' LIMIT 1),
  'кп_отправлено',
  'Заинтересовались. отправил кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2466169359' AND name = 'ООО "ЭнергоИнжиниринг"' LIMIT 1),
  'кп_отправлено',
  'отправил кп.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2411027355' AND name = 'ООО ТСК "ЭНЕРГОАЛЬЯНС" 2411027355' LIMIT 1),
  'заметка',
  'поговорил со светланой. интерес по трансам. скинул цены на вотсапп. 8.04.2026 заявок нет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2460107451' AND name = 'ООО "Энергосибинжиниринг" 2460107451' LIMIT 1),
  'заметка',
  'поговорил с натальей. хочет россети. скинул инфу на вотсапп. но разговор хороший. будет отправлять заявки.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2721206795' AND name = 'ООО "ЭКРА-ВОСТОК" 2721206795' LIMIT 1),
  'письмо',
  'Контакт хороший, но не могу отправить письмо. надо норм почту.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5609088434' AND name = '"КЭС ОРЕНБУРЖЬЯ" 5609088434' LIMIT 1),
  'заметка',
  'поговорил со снабженцем. получил заявку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '4703005850' AND name = 'МП "ВПЭС" 4703005850' LIMIT 1),
  'заметка',
  'Рамочный договор на год. Поговорил с Дашей. Будут иметь нас ввиду.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5031095604' AND name = '"БОГОРОДСКАЯ ЭЛЕКТРОСЕТЬ" 5031095604' LIMIT 1),
  'заметка',
  'Не поговорил со снабжением. Перезвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '9725034250' AND name = 'ООО "СИСТЕМА" 9725034250' LIMIT 1),
  'кп_отправлено',
  'отправил кп на почту. звонил.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7727691900' AND name = 'ООО "ОЭС" 7727691900' LIMIT 1),
  'кп_отправлено',
  'Набрал. Спецы были заняты. отправил кп. связаться позже',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7415041790' AND name = 'ООО "МЭС" 7415041790' LIMIT 1),
  'заметка',
  'Поговорил С ЛПР. Китай не инетересен.только подстанции',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3906970638' AND name = '"ЗАПАДНАЯ ЭНЕРГЕТИЧЕСКАЯ КОМПАНИЯ" 3906970638' LIMIT 1),
  'заметка',
  'Поговорил с закупщицей.Попросила скинуть инфу. Будут в понедельник.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '4205153492' AND name = 'ОАО "СКЭК". 4205153492' LIMIT 1),
  'кп_отправлено',
  'Не дозвон. Отправил КП.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5005005770' AND name = '"ФАБИ" 5005005770' LIMIT 1),
  'заметка',
  'выбил номер снабжения. перезвонить через час',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5036101347' AND name = '"ИНТЕР РАО - ИНЖИНИРИНГ" 5036101347' LIMIT 1),
  'кп_отправлено',
  'НАРЫЛ НОМЕР ЗАКУПЩИКА. У НИХ ЕСТЬ ГКПЗ. СКАЗАЛ УЧАВСТОВАТЬ В ЗАКУПКАХ НА ОБЩИХ ОСНОВАНИЯХ. ПОКА ВЯЛО. НО НАДО ПРОБИВАТЬ. ОН БЫЛ ОЧЕНЬ УСТАВШИМ. ТОРГУЮТСЯ НА СОБСТВЕННОЙ ПЛОЩАДКЕ: https://interrao-zakupki.ru/purchases/',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0277077282' AND name = 'ООО "БГК" 0277077282' LIMIT 1),
  'письмо',
  'Отправил письмо на ген дира.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7743795832' AND name = 'ООО "МЕРИДИАН ЭНЕРГО" 7743795832' LIMIT 1),
  'заметка',
  'секретарь сука. не могу пробить.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7456038645' AND name = 'АО "ГОРЭЛЕКТРОСЕТЬ" 7456038645' LIMIT 1),
  'заметка',
  'торгуются на ртс тендере.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6660003489' AND name = 'АО "ЭЛЕКТРОУРАЛМОНТАЖ" 6660003489' LIMIT 1),
  'заметка',
  'перезвонить завтра. Дозвонился до закупок 5 июня. просят аттестацию россетей. берут 110 трансы и 220 чаще.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7743211928' AND name = '"СПЕЦЭНЕРГОГРУПП" 7743211928' LIMIT 1),
  'заметка',
  'Перезвонить завтра. Битва с закупщиком',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2801108200' AND name = 'АО "ДРСК" 2801108200' LIMIT 1),
  'звонок',
  'не дозвонился до закупок. Российский акционный дом торговая площадка. Интересны китайцы. Прямых нет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6324014124' AND name = 'АО "ПО КХ Г.О. ТОЛЬЯТТИ" 6324014124' LIMIT 1),
  'звонок',
  'не дозвонился',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6311049306' AND name = '"ТРАНСНЕФТЬЭЛЕКТРОСЕТЬСЕРВИС" 6311049306' LIMIT 1),
  'звонок',
  'не дозвонится',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6670018981' AND name = 'АО "РСК" 6670018981' LIMIT 1),
  'заметка',
  'Юрий Григорьевич сказал выходить на торги. Заказ РФ.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6670162424' AND name = 'ООО "ЭЛВЕСТ" 6670162424' LIMIT 1),
  'заметка',
  'дозвониться завтра',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6615010205' AND name = 'ООО "НТЭАЗ Электрик"6615010205 https://www.vsoyuz.com/ru/kontakty/sluzhba-zakupok.htm' LIMIT 1),
  'заметка',
  'снабженка в отпуске. набрать через неделю',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5835133183' AND name = '"АРТЭНЕРГОСТРОЙ" 5835133183' LIMIT 1),
  'заметка',
  'заинтересовались. с китаем работали. нужно представительсво. оно есть. ждем запрос. набрать после уточнения наших цен',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО «КУЗНЕЦК ЭЛЕКТРО»' LIMIT 1),
  'заметка',
  'поговорил с человеком. вроде интерес есть',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5948063201' AND name = '"РЕГИОНЭНЕРГОСЕТЬ"5948063201' LIMIT 1),
  'заметка',
  'снабжения нет на месте',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2801085955' AND name = 'АКЦИОНЕРНОЕ ОБЩЕСТВО "ГИДРОЭЛЕКТРОМОНТАЖ" 2801085955' LIMIT 1),
  'звонок',
  'не дозвонился',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5903047697' AND name = 'АО "УЭСК" 5903047697' LIMIT 1),
  'заметка',
  'перезвонить позже',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО “АвтоматикаСтройСервис”' LIMIT 1),
  'кп_отправлено',
  'Все предложения через руководителя. попросили направить кп на его имя. Попробовать связаться позже',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '1215214540' AND name = '"СК "ЭВЕРЕСТ" 1215214540' LIMIT 1),
  'заметка',
  'было занято. перезвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7448114740' AND name = 'ООО ПКП "ФИНСТРОЙИНВЕСТ" 7448114740' LIMIT 1),
  'заметка',
  'не прошел секретаря. пробовать позже',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5614001069' AND name = 'АО "ОЗЭМИ" 5614001069' LIMIT 1),
  'заметка',
  'перезвонить. на отгрузке.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Общество с ограниченной ответственностью «ЭнергоПрогресс»' LIMIT 1),
  'кп_отправлено',
  'Поговорил с директором. Пока проектов нет. но будут иметь нас в ввиду. отправил кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2724091687' AND name = 'ООО "ЭНЕРГО-ИМПУЛЬС +" 2724091687' LIMIT 1),
  'заметка',
  'Поговорил с Еленой. есть хороший контакт.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6315597656' AND name = 'ООО "ПК ЭЛЕКТРУМ" 6315597656' LIMIT 1),
  'заметка',
  'поговорил с ларисой. замотал ее. будет отправлять заявки',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7817035596' AND name = 'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ " НИИЭФА - ЭНЕРГО " 7817035596' LIMIT 1),
  'кп_отправлено',
  'Поговорил со снабженкой. была не в настроении. попросила кп. перезвонить завтра.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5036003332' AND name = 'АКЦИОНЕРНОЕ ОБЩЕСТВО "ПОДОЛЬСКИЙ ЗАВОД ЭЛЕКТРОМОНТАЖНЫХ ИЗДЕЛИЙ" 5036003332' LIMIT 1),
  'заметка',
  'поговорил. девушка в отпуске до 1 июля',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5249058696' AND name = '5249058696 АО "НИПОМ"' LIMIT 1),
  'звонок',
  'Не дозвонился до начальника. пробовать завтра',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '1659161058' AND name = 'ООО "ЭЛЕКТРООПТИМА" 1659161058' LIMIT 1),
  'кп_отправлено',
  'Поговорил с начальником снабжения. контакт хороший. скину кп на почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = '"ЗАВОД "СИБЭНЕРГОСИЛА"' LIMIT 1),
  'заметка',
  'не берут',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7726590962' AND name = '"ЭЛЕКТРОФФ-ИНЖИНИРИНГ" 7726590962' LIMIT 1),
  'заметка',
  'сказать в отдел закупок. в понедельник',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3702015155' AND name = '3702015155 "СПЕЦЭНЕРГО"' LIMIT 1),
  'кп_отправлено',
  'сказать в отдел закупок. поговорил. рассматривают предложение',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2115905070' AND name = 'ООО "ЗИТ" 2115905070' LIMIT 1),
  'заметка',
  'звонил 3.07. выбил номер снабжения. пока не получил обратную связь',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7817331267' AND name = 'ООО "ЭНЕРГОЭРА" 7817331267' LIMIT 1),
  'заметка',
  'перевели и сбросили. перезвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7811687676' AND name = 'ООО "НПП ЭЛТЕХНИКА" 7811687676' LIMIT 1),
  'кп_отправлено',
  'Никита Евгеньевич. Отправил кп. созвониться на след неделе',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7814104690' AND name = '"ЭЛЕКТРОНМАШ" 7814104690' LIMIT 1),
  'заметка',
  'Поговорил с закупщицей очень хорошо. Скинет заявку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7128014313' AND name = 'ООО "ПП ШЭЛА" 7128014313' LIMIT 1),
  'заметка',
  'все поставщики расписаны на год. была не в настроении. перезвонить через пару недель.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7722286859' AND name = '7722286859 ООО СК "БЕТТА"' LIMIT 1),
  'заметка',
  'снабженка не могла говорить. перезвонить днем.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3663146899' AND name = 'ООО "ЗАВОД ЭЛПРО" 3663146899' LIMIT 1),
  'заметка',
  'не было на месте спеца',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3663048933' AND name = 'ООО ПКФ "ЭЛЕКТРОЩИТ" 3663048933' LIMIT 1),
  'кп_отправлено',
  'ольга скинула трубку перезвонить. Поговорил со снабжением 15.07.2025. Скинул кп. Рассматривают предложение.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7716050936' AND name = 'ООО "ИНИЦИАТИВА" 7716050936' LIMIT 1),
  'кп_отправлено',
  'поговорил со снабженцем. отправил кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5262046636' AND name = 'ООО ФИРМА "ПРОМСВЕТ" 5262046636' LIMIT 1),
  'заметка',
  'Поговорил с коммерческим директором. интересно но говорит про нац режим.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '1658099230' AND name = 'ООО "КЭР-ИНЖИНИРИНГ" 1658099230' LIMIT 1),
  'кп_отправлено',
  'Поговорил с коллегой Айрата.Он сказал что посмотрит кп. перезвонить завтра',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5407222077' AND name = 'ООО "ЭЛЕКТРОПРОФИ" 5407222077' LIMIT 1),
  'кп_отправлено',
  'скинул кп на потчу',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3257028275' AND name = 'ООО "ЭЛЕКТРОСТРОЙ" 3257028275' LIMIT 1),
  'кп_отправлено',
  'отправил кп. пока не звонил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7604175817' AND name = 'ООО КОМПАНИЯ "ИНТЕГРАТОР" 7604175817' LIMIT 1),
  'кп_отправлено',
  'отправил кп на почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2130133291' AND name = '"ЭЛЕККОМ ЛОГИСТИК" 2130133291' LIMIT 1),
  'кп_отправлено',
  'отправил кп. закуп не ответили.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6234126190' AND name = 'ООО "РИМ-РУС". 6234126190' LIMIT 1),
  'заметка',
  'у них сидит менеджер, который отмсматривает заявки и связывается с поставщиками. будут иметь нас ввиду.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5404079654' AND name = 'ООО "ЭНЕРГОТРАНЗИТ" 5404079654' LIMIT 1),
  'заметка',
  'поговорил с ольгой. закупают только энергоэффективные трансформаторы. Площадка сбербанк АСТ. участие бесплатное. Условия договорные.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '8911033894' AND name = '8911033894 АКЦИОНЕРНОЕ ОБЩЕСТВО "ПУРОВСКИЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ"' LIMIT 1),
  'заметка',
  'Валера в отпуске до моего др. набрать позже',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2309132239' AND name = 'ООО "ЭНСИ" 2309132239' LIMIT 1),
  'звонок',
  'пока не дозвон. человека не было на месте.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6165199445' AND name = 'АКЦИОНЕРНОЕ ОБЩЕСТВО "ТЕПЛОКОММУНЭНЕРГО" 6165199445' LIMIT 1),
  'заметка',
  'звонил в коммерческий отдел. сказали будут скидывать заявки',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6311174120' AND name = 'ООО "ЭЛЕКТРОКОНТАКТ" 6311174120' LIMIT 1),
  'заметка',
  'поговорил со старым. хорошо пообщались. Потенциал',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6671408085' AND name = 'ООО "ЭТП" 6671408085' LIMIT 1),
  'звонок',
  'Не дозвонился до Игоря. скорее всего, добавочный 135 но не факт. пробовать еще. 18.09.2025. Поговорил с Игорем. Работают с Россетями. пробить не вышло.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3666089896' AND name = 'ЗАО "РЕКОНЭНЕРГО" 3666089896' LIMIT 1),
  'звонок',
  'не дозвонился',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5402462822' AND name = 'ООО "ЭНЕРГОКАПИТАЛ" 5402462822' LIMIT 1),
  'кп_отправлено',
  '16.09.2025 не дозвон. 17.09.2025 Познакомился с Татьяной. рассматривают кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6658394193' AND name = 'ООО "Импульс" 6658394193' LIMIT 1),
  'звонок',
  'не дозвон',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Самара ВЭМ' LIMIT 1),
  'заметка',
  'Работал с мужиком. он теперь там не работает. Отвечает Елена',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '4632061580' AND name = 'ООО "Электростроймонтаж" 4632061580' LIMIT 1),
  'кп_отправлено',
  'Не дозвон, КП отправил на почту. / 29.04.25 - через секретаря связь с артемом, попросил информационное, обещал завтра скинуть заявку / не доходят сообщения! / 14.05.25 секретарь дал 2 почты закупщика Артема, при звонке не был на месте / все равно письма не доходят! / 20.05.25 - дозванился до Артема, актуализировал его почту, заявок нет говорит /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = '«Липецкэлектро»' LIMIT 1),
  'кп_отправлено',
  'Вышел на закупщика Юрий, попросил инф письмо./ 23.04.25- магел звонил, повторное коммерческое/ 29.04.25 - Алик - запросы есть внес в базу поставщиков / 14.05.25 - Юрий говорит мало заказов, освежил КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '4028033363' AND name = 'ООО "КАСКАД-ЭНЕРГО" 4028033363' LIMIT 1),
  'кп_отправлено',
  'Отправил КП Герасимову / 28.04.25 - звонок Герасимову, не ответ, КП на почту / 14.05.25 -  нет на месте, ответила марина, наш товар интересен, попросила КП, сказала будут отправлять заказы / 15.05..25 - письмо не доставлено герасимову, надо с ним созваниться / 20.05.25 - Герасимов не ответ, все ссылаються нанего /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7104018870' AND name = '"ИНТЭКО"' LIMIT 1),
  'кп_отправлено',
  '15.04Отправил КП / 28.03.25-не дозвон / 21.05.25 - актуализировал номер, надо прозвонить /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7736273017' AND name = '"ФЕНИКС-ЭНЕРГИЯ" 7736273017' LIMIT 1),
  'звонок',
  '/20.03звонокРаботают с атестованными в россетях/ 28.04.25 - не дозвон. Серт нужен - Алик \',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7743910877' AND name = '"ЭМПИН"' LIMIT 1),
  'кп_отправлено',
  '/Тяжело идет на контакт, отправил кп /23.04.25 магел звнок- тяжело идет но пробиваем/Короче Артем его зовут но он ни разу не закупщик надо зайти с иторией чтобы перевели на закупщика!!!! - завтра на брать- Алик 29.04 c Артемом бесполезно говорить он вафля! / 21.05.25 - артем запросил КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7810241335' AND name = 'АО "ЭМС"' LIMIT 1),
  'кп_отправлено',
  'Отправил КП / 23.04.25-не ответ /28.04.25 - ответил вредный секритарь, попросил информационное письмо / 29.04 не дозвон - алик',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ЗАО "КАПЭ" 6911004716' LIMIT 1),
  'кп_отправлено',
  'Отправил КП / 28.04.25 - не ответ, повторное КП / не дозвон - алик 29.04',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "АСМ" 3250519725' LIMIT 1),
  'кп_отправлено',
  'Отправил кп / 28.04.25 - не ответ, повторное КП на почту / номер не досутпен 29.04 алик',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7720748931' AND name = 'ООО "ИК СИТИЭНЕРГО" 7720748931' LIMIT 1),
  'кп_отправлено',
  'Отправил кп / 28.04.25 - секретарь попросил инф письмо на снабжение / сказали отдел снабжения свяжется, если нет придумать историю с курьером',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7720674630' AND name = 'ООО "КАТЭН" 7720674630' LIMIT 1),
  'кп_отправлено',
  'Отправил кп / 28.04.25 - не ответ, повторное КП / 14.05.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7804339445' AND name = 'ООО "ПЕТЕРБУРГ-ЭЛЕКТРО" 7804339445' LIMIT 1),
  'кп_отправлено',
  'Отправил КП / 28.04.25 - не ответ, КП повторно на почту / 14.05.25 - не ответ / 15.04.25 - не ответ / 20.05.25 - не ответ /Секретярь соединяет но номер не ответил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7814677411' AND name = 'ООО "ПЭС" 7814677411' LIMIT 1),
  'кп_отправлено',
  'Отправил КП / 29.04.25 - не интересно работают на довальчиском сырье ( Алик это пиздабольский отмаз?)  / 20.05.25 - Секретарь попросила КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5256149506' AND name = 'ООО "РУСЭЛ" 5256149506' LIMIT 1),
  'звонок',
  'Не дозвон/ не дозвон-20.03.25 / 14.05.25 - не дозвон /15.05.25 - не отвечают / 20.05.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3663049140' AND name = 'ООО "ЦЕНТРЭЛЕКТРОМОНТАЖ" 3663049140' LIMIT 1),
  'кп_отправлено',
  'Отправил кп / 14.05.25 - попросили КП на почту / 15.05.25. - закупщицу зовут Дарья, сказала подстанции производят сами, трансформаторы интересны / 20.05.25 - секретарь соеденял с дарьей, ответила Татьяна, заявок нет, попросила КП на почту / ИСПОЛЬЗУЮТ РЕДКО ТРАНСЫ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2128010302' AND name = 'ООО "Эйч Энерджи Трейд" 2128010302' LIMIT 1),
  'кп_отправлено',
  'Отправил КП/ тут секретарь сложный надо какие то данные предоставить лиретора пробить по инн, вытаскивать номер закупщика / 20.05.25- секретарь запросил письмо КП, перезвонить 23.05.25 / 11,08,25-секретарь говорит отправь кп если интересно то свяжуться',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7708783560' AND name = 'ООО "ЭЛЕКТРОГАРАНТ"' LIMIT 1),
  'заметка',
  'Рам есть контакт. Максим +7-963-154-62-84 (надо доработать )  / 14.05.25 - не ответ / 15.05.25- -Он сказал только атестованные в россетях поставляем /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭНЕРГО-ДОН"' LIMIT 1),
  'кп_отправлено',
  'Профильная компания/ 01.04 звонок, отправилКП / 29.04.25 - секретарь пытался соединь с отделом закупок, никто не ответил, попросила перезвонить после празников / 14.05.25 - наш товар редкий, Ольга закупщик запросила КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3906264262' AND name = 'ООО "ЭНЕРГОМИКС" 3906264262' LIMIT 1),
  'кп_отправлено',
  'Отправил КП / 15.05.25 - ответил секретарь, говорит не интересно, но еомпания профильная, возможно не правильно поняла /Короче тут сказали свяжутся серкетярь, попробую выйти на закупки - алик 22 мая',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7701112033' AND name = 'ООО "Энергоспецснаб" 7701112033' LIMIT 1),
  'кп_отправлено',
  'Отправил КП / 29.04.25 - не ответ / 15.05.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО «РСТ-ЭНЕРГО»' LIMIT 1),
  'кп_отправлено',
  'Вредный секретарь, отправил КП / 14.05.25 - не ответ, повторное КП /нет ответа алик 22 мая',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '1661009491' AND name = 'ООО ПРП "Татэнергоремонт" 1661009491' LIMIT 1),
  'кп_отправлено',
  'Отправил КП / 15.05.25 - ответил секритарь, закупают через площадку на сайте tatenergo.ru, нужно найти выход на закупщика /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО РЕНОВАЦИЯ' LIMIT 1),
  'кп_отправлено',
  'Отправил КП / 15.05.25 - говорит не пользуеться спросом наша продукция, пиздит на сайте другая инфа /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6215016322' AND name = 'Энергосервис 6215016322' LIMIT 1),
  'кп_отправлено',
  '/ 15.05.25 - Связался с Николаем на сотовый, попросил КП на почту / 20.05.25 - николай был не в настроение, разговор не пошел, не помнит о нас /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО «Техносервис»' LIMIT 1),
  'кп_отправлено',
  'Отправил КП / 15.05.25 - Секретарь попросил КП / 20.05.25 - позвонить 21.05.25  Юлии Юрьевне 8(812)612-12-02 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '4710028086' AND name = 'ООО "Завод БКТП" 4710028086' LIMIT 1),
  'заметка',
  'не актуальный номер',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7810216924' AND name = 'Минимакс 7810216924' LIMIT 1),
  'кп_отправлено',
  'Профильная компания, запросили КП. / 15.04.25 -  нужно искать закупщика /
22.05.2025 - не ответ, это интернет магазин /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2901089400' AND name = 'ООО "Энерком-строй" 2901089400' LIMIT 1),
  'кп_отправлено',
  'Занимаються строительством ЛЭП. отпрвил КП / 15.05.25 - секретарь говорит снабженцы отсутствуют на месте, поросила КП на почту / пробил секретаря, постоянно пиздит нет снабженце, снабженец ответил сказал не интерестно и бросил трубку /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3255054223' AND name = 'ООО Элстар' LIMIT 1),
  'кп_отправлено',
  'В основном низковольтное, высоковольтное редко, отправил КП.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5751200700' AND name = 'ООО Строй-Энерго 5751200700' LIMIT 1),
  'письмо',
  'Наши изделия используют редко, запросили информационное письмо.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7703663861' AND name = 'ООО "Резерв-Электро 21 век" 7703663861' LIMIT 1),
  'письмо',
  'Профильная компания запросили информационное письмо. / 15.05.25 - секретарь связал с закупщиком, просят реестр минпромторга, изделия интересны, надо общаться / 22.05.2025 - Григорий говорит нет заказов, залечил его, просит звоонить переодически /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2634076606' AND name = 'ООО СТКОМ 2634076606' LIMIT 1),
  'письмо',
  'Грубят, наш клиент, попросили информационное письмо.  / 15.05.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '1326183263' AND name = 'ООО НПЦ "Электропроект М" 1326183263' LIMIT 1),
  'письмо',
  'Берут наш товар мало, попросили информационное письмо.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7610080930' AND name = 'ООО ЭЛЕКТРО 7610080930' LIMIT 1),
  'письмо',
  'Запросили информационно письмо. / 15.05.25 - владимир не на месте/ 22.05.2025 - ответил Александр, у них торговая организация, говорят что внесли нас в список поставщиков, при звонке узнают Рамиля, заявок пока нет, долбить его не часто /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ТехМир" 1841084642' LIMIT 1),
  'кп_отправлено',
  '/Не дозвон, КПотправил на почту. / 02.06.2025 - Поросили КП на Сергея/',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭнергоТехСервис" 1840031750' LIMIT 1),
  'кп_отправлено',
  'Не дозвон, КПотправил на почту. / 02.06.25- не дозвон, /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0275038560' AND name = 'ООО "БЭСК Инжиниринг"' LIMIT 1),
  'письмо',
  '/Приняли письмо, секретарь оправила начальнику, просила связаться 16.06.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7720613010' AND name = 'АО "НПП ЭНЕРГИЯ".' LIMIT 1),
  'кп_отправлено',
  'не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7720097038' AND name = '"Объединенная Энергия"' LIMIT 1),
  'кп_отправлено',
  'Секретарь пытался соеденить с отделом закупок не вышло, отправил КП на почту / 22.05.2025 - серетарь не смогла соеденить с отделом закупок не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7714826109' AND name = 'ООО "СИСТЕМОТЕХНИКА"' LIMIT 1),
  'кп_отправлено',
  'Ответил секретарь, попросила КП для ознакомления. / 15.05.25 - секритарь прислал на почту что мы молодая компания и они нас боятьс, вопрос на контроле у Магела / 22.05.2025 - анна секретарь напиздела что не берут наш продукт /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5902131473' AND name = 'АО "ЭНЕРГОСЕРВИС"' LIMIT 1),
  'кп_отправлено',
  '/ не дозвон,КП на почту/',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6658491415' AND name = 'ЭнергоТренд' LIMIT 1),
  'кп_отправлено',
  '/ Профильная компания, секретарь запросил КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2130065323' AND name = 'ООО "ПРОГРЕССЭНЕРГО"' LIMIT 1),
  'кп_отправлено',
  '/ Профильная компания, секретарь запросил КП на почту / 22.05.2025 - ответил павел закуп, готовы расмотреть нашу продукцию под выйгранные торги, запросил КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3328492856' AND name = 'ООО "ЭНЕРГО ЦЕНТР"' LIMIT 1),
  'кп_отправлено',
  '/ Профильная компания, секретарь запросил КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'л' LIMIT 1),
  'кп_отправлено',
  '/ в основном низвольтное оборудование, наше редко берут, отправил КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5053025953' AND name = 'ООО "Энерго Пром Сервис"' LIMIT 1),
  'кп_отправлено',
  '/ секретарь запросил КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7810846884' AND name = 'АО "ЭНЕРГОСЕРВИСНАЯ КОМПАНИЯ ЛЕНЭНЕРГО"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7734362487' AND name = 'ООО "ЭНЕРГОКОМПЛЕКТ"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5260158510' AND name = 'ПКФ "МЕТЭК-ЭНЕРГО"' LIMIT 1),
  'кп_отправлено',
  '/ профильная компания, запросили КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5003037311' AND name = 'ООО "Энергопоставка"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5044089069' AND name = 'ООО "Энергосистемы"' LIMIT 1),
  'кп_отправлено',
  '/ секретарь поросил КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5024014330' AND name = 'АО "МНПО "ЭНЕРГОСПЕЦТЕХНИКА"' LIMIT 1),
  'кп_отправлено',
  '/ производители дизель станций, попросили КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '1840004147' AND name = 'ООО "ЭнергоСоюз"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7709153722' AND name = 'АО ПИК "ЭНЕРГОТРАСТ"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7813479840' AND name = 'ООО "ЭНЕРГО СТРОЙ"' LIMIT 1),
  'кп_отправлено',
  '/ секретарь связала с Александрой, она попросила КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3257025820' AND name = 'ООО "ЭНЕРГОКОМ"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ на основной КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7706596941' AND name = 'ООО "ТД "ЭнергоПромМаш"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ на основной КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2635095256' AND name = 'ООО "Энергостройуниверсал"' LIMIT 1),
  'кп_отправлено',
  '/ Альберт нач отдела снаб, попросил КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7702810351' AND name = 'ООО "Энергоиндустрия"' LIMIT 1),
  'кп_отправлено',
  '/  Попросили КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2104000577' AND name = 'ООО "Сельхозэнерго"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, отправил КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5012026637' AND name = 'ООО "БЭЛС-Энергосервис"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7810762585' AND name = 'ООО "МОНТАЖЭНЕРГОПРОФ"' LIMIT 1),
  'кп_отправлено',
  '/ Ксения секретарь - говорит нет заказов. Протолкнул ей КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7839427766' AND name = 'ООО "ЭНЕРГОАЛЬЯНС"' LIMIT 1),
  'кп_отправлено',
  '/ ответил Павел, попросил КП на расмотрение / 02.06.25 - не ответ/',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7717735629' AND name = 'ООО "Стандартэнерго"' LIMIT 1),
  'заметка',
  '/ Нужны бетонные КТП и атестация в россети /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7709843116' AND name = 'ООО "Альянс-Энерджи"' LIMIT 1),
  'кп_отправлено',
  '/ производят генераторы, запросили кп на тех отдел /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7725592815' AND name = 'АО "ЭНЕРГОПРОЕКТ-ИНЖИНИРИНГ"' LIMIT 1),
  'заметка',
  '/ Клиент Анара, держать на контроле /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '9102011960' AND name = 'ООО "ЭНЕРГОКОМПЛЕКТ КРЫМ"' LIMIT 1),
  'кп_отправлено',
  '/ Яна секретарь запросила КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '9705088145' AND name = 'ООО "ЭНЕРГОГРУПП"' LIMIT 1),
  'кп_отправлено',
  '/ профильная компания, запросили КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7810397798' AND name = 'ООО ТК "ЭНЕРГОКОМПЛЕКС"' LIMIT 1),
  'кп_отправлено',
  '/ кузнецов Андрей закупщик, отправил КП, его не было на месте /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7727155923' AND name = 'ООО "ПСК "Тепло Центр Строй"' LIMIT 1),
  'кп_отправлено',
  '/ секретарь запросил КП организация профильная /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7725346376' AND name = 'ООО "ЭНЕРГОТРЕСТ"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7702350129' AND name = 'ООО "Гарантэнерго"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2801246747' AND name = 'ООО Связь Энергострой' LIMIT 1),
  'кп_отправлено',
  '/ ответил Георгий, попросил КП на ватсап/',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5045019586' AND name = 'ООО "ССМНУ-58"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7842489681' AND name = 'ООО "НОРДГРИД"' LIMIT 1),
  'кп_отправлено',
  '/ответил секретарь, проф организация, запросила КП на Вадима /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3662287110' AND name = 'ООО "КНГ - ЭНЕРГО' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, КП на почту / 14.07.25 - закупщик грубит не заебывать часто /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2373002283' AND name = 'ООО "Центр Инжениринг"' LIMIT 1),
  'кп_отправлено',
  '/Через секретаря связался с менеджером Антоном, в ходе разговора он понял значемость и передаст КП директору, сказал директор свяжеться с нами/ 10.06.25 -  попросил позвонить 16.06.25 -14:00 / 16.06.25 - попросил набрать 23.06.25 / 25.06.25 - Антон попросил КП на ватсапп и пошол к диру на разговор / Просят атестацию в россети /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7722756818' AND name = '"ГРУППА КОМПАНИЙ ПРОФИТРЕЙД"' LIMIT 1),
  'кп_отправлено',
  '/ отправил КП не прошол секретаря / 22.07.25-секретарь говорит наше предложение не актуально /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭМКОМ" 7802335484' LIMIT 1),
  'заметка',
  '/ пока не требуеться / 22.07.25 - пока не требуеться / 11.08.25 - пока нет заказов, набрать 11.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0224011030' AND name = 'ООО "Завод "Энергетик"' LIMIT 1),
  'кп_отправлено',
  '/ секретарь попросила КП, и перезвонить 04.07.25 позвать виталия игоривича / 04.07.25.- Виталий говорит берут масло до 630ква, интерестно что когда будет у нас на складе, взял мой номер / 11.08.25 - Виталий не ответил / 08.09.25- запросили цены, набрать 15.09.25 / Виталий говорит интерестно на складе, ждать долго, разговор не о чем, набрать в конце сентября /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6950049622' AND name = 'АО "МЕРИНГ ИНЖИНИРИНГ' LIMIT 1),
  'whatsapp',
  '/ Вышел на нач закуп Лев, заинтересовал, взял личный номер, отправил инфу в ватсапп / 30.06.25 - Лев помнит про нас, сейчас нет заказов, ждет новые проекты / 10.07.25 - Лев помнит про нас, ждет заказы / 09.09.25 - написал ему в ватс ап сросил актуальные заказы / 16.04.26 - пока нет действующих проектов /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7422036304' AND name = '"Озёрский завод энергоустановок"' LIMIT 1),
  'кп_отправлено',
  '/ попросили КП на отдел снабжения для Екатерины / 03.07.25 - екатерина не получила наш КП, попросила повторно,  перезвонить 25.07.25  / 11.08.25 - заявок нет, перезвонить в начале сентября / ПИЗДИТ ЧТО НЕ ИСПОЛЬЗУЮТ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7704372086' AND name = 'ООО "ТД "ПРОМЫШЛЕННОЕ ОБОРУДОВАНИЕ"' LIMIT 1),
  'кп_отправлено',
  '/Секретарь передаст письмо генеральному директору/ 16.06.25 - не пробиваемый секретарь, просит КП / 25.06.25 - не дозвон / 30.06.25 - секретарь не помнит про нас, прислал на почту секретаря КП (дохлый номер) / 22.07.25 - не заинтересовало /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2312118185' AND name = 'ООО "АС-ЭНЕРГО"' LIMIT 1),
  'кп_отправлено',
  '/ не пробил, КП отправил / 02.07.25 - секретарь пыталась направить в отдел снабжения не ответ / 03.07.25 - Попал на николая, ему интерестно, дал свой сотовый. отправил инфу на ватсапп / 14.07.25 - цена дорогая на масло, про нас помнит, не задрачивать его /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0264080182' AND name = 'ООО НПП "220 Вольт"' LIMIT 1),
  'кп_отправлено',
  '/ отправил КП на ватсапп / 25.08..25 - Елена не ответ /  ответила Эльмира, Елена в отпуске до 15.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7722105693' AND name = 'ЗАО "ЭЛСИЭЛ"' LIMIT 1),
  'кп_отправлено',
  '/ попросили инф письмо и перезвонить / 10.07.25 - отдел закупок запросил повторно КП, по необходимости свяжуться сами / 25.08.25 - не нужно /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7743639382' AND name = 'ООО "Энергии Технологии"' LIMIT 1),
  'кп_отправлено',
  '/ Секретарь попросила инф письмо на гл инженера / 25.06.25 - Шитов расмотрел КП все понравилось попросилконтактные данные, говорит пока нет заказов, по необходимости свяжеться / 11.08.25 - Павел в отпуске до 25.08.25 / Павел говорит нет заказов, набрать в след году (мажеться урод) /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2310212721' AND name = 'ООО "СНАБЭНЕРГОРЕСУРС"' LIMIT 1),
  'заметка',
  '/ Переодически его задрочил/ добавил мой номер в ЧС /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7720679090' AND name = 'ООО "Энергопроф"' LIMIT 1),
  'кп_отправлено',
  '/Секретарь попросил КП и презвонить в 16:00 по мск Владимиру Анатольевичу / 25.06.25 - Состоялся диалог с Владимиром, заинтересован, будет присылать заказы / 14.07.25 - Владимир не на месте / 25.08.25 - не дозвон /  Владимир говорит пока нет заявок на трансы и ктп, основное это щитовое оборудование набрать 19.09.25  /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6679125667' AND name = 'ПКФ"ЭЛЕКТРОКОМПЛЕКС"' LIMIT 1),
  'кп_отправлено',
  '/ не представился но есть интерес, попросил КП с ценами/ 16.05.25 - о нас помнит, ждет заказы, напоминать о себе переодически / 14.07.25 - Андрей просит набрать 16.07 / 11.08.25 - скоро будет запрос / набрать 17.09.25 я затупил не правельно шашел /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7801703745' AND name = '"РЕСУРССПЕЦМОНАЖ"' LIMIT 1),
  'кп_отправлено',
  '/монтажная организация, попросил кп на личный номер ватсапп, перезвонить 27.06.25 / 30.06.25 - Игорь говорит не пока заказов, просил набрать 07.07.25 / 10.07.25 - игорь попросил перезвонить 11.07.25 в 17:00 / 14.07 - пока нет заказов, Игорю интерестно представительство в СПБ, думает в тчечении недели и должен набрать до 18.07.25 / 22.07.25 - не ответ / 11.08.25 - нет заинтересованости, не знает кому предложить /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7806202005' AND name = 'Завод производитель трансформаторных подстанций "МИН"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, КП на почту / 02.07.25 - попросили КП на почту и перезвонить 04.07.25 / 04.07.25 - не ответ / 14.07.25 - КП не получили отправил повторно (набрать 23.07) / 24.07.25- сказали не актуально /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7831000122' AND name = '"Мосэлектрощит"' LIMIT 1),
  'заметка',
  '/ отдел закупок не отвечает / 02.07.25 - не овет / 14.07 - не ответ / 09.09.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2623024116' AND name = 'ООО "МЭК"' LIMIT 1),
  'кп_отправлено',
  '/ отправил КП, не очень интерестно / 09.09.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6313132888' AND name = 'ООО "Электрощит"-ЭТС' LIMIT 1),
  'кп_отправлено',
  '/ закуп евгений, норм диалог, попросил КП / 14.07.25 - не дозвон / 22.07.25 - рынок стоит. пока не актуально. перезвонить 20.08.25 / 25.08.25 - заявок нет пока набрать в начале сентября / 09.09.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5405495093' AND name = 'ООО "Ринэко"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, КП на почту / 11.08.25 - запрос КП / 25.08.25 - секретарь не смог соединить с закупом, никто не ответил, попросила инф письмо на почту / 08.09.25 попросили инф письмо на закупки /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5101311690' AND name = 'ООО "КИМ"' LIMIT 1),
  'заметка',
  '/ интересны КТП, пока нет заказов / 08.09.25 - тока пришла с отпуска не заявок набрать после 20.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5038057975' AND name = 'ООО "Комплексные энергетические решения"' LIMIT 1),
  'кп_отправлено',
  '/ секретарь получил КП / 14.07.25 - компания монтажники, работы нет, просит прозванивать раз в месяц /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7707836184' AND name = 'ООО "ЭЛЭНЕРГО"' LIMIT 1),
  'кп_отправлено',
  '/ Запросил КП / 14.07.25 - Иван не получил КП, дал свой номер и КП на ватсапп / 11.08.25 - Иван не ответ / 08.09.25 - работают с россети, попросил инф письмо на почту, звонить на городской позвать нач закупок, набрать 11.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2129042924' AND name = 'ООО "ЧЭТА"' LIMIT 1),
  'кп_отправлено',
  '/ секретарь приняла КП, дала номер отдела закупок / 11.08.25 - Кравченко Игорь Александрович закуп, запросил КП на почту / 08.09.25 - нашли сами китайцев, пока думают, набрать после 20.09.25.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6672222750' AND name = 'Электрощит' LIMIT 1),
  'кп_отправлено',
  '/ не ответ, отправил КП на почту / 10.07.25 - Секретарь получила КП, перезвонить 15.07.25 / 24.07.25 - решение еще не принято, набрать 30.07.25 / 11.08.25 - не дозвон /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7716701049' AND name = '"СТРОЙЭНЕРГОСИСТЕМЫ"' LIMIT 1),
  'кп_отправлено',
  '/ Кирил, получил КП  / 11.08.25 -  не актуально /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3810310687' AND name = 'ООО ПО "Радиан"' LIMIT 1),
  'кп_отправлено',
  '/ Евгений Генадьевичь нач снаб, заинтересован, отправил КП / 14.07.25 - не дозвон ИРКУТСК! / Работает Анар / 16.09.25 -  набрать в конце сентября /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5404329400' AND name = 'ООО "ЭЛЕКТРОМАКС"' LIMIT 1),
  'кп_отправлено',
  '/ Ответил Павел он получил КП и просил перезвонить 15.07.25 / 15.07.25 - говорит рынок стоит, набрать 29.07.25 / 11.08.25 - пока нет заказов, звонить в сентябре / 01.09.25 - перезвонить 04.09.25 /  09.09.25 - пока нет заказов, набрать в конце сентября /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2312135208' AND name = 'ООО "МАКСИМУМ"' LIMIT 1),
  'заметка',
  '/ профильная компания, заказы с торгов будут присылать/ 14.07.25 - заинтересовал ивана нашими трансами, он в размышлениях, покажет руководству всю инфу  / 24.07.25 - говорит нет заказов набрать к концу августа / 11.08.25 - не ответ / 08.09.25 - Говорит помнит про нас лучше не названивать /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7825051584' AND name = 'ООО "ТСН"' LIMIT 1),
  'кп_отправлено',
  'Рам 04.03 - Профельная компания не получиось обойти секретаря. отправил КП надо прожимать / 14.05.25 - забыли про нас, попросили инф письмо / 20.05.25 -  Секретарь сново попросил КП / 24.07.25 - директор по снабжению в отпуске / 11.08.25 - секретарь не помнит о нас запросила КП, набрать 25.08.25 / 09.09.25 попросила инф письмо, не пробиваемы секритарь, звонить в конце сентября  /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0269044244' AND name = 'ООО ЕТекс' LIMIT 1),
  'заметка',
  '/ Эмиль заинтересовался, нужно добивать, набрать 28.07.25 / 11.08.25 - пока рынок стоит, о нас помнит, набрать 25.08.25 / 29.08.25 - Эмиль спросил цену 400ква тмг, сколький тип /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "БТ Энерго" 7811573630' LIMIT 1),
  'кп_отправлено',
  'Отправил, КП. Берут под торги, нужно прожимать / 09.09.25 - нет заказов /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7451263799' AND name = '(ООО "Челябинский завод "Подстанция") 7451263799' LIMIT 1),
  'whatsapp',
  '/ Отправил на ватсапп инфу, заказов нет / 09.09.25 - не ответ александр /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7718289053' AND name = 'ООО НПК "ТехноПром"' LIMIT 1),
  'кп_отправлено',
  'Василий попросил КП, и перезвонить 28.07.25 / 09.09.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '1840010380' AND name = 'ООО "Управляющая компания "Уралэнерго' LIMIT 1),
  'письмо',
  '/ Азат запросил инф письмо и перезвонить 24.07.25 / 24.07.25 - пока не интересно, набрать к коцу августа / 29.08.25 - спорили с азатом по цене, запросил прайс, след созвон 10-15 сентября / 09.09.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7722330113' AND name = 'ООО "Инженерный центр "Энергосервис"' LIMIT 1),
  'письмо',
  '/ Секретарь получила инф письмо / 09.09.25- не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7107550225' AND name = 'ООО "ИЦ ЭНЕРГЕТИКИ"' LIMIT 1),
  'письмо',
  '/ инф письмо на почту, проверить рассмотрение / 24.07.25 - если не связались значит нет надобности, набрать в середине августа / 29.08.25 - повторно инф письмо попросили и набрать 5 сентября / 09.09 25 - не помнят про нас, попросили повторное инф письмо /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5040148531' AND name = 'ООО ТПК "ЭНЕРГЕТИЧЕСКАЯ СИСТЕМА"' LIMIT 1),
  'кп_отправлено',
  '/ не ответ инф письмо на почту / 24.07.25 - попросили повторное КП, если интерестно свяжуться  /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7722621137' AND name = 'АО "ОВЛ-ЭНЕРГО"' LIMIT 1),
  'заметка',
  '/ трудные, инф на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7718914758' AND name = 'ООО "Группа Электроэнергетика"' LIMIT 1),
  'whatsapp',
  '/ Работают с россетями, поговорит с начальством набрать  24.07.25 / 24.07.25 - александр дал свой номер отправил ему инфу и видео на ватсапп, сказал обсудит с начальством и перезвонит / 24.07.25 - не заинтересованы, работают с россети /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО " ЛЕРОН " 7803010217' LIMIT 1),
  'заметка',
  'Ответил гореев рассул  инфу принял, интерестно, набрать 01.09.25 / 09.09.25 - Сергей занят, набрать 11.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭНЕРГО ЦЕНТР" 3328492856' LIMIT 1),
  'кп_отправлено',
  '/ запросили КП и набрать 15.08.25 / 08.09.25 - нет заказов /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7804382585' AND name = 'ООО РЭСЭНЕРГОСИСТЕМЫ' LIMIT 1),
  'кп_отправлено',
  '/ мария запросила КП на общую почту / 09.09.25 - закуп не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6658012599' AND name = 'ООО ВП "НТБЭ' LIMIT 1),
  'письмо',
  '/ ответил Александр, запросил инф письмо / 09.09.25 - пока нет потребности, 22.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ЭНЕРГОСТРОЙМОНТАЖ" 7203311501' LIMIT 1),
  'письмо',
  '/ Владиславу интерестно из наличия, заявки есть постоянно у них, запросил инф письмо, нужно доробатывать,   набрать 15.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '8901029539' AND name = 'ООО "ЭНЕРГОИНВЕСТ"' LIMIT 1),
  'письмо',
  '/ Секретарь запросила инф письмо, работают на довальческом, уточнить расмотрение 15.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7816600118' AND name = '"ЭНЕРГ-ОН"' LIMIT 1),
  'заметка',
  '/ 16.09.25 - наш товар редкий, основное это щитовое, запрос инф на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7802753273' AND name = 'ООО "НПО "ЛЕНЭНЕРГОМАШ" 7802753273' LIMIT 1),
  'письмо',
  '/30.09.25 инф письмо на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7415078430' AND name = 'ООО ЭТЗ "ИВАРУС"' LIMIT 1),
  'кп_отправлено',
  '/Алексей закупщик, заинтересован, попросил КП с ценами/ 16.06.25 - Александр Сухоруков, попросил КП, Алексей в опуске / 19.06.25 - прислапли на почту заявку на тсл 3150 / 26.06.25 - Яков мажеться, говорит некогда,прислал на почту запрос от СБ  / 01.07.25 - отправленные пояснения и бизнес карта / 09.07.25 - нет на месте / 14.07.25 - Яков просит позвонит 16.07.25 / 18.07.25 - Яков скинул заявку на сухие трансы, кп отправленно 21.07.25 / 22.07.25 - яков попросил цены на масло от 630 до 2500 ква в ознакомительных целях, задал эмми вопрос по доставке и диллерству / 11.08.25 - не дозвон / 30.09.25 - Яков просит набрать 08.10.25 обсудить конкретику /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5948025911' AND name = 'ЗАО "Энергомашкомплект"' LIMIT 1),
  'кп_отправлено',
  '/Вышел на закуп, отправил КП/ Пришла заявка на транс тока, запрос отправил ерболу/ 04.07.25 - не ответ / 11.08.25 - пока нет заказов /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6670227858' AND name = 'ООО "ЦРЗЭ"' LIMIT 1),
  'кп_отправлено',
  '/ Хороший заход, запросили КП на почту / 14.07.25- Сергей не на месте, набрать 15.07.25 / 22.07.25 - пока нет заказов, но интерестно, скинет на почту пример для просчета / 24.07.25 - отправил каталог / 11.08.25 - прислали опросник на тсл 2000 ответ на почту / 28.08.25 - в ответ на кп прислал запрос на 1250 сухой медь / 30.09.25 - пока нет запросов про нас помнит, сильно не задрачивать /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7706684490' AND name = 'ООО "Энергетический Стандарт"' LIMIT 1),
  'whatsapp',
  '/ не ответ инф на почту / 24.07.25 - Александру очень интерестно поставки из китая, дал свой номер и запросил инфу на ватсапп / 09.09.25 - занят на пергаворах / 16.09.25 - интересны от 110 кв, о нас ппомнит сильно не задрачивать, звонок начало октября /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5402543239' AND name = 'ООО "РиМтехэнерго"' LIMIT 1),
  'кп_отправлено',
  '/ Берут наш товар, Евгений попросил КП на почту / 02.06.25 - нет заявок, попросил набрать в конце месяца/  05.08.25.- евгений попросил инфу на ватс апп и обещал заявку / 30.09.25 - попросил почту, есть заказ на ктп /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7726384409' AND name = '"ЭНЕРГОПРОМ-АЛЬЯНС"' LIMIT 1),
  'кп_отправлено',
  '/ закуп Сергей, плотно поговорили про китай и энергоэфективность .КП отправил/ 19.06 - он не получил инфу про нас, отправил повторно, долго тележили за китай, он пытался навялить что херня / 30.06.25 - Сергей запросил больше информации о трансформаторах, расширенный протокол испытаний (вопрос ерболу) / 10.07.25 - расширенные испытания отправленны, сергей не отвечает на телефон / 14.07.25 - Сергей в отпуске до 25.07.25 / 11.08.25 - мозгоеб про то что трансы не соответствуют ГОСТ, просит набрать 14.08.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5032304480' AND name = 'ООО "НПО АР-ТЕХНОЛОГИИ"' LIMIT 1),
  'кп_отправлено',
  '/ Андрей нач снаб, заинтересован в трансах / 30.06.25 - КП на рассмотрении ТЕХ отдела, просил набрать 14.07.25 / 14.07.25 - Андрей говорит тех отдел пока не рассмотрел наше предложение, наберт сам, если долго не выйдет на связь прожать его / 11.08.25 - пока нет заказ, набрать 25.08.25 / 25.08.25 - Андрей запросил 1250 сухой /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6316213310' AND name = 'ООО "ПКФ "ТСК"' LIMIT 1),
  'звонок',
  '/ 16.09.25 - не дозвон инф на почту / 30.09.25 - Александр попросил инф на почту / 22.12.25 - прислал запрос на тмг 2500 и 630',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7719612213' AND name = 'ООО "ЭЛСНАБ" ИНН: 7719612213' LIMIT 1),
  'заметка',
  'Жду опросный лист БКТП. Свяжеться сам Вышел на ЛПР .',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5405498048' AND name = 'ООО "ПАРТНЕР ТТ" ИНН: 5405498048' LIMIT 1),
  'кп_отправлено',
  'Отправил после звонка КП на почту. Не прошел секретаря',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2309073209' AND name = 'ООО "КУБАНЬГАЗЭНЕРГОСЕРВИС" 2309073209' LIMIT 1),
  'кп_отправлено',
  'Отправил КП на почту . Не прошел секретаря',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7705975665' AND name = 'ООО "Коксохим-Электромонтаж" 7705975665' LIMIT 1),
  'заметка',
  'НЕ ЗАКУПАЮТ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО «Солар Системс»' LIMIT 1),
  'заметка',
  'Отправил на имя генерального директора ком перд на почту. Не прошел секретаря',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Инжиниринговая Компания ТЭЛПРО' LIMIT 1),
  'заметка',
  'Отрпавил информацию в whats app. Сказал вышлет пару опросных на подстанции.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'SciTex Group' LIMIT 1),
  'кп_отправлено',
  'Продукция интересует. Отправил на почту коммерческое предложение.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'МУП ЖМЛКОМСЕРВИС' LIMIT 1),
  'заметка',
  'Потенциально могут закупать трансформаторы.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "СибЭлектроМонтаж"' LIMIT 1),
  'заметка',
  'Знают про СВЕРДЛОВЭЛЕКТРОЩИТ. Потербности нет.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО «Кайрос Инжиниринг»' LIMIT 1),
  'заметка',
  'Отправил информацию в отдел снабжения через секретаря. Возможно заинтересуются',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ГК "НЗО"' LIMIT 1),
  'заметка',
  'Перезвонить, потенциально могут закупать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО «СИРИУС-МК»' LIMIT 1),
  'whatsapp',
  'Потенциальный клиент, вышел на личный контакт whatsapp, обратится при потребности',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО НПП «Элекор»' LIMIT 1),
  'кп_отправлено',
  'Есть интерес в закупке НОВЫХ трансформаторов. Покупают у энетры и в брянске. ОТПРАВИТЬ КП на почту.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ооо пкф спектор' LIMIT 1),
  'заметка',
  'Дозвонится',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7802536127' AND name = 'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ' LIMIT 1),
  'заметка',
  'Дальний восток, связаться , потеницально могут закупать. Не ответил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Крия Инжиниринг' LIMIT 1),
  'заметка',
  'Отправил информацию на почту, переодически есть потребность , можем сработать в будущем.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Общество с ограниченной ответственностью "Самур"' LIMIT 1),
  'кп_отправлено',
  'Не довзонился. Отправил предложение на почту в отдел закупок.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Акционерное общество "Дальневосточная электротехническая компания"' LIMIT 1),
  'заметка',
  'Написал на почту. Позвонить. Дальний восток.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО НСК' LIMIT 1),
  'кп_отправлено',
  'Заполнил форму обратной связи. Выслал КП. Можно позвонить днем.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО МНПП «АНТРАКС»' LIMIT 1),
  'заметка',
  'Отправил форму обратной связи . Можно позвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО РУСТРЕЙДКОМ' LIMIT 1),
  'кп_отправлено',
  'Непрофильно, но участвуют в торгах. Отправил КП. Можно позвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО «Сибтэк»' LIMIT 1),
  'заметка',
  'Направил информацию на почту. Телефон не доступен.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО Дюртюлинские ЭиТС' LIMIT 1),
  'кп_отправлено',
  'ЗВОНИЛ, СКАЗАЛИ ВСЕ ТОЛЬКО ЧЕРЕЗ ТОРГИ. ОТПРАВИЛ КП НА ПОЧТУ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Группа компаний «РИНАКО»' LIMIT 1),
  'кп_отправлено',
  'Отправил КП на почту. Не прошел секретаря.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО «Энергоремонт»' LIMIT 1),
  'заметка',
  'Закупают только через тендерные площадки. Можно попробовать пробится к ЛПР.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "СТАРТ"' LIMIT 1),
  'заметка',
  'Закупают трансформаторы. Хорошо разбирается в рынке, представился как диллер уральского силового',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ТЭХ"' LIMIT 1),
  'заметка',
  'Закупают трансформаторы. На лпр не вышел, но добавили в список поставщиков.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ТРИНИТАС"' LIMIT 1),
  'заметка',
  'не закупают',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6623071272' AND name = 'ООО "ПТМ" ИНН 6623071272' LIMIT 1),
  'заметка',
  'Строительно-монтажные работы, потенциально сильный клиент. Не ответил.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6623051325' AND name = 'ООО "ПРОИЗВОДСТВЕННО-СТРОИТЕЛЬНАЯ КОМПАНИЯ "ТАГИЛЭНЕРГОКОМПЛЕКТ" ИНН 6623051325' LIMIT 1),
  'заметка',
  'Используют давальческий материал.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0257009703' AND name = '"ЭЛЕКТРИЧЕСКИЕ СЕТИ" 0257009703' LIMIT 1),
  'заметка',
  'Закупают через B2B',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'Энергопрайм' LIMIT 1),
  'кп_отправлено',
  'Закупают трансы. Можно пробивать. Отправил КП УСТ на почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "Энерготранзит"' LIMIT 1),
  'кп_отправлено',
  'Не дозвонился. Сетевая компания. Проводят торги. Скинул КП на почту от УралСилТранс',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО СКАТ ИНН 254 314 48 34' LIMIT 1),
  'заметка',
  'Созвонился. Есть дейсвтующий партнер - завод. Новых не рассматривает. Возможно пробить в будущем',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2312271472' AND name = 'ООО КЕДР 2312271472' LIMIT 1),
  'заметка',
  'Аварийная служба. Есть форма для поставщиков. Заполнил, отправил. Можно позвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6449032030' AND name = 'ООО "ФАЗА" ИНН 6449032030' LIMIT 1),
  'заметка',
  'Номера не доступны',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2631041620' AND name = 'ООО "КАВКАЗТРАНСМОНТАЖ" ИНН 2631041620' LIMIT 1),
  'whatsapp',
  'Отправил информацию по уралсилтранс в ватсапп. Пока нет ответа',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2632107016' AND name = 'ООО "ЭНЕРГОПРОМ-МОНТАЖ" 2632107016' LIMIT 1),
  'заметка',
  'не закупают',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2312278950' AND name = 'ООО "ЮГ-ТРАНСЭНЕРГО" ИНН 2312278950' LIMIT 1),
  'заметка',
  'Набрать !',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2302053490' AND name = 'ООО "ЛИТВЕС" 2302053490' LIMIT 1),
  'кп_отправлено',
  'Отправил КП на почту. Завтра набрать или в ватсапп написать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7105034112' AND name = 'ООО "ГЕОЗЕМКАДАСТР " 7105034112' LIMIT 1),
  'заметка',
  'Выполняют кадастровые работы. Вряд ли связаны с оборудованием, но можно пробовать.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3661054875' AND name = 'ООО "РСО-ЭНЕРГО" 3661054875' LIMIT 1),
  'заметка',
  'Не пробил серетаря.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '3663143778' AND name = 'ООО "ЭНЕРГОИНЖИНИРИНГ" 3663143778' LIMIT 1),
  'кп_отправлено',
  'Отправил КП на почту, набрать. Сотрудничают через почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ИВЭНЕРГОРЕМОНТ"' LIMIT 1),
  'кп_отправлено',
  'Отправил КП на почту. Занимаются ремонтом, могут купить теоритически. Написать в ватсапп, набрать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "ТПК ДВ ЭНЕРГОСЕРВИС"' LIMIT 1),
  'кп_отправлено',
  'Направил КП на почту. Заполнил форму обратной связи. Можно прозвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'БЕЛЭНЕРГОПРОМ' LIMIT 1),
  'кп_отправлено',
  'Направил кп на почту. можно набрать. собирают ктп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО ИНЭСК' LIMIT 1),
  'кп_отправлено',
  'Направил КП на почту. Собирают подстанции. Можно набрать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО ТК ЭНЕРГООБОРУДОВАНИЕ' LIMIT 1),
  'кп_отправлено',
  'Направил кп на почту. Торговая компания. Обязательно набрать.  Диллеры завода СЗТТ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО АРКТИК ЭНЕРГОСТРОЙ' LIMIT 1),
  'кп_отправлено',
  'Направил КП. Занимаются монтажом энергообъектов',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'АО ИНЖЕНЕРНО-ТЕХНИЧЕСКИЙ ЦЕНТР НИИ ЭЛЕКТРОМАШИНОСТРОЕНИЯ' LIMIT 1),
  'кп_отправлено',
  'Созвонился. Закупают. Целевой. Отправил КП  Совзонится в  среду.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0268052524' AND name = 'ООО "ХИМРЕМОНТ" 0268052524' LIMIT 1),
  'кп_отправлено',
  'НАПРАВИЛ КП В ВАТСАПП И ПОЧТУ. ЖДУ ОБРАТКУ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '0326577315' AND name = 'ООО РНК КЭПИТАЛ 0326577315' LIMIT 1),
  'заметка',
  'НАПРАВИЛ НА ПОЧТУ. мЕЛКАЯ КОМПАНИЯ НО УЧАСТВУЕТ В ТОРГАХ.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '780513013333' AND name = 'ИП Тарасова Екатерина Анатольевна 780513013333' LIMIT 1),
  'кп_отправлено',
  'Направил на почту коммерческое предложение. Телефона нет.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО "Инфинити Инвест Групп"' LIMIT 1),
  'заметка',
  'Очень редко берут трансформаторы. Можно периодически выходить на связь.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7704703740' AND name = 'ООО СТРОЙПРОЕКТ 7704703740' LIMIT 1),
  'кп_отправлено',
  'Созвонился, закупают. Передаст КП менеджерам. Отправляю СЭЩ. Можно позже Уралсилтранс',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7717582411' AND name = 'ООО "КОНТРАКТ КОМПЛЕКТ 21" 7717582411' LIMIT 1),
  'кп_отправлено',
  'Набрал. Пока заявок, но закупают, можно сотрудничать. Отправил КП на почту. Переодически набирать. СЭЩ отправил, потом пробью СилТрансом',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6670292367' AND name = 'ООО "ЭТС" 6670292367' LIMIT 1),
  'заметка',
  'Аварийная служба. Есть форма для поставщиков. Заполнил, отправил. Можно позвонить. Отправил от СИЛТРАНСА',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '4345509318' AND name = 'ООО ТД СЕВЕРНАЯ ЭНЕРГИЯ 4345509318' LIMIT 1),
  'заметка',
  'Дозвонился. Закупают. Выслал инфу на почту с 2мя предложениями.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7721482650' AND name = 'ООО ТРАНСКОМ 7721482650' LIMIT 1),
  'заметка',
  'Закупают у табриза и поставляют ему. Можно позже пробивать от силтранса и предлагать китай',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6950210582' AND name = 'ООО МОНТАЖНИКПЛЮС 6950210582' LIMIT 1),
  'звонок',
  'Не дозвонился. Отправить на почту.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '2723051681' AND name = 'АО ДЭТК 2723051681' LIMIT 1),
  'заметка',
  'Набрать по их времене. Скорее всего закупают.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7751279140' AND name = 'ООО АЛГОРИТМ 7751279140' LIMIT 1),
  'кп_отправлено',
  'Не закупают, но запросил КП , отправил ему на почту . Можно пробивать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5404177588' AND name = 'ООО МИР-ЭНЕРГО 5404177588' LIMIT 1),
  'заметка',
  'Знает Табриза. Очень редко закупают. Можно бить от уралсилтранса',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7725569968' AND name = 'ЗАО ТДМ ЦЕНТР 7725569968' LIMIT 1),
  'заметка',
  'Пока нет потребности, но в будущем может быть',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7704784450' AND name = 'АО ИНТЕР РАО ЭЛЕКТРОГЕНЕРАЦИЯ 7704784450' LIMIT 1),
  'кп_отправлено',
  'Не дозвонился. Отправить КП на почту. Дозвонится',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО ЛИСЕТ' LIMIT 1),
  'заметка',
  'Есть в будущем заявка на 2000 ква',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  (SELECT id FROM companies WHERE inn IS NULL AND name = 'ООО «Тексис Груп»' LIMIT 1),
  'кп_отправлено',
  'Поставляют оборудование. Скинул КП на рассмотерние',
  now()
);

-- ================================================================
-- INSERT PROPOSALS (КП — коммерческие предложения)
-- ================================================================

INSERT INTO proposals (company_id, manager_name, number, status, total_amount, valid_until, notes, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5032304480' AND name = 'ООО "НПО АР-ТЕХНОЛОГИИ"' LIMIT 1),
  'Рам',
  'КП-001',
  'отправлено',
  2952000,
  '2025-09-02',
  'Запрос от 2025-08-29',
  '2025-08-29'
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  (SELECT id FROM proposals WHERE number = 'КП-001' LIMIT 1),
  'ТСЛ 1250/20-10/0.4 Алюминь',
  1,
  'шт.',
  1600000,
  1600000
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  (SELECT id FROM proposals WHERE number = 'КП-001' LIMIT 1),
  'ТСЛ 1250/10/0.4 алюминь',
  1,
  'шт.',
  1352000,
  1352000
);

INSERT INTO proposals (company_id, manager_name, number, status, total_amount, valid_until, notes, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6670227858' AND name = 'ООО "ЦРЗЭ"' LIMIT 1),
  'Рам',
  'КП-002',
  'отправлено',
  4380000,
  '2025-09-01',
  'Запрос от 2025-08-29',
  '2025-08-29'
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  (SELECT id FROM proposals WHERE number = 'КП-002' LIMIT 1),
  'ТСЛ 1250/10/0.4 медь',
  2,
  'шт.',
  2190000,
  4380000
);

INSERT INTO proposals (company_id, manager_name, number, status, total_amount, valid_until, notes, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '7801454062' AND name = 'ООО "ПЭП"' LIMIT 1),
  'Рам',
  'КП-003',
  'отправлено',
  0,
  NULL,
  'Запрос от 2025-09-11',
  '2025-09-11'
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  (SELECT id FROM proposals WHERE number = 'КП-003' LIMIT 1),
  'трднс 25 000',
  1,
  'шт.',
  0,
  0
);

INSERT INTO proposals (company_id, manager_name, number, status, total_amount, valid_until, notes, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '5402543239' AND name = 'ООО "РиМтехЭнерго"' LIMIT 1),
  'Рам',
  'КП-004',
  'отправлено',
  0,
  NULL,
  'Запрос от 2025-09-30',
  '2025-09-30'
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  (SELECT id FROM proposals WHERE number = 'КП-004' LIMIT 1),
  '2ктп 3150 сухари',
  1,
  'шт.',
  0,
  0
);

INSERT INTO proposals (company_id, manager_name, number, status, total_amount, valid_until, notes, created_at) VALUES (
  (SELECT id FROM companies WHERE inn = '6316213310' AND name = 'ООО "ПКФ "ТСК"' LIMIT 1),
  'Рам',
  'КП-005',
  'отправлено',
  0,
  NULL,
  'Запрос от неизвестно',
  now()
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  (SELECT id FROM proposals WHERE number = 'КП-005' LIMIT 1),
  'Прошу дать цену на трансформаторы',
  1,
  'шт.',
  0,
  0
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  (SELECT id FROM proposals WHERE number = 'КП-005' LIMIT 1),
  '1. ТМГ-630 10/0,4 D/Yн  -  (S9-630 10/0,4 D/Yн)',
  2,
  'шт.',
  0,
  0
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  (SELECT id FROM proposals WHERE number = 'КП-005' LIMIT 1),
  '2. ТМГ-2500 10/0,4 D/Yн  -  (S9-2500 10/0,4 D/Yн)',
  6,
  'шт.',
  0,
  0
);

-- ================================================================
-- UPDATE PIPELINE STAGES (if table exists)
-- ================================================================

DO $$ BEGIN
  UPDATE pipeline_stages SET name='Слабый интерес', position=1, probability=10, color='#94a3b8' WHERE name='Lead';
  UPDATE pipeline_stages SET name='Надо залечивать', position=2, probability=30, color='#f59e0b' WHERE name='Contact';
  UPDATE pipeline_stages SET name='Запрос КП', position=3, probability=50, color='#3b82f6' WHERE name='Negotiation';
  UPDATE pipeline_stages SET name='В работе', position=4, probability=70, color='#8b5cf6' WHERE name='Proposal';
  UPDATE pipeline_stages SET name='Заказ', position=5, probability=100, color='#22c55e' WHERE name='Agreement';
  UPDATE pipeline_stages SET name='Отказ', position=6, probability=0, color='#ef4444' WHERE name='Lost';
EXCEPTION WHEN OTHERS THEN NULL;
END $$;

