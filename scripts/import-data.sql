-- ================================================================
-- PulseCRM — Complete Database Setup + Data Import
-- Generated: 2026-04-16T23:30:14.691Z
-- Companies: 431 | Proposals: 5
-- ================================================================

-- ================================================================
-- CLEAN IMPORT — drops and recreates all CRM tables
-- ================================================================

DROP TABLE IF EXISTS proposal_items CASCADE;
DROP TABLE IF EXISTS proposals CASCADE;
DROP TABLE IF EXISTS activities CASCADE;
DROP TABLE IF EXISTS company_contacts CASCADE;
DROP TABLE IF EXISTS companies CASCADE;

-- ── 1. COMPANIES ─────────────────────────────────────────────
CREATE TABLE companies (
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
CREATE TABLE company_contacts (
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

-- ── 3. ACTIVITIES ─────────────────────────────────────────────
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
CREATE TABLE proposals (
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
CREATE TABLE proposal_items (
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

-- ── 7. RLS POLICIES ───────────────────────────────────────────
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3d8304b7-eeae-4b0a-bb76-a0a8075f6a79',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '67a88c3d-a8a1-4a20-adc2-d3712222aa5b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '27a6f0ee-bf7a-4526-9c5b-16f767ddca86',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '426c7756-0491-434d-bfd8-ee362e974bd7',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2a9e107f-16d7-4d23-a7f8-ebc4e6371744',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c4534496-38f1-43b5-98ab-827e716e12ad',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b58f13cc-98ea-45d2-ad9a-7a58f73ca3f7',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a4400d3f-fc8b-41d8-b67a-38b688e9be9f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f178f411-1b09-433a-bc95-9e4bc56fed5e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6432fdc3-ae97-4bff-96db-1202acf0aa6b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3604e435-cd37-4602-9fa5-ceaa43f25d90',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9b841c42-3f62-47bf-81c8-0aa61f7e10ec',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8ae88da5-19f8-4f0d-80ea-33b7f0519d72',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a2736df8-ffc3-47f2-9b2c-e3d84d528c43',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '74b9f531-8ef3-4df6-b105-a972bca6f38f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5939797f-2327-43d6-8102-f6221c0734f2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '844e8164-6e45-429c-9455-8f4bd3d371b6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5e3cc7cf-3e48-4f09-b6b5-66d393f4382c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '97afb53a-d395-42e5-b130-f5e986fe4d92',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e40cd266-38f3-4460-8783-25bf2b3d846d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '530945f6-60f4-4cd2-aaec-d9b78f606406',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7c67b6d2-5904-4c06-9ba9-e526b5e25fda',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '04b8fdaf-07b3-47cd-886f-41405e884996',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5e754e3e-cc81-462a-bc14-ceb69add3d9a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c6eeafc2-985a-4b4c-bc0e-301db7302baa',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3dfd49f2-ee30-459b-9d71-3a47296f8ce6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b327b624-d2d3-4e2c-b042-d902347a670e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b6456f83-cd7b-4a20-bbc7-46947ac4dec6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8b3bbd9e-9b17-4366-a0aa-bc9f46766064',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6cad90df-a294-4f4f-9e99-754c385ae2ea',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7acae3cd-4c47-4e42-8e95-cd61badc6380',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9918d259-837c-4b1d-90b2-7bbcc72e68ab',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1e5a414e-ea82-4bf5-bf2e-c37e39dbca62',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a6328a78-1dfb-4975-89a0-a4b9ac2fd201',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'dfecf5c1-1957-4a3c-90fd-83922837e19a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9746a62b-393d-4e95-90d9-a92bf2f120e5',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'd87ea671-618c-4ec7-aeb4-b39a32105c0c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f03665c6-dd96-439a-8e0e-385de6d8127e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '99310ace-9f0f-49cd-9d5c-65bde7720883',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e02464b6-3215-4cb4-be8d-f7f7317d4300',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '331ce892-88a5-4bcb-a0bf-c00c4b889229',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'df475f32-6b53-40fd-8bd0-556c1f5f56b4',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e092a17a-f967-41ee-ae39-242930ea827e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '547c460f-aab3-4a9c-b6ea-2a22e5059e4a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3973f0d6-3d5d-4bc6-ae5a-a9091972f388',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9b065d25-a99c-495a-81e0-319dfcdb9f44',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a4d6afef-ccb1-4f26-a4ad-46bdff29c9c1',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '59d7c527-8449-4963-bd63-00d4d57a876d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '048e31a1-ef7c-4571-9844-41f7cb4f5eb9',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5466492b-781f-4b6d-9553-ba52994c0b56',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '607e234e-c5f1-4975-b80d-b4ef168e8a1c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '90289e5e-92d5-456f-9e61-5564dfba2b6d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'd81ca11c-31e9-498a-bee6-93637d212deb',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c4b65717-8571-423f-bc43-adadfac85a52',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3141523e-ebbd-476a-bea8-3cf4983a63fa',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '55701758-bf88-455d-9242-0943156864e8',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '324df065-2793-46d6-a757-62f9a46e322e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'da21efc6-fcd1-4c41-adc2-5b53efebe215',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c2fe2fe4-7591-4838-bb24-eb04628e34ae',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'aa2951e0-6a94-4e3f-b18b-00def879196f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '435171df-0ec3-4fdf-909e-e2dcec739f39',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9ce8585b-82f7-4f16-9924-dceed44afef0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '20a3350a-e5af-41ee-a359-624bb7b88251',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9a0354ec-ff48-400c-b656-c39fc7848ac3',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a164cddb-41a2-4d9c-b47e-3a350e1ad76d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '78d752af-31bb-4c58-8f22-67bff1714428',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '69232592-8468-4d26-a16a-a3322a3207a2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'd6a84106-e872-476f-abb9-8e2958e816e6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2020efe5-5e06-4bd1-bead-fb23e73cc0df',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8c0d9e5f-6174-4c47-998c-eeed295d2008',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '91b33da8-fc65-4eab-80c5-ee2716383b56',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a3e8b4a1-5bac-477b-b0f7-5834b264cec2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8d9b2ec5-2b0e-4764-bb3a-bb1a6b167dcc',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '14e888bb-e271-4170-85e9-6d04ac5854d8',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ba8457b6-9dda-4f24-8429-065dbc5ef414',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '314cf96b-bc69-480b-b140-4d106561c77f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'cdf72bad-e7ce-4771-b380-169b586a1112',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3361f60c-57ef-45f8-983d-513251a45bd7',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'bb3752e5-0f18-4904-a1ed-7eb225d698ff',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6774251c-fdce-43ee-9dd9-f0507a68a6b2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '86f3e5bd-7126-476a-8ba1-594ee51f8161',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '56548b53-f772-4595-b9ec-0b04cab1d3c3',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e8b9a1f9-e1d8-4c86-8f2f-424bed19314f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '132e208f-9573-47d6-a3ac-a2f4340976dc',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8b260a97-27cc-4ee8-b3a5-e6a94e97d705',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5d427600-86c5-40cb-84b3-9c13588b1e9f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1dc74de9-acbb-475e-aa85-cf77a054f52c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ce18f1e4-ecd9-4798-afc4-7fdd942d6a62',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'eaf134af-543a-452d-912b-2519af3e1043',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e9dbc3b1-af0b-4ee3-8477-c61edc17f38a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a8e78320-7fa4-4874-ad79-a1f31583dc80',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a9f025ac-b9ff-49f7-9509-7befea518cca',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e019cf0b-6dfe-4c3d-910d-7680738f4af3',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ad35edca-fe6c-4ded-9b04-d7e868e06a3c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6a5f6a3c-eb6e-43c4-8a5f-e6b4815dfbe0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'db1bd86c-c89f-45ff-a71c-cdec79b0d9cc',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '55251a42-d5e1-4540-9f48-852699f58ab2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b43faaaf-84b0-450b-b196-9624b8cb8bf6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '698cfcf4-a575-4e9a-af06-fa515f27e406',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e27c514b-b0f4-40c9-8ee8-72104440ef9f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'db3ff987-68ae-4f7d-ad7e-09626e6d340e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '46841329-13c9-459a-97e8-1636580363f0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '628899dc-4ce9-4378-bf20-ebaed7e32ea0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ce3a020e-9c7a-4899-a836-c55e87904020',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a26ad28c-5a79-4843-87c9-a1842ea597f0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c4307a5b-7e62-4c0c-8cdf-27ca9ea94d68',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '23522455-d460-489c-96a3-87a497ed9017',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'cb95b816-7170-4956-ab4f-62be1e3f2dc0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '26f371a7-671b-4af4-a141-6cb7c5580619',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'fe2a7705-3e9d-490d-824e-945cdf25afd5',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'cf8109e1-5822-470d-8673-b274f204ed11',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8d6e598e-4013-41a9-a3c3-75c973b93829',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f29018e9-d8a5-4526-9ec0-622d8c8caedb',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ea865738-759a-4162-b597-8e51b530118f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '15a53ff1-fde1-413e-a1ec-693f4505b62c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6d72dbe1-0bca-46c3-adc2-2901db4c0bda',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1efce130-6b72-4f1e-ae94-a95fdef6971a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'd73d2715-e27e-49e2-8b04-7cec5c8e5f59',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ce0edebf-1ee4-45ef-a369-f9f53d35f4fd',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3941c71a-21b1-4f7b-87e7-33e85417b0b0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e64adb94-44f2-438a-b20b-cb9c334b3536',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ac0c1fbd-9ff0-4619-8ea1-95a582e1d5aa',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '913ceae0-0131-46d4-ba04-ecd5ed913600',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5d179f35-fc59-402f-8c74-e216382d8265',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0e2ee0be-482d-468f-a843-4d89f8f215da',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b4fd274f-c410-4c83-8a18-ec4134a6297d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0cdbd4ce-b8f2-4f5b-8dd2-7c706671d056',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9c14bb44-9928-4dc3-bb2e-3023eb5aab88',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '06f10368-5aa6-4716-bb92-6e4c467921a6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4b58676c-b42f-4a4c-ad71-117f95ec650b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0ce911fa-bdd0-4869-a87f-34a0b6ef03ff',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '90566ea9-a79d-4df3-b6d5-955f6c6e5a41',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2e422605-2566-4a80-9fc8-96128e6b9e9a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8b5ea875-e814-474d-a3cc-8bb7f737346c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '70f2a373-91cc-4afa-8d3d-05837776a7cc',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '12e9fda3-8f71-44e4-80c3-0e193d5ac229',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8dfc80a7-8eb9-4ea5-b765-0a8bca914f6e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b663646c-af57-461e-9db3-1fbf31e486a6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2c697890-ee74-49c5-9cc3-669bafd9081b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7c7dcbb9-9a42-474f-851b-08009965692b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'cfc408aa-de1c-4ce5-bc65-9e607390a81a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '10ff38d6-03c8-4359-bd09-1617c59d6d26',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a0cf7c1d-cfe1-4dda-8541-996803ba898e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c6e1145e-4e0b-4b4d-beb8-8a93bb338791',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4c61bd77-2d82-417b-b1b0-4a53317ffbbf',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3c21402c-58ea-41fb-9adb-6fae2fb2a24d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2669ac73-7bfe-42e5-9b6a-6e0bcde40500',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8ced7071-418c-4abd-a334-53561a64c0f5',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '52fdaf0d-b6e9-4bd2-b9a4-5a1cc11d2d4a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'df343b3b-146c-4b1e-aeef-07af25da3e2f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '839c4634-8d1f-4a36-901b-18b2b1798bc4',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6fd2cb0a-7db8-4a4d-9a22-8742a9a12274',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1160882e-bab6-40d2-ab60-6818bbbb09ff',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '668f52ea-39a3-470c-b259-771711df3033',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1fa56e79-c351-49e7-8af8-351726304592',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'cd39e8cc-ea1b-428c-82a9-00c3d4488a8f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'd6fd4343-040f-4789-a5fc-99051e7ed3b5',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3fad9665-9f4f-45fa-bccc-36f05c2e9185',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '91e6e98a-ccf8-4d9e-8942-2ea5500c79ee',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0f9767a3-240f-4e0a-8a78-e2c6cb6cc1b5',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '71d10bab-d324-4a53-830f-5c61e0cdb8c6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '461fe295-b2f8-4335-858c-36c8ff92f898',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b2072070-3d01-4501-986e-1283d1f1e934',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'cd64e110-e3ee-4833-830c-e6bbe0fb787d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b1743cd1-e5c5-4550-a7de-af9b3176a3de',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '29665b7c-cff7-4369-ad77-9be5ca420854',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e7a611e8-dc64-4739-ae15-c05786b5b3ff',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '40dc6457-e5b5-4a54-a639-9abc65658661',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0ff6ee4b-3d8d-4e23-9d6d-7b5dddee6186',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '25ddfe9a-63c1-41c1-8c9d-c6530467691a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0d2bb6e7-e0cf-4c2e-afdf-0ad8f6defff2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7d5e7b42-32c9-46b7-b327-3e7793a08280',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5bf55155-948e-4f62-83ce-3e74d620fa34',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '88b2b5f0-aade-4f47-82ab-bedc55f9df93',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'eeda0de5-b805-4847-9d8b-a68b7ca17d44',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b32b8f3c-1207-4c9d-afe1-07d0c38e4b74',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'fd8667c7-a8e6-4c6e-9048-36fc053668db',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '10903b76-d59f-4d03-a7de-51527ec5b0df',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'edbaa117-72c4-49ce-a2ac-06d58722b851',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8745cef4-ee0d-4db4-8889-0e06bbb4ddbf',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'cfc10b44-c10d-41fe-8a57-57391c389df8',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3dfbbd0c-4235-43f0-9d4d-a1a0812e85f5',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8f2d3fbe-c215-4e53-873c-f2f0b1784793',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '85bb2b22-4202-4910-8b33-3493978a4210',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2efeaa11-0d76-490a-9808-e78f9d28fb70',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '17c9b089-7c6b-4eac-94ac-8ee17788503f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8e4ca54f-9ed0-4e10-a7ad-ba2f0ff128ea',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a93964d8-f7c3-45ee-9e23-42f8f779b773',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e72ab107-a84f-47f0-9f80-40e7b1f6f951',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f491db60-d94d-42d8-8910-4816330f9b0d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '20923759-7ac7-469e-a7f5-d6624b6840e4',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f7e57de0-d6a6-4812-8946-ac9ec0a9a277',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'aafe8556-2f1c-49d8-b41a-430413d070ea',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5326b38d-d7f0-45ab-b54b-e78d919d98bd',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4ad91ade-8c90-4556-9109-5925189e7cc5',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7f9d9a0e-525d-43d4-baba-1b44131f0dd3',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4f2ef411-ff26-4958-9da5-5dc144dd4773',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a052783e-775c-4639-afe3-791b5845d9ec',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f8fb3121-9390-4db2-a1c7-23312ebc5b02',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '84125edd-d083-4235-a52d-641e44d077a6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '78b4968f-af3d-4dd2-9eb0-57c7e95ab9b6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '746ecca0-628f-4f59-a1dd-5cdedc1da198',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '72ae89e8-a893-4f76-b598-2128215307c6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '557281fa-4d87-4e1d-bab5-f64d1be0e05e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a365262f-68fd-4e1d-852d-e96843fb566e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '760ca6b7-b480-4a50-8523-d7898aee5824',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1d9f532d-7fc4-4dab-8f78-becda8cb6c17',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7c5bdfda-3833-4a01-871b-26b53365d26b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9ff74a04-59ef-4420-b123-295828455c5c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ecddc08a-d692-4b34-950c-036c23a0e809',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1774a8e9-8a0c-4ba1-b3a8-4dfb7507faf2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8a2d3dbd-69df-4918-8202-bd8d5cf2ff39',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '47341c1e-4bd1-4d78-be6e-aadf51a2d726',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'bbf0d48c-204a-48bd-885c-4da95ca12881',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ee4600e2-ecf4-4a6d-8f35-8f188a48061d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '00db46d1-6ac4-47a9-b6af-372053578728',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9b3d5308-af17-4a3b-a5a3-e93a26c13836',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '027ee0b0-1ab4-40c7-8f4e-02139f4cc883',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'fa0b2406-a4e9-4bc8-ad1a-570499006f46',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3b5dfd65-2e7d-44fc-b9ca-f39c23cf9120',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ef167920-e802-4104-b50e-06da5f1edc94',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7b2b8e6c-62a1-41de-af89-a19f0dddb4e3',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '641f00ad-d9b9-4dad-9159-52e4243e96f2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'd32d4664-2e0f-4791-82fa-060447a2d491',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'deb5ab48-abe0-4c39-89be-ae88b0a0e677',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b345ed95-a1a1-4502-bcd2-c4a68db96364',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '03311344-93fc-499e-b8ba-40167b3afdc4',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3fd34ed5-4914-4c12-af17-a54e38c608d9',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '44682a55-2a94-4d8d-bff3-33a65fd91971',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e4de820f-30b7-4b93-990f-fd66e06d8271',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '64ff2c77-f531-4a7f-95f3-413f83f50833',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'd1f0efd8-4375-48eb-b07f-afc889bfe1b0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '37ea5fb5-57ed-4c20-8720-f6058bd58d8a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'fbbdfdd6-a55c-418a-bed6-28bd702002d6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4700f7e7-4d04-4ad5-8cb0-dedb27445d56',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '01ffb52a-d8f0-4d9c-9783-a286d6b59563',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6e1af4b5-d3e3-4bd5-bc79-2beccca4d7f1',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '61f670cd-4ff1-4f9d-9777-148cea279775',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '487fe2e2-84bd-42c2-bf04-e030da566bbc',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a225b237-4dd2-43e2-b34b-1dbfc3ef3607',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e29d8166-9f3b-42fd-a2be-142a5130296b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7b23e840-6b14-4392-ac75-97761ef48077',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2e55d748-5ff9-4f5a-810c-d5840927eeaf',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '47cd980a-b3d3-41a9-b860-129606208c6e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4fcd5535-580d-44c8-89c6-11a88587814d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f1abbe1b-a42c-45ed-96dc-fd3dc2710597',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '078f04e1-f565-4118-a5d9-55a361af9074',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ad9b8f7b-a803-4f56-ac98-236e9694f8f4',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '74e49373-31f9-4dfc-ac01-802f34265604',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f9bd6f55-211c-4bef-bba2-aa39e078fba0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '30674e12-b6b0-433e-a4a2-f57cbcff6b34',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c480326a-1b9e-4286-94b5-20a8c2ff3a4b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'fa1e2154-7cd5-4a89-a3d7-b5153ce95027',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e3dc6f53-a93a-49ea-8874-77fe2cfbabb5',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '849fea66-a681-403f-b4d0-6475f292c9b9',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4f3c8f40-1dff-43ce-b1bf-71da60f7085e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f8b7c4cf-9f89-4595-93c3-a4bbd80085c7',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '14527caf-1967-4660-bea3-d05a384e57f1',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6c2afcc5-c916-4a79-8d0f-ac5432bad9b9',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '11726e3c-21e1-4cf0-bf8e-81c1eed727c7',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '63145f5f-82b7-464e-870d-9822b37fcb2c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e14a4743-9831-43cb-bce1-1d257f8d392b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f0a60411-1b80-4147-bb52-2813c89684c4',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8b656cc8-4980-42f2-b72f-de492a260d70',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '748a957b-3783-4418-b515-f3be5dd2df54',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '35dffb7c-d4af-44fe-b73a-9d6f0e87c1e4',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '600cf802-c474-4827-bc9f-55dca2eeeeed',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'bb4c4f51-38c3-4229-a22e-a61e5477ed37',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4f137f37-de50-4901-b6d4-a84d131e792b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3d5e3971-9da3-4d7f-be35-10168aeb8b22',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '67f94350-e6ba-47b2-b239-3e0f47d4cdcb',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9e82ed24-7bea-4aa0-936f-13f06dae786d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'db7c5436-0892-4555-ae04-65a79b74645c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'db69f70a-f44d-4d16-8877-25bb2585d9f6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3ec79f68-7c33-40db-b36d-1b5a68f727cd',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ac9e6dfb-12b9-4227-96ee-acf893991da0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'bf886825-77ad-401f-a6b7-26812af92908',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '69d4f495-db2e-404a-9e27-a68502477f7b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '74cf4ac0-2cc8-4814-a19b-f96302eaeeb3',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '18d293d8-865f-43b6-92e1-d0644e26d215',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '20fccf87-1138-4505-9e2a-5a9d2736aa14',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '14cafef0-1282-4d31-92c9-82db930c1c36',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9ff6b15c-b4ea-4fb8-8749-7c103dba07eb',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0e5f81e6-1157-459f-8a9a-fdeeb58ca030',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f5c7f6fe-fab1-4938-bdee-c625e44dea7c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'bc010704-ba83-452f-bbdc-0b62944595f9',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c88d7211-9eb9-4c1c-8522-279909012fba',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c427f5d5-a0b2-4b65-950f-0da4d5b930d8',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0bd18253-c7d8-4c09-babf-61fcaa50390d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3a59b849-30ad-421a-8465-2106550d796e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a58d7458-2a07-453b-be6f-b7d32f0daf50',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ba464a19-a14b-432c-a1e5-0104dc7fd3e9',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8266aa1e-c7f0-4aa7-b7b6-cb10033efaca',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9e445b74-48e0-451e-a295-2637bea30d88',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6d28495e-5890-4e55-9649-53de2d689341',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4300980b-ee50-41e6-bc0b-1a3d734387a4',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0274f410-cdf4-495e-be7a-164b3c949800',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '62cda481-01f6-4969-a64d-09a7b6b6b023',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b08df7fa-0e2d-414e-ac99-260e7518d2ef',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5a18f055-9e5b-479f-900c-b4d041582318',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e769c1dd-134e-404f-8845-c411d9d88036',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7c62fb67-6f57-46fe-a12a-6b972d783ed2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '667ae957-a5a7-46ac-99b6-8bbca70bce3c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '802ef326-0614-4753-a2b6-22a455459b4e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1ac61687-4a0a-4085-9e8c-8a006a817a68',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8316d736-200e-4a7d-94e7-7bd4df33c541',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e470705b-d07d-4196-ae5c-d35cc106cef3',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c0b45466-060d-4cda-8f9e-061ca6fe6813',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '86b91813-2a6d-4792-a5b2-d31cae950ea6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8d8f8b80-4c1c-4752-8fb2-561a72e5160f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'dae03537-f9ff-43cd-bd9f-9cd3f4ab6e8f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '36ba943b-4032-4981-9adf-b31d50163375',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e5fad5cf-c108-4d37-9496-70514c863605',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '73c6660f-6a89-4144-9d9b-1494992817a2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'd7e82ad3-5e59-4a84-8a0e-62ae4ff50dc5',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7dd03c9c-0f83-41bd-a660-748f6c0df63f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ef0ce7f1-19dc-46ce-a756-8a3bea384976',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'bef8a0bb-4d3d-490e-acf9-cbec7aa435a1',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'fe58e86b-13fe-41da-b10e-4c4321fc6e82',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9b4a8a92-0174-411d-a883-c37fda5031dd',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '55c76df4-1036-485a-8dde-514d58fad2e2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4d715427-6a2c-4c03-bcea-55db1c97f4ad',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7e0c394c-00b1-46aa-a6b4-7068e2e94f67',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6daaedfb-0a81-4b5b-a801-c72a8f1d0cc1',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e1e2b956-0eea-45c9-9055-a64ed725c04b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'df6093d8-623a-476c-b0ca-46df9ca14383',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5c3e4b23-cc99-4dd1-8070-cd6cc50a7f81',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e06ecbb2-48e4-4438-8968-6cbc24996b2a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '165bfd7f-065c-4d12-be70-077d0899901b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e5b883a2-e648-40c1-8e66-8539456f8941',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e5112d7c-0fe0-428b-b1dd-94f0b0ba74e6',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '00249ae2-1970-4ec8-9b20-aaa88fb0bbc4',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'abd61738-1297-4ed2-97c9-b28eb589225a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '03a68ffa-16da-4d5a-9439-f461e7bf7892',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '974599f4-a7ce-4918-b154-f0e1d49450e8',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5f20b426-5971-4d0c-9ea4-f15f0f16a9a8',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '95dc25e8-0cc1-44d2-9dcd-ea1d9c3977e0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7a09667c-d62d-431e-bd20-a5b44f8d82e3',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1b793b65-ed06-49ee-99bc-b5de6e14114a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'ab323268-6e7c-401e-a483-eeccde688b35',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a1cf87aa-d981-44f5-b68e-e6d1379b601f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1cbfa4e7-967c-4dac-b399-38db834d5e21',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6c5ebd68-e412-4c9a-900d-2b380f801c88',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8f08c354-2a8a-424d-b2d4-ce736c354362',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c02743c3-8bdb-482d-be48-e35a6112b8fd',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '52142b09-a7c7-45ca-8ba1-b253d34953db',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'efa81474-6c5e-4d00-ba88-0bdcb8e5aa3a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c10a12ba-0957-440c-9f60-7bddc5ade57d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a5eec0ab-29cb-4f17-9cde-e73bcf6a81cb',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'd15c1ee7-88bd-477e-9f5a-f7fd5840e798',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'd2c57ce8-fd5f-4ecc-a722-8dc1b0e8ec0c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b74491f4-8321-4ddd-8c54-c86737e167a9',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a373c577-d9d7-4085-ba83-9ffe33e35116',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9573e218-0cb9-4906-be6f-1f041915485d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '57ebe248-e1dc-4c0a-a363-248fca6a0659',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '412e406e-5603-428c-8560-99c3b519d72b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0beebb18-0c48-443b-9654-3c68a93023dc',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c506ddff-f591-4ecc-90d7-cc3a212f5ee8',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'caff5e4e-8605-46f2-b824-694d2590001f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f6241e76-765e-4ce2-b782-5f81ee14be4e',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1ab455e4-b1cf-41b4-97a1-85dfd294d0fd',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '06f74724-51ae-4bbc-8416-f1720a40aeb2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '15ebbc2a-795e-45ba-bab8-c011f32c8071',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3aedb687-06da-4a2e-b574-3207e281d88f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '88529d23-9d44-40b7-8f54-a5214cf6aad0',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b8e83983-5240-4fc7-a3db-3e4bec65a63b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a9abaa20-f336-4074-9e28-bec3ce8962ae',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3515e818-0754-4b0a-b188-0251374c39f4',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4728906d-661f-4425-8eb3-dd42341b7d54',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1e322444-cdea-47ab-8d2f-3f6107b4eeaa',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'c5de8f62-a0ac-4e1d-8f11-e0aa085ec74f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2d8dd193-ede7-459c-bb92-7510fe3db133',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '339a30d3-0521-481c-8cd2-73d449d18662',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3f78eb8d-0586-4048-b738-df6461ec1484',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'eccc8d74-731c-423f-9d78-7df628f5a69d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b5bd2ed0-a607-40f6-8dbc-b00321c431f5',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '60d55160-ee0a-492e-9892-99d67e3e3872',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'bb03c240-8e26-49c0-8cc1-796412989513',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '6d954d59-9ef4-428a-8e96-33acaff98f16',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2552a599-d799-4c4d-b347-dc5206a8186a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '904d3247-b73c-42cd-babc-b74091918d4a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '22590573-3593-4be0-a6e8-56b499270bf1',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4ec23383-c48c-402b-b45c-e6be7745d711',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '549c2013-3137-4d6b-8a86-b7f7459508ec',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e659e876-68da-48ba-a62f-bbc05614ee09',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '4e400dab-742c-4cac-9afb-8d37f3fae62f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '48b158a9-3c2f-4a08-b9ff-a2b7b94d6315',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b2912e28-d14e-4e49-94b7-aeeaa4ade088',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8f8fd0ec-f7c2-4ac1-850b-3273aed46da9',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a13e3d9a-38bb-4e1f-a0dd-240eb002fc6f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '35b2f34b-b304-40b7-aa5f-e12b519c024a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '05ba3a8f-5d73-41a2-8621-9ae2b543c705',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '11fc5f6a-9cdd-497e-8ee2-0b15b9df91ff',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8eacc50f-459a-474e-b688-2a9db4964fe3',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5c185a66-034a-47e2-b113-3f1295642031',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b7fbe664-13b1-442e-af0a-7389b1a1ee43',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'f4cd585e-e61c-41d6-80e8-b017c7bdfdce',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a50e3f58-0af3-41ab-9ba5-22b8f4df7c57',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'aa5c7774-9906-4580-b6bb-5a73e1d28e20',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '92889345-cbca-48b7-b72f-58e233e90d6c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a3df5d9b-66e1-4964-a56f-cb685901d06c',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8b4768b7-0cbf-497d-88d6-54cb119391e1',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a791f888-a2b9-4aaf-808b-64978139b27b',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '8933600f-0121-48b8-9903-5e7d78f1c084',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'fef160d7-a332-4c0c-b578-28083d90ed7a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '42a1eb3d-a58f-4ae4-a23e-7a39711b7be8',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '1edfbbee-9604-44ef-8f01-7d56f64be8a2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '9fd6de94-7edc-4e94-aee7-fe67d8d0fe65',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '03803a54-ee9a-4b95-afae-ea5ec35d517d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '36b4559f-e9a3-41ef-af0e-13afb7b76b5a',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e7ced46c-b4e3-41e5-8916-24e3bb0811ff',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e620fb38-b438-4197-ab6d-bd02d8584d6f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '141cd122-6391-483f-adee-7d18743b3b0d',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'e6a1ab3e-a674-4b74-92f0-ff5014d12070',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '58dbc5b8-b89c-494b-a5fa-243f0edbd068',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'dffe7382-7664-4cab-838f-f67e5eb273ba',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'd6ce21a3-128b-4216-9d16-747331e0c7ac',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '0cde1c12-a2cb-4938-abdf-ba34c3e0b5fd',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b98bf667-ffcb-4e85-935e-d295cd643f6f',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '3752773b-5f9d-4bb0-a769-b19ddd974224',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a7b3986e-4315-43b2-bfc2-0f473f2183e1',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '34b373b0-b75a-4af1-93fe-34257f84c596',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'a6feb1da-8b71-4937-becb-5120d016bec1',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '5b4ae2bb-1ffe-4bb3-abc7-983a48cc8259',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  'b6c405da-1dc5-4ef7-872b-bee50e4aaad7',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '863c6aa4-77f0-4dd6-b8df-a99b377bb3e3',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '7e43dcf5-b0b8-4e94-935b-946adb77e4ff',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '611846a3-1a55-409e-8bc8-73a53ac66dc2',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '15aa77f1-1801-4b94-ac73-cad1c83f2ee4',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '14dde2b3-9870-406b-966f-4e299923bd84',
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
INSERT INTO companies (id, name, inn, city, website, contact_phone, contact_email, source, status, manager_name, next_contact_date, notes) VALUES (
  '2854ca39-f27d-4f31-be9b-cefe6efac27e',
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
  '3d8304b7-eeae-4b0a-bb76-a0a8075f6a79',
  '',
  NULL,
  '89057065957',
  'stepanuk_EN@gtenergo.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '67a88c3d-a8a1-4a20-adc2-d3712222aa5b',
  'Гончар Родион Сергеевич Тел.: +7 (950) 791 14 16',
  NULL,
  NULL,
  'grs@tehold.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '27a6f0ee-bf7a-4526-9c5b-16f767ddca86',
  'Богдан на связи +7 911 548-67-17',
  NULL,
  '+7 911 548-67-17',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '426c7756-0491-434d-bfd8-ee362e974bd7',
  'Никита',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '2a9e107f-16d7-4d23-a7f8-ebc4e6371744',
  'Валентин',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'f178f411-1b09-433a-bc95-9e4bc56fed5e',
  'Евгения z35@olnisa.ru 88003331959 доб 63',
  NULL,
  '88003331959',
  'z35@olnisa.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '6432fdc3-ae97-4bff-96db-1202acf0aa6b',
  '',
  NULL,
  '8 800 200 64 46',
  'support@systeme.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '844e8164-6e45-429c-9455-8f4bd3d371b6',
  '',
  NULL,
  '+7 496 639-46-64',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '04b8fdaf-07b3-47cd-886f-41405e884996',
  '',
  NULL,
  '+7 985 762-30-35',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '5e754e3e-cc81-462a-bc14-ceb69add3d9a',
  '',
  NULL,
  '84992882894',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '3dfd49f2-ee30-459b-9d71-3a47296f8ce6',
  'Илья',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'b6456f83-cd7b-4a20-bbc7-46947ac4dec6',
  'Мария',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8b3bbd9e-9b17-4366-a0aa-bc9f46766064',
  '',
  NULL,
  '89274098725',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '6cad90df-a294-4f4f-9e99-754c385ae2ea',
  'Никита',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '7acae3cd-4c47-4e42-8e95-cd61badc6380',
  '',
  NULL,
  '+7(920)557-11-75',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '9918d259-837c-4b1d-90b2-7bbcc72e68ab',
  'Евгений закупщик +7 863 269-79-60',
  NULL,
  '+7 863 269-79-60',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '1e5a414e-ea82-4bf5-bf2e-c37e39dbca62',
  'Вадим 89199202784',
  NULL,
  '89199202784',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'dfecf5c1-1957-4a3c-90fd-83922837e19a',
  'Евгений ведущий инженер на бонусе',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '9746a62b-393d-4e95-90d9-a92bf2f120e5',
  'Мария Генадьевна закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'f03665c6-dd96-439a-8e0e-385de6d8127e',
  'Юлия Снабженец +7 861 260-09-96',
  NULL,
  '+7 861 260-09-96',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '99310ace-9f0f-49cd-9d5c-65bde7720883',
  'Олег Закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e02464b6-3215-4cb4-be8d-f7f7317d4300',
  'Михаи закупщик, Регина тоде закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '331ce892-88a5-4bcb-a0bf-c00c4b889229',
  'Сергей Павлович 83412220015',
  NULL,
  '83412220015',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'df475f32-6b53-40fd-8bd0-556c1f5f56b4',
  'Цепелев доб 1022 отдел снабжения +7 (846) 278-55-55',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '547c460f-aab3-4a9c-b6ea-2a22e5059e4a',
  '',
  NULL,
  '+7 905 089-99-30',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '3973f0d6-3d5d-4bc6-ae5a-a9091972f388',
  'Доб 113 у снабжения',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '9b065d25-a99c-495a-81e0-319dfcdb9f44',
  'Дмитрий',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'a4d6afef-ccb1-4f26-a4ad-46bdff29c9c1',
  'Данил закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '59d7c527-8449-4963-bd63-00d4d57a876d',
  '',
  NULL,
  '88002227880',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '5466492b-781f-4b6d-9553-ba52994c0b56',
  '',
  NULL,
  '+7 831 429-29-29',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '607e234e-c5f1-4975-b80d-b4ef168e8a1c',
  'Евгений милюшкин занимается нашим сказал вышли кп посмотрю',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '90289e5e-92d5-456f-9e61-5564dfba2b6d',
  'Закупщица анна',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'c4b65717-8571-423f-bc43-adadfac85a52',
  'Сергей закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '324df065-2793-46d6-a757-62f9a46e322e',
  'Михаил пока что недоступен',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'da21efc6-fcd1-4c41-adc2-5b53efebe215',
  'Екатерина начальник отдела снабжения',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'aa2951e0-6a94-4e3f-b18b-00def879196f',
  'Закупщик екатерина',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '9ce8585b-82f7-4f16-9924-dceed44afef0',
  'Антон закупщик доб 429',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '9a0354ec-ff48-400c-b656-c39fc7848ac3',
  '',
  '+7(473)300-32-62 отдел снб доб 1',
  '+7(473)300-32-62',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '78d752af-31bb-4c58-8f22-67bff1714428',
  '',
  NULL,
  '+7 495 740-40-91',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '69232592-8468-4d26-a16a-a3322a3207a2',
  'Татьяна закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8c0d9e5f-6174-4c47-998c-eeed295d2008',
  '',
  NULL,
  '88123362476',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '91b33da8-fc65-4eab-80c5-ee2716383b56',
  'Светалана снабженец',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8d9b2ec5-2b0e-4764-bb3a-bb1a6b167dcc',
  'Андрей директор +7 910 787-47-98',
  NULL,
  '+7 910 787-47-98',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '14e888bb-e271-4170-85e9-6d04ac5854d8',
  'Андрей Микишев технич директор доб 318 7 (343) 363-05-93',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'cdf72bad-e7ce-4771-b380-169b586a1112',
  'Сергей',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '3361f60c-57ef-45f8-983d-513251a45bd7',
  'Магомед',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'bb3752e5-0f18-4904-a1ed-7eb225d698ff',
  'Андрей',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '86f3e5bd-7126-476a-8ba1-594ee51f8161',
  '',
  NULL,
  '+7 499 213-32-10',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '56548b53-f772-4595-b9ec-0b04cab1d3c3',
  'Елена закупщица',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8b260a97-27cc-4ee8-b3a5-e6a94e97d705',
  'Владимир Иванович  руководитель',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'ad35edca-fe6c-4ded-9b04-d7e868e06a3c',
  'Павел Алексеевич рук отдела закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '6a5f6a3c-eb6e-43c4-8a5f-e6b4815dfbe0',
  'Евгений',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'db1bd86c-c89f-45ff-a71c-cdec79b0d9cc',
  'Татьяна занимается трансформаторами',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'db3ff987-68ae-4f7d-ad7e-09626e6d340e',
  'Константин закупщик +79111114339',
  NULL,
  '+79111114339',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'ce3a020e-9c7a-4899-a836-c55e87904020',
  'Вадим николаев',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'a26ad28c-5a79-4843-87c9-a1842ea597f0',
  'Панкратов Алексей Викторович',
  NULL,
  NULL,
  'oho2@oes37.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'c4307a5b-7e62-4c0c-8cdf-27ca9ea94d68',
  'Отдел закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '23522455-d460-489c-96a3-87a497ed9017',
  'Отдел закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'cb95b816-7170-4956-ab4f-62be1e3f2dc0',
  'Начальник снабжения',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '26f371a7-671b-4af4-a141-6cb7c5580619',
  'Екатерина Юрьевна',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'fe2a7705-3e9d-490d-824e-945cdf25afd5',
  'Азат Аскатович начальник ПТО',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'cf8109e1-5822-470d-8673-b274f204ed11',
  '',
  NULL,
  NULL,
  'nazarov@pges.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8d6e598e-4013-41a9-a3c3-75c973b93829',
  'Евгений Васильевич Начальник снабжения',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '15a53ff1-fde1-413e-a1ec-693f4505b62c',
  'Анастасия игоревна закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '6d72dbe1-0bca-46c3-adc2-2901db4c0bda',
  'Секретарь',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'd73d2715-e27e-49e2-8b04-7cec5c8e5f59',
  'Попросить перевести на отдел закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'ce0edebf-1ee4-45ef-a369-f9f53d35f4fd',
  'Александр Устинов',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'ac0c1fbd-9ff0-4619-8ea1-95a582e1d5aa',
  'Горьковская Евгения Александровна начальник снбаж',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '913ceae0-0131-46d4-ba04-ecd5ed913600',
  'Мужик какой-то',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '5d179f35-fc59-402f-8c74-e216382d8265',
  'Закупщица Татьяна',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'b4fd274f-c410-4c83-8a18-ec4134a6297d',
  'Бухматов Владимир Александрович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '06f10368-5aa6-4716-bb92-6e4c467921a6',
  'Имя не узнал',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '90566ea9-a79d-4df3-b6d5-955f6c6e5a41',
  'Не спросил',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '2e422605-2566-4a80-9fc8-96128e6b9e9a',
  'Игорь Николаевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8b5ea875-e814-474d-a3cc-8bb7f737346c',
  'Секретарь',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8dfc80a7-8eb9-4ea5-b765-0a8bca914f6e',
  'Евгений Орлов',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'b663646c-af57-461e-9db3-1fbf31e486a6',
  'Сергей Станиславович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '2c697890-ee74-49c5-9cc3-669bafd9081b',
  'Сергей Алексеевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '7c7dcbb9-9a42-474f-851b-08009965692b',
  'Отдел закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '2669ac73-7bfe-42e5-9b6a-6e0bcde40500',
  'Елена Грибова',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'df343b3b-146c-4b1e-aeef-07af25da3e2f',
  'Наталья начальник снабж',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '839c4634-8d1f-4a36-901b-18b2b1798bc4',
  'Вадим Валерьевич снабж',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '6fd2cb0a-7db8-4a4d-9a22-8742a9a12274',
  'Руслан Амварович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '1160882e-bab6-40d2-ab60-6818bbbb09ff',
  'Дарья Жукова',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'd6fd4343-040f-4789-a5fc-99051e7ed3b5',
  'Андрей Борисович Петров',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '91e6e98a-ccf8-4d9e-8942-2ea5500c79ee',
  'Абзалов Кирилл Ильдарович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '0f9767a3-240f-4e0a-8a78-e2c6cb6cc1b5',
  'Снабжение',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '29665b7c-cff7-4369-ad77-9be5ca420854',
  'Не спросил',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '25ddfe9a-63c1-41c1-8c9d-c6530467691a',
  'Юрий Григорьевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'cfc10b44-c10d-41fe-8a57-57391c389df8',
  'Анатолий александрович начальник снабжения',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8f2d3fbe-c215-4e53-873c-f2f0b1784793',
  'Александр кравченко',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '85bb2b22-4202-4910-8b33-3493978a4210',
  'Елена Шмакова',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '2efeaa11-0d76-490a-9808-e78f9d28fb70',
  'Лариса',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8e4ca54f-9ed0-4e10-a7ad-ba2f0ff128ea',
  'Маргарита',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'a93964d8-f7c3-45ee-9e23-42f8f779b773',
  'Олег Николаевич Дадонов руководитель отедла закупок',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e72ab107-a84f-47f0-9f80-40e7b1f6f951',
  'Венера Гусмановна',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '4f2ef411-ff26-4958-9da5-5dc144dd4773',
  'Светлана не дозвон',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'f8fb3121-9390-4db2-a1c7-23312ebc5b02',
  'Анна николаевна',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '557281fa-4d87-4e1d-bab5-f64d1be0e05e',
  'Вячеслав',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '760ca6b7-b480-4a50-8523-d7898aee5824',
  'Айрат Зуфарович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '47341c1e-4bd1-4d78-be6e-aadf51a2d726',
  'Валерий Николаевич главный инженер',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '9b3d5308-af17-4a3b-a5a3-e93a26c13836',
  'Игорь',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '7b2b8e6c-62a1-41de-af89-a19f0dddb4e3',
  'Артем',
  'закупщик',
  NULL,
  'joev.ar@gmail.com',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '641f00ad-d9b9-4dad-9159-52e4243e96f2',
  'Юрий (закупщик) le48_yuri@mail.ru',
  NULL,
  NULL,
  'le48_yuri@mail.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'd32d4664-2e0f-4791-82fa-060447a2d491',
  'Начальник отдела снабжения',
  NULL,
  NULL,
  'p.gerasimov@kenergo.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'd32d4664-2e0f-4791-82fa-060447a2d491',
  'Герасимов Павел Викторович',
  NULL,
  NULL,
  'p.gerasimov@kenergo.ru',
  false
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '03311344-93fc-499e-b8ba-40167b3afdc4',
  'Артем',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '64ff2c77-f531-4a7f-95f3-413f83f50833',
  '',
  NULL,
  NULL,
  'snab@cityengin.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '01ffb52a-d8f0-4d9c-9783-a286d6b59563',
  'Дарья(закупщик)',
  NULL,
  NULL,
  'omts@cem.pro',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '61f670cd-4ff1-4f9d-9777-148cea279775',
  'Максим +7-963-154-62-84',
  NULL,
  '+7-963-154-62-84',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '487fe2e2-84bd-42c2-bf04-e030da566bbc',
  'Ольга (закупщик)',
  NULL,
  NULL,
  'torgi2@energo-don.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '4fcd5535-580d-44c8-89c6-11a88587814d',
  '',
  NULL,
  '8-910-568-39-80',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'c480326a-1b9e-4286-94b5-20a8c2ff3a4b',
  'Григорий закупщик',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '849fea66-a681-403f-b4d0-6475f292c9b9',
  'Владимир',
  NULL,
  '8 485 528 03 05',
  'avan_76@mail.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8b656cc8-4980-42f2-b72f-de492a260d70',
  'Отдел закупок:',
  NULL,
  NULL,
  '111@progenerg.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8b656cc8-4980-42f2-b72f-de492a260d70',
  'Паввел',
  NULL,
  NULL,
  '111@progenerg.ru',
  false
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'ac9e6dfb-12b9-4227-96ee-acf893991da0',
  'Александра',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '74cf4ac0-2cc8-4814-a19b-f96302eaeeb3',
  'Альберт нач.снаб.',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '18d293d8-865f-43b6-92e1-d0644e26d215',
  'Юрий Владимирович',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '3a59b849-30ad-421a-8465-2106550d796e',
  'Кузнецов Андрей(закупщик)',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '4300980b-ee50-41e6-bc0b-1a3d734387a4',
  'Вадим Аскеров (закуп)',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '0274f410-cdf4-495e-be7a-164b3c949800',
  '',
  '+7 (473) 202-02-75 – отдел закупок',
  NULL,
  'snab@kngenergo.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '62cda481-01f6-4969-a64d-09a7b6b6b023',
  'Антон',
  NULL,
  '89959615925',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '5a18f055-9e5b-479f-900c-b4d041582318',
  'Алексей Николаевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e769c1dd-134e-404f-8845-c411d9d88036',
  'Виталий Игоревич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '7c62fb67-6f57-46fe-a12a-6b972d783ed2',
  'Лев',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '667ae957-a5a7-46ac-99b6-8bbca70bce3c',
  'Руских Наталья Викторовна нач снаб',
  NULL,
  '8 351 304 36 85',
  'omts4@ozeu.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '802ef326-0614-4753-a2b6-22a455459b4e',
  'Епифанов Роман Александрович(дир)',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '1ac61687-4a0a-4085-9e8c-8a006a817a68',
  'Николай',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8316d736-200e-4a7d-94e7-7bd4df33c541',
  'Елена (закуп)',
  NULL,
  NULL,
  '777@220ufa.com',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e470705b-d07d-4196-ae5c-d35cc106cef3',
  '',
  'отдел снабжения доб. 620',
  NULL,
  '628@elsiel.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'c0b45466-060d-4cda-8f9e-061ca6fe6813',
  'Гл. инженер',
  NULL,
  NULL,
  'shitov@ener-t.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'c0b45466-060d-4cda-8f9e-061ca6fe6813',
  'Шитов Павел Федорович',
  NULL,
  NULL,
  'shitov@ener-t.ru',
  false
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '86b91813-2a6d-4792-a5b2-d31cae950ea6',
  'Владимир (снаб)',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '8d8f8b80-4c1c-4752-8fb2-561a72e5160f',
  'Владимир Анатольевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'dae03537-f9ff-43cd-bd9f-9cd3f4ab6e8f',
  'Андрей',
  NULL,
  NULL,
  'tk2@l-complex.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '36ba943b-4032-4981-9adf-b31d50163375',
  'Машуков Игорь',
  NULL,
  '8 921 950 99 09',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e5fad5cf-c108-4d37-9496-70514c863605',
  '',
  'отдела закупок:',
  NULL,
  'snab@minspb.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'd7e82ad3-5e59-4a84-8a0e-62ae4ff50dc5',
  'Алексей',
  NULL,
  NULL,
  'mec26@mail.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'd7e82ad3-5e59-4a84-8a0e-62ae4ff50dc5',
  'Отдел снабжения',
  NULL,
  NULL,
  'mec26@mail.ru',
  false
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '7dd03c9c-0f83-41bd-a660-748f6c0df63f',
  'ЕвгенийНикитин(закуп)',
  NULL,
  NULL,
  'enikitin@elsh.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'ef0ce7f1-19dc-46ce-a756-8a3bea384976',
  '',
  NULL,
  NULL,
  'zakupki@rineco.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'bef8a0bb-4d3d-490e-acf9-cbec7aa435a1',
  'Екатерина',
  NULL,
  NULL,
  'mto@kim51.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'fe58e86b-13fe-41da-b10e-4c4321fc6e82',
  'Денис Суровый',
  NULL,
  NULL,
  'suroviy.d@energy-solution.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '9b4a8a92-0174-411d-a883-c37fda5031dd',
  'Иван',
  NULL,
  '+7(968)0681333',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '55c76df4-1036-485a-8dde-514d58fad2e2',
  'Кравченко Игорь Александрович',
  'отдел закуп',
  NULL,
  'zakupki@cheta.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '7e0c394c-00b1-46aa-a6b4-7068e2e94f67',
  'Кирил',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '6daaedfb-0a81-4b5b-a801-c72a8f1d0cc1',
  'Боровнев ЕвгенийГенадьевич',
  NULL,
  NULL,
  'borovnev@radian-holding.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e1e2b956-0eea-45c9-9055-a64ed725c04b',
  'Павел Данилов',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'df6093d8-623a-476c-b0ca-46df9ca14383',
  'Иван',
  NULL,
  NULL,
  '05maximum@list.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e06ecbb2-48e4-4438-8968-6cbc24996b2a',
  'Эмиль',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e5b883a2-e648-40c1-8e66-8539456f8941',
  'Курышкин Александр Сергеевич',
  '(Начальник коммерческого отдела)',
  '8-922-740-87-80',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e5112d7c-0fe0-428b-b1dd-94f0b0ba74e6',
  'Василий Генадьевич',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '00249ae2-1970-4ec8-9b20-aaa88fb0bbc4',
  'Азат доб 1310',
  NULL,
  NULL,
  'amavlin@u-energo.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '95dc25e8-0cc1-44d2-9dcd-ea1d9c3977e0',
  'Александр',
  NULL,
  '8 936 245 17 04',
  'pto@elengroup.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '7a09667c-d62d-431e-bd20-a5b44f8d82e3',
  'Сергей Степанович',
  NULL,
  '8 981 985 81 95',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'ab323268-6e7c-401e-a483-eeccde688b35',
  'Мария',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'a1cf87aa-d981-44f5-b68e-e6d1379b601f',
  'Александр',
  NULL,
  NULL,
  'alex@ntbe.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '1cbfa4e7-967c-4dac-b399-38db834d5e21',
  'Владислав',
  NULL,
  NULL,
  'LVV@esm-t.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '52142b09-a7c7-45ca-8ba1-b253d34953db',
  'Алексей',
  'отдела снабжения',
  '7(351)700-70-36',
  '109@ktp74.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '52142b09-a7c7-45ca-8ba1-b253d34953db',
  'Васильков Яков Сергеевич',
  'отдела снабжения',
  '7(351)700-70-36',
  'snab@ktp74.ru',
  false
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'efa81474-6c5e-4d00-ba88-0bdcb8e5aa3a',
  'Новикиова Татьяна Сергеевна(закуп)',
  NULL,
  NULL,
  't.novikova@emk-perm.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'a373c577-d9d7-4085-ba83-9ffe33e35116',
  'Александр Мишалкин',
  NULL,
  '+7 937 184 93 64',
  'pkf45@pkftsk.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '9573e218-0cb9-4906-be6f-1f041915485d',
  'Михаил, добавочно 405',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'caff5e4e-8605-46f2-b824-694d2590001f',
  'Щупляков Сергей Алексеевич',
  NULL,
  '8-915-747-81-14',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'f6241e76-765e-4ce2-b782-5f81ee14be4e',
  'Не вышешл',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '88529d23-9d44-40b7-8f54-a5214cf6aad0',
  '',
  NULL,
  '79876716497',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'b8e83983-5240-4fc7-a3db-3e4bec65a63b',
  'Вадим',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '3515e818-0754-4b0a-b188-0251374c39f4',
  'Павел Васильевич +79294089979',
  NULL,
  '+79294089979',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '4728906d-661f-4425-8eb3-dd42341b7d54',
  'Илья',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'c5de8f62-a0ac-4e1d-8f11-e0aa085ec74f',
  '',
  NULL,
  NULL,
  '142@dv-electro.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '3f78eb8d-0586-4048-b738-df6461ec1484',
  '',
  NULL,
  NULL,
  'info@rustradecom.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'eccc8d74-731c-423f-9d78-7df628f5a69d',
  'Телефон: +7 (391) 280-77-11',
  NULL,
  NULL,
  'info@sibtek.su',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'b5bd2ed0-a607-40f6-8dbc-b00321c431f5',
  'Заместитель',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '6d954d59-9ef4-428a-8e96-33acaff98f16',
  '',
  NULL,
  '79960074186',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e659e876-68da-48ba-a62f-bbc05614ee09',
  '',
  NULL,
  NULL,
  'info@energoprime.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '42a1eb3d-a58f-4ae4-a23e-7a39711b7be8',
  '',
  NULL,
  '+7 950 318-77-75',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '03803a54-ee9a-4b95-afae-ea5ec35d517d',
  '',
  NULL,
  '78123091645',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '36b4559f-e9a3-41ef-af0e-13afb7b76b5a',
  '',
  NULL,
  '79268181918',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e7ced46c-b4e3-41e5-8916-24e3bb0811ff',
  '',
  NULL,
  '79998800532',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e620fb38-b438-4197-ab6d-bd02d8584d6f',
  '',
  NULL,
  '79120358786',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '141cd122-6391-483f-adee-7d18743b3b0d',
  'Алексей',
  NULL,
  NULL,
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'e6a1ab3e-a674-4b74-92f0-ff5014d12070',
  '',
  NULL,
  '+7-903-770-70-75',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '34b373b0-b75a-4af1-93fe-34257f84c596',
  '',
  NULL,
  '+79933606544',
  NULL,
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '5b4ae2bb-1ffe-4bb3-abc7-983a48cc8259',
  '',
  NULL,
  '8-950-290-90-02',
  'dv@sibem24.ru',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  'b6c405da-1dc5-4ef7-872b-bee50e4aaad7',
  '',
  NULL,
  NULL,
  'mirenergo54@gmail.com',
  true
);

INSERT INTO company_contacts (company_id, name, position, phone, email, is_primary) VALUES (
  '14dde2b3-9870-406b-966f-4e299923bd84',
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
  '3d8304b7-eeae-4b0a-bb76-a0a8075f6a79',
  'кп_отправлено',
  'Входяшка.Отправил КП',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '67a88c3d-a8a1-4a20-adc2-d3712222aa5b',
  'кп_отправлено',
  'Входяшка, звонил анар попутка по нашей теме отправилКП',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '27a6f0ee-bf7a-4526-9c5b-16f767ddca86',
  'звонок',
  'На связи с ним',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '426c7756-0491-434d-bfd8-ee362e974bd7',
  'звонок',
  'На связи с ним',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '2a9e107f-16d7-4d23-a7f8-ebc4e6371744',
  'заметка',
  'Сказал директор отправить на щакупшика на валентина с ним еще пообщаться надо',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c4534496-38f1-43b5-98ab-827e716e12ad',
  'кп_отправлено',
  'недозвон кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b58f13cc-98ea-45d2-ad9a-7a58f73ca3f7',
  'кп_отправлено',
  'Пообшались сказали закупают кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a4400d3f-fc8b-41d8-b67a-38b688e9be9f',
  'кп_отправлено',
  'недозвон кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f178f411-1b09-433a-bc95-9e4bc56fed5e',
  'кп_отправлено',
  'кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6432fdc3-ae97-4bff-96db-1202acf0aa6b',
  'кп_отправлено',
  'ОТправил кп сложно пробиться',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3604e435-cd37-4602-9fa5-ceaa43f25d90',
  'заметка',
  'Сказал закупили уже много чего в первом квартале, звонить в конце августа',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9b841c42-3f62-47bf-81c8-0aa61f7e10ec',
  'кп_отправлено',
  'Отправил КП, поговорил сказал перенабрать поговорить точечно а так закупают',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8ae88da5-19f8-4f0d-80ea-33b7f0519d72',
  'кп_отправлено',
  'Кп отправил недозвон пока что с кем то разговаривал',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a2736df8-ffc3-47f2-9b2c-e3d84d528c43',
  'кп_отправлено',
  'Попросил кп на почту снабженец',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '74b9f531-8ef3-4df6-b105-a972bca6f38f',
  'кп_отправлено',
  'Кп отправил , сказал пока что вопрос по поставкам неакутальный, но будем пробивать его',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5939797f-2327-43d6-8102-f6221c0734f2',
  'кп_отправлено',
  'Кп отправил Занято',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '844e8164-6e45-429c-9455-8f4bd3d371b6',
  'кп_отправлено',
  'Кп отправил Занято',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5e3cc7cf-3e48-4f09-b6b5-66d393f4382c',
  'кп_отправлено',
  'Кп отправил Занято',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '97afb53a-d395-42e5-b130-f5e986fe4d92',
  'кп_отправлено',
  'Кп отправил сложно пробиться буду пробовать еще раз',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e40cd266-38f3-4460-8783-25bf2b3d846d',
  'заметка',
  'Телефон не работает',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '530945f6-60f4-4cd2-aaec-d9b78f606406',
  'заметка',
  'Блять не понимаю че у них у всех с телефонами',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7c67b6d2-5904-4c06-9ba9-e526b5e25fda',
  'кп_отправлено',
  'Сказала отправляйте кп рассмотрим начальник отдела снабжения',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '04b8fdaf-07b3-47cd-886f-41405e884996',
  'кп_отправлено',
  'Ответила женщина сказала проекты есть направляйте кп для снаюжения еще раз перезвоним ей потом',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5e754e3e-cc81-462a-bc14-ceb69add3d9a',
  'заметка',
  'пока что сказала ничего нет в работе',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c6eeafc2-985a-4b4c-bc0e-301db7302baa',
  'заметка',
  'Мой клиент по основной работе, у них конкурсы черещ плошадку их собственную там надо регать компанию чтобы учавствовать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3dfd49f2-ee30-459b-9d71-3a47296f8ce6',
  'заметка',
  'Договорились тут на встречу классны типо закупают',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b327b624-d2d3-4e2c-b042-d902347a670e',
  'звонок',
  'Не дозвонился попробовать еще раз в снабжение/ не дозвон пока что',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b6456f83-cd7b-4a20-bbc7-46947ac4dec6',
  'письмо',
  'Сказала закупают, направлю письмо сказщала посмотрит',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8b3bbd9e-9b17-4366-a0aa-bc9f46766064',
  'звонок',
  'Не дозвонился пока что до него, скинул, позже набрать/ на обеде сказал чуть позже набрать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6cad90df-a294-4f4f-9e99-754c385ae2ea',
  'кп_отправлено',
  'Заинтересовался, попросил предложение на почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7acae3cd-4c47-4e42-8e95-cd61badc6380',
  'кп_отправлено',
  'Номер щакупок выцепил пока что не отвечают, отправляю кп   89204505168 Роман Сергеевич agregatel1@bk.ru(11.06)',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9918d259-837c-4b1d-90b2-7bbcc72e68ab',
  'заметка',
  'Сказал зщакупают все ок запросы пришлет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1e5a414e-ea82-4bf5-bf2e-c37e39dbca62',
  'письмо',
  'Вадим Логист, сказал перешлет письмо с инженерам с ним на коннекте',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a6328a78-1dfb-4975-89a0-a4b9ac2fd201',
  'кп_отправлено',
  'Не дозвонился но кп отправил, пробовать снова',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'dfecf5c1-1957-4a3c-90fd-83922837e19a',
  'заметка',
  'В вотсап написал 10 июля',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9746a62b-393d-4e95-90d9-a92bf2f120e5',
  'кп_отправлено',
  'Пока что нет ее на месте кп отправил перезвонить. ОТправил ей кп, сказала закупают рассмотрит/ короче ктп сами делают говорит в основном заказчик сам приорбретает трансформатор но если что то будет направит',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'd87ea671-618c-4ec7-aeb4-b39a32105c0c',
  'кп_отправлено',
  'Нвправио кп в отдел снабжения',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f03665c6-dd96-439a-8e0e-385de6d8127e',
  'заметка',
  'Короче они заказывают по ошибке реально они зщаказывали трансу другой компании короче надо внедриться к ним, не отвечает 11.06/ не отвечает пока что Юлия/stv@/Юлия не отвечает пока что 10/07',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '99310ace-9f0f-49cd-9d5c-65bde7720883',
  'кп_отправлено',
  'Сказал закупают кп направляю',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e02464b6-3215-4cb4-be8d-f7f7317d4300',
  'заметка',
  'Сказал скиньте инфу посмотрим',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '331ce892-88a5-4bcb-a0bf-c00c4b889229',
  'кп_отправлено',
  'Не отвечает пока что перезвонить кп направил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'df475f32-6b53-40fd-8bd0-556c1f5f56b4',
  'заметка',
  'не отвечает перезвонить/не отвечает не могу дозвонится пока что на обеде',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e092a17a-f967-41ee-ae39-242930ea827e',
  'заметка',
  'не смог дозвониться, видимо все на обеде, чуть позже набрать но через добавочные на них можно выйти /недозвон',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '547c460f-aab3-4a9c-b6ea-2a22e5059e4a',
  'заметка',
  'Сказал набрать в рабочее время перезвонить/Сказал направить на почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3973f0d6-3d5d-4bc6-ae5a-a9091972f388',
  'заметка',
  'Все слиняли уже на рпаздники набрать после  / пока что не отвечают почему то по добавочному',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9b065d25-a99c-495a-81e0-319dfcdb9f44',
  'кп_отправлено',
  'Кп отправил на Дмитрия/ передам инфу дмитрию и на этом все закончилось мерзкий секретарь 10/07',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a4d6afef-ccb1-4f26-a4ad-46bdff29c9c1',
  'заметка',
  'Сказал заявки есть и проекты тоже есть',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '59d7c527-8449-4963-bd63-00d4d57a876d',
  'заметка',
  'Попробуем в русский свет пробиться',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '048e31a1-ef7c-4571-9844-41f7cb4f5eb9',
  'заметка',
  'Юлия Азарова 2 ярда оборот',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5466492b-781f-4b6d-9553-ba52994c0b56',
  'кп_отправлено',
  'Нет ответа мб уже на праздниках,кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '607e234e-c5f1-4975-b80d-b4ef168e8a1c',
  'кп_отправлено',
  'сказал вышли кп посмотрю',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '90289e5e-92d5-456f-9e61-5564dfba2b6d',
  'кп_отправлено',
  'Сказала у них только с атестацией в Россетях но кп сказала направьте',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'd81ca11c-31e9-498a-bee6-93637d212deb',
  'заметка',
  'Перенабрать еще раз не соединилось с отделом закупок',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c4b65717-8571-423f-bc43-adadfac85a52',
  'кп_отправлено',
  'Сказал закупаем переодически направляю кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3141523e-ebbd-476a-bea8-3cf4983a63fa',
  'кп_отправлено',
  'Тут надо выйти на отдел снабжения они этим занимаются, кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '55701758-bf88-455d-9242-0943156864e8',
  'заметка',
  'Тут надо выйти на снабжение не отвечали, попробовать дозвониться',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '324df065-2793-46d6-a757-62f9a46e322e',
  'заметка',
  '89210409085 Михаил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'da21efc6-fcd1-4c41-adc2-5b53efebe215',
  'заметка',
  'Сказала присылайте посмотрим интерес есть',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c2fe2fe4-7591-4838-bb24-eb04628e34ae',
  'кп_отправлено',
  'Направил кп, недозвон',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'aa2951e0-6a94-4e3f-b18b-00def879196f',
  'заметка',
  'Задача пообшаться С катей? обшался с Сергеем, сказал закупают трансформаторы',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '435171df-0ec3-4fdf-909e-e2dcec739f39',
  'кп_отправлено',
  'Каталог отправил кп тоде дозвниться тут не смог',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9ce8585b-82f7-4f16-9924-dceed44afef0',
  'кп_отправлено',
  'Будет на след неделе а так у них запросы есть, кп отправил в догонку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '20a3350a-e5af-41ee-a359-624bb7b88251',
  'кп_отправлено',
  'Кп отпрапвил сотрудник на совещании перезвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9a0354ec-ff48-400c-b656-c39fc7848ac3',
  'кп_отправлено',
  'До снабжения не дозвонился на обеде, ставлю перезвон, кп в догонку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a164cddb-41a2-4d9c-b47e-3a350e1ad76d',
  'кп_отправлено',
  'Обед, перезвонить, кп в догонку/ набрать в 3 по екб обед у них',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '78d752af-31bb-4c58-8f22-67bff1714428',
  'кп_отправлено',
  'Перенабрать предложить сотрудничесво секретарь не втухает/перенабрал кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '69232592-8468-4d26-a16a-a3322a3207a2',
  'заметка',
  'Татьяна закупщик сказала проекты бывают перешлет проектому отделу',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'd6a84106-e872-476f-abb9-8e2958e816e6',
  'кп_отправлено',
  'Направил кп не дозвонился',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '2020efe5-5e06-4bd1-bead-fb23e73cc0df',
  'кп_отправлено',
  'Не отвечабт скорее всего на обеде отправляю кп на отдел закупок',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8c0d9e5f-6174-4c47-998c-eeed295d2008',
  'письмо',
  'Для Марии направил письмо',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '91b33da8-fc65-4eab-80c5-ee2716383b56',
  'кп_отправлено',
  'Закупают кп отправил для них, но нужно узнат имя человека который акупает трансы',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a3e8b4a1-5bac-477b-b0f7-5834b264cec2',
  'заметка',
  'Не отвечабт мб на обеде перезвонить с утра',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8d9b2ec5-2b0e-4764-bb3a-bb1a6b167dcc',
  'кп_отправлено',
  'Кп направил ему сказал рассмотрит',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '14e888bb-e271-4170-85e9-6d04ac5854d8',
  'кп_отправлено',
  'не дозвонился до него нало перещзвонить видимо не на месте/ дозвонился кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ba8457b6-9dda-4f24-8429-065dbc5ef414',
  'заметка',
  'Закупабт тут технари а не отдел снабжения заявку сказал сейчас пришел',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '314cf96b-bc69-480b-b140-4d106561c77f',
  'заметка',
  'тут не пробился пробовать еще',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'cdf72bad-e7ce-4771-b380-169b586a1112',
  'кп_отправлено',
  'Закупают трансформаторы сами производят сухие, кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3361f60c-57ef-45f8-983d-513251a45bd7',
  'заметка',
  'Интересно ему ждем от него сообщение в вотсапе',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'bb3752e5-0f18-4904-a1ed-7eb225d698ff',
  'заметка',
  'Списались в вотсапе',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6774251c-fdce-43ee-9dd9-f0507a68a6b2',
  'кп_отправлено',
  'Кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '86f3e5bd-7126-476a-8ba1-594ee51f8161',
  'заметка',
  'Перезвонить Юлии, уточнить акупают ли они трансы представиться как ХЭНГ она закупщица/ Ответил тип какой то выйти на Юоию надо',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '56548b53-f772-4595-b9ec-0b04cab1d3c3',
  'кп_отправлено',
  'Закупают кп на почту отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e8b9a1f9-e1d8-4c86-8f2f-424bed19314f',
  'кп_отправлено',
  'Не отвечали направляю кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '132e208f-9573-47d6-a3ac-a2f4340976dc',
  'кп_отправлено',
  'Иркутск кп отправил с утра набрать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8b260a97-27cc-4ee8-b3a5-e6a94e97d705',
  'кп_отправлено',
  'Кп отправил на него ждем запросы',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5d427600-86c5-40cb-84b3-9c13588b1e9f',
  'кп_отправлено',
  'Направил кп секретарь сложный',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1dc74de9-acbb-475e-aa85-cf77a054f52c',
  'кп_отправлено',
  'Кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ce18f1e4-ecd9-4798-afc4-7fdd942d6a62',
  'кп_отправлено',
  'кп отправил по номерам не дозвониться',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'eaf134af-543a-452d-912b-2519af3e1043',
  'кп_отправлено',
  'Кп отправил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e9dbc3b1-af0b-4ee3-8477-c61edc17f38a',
  'заметка',
  'Пробуем пробиться в башкирэнерго',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a8e78320-7fa4-4874-ad79-a1f31583dc80',
  'кп_отправлено',
  'кп отправил на линии занято',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a9f025ac-b9ff-49f7-9509-7befea518cca',
  'кп_отправлено',
  'не отвечабт кп направил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e019cf0b-6dfe-4c3d-910d-7680738f4af3',
  'кп_отправлено',
  'кп направил не отвечают',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ad35edca-fe6c-4ded-9b04-d7e868e06a3c',
  'письмо',
  'Отправил ему письмо жду заявку, перенабрать ему тоже надо',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6a5f6a3c-eb6e-43c4-8a5f-e6b4815dfbe0',
  'заметка',
  'Мы с ним на вотсапе попросил инфу',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'db1bd86c-c89f-45ff-a71c-cdec79b0d9cc',
  'кп_отправлено',
  'КП направил она не отвечает перезвонить ей',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '55251a42-d5e1-4540-9f48-852699f58ab2',
  'кп_отправлено',
  'Отправил кп не дозвонился',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b43faaaf-84b0-450b-b196-9624b8cb8bf6',
  'заметка',
  'сказали обед перезвонить отдел снабжения',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '698cfcf4-a575-4e9a-af06-fa515f27e406',
  'заметка',
  'Антон, главный инженер сказал направбте на мое имя, нужно еще в отдел закупок доб 1',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e27c514b-b0f4-40c9-8ee8-72104440ef9f',
  'заметка',
  'Будут кидать нам запросы для выход на торги',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'db3ff987-68ae-4f7d-ad7e-09626e6d340e',
  'заметка',
  'Связь с закупчиком хорошая',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '628899dc-4ce9-4378-bf20-ebaed7e32ea0',
  'заметка',
  'Поговорил со стасом. Надо регаться на сайте https://td.enplus.ru/ru/zakupki-tovarov/ Можно работать. У нас общие китайцы. Второй звонок',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ce3a020e-9c7a-4899-a836-c55e87904020',
  'заметка',
  'Готовы брать из наличия. По торгам у них выступает другое юр лицо. Торговый дом sds treid. искать на госзакупках',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a26ad28c-5a79-4843-87c9-a1842ea597f0',
  'заметка',
  'начальник снажения. контакт хороший.жду обратную связь',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c4307a5b-7e62-4c0c-8cdf-27ca9ea94d68',
  'заметка',
  'работают только через торги. смотреть гос.закупки',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '23522455-d460-489c-96a3-87a497ed9017',
  'кп_отправлено',
  'Поговорил с закупщиком КТП. Женщина. Говорит что закупают напрямую. Просит давать самое выгодное предложение сразу, время торговаться нету. газпром росселторг',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'cb95b816-7170-4956-ab4f-62be1e3f2dc0',
  'заметка',
  'Не могу дозвониться. надо пробовать.21.05.25. Дозвонился до отдела закупок. Торгуются на площадке газпрома.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '26f371a7-671b-4af4-a141-6cb7c5580619',
  'заметка',
  'Берут БКТП и трансформаторы. Связаться после среды.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'fe2a7705-3e9d-490d-824e-945cdf25afd5',
  'заметка',
  'Связался с начальником ПТО. Тендерная система. Закрытые закупки. Китайцы интересны. По техническим моментам (40140)/ 29.08.2025 заявок нет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'cf8109e1-5822-470d-8673-b274f204ed11',
  'звонок',
  'Павел не решает. До александра не дозвонился. 5 августа 2025 - заявок нет// 25 августа 2025 года - заявок нет// 17 сентября - заявок нет//',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8d6e598e-4013-41a9-a3c3-75c973b93829',
  'заметка',
  '26.03.2026. заявок нет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f29018e9-d8a5-4526-9ec0-622d8c8caedb',
  'заметка',
  'Заинтересовал снабженца Китаем. Попросил скинуть ему на почту инфу о нас. Говорит, что будет закупка - будет и пища)',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ea865738-759a-4162-b597-8e51b530118f',
  'заметка',
  'не дохвонился, а надо',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '15a53ff1-fde1-413e-a1ec-693f4505b62c',
  'заметка',
  'Выбил комер закупщика. Поговорил. Отправят запрос на КТП',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6d72dbe1-0bca-46c3-adc2-2901db4c0bda',
  'заметка',
  'Набрал в общий отдел. Дали этот номер. Сегодня там   выходной. Набрать завтра. Спросить снабжение',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1efce130-6b72-4f1e-ae94-a95fdef6971a',
  'заметка',
  'Связался с секретарем. Дали комер отдела закупок. Не взяли. Пробовать еще раз.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'd73d2715-e27e-49e2-8b04-7cec5c8e5f59',
  'заметка',
  'Поговорил с закупщиком. Женщина в возрасте. Работают под росстеями под торги. Торги проходят на площадке РАД. Будут торги на трансформаторы 250,400,630 после майских',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ce0edebf-1ee4-45ef-a369-f9f53d35f4fd',
  'заметка',
  'Познакомился с закупщиком. Нашего профиля маловато, но будут скидывать запросы, потому что хорошо поговорили.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3941c71a-21b1-4f7b-87e7-33e85417b0b0',
  'звонок',
  'Не дозвонился до инженера. Пробовать еще. в этом году не будет закупок. звонок юыд 14 -7 2025',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e64adb94-44f2-438a-b20b-cb9c334b3536',
  'кп_отправлено',
  'Кое-как нашел номер приемной но не дозвонился.11 сенября 2025 вытащил номер главного инженера. было занято/// 18.09.2025. поговорил с инженером. закупки проходят по 223 фз. прямых нет. попросил кп.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ac0c1fbd-9ff0-4619-8ea1-95a582e1d5aa',
  'заметка',
  'Работают через торги. Наш профиль. Площадка: ЭТП ГПБ.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '913ceae0-0131-46d4-ba04-ecd5ed913600',
  'заметка',
  'Берут только измерительные трансы нтми.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5d179f35-fc59-402f-8c74-e216382d8265',
  'кп_отправлено',
  'Пообщался с закупщицей. Очень хорошо поговорили. Есть и прямые закупки до 1.5 млн. Берут и трансы и ктп. РТС тендер. скоро закупка. Отправил КП',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '0e2ee0be-482d-468f-a843-4d89f8f215da',
  'заметка',
  '21.05.2025. Дозовнился до отдела закупок. торгуются на площадке ТЕГТОРГ. Прямых на подстанции и трансы не бывает.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b4fd274f-c410-4c83-8a18-ec4134a6297d',
  'заметка',
  'Пообщался со старым) Нормальный перец. будут брать,думаю/ 29.08.2025 не берет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '0cdbd4ce-b8f2-4f5b-8dd2-7c706671d056',
  'звонок',
  'Поговорил с секретарем. Снабженцы сидят на Колымской ГЭС. Дала номер, но там пищат что-то. пробовать позже/29.08.2025. Не дозвон.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9c14bb44-9928-4dc3-bb2e-3023eb5aab88',
  'звонок',
  'Узнал номер снабжения безхитростным путем. Но там сука не берут. Пытаться еще/29.08.2025. Не дозвон.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '06f10368-5aa6-4716-bb92-6e4c467921a6',
  'звонок',
  'Поговорил с закупщиком. Он сказал, что больших закупок пока не будет, но будут разовые. Китай интересен. 29.08.2025. Не дозвон.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4b58676c-b42f-4a4c-ad71-117f95ec650b',
  'заметка',
  'Поговорил с девочкой. Пока заказов нет, но просит отправить инфу. Контакт хороший',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '0ce911fa-bdd0-4869-a87f-34a0b6ef03ff',
  'заметка',
  'Руслан хороший парень. Сразу скентовались с ним) Уже есть заказ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '90566ea9-a79d-4df3-b6d5-955f6c6e5a41',
  'кп_отправлено',
  'Поговорил с закупщицей. Рассмотрят наше предложение//29.08.2025  Сказала не занимаются трансами. пиздит возможно',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '2e422605-2566-4a80-9fc8-96128e6b9e9a',
  'заметка',
  'Поговорили с Игорем. Интересно ему. Скинет заявку.Поговорил с игорем 14 07 25. не получил заявку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8b5ea875-e814-474d-a3cc-8bb7f737346c',
  'кп_отправлено',
  'отправил кп на почту/ 29.08.2025 Секретарь ебет мозга',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '70f2a373-91cc-4afa-8d3d-05837776a7cc',
  'заметка',
  'Позвонил в отдел снабжения. Поговорил с парнем. Торгуются на РТС. Прямых нет.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '12e9fda3-8f71-44e4-80c3-0e193d5ac229',
  'кп_отправлено',
  'Разговаривал с закупщиком. Строгий дядя) Но попросил КП.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8dfc80a7-8eb9-4ea5-b765-0a8bca914f6e',
  'кп_отправлено',
  'Поговори с начальником снабжения. Скинул КП',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b663646c-af57-461e-9db3-1fbf31e486a6',
  'кп_отправлено',
  'Отправил снабженцу кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '2c697890-ee74-49c5-9cc3-669bafd9081b',
  'кп_отправлено',
  'отправил кп на почту. звонил. 29.08.2025 сказал на пол года проекты расписаны. отравить кп. Набрать после майских 2026',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7c7dcbb9-9a42-474f-851b-08009965692b',
  'заметка',
  'связался с закупками. работают через торги 223 фз. 29.08.2025 закупщица сказала, что не сказала бы что закупка проводится',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'cfc408aa-de1c-4ce5-bc65-9e607390a81a',
  'заметка',
  'поговорил с секретарем. сказала пока не даст номер снабженца и имя не скажет. но ключевое слово пока))',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '10ff38d6-03c8-4359-bd09-1617c59d6d26',
  'заметка',
  'не прошел секретаря. отдать алику на доработку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a0cf7c1d-cfe1-4dda-8541-996803ba898e',
  'звонок',
  'не дозвон',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c6e1145e-4e0b-4b4d-beb8-8a93bb338791',
  'заметка',
  'снабженца нет на месте пока. перезвоню',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4c61bd77-2d82-417b-b1b0-4a53317ffbbf',
  'заметка',
  'Поговорил со снбаженцем. Пока что мнется, но сказал набрать попозже. может, что появится. у секретаря сразу просить соеденить со снабжением.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3c21402c-58ea-41fb-9adb-6fae2fb2a24d',
  'кп_отправлено',
  'отправил кп на почту.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '2669ac73-7bfe-42e5-9b6a-6e0bcde40500',
  'кп_отправлено',
  'Заинтересовались. отправил кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8ced7071-418c-4abd-a334-53561a64c0f5',
  'кп_отправлено',
  'отправил кп.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '52fdaf0d-b6e9-4bd2-b9a4-5a1cc11d2d4a',
  'заметка',
  'поговорил со светланой. интерес по трансам. скинул цены на вотсапп. 8.04.2026 заявок нет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'df343b3b-146c-4b1e-aeef-07af25da3e2f',
  'заметка',
  'поговорил с натальей. хочет россети. скинул инфу на вотсапп. но разговор хороший. будет отправлять заявки.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '839c4634-8d1f-4a36-901b-18b2b1798bc4',
  'письмо',
  'Контакт хороший, но не могу отправить письмо. надо норм почту.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6fd2cb0a-7db8-4a4d-9a22-8742a9a12274',
  'заметка',
  'поговорил со снабженцем. получил заявку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1160882e-bab6-40d2-ab60-6818bbbb09ff',
  'заметка',
  'Рамочный договор на год. Поговорил с Дашей. Будут иметь нас ввиду.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '668f52ea-39a3-470c-b259-771711df3033',
  'заметка',
  'Не поговорил со снабжением. Перезвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1fa56e79-c351-49e7-8af8-351726304592',
  'кп_отправлено',
  'отправил кп на почту. звонил.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'cd39e8cc-ea1b-428c-82a9-00c3d4488a8f',
  'кп_отправлено',
  'Набрал. Спецы были заняты. отправил кп. связаться позже',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'd6fd4343-040f-4789-a5fc-99051e7ed3b5',
  'заметка',
  'Поговорил С ЛПР. Китай не инетересен.только подстанции',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3fad9665-9f4f-45fa-bccc-36f05c2e9185',
  'заметка',
  'Поговорил с закупщицей.Попросила скинуть инфу. Будут в понедельник.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '91e6e98a-ccf8-4d9e-8942-2ea5500c79ee',
  'кп_отправлено',
  'Не дозвон. Отправил КП.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '0f9767a3-240f-4e0a-8a78-e2c6cb6cc1b5',
  'заметка',
  'выбил номер снабжения. перезвонить через час',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '71d10bab-d324-4a53-830f-5c61e0cdb8c6',
  'кп_отправлено',
  'НАРЫЛ НОМЕР ЗАКУПЩИКА. У НИХ ЕСТЬ ГКПЗ. СКАЗАЛ УЧАВСТОВАТЬ В ЗАКУПКАХ НА ОБЩИХ ОСНОВАНИЯХ. ПОКА ВЯЛО. НО НАДО ПРОБИВАТЬ. ОН БЫЛ ОЧЕНЬ УСТАВШИМ. ТОРГУЮТСЯ НА СОБСТВЕННОЙ ПЛОЩАДКЕ: https://interrao-zakupki.ru/purchases/',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '461fe295-b2f8-4335-858c-36c8ff92f898',
  'письмо',
  'Отправил письмо на ген дира.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b2072070-3d01-4501-986e-1283d1f1e934',
  'заметка',
  'секретарь сука. не могу пробить.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'cd64e110-e3ee-4833-830c-e6bbe0fb787d',
  'заметка',
  'торгуются на ртс тендере.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b1743cd1-e5c5-4550-a7de-af9b3176a3de',
  'заметка',
  'перезвонить завтра. Дозвонился до закупок 5 июня. просят аттестацию россетей. берут 110 трансы и 220 чаще.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '29665b7c-cff7-4369-ad77-9be5ca420854',
  'заметка',
  'Перезвонить завтра. Битва с закупщиком',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e7a611e8-dc64-4739-ae15-c05786b5b3ff',
  'звонок',
  'не дозвонился до закупок. Российский акционный дом торговая площадка. Интересны китайцы. Прямых нет',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '40dc6457-e5b5-4a54-a639-9abc65658661',
  'звонок',
  'не дозвонился',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '0ff6ee4b-3d8d-4e23-9d6d-7b5dddee6186',
  'звонок',
  'не дозвонится',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '25ddfe9a-63c1-41c1-8c9d-c6530467691a',
  'заметка',
  'Юрий Григорьевич сказал выходить на торги. Заказ РФ.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '0d2bb6e7-e0cf-4c2e-afdf-0ad8f6defff2',
  'заметка',
  'дозвониться завтра',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5bf55155-948e-4f62-83ce-3e74d620fa34',
  'заметка',
  'снабженка в отпуске. набрать через неделю',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '88b2b5f0-aade-4f47-82ab-bedc55f9df93',
  'заметка',
  'заинтересовались. с китаем работали. нужно представительсво. оно есть. ждем запрос. набрать после уточнения наших цен',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'eeda0de5-b805-4847-9d8b-a68b7ca17d44',
  'заметка',
  'поговорил с человеком. вроде интерес есть',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b32b8f3c-1207-4c9d-afe1-07d0c38e4b74',
  'заметка',
  'снабжения нет на месте',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'fd8667c7-a8e6-4c6e-9048-36fc053668db',
  'звонок',
  'не дозвонился',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '10903b76-d59f-4d03-a7de-51527ec5b0df',
  'заметка',
  'перезвонить позже',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'edbaa117-72c4-49ce-a2ac-06d58722b851',
  'кп_отправлено',
  'Все предложения через руководителя. попросили направить кп на его имя. Попробовать связаться позже',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8745cef4-ee0d-4db4-8889-0e06bbb4ddbf',
  'заметка',
  'было занято. перезвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'cfc10b44-c10d-41fe-8a57-57391c389df8',
  'заметка',
  'не прошел секретаря. пробовать позже',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3dfbbd0c-4235-43f0-9d4d-a1a0812e85f5',
  'заметка',
  'перезвонить. на отгрузке.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8f2d3fbe-c215-4e53-873c-f2f0b1784793',
  'кп_отправлено',
  'Поговорил с директором. Пока проектов нет. но будут иметь нас в ввиду. отправил кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '85bb2b22-4202-4910-8b33-3493978a4210',
  'заметка',
  'Поговорил с Еленой. есть хороший контакт.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '2efeaa11-0d76-490a-9808-e78f9d28fb70',
  'заметка',
  'поговорил с ларисой. замотал ее. будет отправлять заявки',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '17c9b089-7c6b-4eac-94ac-8ee17788503f',
  'кп_отправлено',
  'Поговорил со снабженкой. была не в настроении. попросила кп. перезвонить завтра.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8e4ca54f-9ed0-4e10-a7ad-ba2f0ff128ea',
  'заметка',
  'поговорил. девушка в отпуске до 1 июля',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a93964d8-f7c3-45ee-9e23-42f8f779b773',
  'звонок',
  'Не дозвонился до начальника. пробовать завтра',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e72ab107-a84f-47f0-9f80-40e7b1f6f951',
  'кп_отправлено',
  'Поговорил с начальником снабжения. контакт хороший. скину кп на почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '20923759-7ac7-469e-a7f5-d6624b6840e4',
  'заметка',
  'не берут',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f7e57de0-d6a6-4812-8946-ac9ec0a9a277',
  'заметка',
  'сказать в отдел закупок. в понедельник',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'aafe8556-2f1c-49d8-b41a-430413d070ea',
  'кп_отправлено',
  'сказать в отдел закупок. поговорил. рассматривают предложение',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5326b38d-d7f0-45ab-b54b-e78d919d98bd',
  'заметка',
  'звонил 3.07. выбил номер снабжения. пока не получил обратную связь',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4ad91ade-8c90-4556-9109-5925189e7cc5',
  'заметка',
  'перевели и сбросили. перезвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7f9d9a0e-525d-43d4-baba-1b44131f0dd3',
  'кп_отправлено',
  'Никита Евгеньевич. Отправил кп. созвониться на след неделе',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f8fb3121-9390-4db2-a1c7-23312ebc5b02',
  'заметка',
  'Поговорил с закупщицей очень хорошо. Скинет заявку',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '84125edd-d083-4235-a52d-641e44d077a6',
  'заметка',
  'все поставщики расписаны на год. была не в настроении. перезвонить через пару недель.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '78b4968f-af3d-4dd2-9eb0-57c7e95ab9b6',
  'заметка',
  'снабженка не могла говорить. перезвонить днем.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '746ecca0-628f-4f59-a1dd-5cdedc1da198',
  'заметка',
  'не было на месте спеца',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '72ae89e8-a893-4f76-b598-2128215307c6',
  'кп_отправлено',
  'ольга скинула трубку перезвонить. Поговорил со снабжением 15.07.2025. Скинул кп. Рассматривают предложение.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '557281fa-4d87-4e1d-bab5-f64d1be0e05e',
  'кп_отправлено',
  'поговорил со снабженцем. отправил кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a365262f-68fd-4e1d-852d-e96843fb566e',
  'заметка',
  'Поговорил с коммерческим директором. интересно но говорит про нац режим.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '760ca6b7-b480-4a50-8523-d7898aee5824',
  'кп_отправлено',
  'Поговорил с коллегой Айрата.Он сказал что посмотрит кп. перезвонить завтра',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1d9f532d-7fc4-4dab-8f78-becda8cb6c17',
  'кп_отправлено',
  'скинул кп на потчу',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7c5bdfda-3833-4a01-871b-26b53365d26b',
  'кп_отправлено',
  'отправил кп. пока не звонил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9ff74a04-59ef-4420-b123-295828455c5c',
  'кп_отправлено',
  'отправил кп на почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ecddc08a-d692-4b34-950c-036c23a0e809',
  'кп_отправлено',
  'отправил кп. закуп не ответили.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1774a8e9-8a0c-4ba1-b3a8-4dfb7507faf2',
  'заметка',
  'у них сидит менеджер, который отмсматривает заявки и связывается с поставщиками. будут иметь нас ввиду.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8a2d3dbd-69df-4918-8202-bd8d5cf2ff39',
  'заметка',
  'поговорил с ольгой. закупают только энергоэффективные трансформаторы. Площадка сбербанк АСТ. участие бесплатное. Условия договорные.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '47341c1e-4bd1-4d78-be6e-aadf51a2d726',
  'заметка',
  'Валера в отпуске до моего др. набрать позже',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'bbf0d48c-204a-48bd-885c-4da95ca12881',
  'звонок',
  'пока не дозвон. человека не было на месте.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ee4600e2-ecf4-4a6d-8f35-8f188a48061d',
  'заметка',
  'звонил в коммерческий отдел. сказали будут скидывать заявки',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '00db46d1-6ac4-47a9-b6af-372053578728',
  'заметка',
  'поговорил со старым. хорошо пообщались. Потенциал',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9b3d5308-af17-4a3b-a5a3-e93a26c13836',
  'звонок',
  'Не дозвонился до Игоря. скорее всего, добавочный 135 но не факт. пробовать еще. 18.09.2025. Поговорил с Игорем. Работают с Россетями. пробить не вышло.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '027ee0b0-1ab4-40c7-8f4e-02139f4cc883',
  'звонок',
  'не дозвонился',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'fa0b2406-a4e9-4bc8-ad1a-570499006f46',
  'кп_отправлено',
  '16.09.2025 не дозвон. 17.09.2025 Познакомился с Татьяной. рассматривают кп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3b5dfd65-2e7d-44fc-b9ca-f39c23cf9120',
  'звонок',
  'не дозвон',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ef167920-e802-4104-b50e-06da5f1edc94',
  'заметка',
  'Работал с мужиком. он теперь там не работает. Отвечает Елена',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7b2b8e6c-62a1-41de-af89-a19f0dddb4e3',
  'кп_отправлено',
  'Не дозвон, КП отправил на почту. / 29.04.25 - через секретаря связь с артемом, попросил информационное, обещал завтра скинуть заявку / не доходят сообщения! / 14.05.25 секретарь дал 2 почты закупщика Артема, при звонке не был на месте / все равно письма не доходят! / 20.05.25 - дозванился до Артема, актуализировал его почту, заявок нет говорит /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '641f00ad-d9b9-4dad-9159-52e4243e96f2',
  'кп_отправлено',
  'Вышел на закупщика Юрий, попросил инф письмо./ 23.04.25- магел звонил, повторное коммерческое/ 29.04.25 - Алик - запросы есть внес в базу поставщиков / 14.05.25 - Юрий говорит мало заказов, освежил КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'd32d4664-2e0f-4791-82fa-060447a2d491',
  'кп_отправлено',
  'Отправил КП Герасимову / 28.04.25 - звонок Герасимову, не ответ, КП на почту / 14.05.25 -  нет на месте, ответила марина, наш товар интересен, попросила КП, сказала будут отправлять заказы / 15.05..25 - письмо не доставлено герасимову, надо с ним созваниться / 20.05.25 - Герасимов не ответ, все ссылаються нанего /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'deb5ab48-abe0-4c39-89be-ae88b0a0e677',
  'кп_отправлено',
  '15.04Отправил КП / 28.03.25-не дозвон / 21.05.25 - актуализировал номер, надо прозвонить /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b345ed95-a1a1-4502-bcd2-c4a68db96364',
  'звонок',
  '/20.03звонокРаботают с атестованными в россетях/ 28.04.25 - не дозвон. Серт нужен - Алик \',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '03311344-93fc-499e-b8ba-40167b3afdc4',
  'кп_отправлено',
  '/Тяжело идет на контакт, отправил кп /23.04.25 магел звнок- тяжело идет но пробиваем/Короче Артем его зовут но он ни разу не закупщик надо зайти с иторией чтобы перевели на закупщика!!!! - завтра на брать- Алик 29.04 c Артемом бесполезно говорить он вафля! / 21.05.25 - артем запросил КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3fd34ed5-4914-4c12-af17-a54e38c608d9',
  'кп_отправлено',
  'Отправил КП / 23.04.25-не ответ /28.04.25 - ответил вредный секритарь, попросил информационное письмо / 29.04 не дозвон - алик',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '44682a55-2a94-4d8d-bff3-33a65fd91971',
  'кп_отправлено',
  'Отправил КП / 28.04.25 - не ответ, повторное КП / не дозвон - алик 29.04',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e4de820f-30b7-4b93-990f-fd66e06d8271',
  'кп_отправлено',
  'Отправил кп / 28.04.25 - не ответ, повторное КП на почту / номер не досутпен 29.04 алик',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '64ff2c77-f531-4a7f-95f3-413f83f50833',
  'кп_отправлено',
  'Отправил кп / 28.04.25 - секретарь попросил инф письмо на снабжение / сказали отдел снабжения свяжется, если нет придумать историю с курьером',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'd1f0efd8-4375-48eb-b07f-afc889bfe1b0',
  'кп_отправлено',
  'Отправил кп / 28.04.25 - не ответ, повторное КП / 14.05.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '37ea5fb5-57ed-4c20-8720-f6058bd58d8a',
  'кп_отправлено',
  'Отправил КП / 28.04.25 - не ответ, КП повторно на почту / 14.05.25 - не ответ / 15.04.25 - не ответ / 20.05.25 - не ответ /Секретярь соединяет но номер не ответил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'fbbdfdd6-a55c-418a-bed6-28bd702002d6',
  'кп_отправлено',
  'Отправил КП / 29.04.25 - не интересно работают на довальчиском сырье ( Алик это пиздабольский отмаз?)  / 20.05.25 - Секретарь попросила КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4700f7e7-4d04-4ad5-8cb0-dedb27445d56',
  'звонок',
  'Не дозвон/ не дозвон-20.03.25 / 14.05.25 - не дозвон /15.05.25 - не отвечают / 20.05.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '01ffb52a-d8f0-4d9c-9783-a286d6b59563',
  'кп_отправлено',
  'Отправил кп / 14.05.25 - попросили КП на почту / 15.05.25. - закупщицу зовут Дарья, сказала подстанции производят сами, трансформаторы интересны / 20.05.25 - секретарь соеденял с дарьей, ответила Татьяна, заявок нет, попросила КП на почту / ИСПОЛЬЗУЮТ РЕДКО ТРАНСЫ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6e1af4b5-d3e3-4bd5-bc79-2beccca4d7f1',
  'кп_отправлено',
  'Отправил КП/ тут секретарь сложный надо какие то данные предоставить лиретора пробить по инн, вытаскивать номер закупщика / 20.05.25- секретарь запросил письмо КП, перезвонить 23.05.25 / 11,08,25-секретарь говорит отправь кп если интересно то свяжуться',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '61f670cd-4ff1-4f9d-9777-148cea279775',
  'заметка',
  'Рам есть контакт. Максим +7-963-154-62-84 (надо доработать )  / 14.05.25 - не ответ / 15.05.25- -Он сказал только атестованные в россетях поставляем /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '487fe2e2-84bd-42c2-bf04-e030da566bbc',
  'кп_отправлено',
  'Профильная компания/ 01.04 звонок, отправилКП / 29.04.25 - секретарь пытался соединь с отделом закупок, никто не ответил, попросила перезвонить после празников / 14.05.25 - наш товар редкий, Ольга закупщик запросила КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a225b237-4dd2-43e2-b34b-1dbfc3ef3607',
  'кп_отправлено',
  'Отправил КП / 15.05.25 - ответил секретарь, говорит не интересно, но еомпания профильная, возможно не правильно поняла /Короче тут сказали свяжутся серкетярь, попробую выйти на закупки - алик 22 мая',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e29d8166-9f3b-42fd-a2be-142a5130296b',
  'кп_отправлено',
  'Отправил КП / 29.04.25 - не ответ / 15.05.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7b23e840-6b14-4392-ac75-97761ef48077',
  'кп_отправлено',
  'Вредный секретарь, отправил КП / 14.05.25 - не ответ, повторное КП /нет ответа алик 22 мая',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '2e55d748-5ff9-4f5a-810c-d5840927eeaf',
  'кп_отправлено',
  'Отправил КП / 15.05.25 - ответил секритарь, закупают через площадку на сайте tatenergo.ru, нужно найти выход на закупщика /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '47cd980a-b3d3-41a9-b860-129606208c6e',
  'кп_отправлено',
  'Отправил КП / 15.05.25 - говорит не пользуеться спросом наша продукция, пиздит на сайте другая инфа /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4fcd5535-580d-44c8-89c6-11a88587814d',
  'кп_отправлено',
  '/ 15.05.25 - Связался с Николаем на сотовый, попросил КП на почту / 20.05.25 - николай был не в настроение, разговор не пошел, не помнит о нас /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f1abbe1b-a42c-45ed-96dc-fd3dc2710597',
  'кп_отправлено',
  'Отправил КП / 15.05.25 - Секретарь попросил КП / 20.05.25 - позвонить 21.05.25  Юлии Юрьевне 8(812)612-12-02 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '078f04e1-f565-4118-a5d9-55a361af9074',
  'заметка',
  'не актуальный номер',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ad9b8f7b-a803-4f56-ac98-236e9694f8f4',
  'кп_отправлено',
  'Профильная компания, запросили КП. / 15.04.25 -  нужно искать закупщика /
22.05.2025 - не ответ, это интернет магазин /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '74e49373-31f9-4dfc-ac01-802f34265604',
  'кп_отправлено',
  'Занимаються строительством ЛЭП. отпрвил КП / 15.05.25 - секретарь говорит снабженцы отсутствуют на месте, поросила КП на почту / пробил секретаря, постоянно пиздит нет снабженце, снабженец ответил сказал не интерестно и бросил трубку /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f9bd6f55-211c-4bef-bba2-aa39e078fba0',
  'кп_отправлено',
  'В основном низковольтное, высоковольтное редко, отправил КП.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '30674e12-b6b0-433e-a4a2-f57cbcff6b34',
  'письмо',
  'Наши изделия используют редко, запросили информационное письмо.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c480326a-1b9e-4286-94b5-20a8c2ff3a4b',
  'письмо',
  'Профильная компания запросили информационное письмо. / 15.05.25 - секретарь связал с закупщиком, просят реестр минпромторга, изделия интересны, надо общаться / 22.05.2025 - Григорий говорит нет заказов, залечил его, просит звоонить переодически /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'fa1e2154-7cd5-4a89-a3d7-b5153ce95027',
  'письмо',
  'Грубят, наш клиент, попросили информационное письмо.  / 15.05.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e3dc6f53-a93a-49ea-8874-77fe2cfbabb5',
  'письмо',
  'Берут наш товар мало, попросили информационное письмо.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '849fea66-a681-403f-b4d0-6475f292c9b9',
  'письмо',
  'Запросили информационно письмо. / 15.05.25 - владимир не на месте/ 22.05.2025 - ответил Александр, у них торговая организация, говорят что внесли нас в список поставщиков, при звонке узнают Рамиля, заявок пока нет, долбить его не часто /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4f3c8f40-1dff-43ce-b1bf-71da60f7085e',
  'кп_отправлено',
  '/Не дозвон, КПотправил на почту. / 02.06.2025 - Поросили КП на Сергея/',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f8b7c4cf-9f89-4595-93c3-a4bbd80085c7',
  'кп_отправлено',
  'Не дозвон, КПотправил на почту. / 02.06.25- не дозвон, /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '14527caf-1967-4660-bea3-d05a384e57f1',
  'письмо',
  '/Приняли письмо, секретарь оправила начальнику, просила связаться 16.06.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6c2afcc5-c916-4a79-8d0f-ac5432bad9b9',
  'кп_отправлено',
  'не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '11726e3c-21e1-4cf0-bf8e-81c1eed727c7',
  'кп_отправлено',
  'Секретарь пытался соеденить с отделом закупок не вышло, отправил КП на почту / 22.05.2025 - серетарь не смогла соеденить с отделом закупок не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '63145f5f-82b7-464e-870d-9822b37fcb2c',
  'кп_отправлено',
  'Ответил секретарь, попросила КП для ознакомления. / 15.05.25 - секритарь прислал на почту что мы молодая компания и они нас боятьс, вопрос на контроле у Магела / 22.05.2025 - анна секретарь напиздела что не берут наш продукт /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e14a4743-9831-43cb-bce1-1d257f8d392b',
  'кп_отправлено',
  '/ не дозвон,КП на почту/',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f0a60411-1b80-4147-bb52-2813c89684c4',
  'кп_отправлено',
  '/ Профильная компания, секретарь запросил КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8b656cc8-4980-42f2-b72f-de492a260d70',
  'кп_отправлено',
  '/ Профильная компания, секретарь запросил КП на почту / 22.05.2025 - ответил павел закуп, готовы расмотреть нашу продукцию под выйгранные торги, запросил КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '748a957b-3783-4418-b515-f3be5dd2df54',
  'кп_отправлено',
  '/ Профильная компания, секретарь запросил КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '35dffb7c-d4af-44fe-b73a-9d6f0e87c1e4',
  'кп_отправлено',
  '/ в основном низвольтное оборудование, наше редко берут, отправил КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '600cf802-c474-4827-bc9f-55dca2eeeeed',
  'кп_отправлено',
  '/ секретарь запросил КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'bb4c4f51-38c3-4229-a22e-a61e5477ed37',
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4f137f37-de50-4901-b6d4-a84d131e792b',
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3d5e3971-9da3-4d7f-be35-10168aeb8b22',
  'кп_отправлено',
  '/ профильная компания, запросили КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '67f94350-e6ba-47b2-b239-3e0f47d4cdcb',
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9e82ed24-7bea-4aa0-936f-13f06dae786d',
  'кп_отправлено',
  '/ секретарь поросил КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'db7c5436-0892-4555-ae04-65a79b74645c',
  'кп_отправлено',
  '/ производители дизель станций, попросили КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'db69f70a-f44d-4d16-8877-25bb2585d9f6',
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3ec79f68-7c33-40db-b36d-1b5a68f727cd',
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ac9e6dfb-12b9-4227-96ee-acf893991da0',
  'кп_отправлено',
  '/ секретарь связала с Александрой, она попросила КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'bf886825-77ad-401f-a6b7-26812af92908',
  'кп_отправлено',
  '/ не ответ на основной КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '69d4f495-db2e-404a-9e27-a68502477f7b',
  'кп_отправлено',
  '/ не ответ на основной КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '74cf4ac0-2cc8-4814-a19b-f96302eaeeb3',
  'кп_отправлено',
  '/ Альберт нач отдела снаб, попросил КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '18d293d8-865f-43b6-92e1-d0644e26d215',
  'кп_отправлено',
  '/  Попросили КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '20fccf87-1138-4505-9e2a-5a9d2736aa14',
  'кп_отправлено',
  '/ не ответ, отправил КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '14cafef0-1282-4d31-92c9-82db930c1c36',
  'кп_отправлено',
  '/ не ответ КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9ff6b15c-b4ea-4fb8-8749-7c103dba07eb',
  'кп_отправлено',
  '/ Ксения секретарь - говорит нет заказов. Протолкнул ей КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '0e5f81e6-1157-459f-8a9a-fdeeb58ca030',
  'кп_отправлено',
  '/ ответил Павел, попросил КП на расмотрение / 02.06.25 - не ответ/',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f5c7f6fe-fab1-4938-bdee-c625e44dea7c',
  'заметка',
  '/ Нужны бетонные КТП и атестация в россети /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'bc010704-ba83-452f-bbdc-0b62944595f9',
  'кп_отправлено',
  '/ производят генераторы, запросили кп на тех отдел /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c88d7211-9eb9-4c1c-8522-279909012fba',
  'заметка',
  '/ Клиент Анара, держать на контроле /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c427f5d5-a0b2-4b65-950f-0da4d5b930d8',
  'кп_отправлено',
  '/ Яна секретарь запросила КП /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '0bd18253-c7d8-4c09-babf-61fcaa50390d',
  'кп_отправлено',
  '/ профильная компания, запросили КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3a59b849-30ad-421a-8465-2106550d796e',
  'кп_отправлено',
  '/ кузнецов Андрей закупщик, отправил КП, его не было на месте /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a58d7458-2a07-453b-be6f-b7d32f0daf50',
  'кп_отправлено',
  '/ секретарь запросил КП организация профильная /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ba464a19-a14b-432c-a1e5-0104dc7fd3e9',
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8266aa1e-c7f0-4aa7-b7b6-cb10033efaca',
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9e445b74-48e0-451e-a295-2637bea30d88',
  'кп_отправлено',
  '/ ответил Георгий, попросил КП на ватсап/',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6d28495e-5890-4e55-9649-53de2d689341',
  'кп_отправлено',
  '/ не ответ, КП на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4300980b-ee50-41e6-bc0b-1a3d734387a4',
  'кп_отправлено',
  '/ответил секретарь, проф организация, запросила КП на Вадима /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '0274f410-cdf4-495e-be7a-164b3c949800',
  'кп_отправлено',
  '/ не ответ, КП на почту / 14.07.25 - закупщик грубит не заебывать часто /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '62cda481-01f6-4969-a64d-09a7b6b6b023',
  'кп_отправлено',
  '/Через секретаря связался с менеджером Антоном, в ходе разговора он понял значемость и передаст КП директору, сказал директор свяжеться с нами/ 10.06.25 -  попросил позвонить 16.06.25 -14:00 / 16.06.25 - попросил набрать 23.06.25 / 25.06.25 - Антон попросил КП на ватсапп и пошол к диру на разговор / Просят атестацию в россети /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b08df7fa-0e2d-414e-ac99-260e7518d2ef',
  'кп_отправлено',
  '/ отправил КП не прошол секретаря / 22.07.25-секретарь говорит наше предложение не актуально /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5a18f055-9e5b-479f-900c-b4d041582318',
  'заметка',
  '/ пока не требуеться / 22.07.25 - пока не требуеться / 11.08.25 - пока нет заказов, набрать 11.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e769c1dd-134e-404f-8845-c411d9d88036',
  'кп_отправлено',
  '/ секретарь попросила КП, и перезвонить 04.07.25 позвать виталия игоривича / 04.07.25.- Виталий говорит берут масло до 630ква, интерестно что когда будет у нас на складе, взял мой номер / 11.08.25 - Виталий не ответил / 08.09.25- запросили цены, набрать 15.09.25 / Виталий говорит интерестно на складе, ждать долго, разговор не о чем, набрать в конце сентября /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7c62fb67-6f57-46fe-a12a-6b972d783ed2',
  'whatsapp',
  '/ Вышел на нач закуп Лев, заинтересовал, взял личный номер, отправил инфу в ватсапп / 30.06.25 - Лев помнит про нас, сейчас нет заказов, ждет новые проекты / 10.07.25 - Лев помнит про нас, ждет заказы / 09.09.25 - написал ему в ватс ап сросил актуальные заказы / 16.04.26 - пока нет действующих проектов /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '667ae957-a5a7-46ac-99b6-8bbca70bce3c',
  'кп_отправлено',
  '/ попросили КП на отдел снабжения для Екатерины / 03.07.25 - екатерина не получила наш КП, попросила повторно,  перезвонить 25.07.25  / 11.08.25 - заявок нет, перезвонить в начале сентября / ПИЗДИТ ЧТО НЕ ИСПОЛЬЗУЮТ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '802ef326-0614-4753-a2b6-22a455459b4e',
  'кп_отправлено',
  '/Секретарь передаст письмо генеральному директору/ 16.06.25 - не пробиваемый секретарь, просит КП / 25.06.25 - не дозвон / 30.06.25 - секретарь не помнит про нас, прислал на почту секретаря КП (дохлый номер) / 22.07.25 - не заинтересовало /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1ac61687-4a0a-4085-9e8c-8a006a817a68',
  'кп_отправлено',
  '/ не пробил, КП отправил / 02.07.25 - секретарь пыталась направить в отдел снабжения не ответ / 03.07.25 - Попал на николая, ему интерестно, дал свой сотовый. отправил инфу на ватсапп / 14.07.25 - цена дорогая на масло, про нас помнит, не задрачивать его /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8316d736-200e-4a7d-94e7-7bd4df33c541',
  'кп_отправлено',
  '/ отправил КП на ватсапп / 25.08..25 - Елена не ответ /  ответила Эльмира, Елена в отпуске до 15.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e470705b-d07d-4196-ae5c-d35cc106cef3',
  'кп_отправлено',
  '/ попросили инф письмо и перезвонить / 10.07.25 - отдел закупок запросил повторно КП, по необходимости свяжуться сами / 25.08.25 - не нужно /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c0b45466-060d-4cda-8f9e-061ca6fe6813',
  'кп_отправлено',
  '/ Секретарь попросила инф письмо на гл инженера / 25.06.25 - Шитов расмотрел КП все понравилось попросилконтактные данные, говорит пока нет заказов, по необходимости свяжеться / 11.08.25 - Павел в отпуске до 25.08.25 / Павел говорит нет заказов, набрать в след году (мажеться урод) /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '86b91813-2a6d-4792-a5b2-d31cae950ea6',
  'заметка',
  '/ Переодически его задрочил/ добавил мой номер в ЧС /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8d8f8b80-4c1c-4752-8fb2-561a72e5160f',
  'кп_отправлено',
  '/Секретарь попросил КП и презвонить в 16:00 по мск Владимиру Анатольевичу / 25.06.25 - Состоялся диалог с Владимиром, заинтересован, будет присылать заказы / 14.07.25 - Владимир не на месте / 25.08.25 - не дозвон /  Владимир говорит пока нет заявок на трансы и ктп, основное это щитовое оборудование набрать 19.09.25  /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'dae03537-f9ff-43cd-bd9f-9cd3f4ab6e8f',
  'кп_отправлено',
  '/ не представился но есть интерес, попросил КП с ценами/ 16.05.25 - о нас помнит, ждет заказы, напоминать о себе переодически / 14.07.25 - Андрей просит набрать 16.07 / 11.08.25 - скоро будет запрос / набрать 17.09.25 я затупил не правельно шашел /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '36ba943b-4032-4981-9adf-b31d50163375',
  'кп_отправлено',
  '/монтажная организация, попросил кп на личный номер ватсапп, перезвонить 27.06.25 / 30.06.25 - Игорь говорит не пока заказов, просил набрать 07.07.25 / 10.07.25 - игорь попросил перезвонить 11.07.25 в 17:00 / 14.07 - пока нет заказов, Игорю интерестно представительство в СПБ, думает в тчечении недели и должен набрать до 18.07.25 / 22.07.25 - не ответ / 11.08.25 - нет заинтересованости, не знает кому предложить /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e5fad5cf-c108-4d37-9496-70514c863605',
  'кп_отправлено',
  '/ не ответ, КП на почту / 02.07.25 - попросили КП на почту и перезвонить 04.07.25 / 04.07.25 - не ответ / 14.07.25 - КП не получили отправил повторно (набрать 23.07) / 24.07.25- сказали не актуально /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '73c6660f-6a89-4144-9d9b-1494992817a2',
  'заметка',
  '/ отдел закупок не отвечает / 02.07.25 - не овет / 14.07 - не ответ / 09.09.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'd7e82ad3-5e59-4a84-8a0e-62ae4ff50dc5',
  'кп_отправлено',
  '/ отправил КП, не очень интерестно / 09.09.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7dd03c9c-0f83-41bd-a660-748f6c0df63f',
  'кп_отправлено',
  '/ закуп евгений, норм диалог, попросил КП / 14.07.25 - не дозвон / 22.07.25 - рынок стоит. пока не актуально. перезвонить 20.08.25 / 25.08.25 - заявок нет пока набрать в начале сентября / 09.09.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ef0ce7f1-19dc-46ce-a756-8a3bea384976',
  'кп_отправлено',
  '/ не ответ, КП на почту / 11.08.25 - запрос КП / 25.08.25 - секретарь не смог соединить с закупом, никто не ответил, попросила инф письмо на почту / 08.09.25 попросили инф письмо на закупки /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'bef8a0bb-4d3d-490e-acf9-cbec7aa435a1',
  'заметка',
  '/ интересны КТП, пока нет заказов / 08.09.25 - тока пришла с отпуска не заявок набрать после 20.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'fe58e86b-13fe-41da-b10e-4c4321fc6e82',
  'кп_отправлено',
  '/ секретарь получил КП / 14.07.25 - компания монтажники, работы нет, просит прозванивать раз в месяц /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9b4a8a92-0174-411d-a883-c37fda5031dd',
  'кп_отправлено',
  '/ Запросил КП / 14.07.25 - Иван не получил КП, дал свой номер и КП на ватсапп / 11.08.25 - Иван не ответ / 08.09.25 - работают с россети, попросил инф письмо на почту, звонить на городской позвать нач закупок, набрать 11.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '55c76df4-1036-485a-8dde-514d58fad2e2',
  'кп_отправлено',
  '/ секретарь приняла КП, дала номер отдела закупок / 11.08.25 - Кравченко Игорь Александрович закуп, запросил КП на почту / 08.09.25 - нашли сами китайцев, пока думают, набрать после 20.09.25.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4d715427-6a2c-4c03-bcea-55db1c97f4ad',
  'кп_отправлено',
  '/ не ответ, отправил КП на почту / 10.07.25 - Секретарь получила КП, перезвонить 15.07.25 / 24.07.25 - решение еще не принято, набрать 30.07.25 / 11.08.25 - не дозвон /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7e0c394c-00b1-46aa-a6b4-7068e2e94f67',
  'кп_отправлено',
  '/ Кирил, получил КП  / 11.08.25 -  не актуально /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6daaedfb-0a81-4b5b-a801-c72a8f1d0cc1',
  'кп_отправлено',
  '/ Евгений Генадьевичь нач снаб, заинтересован, отправил КП / 14.07.25 - не дозвон ИРКУТСК! / Работает Анар / 16.09.25 -  набрать в конце сентября /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e1e2b956-0eea-45c9-9055-a64ed725c04b',
  'кп_отправлено',
  '/ Ответил Павел он получил КП и просил перезвонить 15.07.25 / 15.07.25 - говорит рынок стоит, набрать 29.07.25 / 11.08.25 - пока нет заказов, звонить в сентябре / 01.09.25 - перезвонить 04.09.25 /  09.09.25 - пока нет заказов, набрать в конце сентября /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'df6093d8-623a-476c-b0ca-46df9ca14383',
  'заметка',
  '/ профильная компания, заказы с торгов будут присылать/ 14.07.25 - заинтересовал ивана нашими трансами, он в размышлениях, покажет руководству всю инфу  / 24.07.25 - говорит нет заказов набрать к концу августа / 11.08.25 - не ответ / 08.09.25 - Говорит помнит про нас лучше не названивать /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5c3e4b23-cc99-4dd1-8070-cd6cc50a7f81',
  'кп_отправлено',
  'Рам 04.03 - Профельная компания не получиось обойти секретаря. отправил КП надо прожимать / 14.05.25 - забыли про нас, попросили инф письмо / 20.05.25 -  Секретарь сново попросил КП / 24.07.25 - директор по снабжению в отпуске / 11.08.25 - секретарь не помнит о нас запросила КП, набрать 25.08.25 / 09.09.25 попросила инф письмо, не пробиваемы секритарь, звонить в конце сентября  /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e06ecbb2-48e4-4438-8968-6cbc24996b2a',
  'заметка',
  '/ Эмиль заинтересовался, нужно добивать, набрать 28.07.25 / 11.08.25 - пока рынок стоит, о нас помнит, набрать 25.08.25 / 29.08.25 - Эмиль спросил цену 400ква тмг, сколький тип /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '165bfd7f-065c-4d12-be70-077d0899901b',
  'кп_отправлено',
  'Отправил, КП. Берут под торги, нужно прожимать / 09.09.25 - нет заказов /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e5b883a2-e648-40c1-8e66-8539456f8941',
  'whatsapp',
  '/ Отправил на ватсапп инфу, заказов нет / 09.09.25 - не ответ александр /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e5112d7c-0fe0-428b-b1dd-94f0b0ba74e6',
  'кп_отправлено',
  'Василий попросил КП, и перезвонить 28.07.25 / 09.09.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '00249ae2-1970-4ec8-9b20-aaa88fb0bbc4',
  'письмо',
  '/ Азат запросил инф письмо и перезвонить 24.07.25 / 24.07.25 - пока не интересно, набрать к коцу августа / 29.08.25 - спорили с азатом по цене, запросил прайс, след созвон 10-15 сентября / 09.09.25 - не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'abd61738-1297-4ed2-97c9-b28eb589225a',
  'письмо',
  '/ Секретарь получила инф письмо / 09.09.25- не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '03a68ffa-16da-4d5a-9439-f461e7bf7892',
  'письмо',
  '/ инф письмо на почту, проверить рассмотрение / 24.07.25 - если не связались значит нет надобности, набрать в середине августа / 29.08.25 - повторно инф письмо попросили и набрать 5 сентября / 09.09 25 - не помнят про нас, попросили повторное инф письмо /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '974599f4-a7ce-4918-b154-f0e1d49450e8',
  'кп_отправлено',
  '/ не ответ инф письмо на почту / 24.07.25 - попросили повторное КП, если интерестно свяжуться  /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5f20b426-5971-4d0c-9ea4-f15f0f16a9a8',
  'заметка',
  '/ трудные, инф на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '95dc25e8-0cc1-44d2-9dcd-ea1d9c3977e0',
  'whatsapp',
  '/ Работают с россетями, поговорит с начальством набрать  24.07.25 / 24.07.25 - александр дал свой номер отправил ему инфу и видео на ватсапп, сказал обсудит с начальством и перезвонит / 24.07.25 - не заинтересованы, работают с россети /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7a09667c-d62d-431e-bd20-a5b44f8d82e3',
  'заметка',
  'Ответил гореев рассул  инфу принял, интерестно, набрать 01.09.25 / 09.09.25 - Сергей занят, набрать 11.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1b793b65-ed06-49ee-99bc-b5de6e14114a',
  'кп_отправлено',
  '/ запросили КП и набрать 15.08.25 / 08.09.25 - нет заказов /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'ab323268-6e7c-401e-a483-eeccde688b35',
  'кп_отправлено',
  '/ мария запросила КП на общую почту / 09.09.25 - закуп не ответ /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a1cf87aa-d981-44f5-b68e-e6d1379b601f',
  'письмо',
  '/ ответил Александр, запросил инф письмо / 09.09.25 - пока нет потребности, 22.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1cbfa4e7-967c-4dac-b399-38db834d5e21',
  'письмо',
  '/ Владиславу интерестно из наличия, заявки есть постоянно у них, запросил инф письмо, нужно доробатывать,   набрать 15.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6c5ebd68-e412-4c9a-900d-2b380f801c88',
  'письмо',
  '/ Секретарь запросила инф письмо, работают на довальческом, уточнить расмотрение 15.09.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8f08c354-2a8a-424d-b2d4-ce736c354362',
  'заметка',
  '/ 16.09.25 - наш товар редкий, основное это щитовое, запрос инф на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c02743c3-8bdb-482d-be48-e35a6112b8fd',
  'письмо',
  '/30.09.25 инф письмо на почту /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '52142b09-a7c7-45ca-8ba1-b253d34953db',
  'кп_отправлено',
  '/Алексей закупщик, заинтересован, попросил КП с ценами/ 16.06.25 - Александр Сухоруков, попросил КП, Алексей в опуске / 19.06.25 - прислапли на почту заявку на тсл 3150 / 26.06.25 - Яков мажеться, говорит некогда,прислал на почту запрос от СБ  / 01.07.25 - отправленные пояснения и бизнес карта / 09.07.25 - нет на месте / 14.07.25 - Яков просит позвонит 16.07.25 / 18.07.25 - Яков скинул заявку на сухие трансы, кп отправленно 21.07.25 / 22.07.25 - яков попросил цены на масло от 630 до 2500 ква в ознакомительных целях, задал эмми вопрос по доставке и диллерству / 11.08.25 - не дозвон / 30.09.25 - Яков просит набрать 08.10.25 обсудить конкретику /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'efa81474-6c5e-4d00-ba88-0bdcb8e5aa3a',
  'кп_отправлено',
  '/Вышел на закуп, отправил КП/ Пришла заявка на транс тока, запрос отправил ерболу/ 04.07.25 - не ответ / 11.08.25 - пока нет заказов /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c10a12ba-0957-440c-9f60-7bddc5ade57d',
  'кп_отправлено',
  '/ Хороший заход, запросили КП на почту / 14.07.25- Сергей не на месте, набрать 15.07.25 / 22.07.25 - пока нет заказов, но интерестно, скинет на почту пример для просчета / 24.07.25 - отправил каталог / 11.08.25 - прислали опросник на тсл 2000 ответ на почту / 28.08.25 - в ответ на кп прислал запрос на 1250 сухой медь / 30.09.25 - пока нет запросов про нас помнит, сильно не задрачивать /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a5eec0ab-29cb-4f17-9cde-e73bcf6a81cb',
  'whatsapp',
  '/ не ответ инф на почту / 24.07.25 - Александру очень интерестно поставки из китая, дал свой номер и запросил инфу на ватсапп / 09.09.25 - занят на пергаворах / 16.09.25 - интересны от 110 кв, о нас ппомнит сильно не задрачивать, звонок начало октября /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'd15c1ee7-88bd-477e-9f5a-f7fd5840e798',
  'кп_отправлено',
  '/ Берут наш товар, Евгений попросил КП на почту / 02.06.25 - нет заявок, попросил набрать в конце месяца/  05.08.25.- евгений попросил инфу на ватс апп и обещал заявку / 30.09.25 - попросил почту, есть заказ на ктп /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'd2c57ce8-fd5f-4ecc-a722-8dc1b0e8ec0c',
  'кп_отправлено',
  '/ закуп Сергей, плотно поговорили про китай и энергоэфективность .КП отправил/ 19.06 - он не получил инфу про нас, отправил повторно, долго тележили за китай, он пытался навялить что херня / 30.06.25 - Сергей запросил больше информации о трансформаторах, расширенный протокол испытаний (вопрос ерболу) / 10.07.25 - расширенные испытания отправленны, сергей не отвечает на телефон / 14.07.25 - Сергей в отпуске до 25.07.25 / 11.08.25 - мозгоеб про то что трансы не соответствуют ГОСТ, просит набрать 14.08.25 /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b74491f4-8321-4ddd-8c54-c86737e167a9',
  'кп_отправлено',
  '/ Андрей нач снаб, заинтересован в трансах / 30.06.25 - КП на рассмотрении ТЕХ отдела, просил набрать 14.07.25 / 14.07.25 - Андрей говорит тех отдел пока не рассмотрел наше предложение, наберт сам, если долго не выйдет на связь прожать его / 11.08.25 - пока нет заказ, набрать 25.08.25 / 25.08.25 - Андрей запросил 1250 сухой /',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a373c577-d9d7-4085-ba83-9ffe33e35116',
  'звонок',
  '/ 16.09.25 - не дозвон инф на почту / 30.09.25 - Александр попросил инф на почту / 22.12.25 - прислал запрос на тмг 2500 и 630',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9573e218-0cb9-4906-be6f-1f041915485d',
  'заметка',
  'Жду опросный лист БКТП. Свяжеться сам Вышел на ЛПР .',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '57ebe248-e1dc-4c0a-a363-248fca6a0659',
  'кп_отправлено',
  'Отправил после звонка КП на почту. Не прошел секретаря',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '412e406e-5603-428c-8560-99c3b519d72b',
  'кп_отправлено',
  'Отправил КП на почту . Не прошел секретаря',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '0beebb18-0c48-443b-9654-3c68a93023dc',
  'заметка',
  'НЕ ЗАКУПАЮТ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c506ddff-f591-4ecc-90d7-cc3a212f5ee8',
  'заметка',
  'Отправил на имя генерального директора ком перд на почту. Не прошел секретаря',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'caff5e4e-8605-46f2-b824-694d2590001f',
  'заметка',
  'Отрпавил информацию в whats app. Сказал вышлет пару опросных на подстанции.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f6241e76-765e-4ce2-b782-5f81ee14be4e',
  'кп_отправлено',
  'Продукция интересует. Отправил на почту коммерческое предложение.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1ab455e4-b1cf-41b4-97a1-85dfd294d0fd',
  'заметка',
  'Потенциально могут закупать трансформаторы.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '06f74724-51ae-4bbc-8416-f1720a40aeb2',
  'заметка',
  'Знают про СВЕРДЛОВЭЛЕКТРОЩИТ. Потербности нет.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '15ebbc2a-795e-45ba-bab8-c011f32c8071',
  'заметка',
  'Отправил информацию в отдел снабжения через секретаря. Возможно заинтересуются',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3aedb687-06da-4a2e-b574-3207e281d88f',
  'заметка',
  'Перезвонить, потенциально могут закупать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '88529d23-9d44-40b7-8f54-a5214cf6aad0',
  'whatsapp',
  'Потенциальный клиент, вышел на личный контакт whatsapp, обратится при потребности',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b8e83983-5240-4fc7-a3db-3e4bec65a63b',
  'кп_отправлено',
  'Есть интерес в закупке НОВЫХ трансформаторов. Покупают у энетры и в брянске. ОТПРАВИТЬ КП на почту.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a9abaa20-f336-4074-9e28-bec3ce8962ae',
  'заметка',
  'Дозвонится',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3515e818-0754-4b0a-b188-0251374c39f4',
  'заметка',
  'Дальний восток, связаться , потеницально могут закупать. Не ответил',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4728906d-661f-4425-8eb3-dd42341b7d54',
  'заметка',
  'Отправил информацию на почту, переодически есть потребность , можем сработать в будущем.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1e322444-cdea-47ab-8d2f-3f6107b4eeaa',
  'кп_отправлено',
  'Не довзонился. Отправил предложение на почту в отдел закупок.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'c5de8f62-a0ac-4e1d-8f11-e0aa085ec74f',
  'заметка',
  'Написал на почту. Позвонить. Дальний восток.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '2d8dd193-ede7-459c-bb92-7510fe3db133',
  'кп_отправлено',
  'Заполнил форму обратной связи. Выслал КП. Можно позвонить днем.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '339a30d3-0521-481c-8cd2-73d449d18662',
  'заметка',
  'Отправил форму обратной связи . Можно позвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '3f78eb8d-0586-4048-b738-df6461ec1484',
  'кп_отправлено',
  'Непрофильно, но участвуют в торгах. Отправил КП. Можно позвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'eccc8d74-731c-423f-9d78-7df628f5a69d',
  'заметка',
  'Направил информацию на почту. Телефон не доступен.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b5bd2ed0-a607-40f6-8dbc-b00321c431f5',
  'кп_отправлено',
  'ЗВОНИЛ, СКАЗАЛИ ВСЕ ТОЛЬКО ЧЕРЕЗ ТОРГИ. ОТПРАВИЛ КП НА ПОЧТУ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '60d55160-ee0a-492e-9892-99d67e3e3872',
  'кп_отправлено',
  'Отправил КП на почту. Не прошел секретаря.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'bb03c240-8e26-49c0-8cc1-796412989513',
  'заметка',
  'Закупают только через тендерные площадки. Можно попробовать пробится к ЛПР.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '6d954d59-9ef4-428a-8e96-33acaff98f16',
  'заметка',
  'Закупают трансформаторы. Хорошо разбирается в рынке, представился как диллер уральского силового',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '2552a599-d799-4c4d-b347-dc5206a8186a',
  'заметка',
  'Закупают трансформаторы. На лпр не вышел, но добавили в список поставщиков.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '904d3247-b73c-42cd-babc-b74091918d4a',
  'заметка',
  'не закупают',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '22590573-3593-4be0-a6e8-56b499270bf1',
  'заметка',
  'Строительно-монтажные работы, потенциально сильный клиент. Не ответил.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4ec23383-c48c-402b-b45c-e6be7745d711',
  'заметка',
  'Используют давальческий материал.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '549c2013-3137-4d6b-8a86-b7f7459508ec',
  'заметка',
  'Закупают через B2B',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e659e876-68da-48ba-a62f-bbc05614ee09',
  'кп_отправлено',
  'Закупают трансы. Можно пробивать. Отправил КП УСТ на почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '4e400dab-742c-4cac-9afb-8d37f3fae62f',
  'кп_отправлено',
  'Не дозвонился. Сетевая компания. Проводят торги. Скинул КП на почту от УралСилТранс',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '48b158a9-3c2f-4a08-b9ff-a2b7b94d6315',
  'заметка',
  'Созвонился. Есть дейсвтующий партнер - завод. Новых не рассматривает. Возможно пробить в будущем',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b2912e28-d14e-4e49-94b7-aeeaa4ade088',
  'заметка',
  'Аварийная служба. Есть форма для поставщиков. Заполнил, отправил. Можно позвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8f8fd0ec-f7c2-4ac1-850b-3273aed46da9',
  'заметка',
  'Номера не доступны',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a13e3d9a-38bb-4e1f-a0dd-240eb002fc6f',
  'whatsapp',
  'Отправил информацию по уралсилтранс в ватсапп. Пока нет ответа',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '35b2f34b-b304-40b7-aa5f-e12b519c024a',
  'заметка',
  'не закупают',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '05ba3a8f-5d73-41a2-8621-9ae2b543c705',
  'заметка',
  'Набрать !',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '5c185a66-034a-47e2-b113-3f1295642031',
  'кп_отправлено',
  'Отправил КП на почту. Завтра набрать или в ватсапп написать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b7fbe664-13b1-442e-af0a-7389b1a1ee43',
  'заметка',
  'Выполняют кадастровые работы. Вряд ли связаны с оборудованием, но можно пробовать.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'f4cd585e-e61c-41d6-80e8-b017c7bdfdce',
  'заметка',
  'Не пробил серетаря.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a50e3f58-0af3-41ab-9ba5-22b8f4df7c57',
  'кп_отправлено',
  'Отправил КП на почту, набрать. Сотрудничают через почту',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'aa5c7774-9906-4580-b6bb-5a73e1d28e20',
  'кп_отправлено',
  'Отправил КП на почту. Занимаются ремонтом, могут купить теоритически. Написать в ватсапп, набрать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '92889345-cbca-48b7-b72f-58e233e90d6c',
  'кп_отправлено',
  'Направил КП на почту. Заполнил форму обратной связи. Можно прозвонить',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a3df5d9b-66e1-4964-a56f-cb685901d06c',
  'кп_отправлено',
  'Направил кп на почту. можно набрать. собирают ктп',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8b4768b7-0cbf-497d-88d6-54cb119391e1',
  'кп_отправлено',
  'Направил КП на почту. Собирают подстанции. Можно набрать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a791f888-a2b9-4aaf-808b-64978139b27b',
  'кп_отправлено',
  'Направил кп на почту. Торговая компания. Обязательно набрать.  Диллеры завода СЗТТ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '8933600f-0121-48b8-9903-5e7d78f1c084',
  'кп_отправлено',
  'Направил КП. Занимаются монтажом энергообъектов',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'fef160d7-a332-4c0c-b578-28083d90ed7a',
  'кп_отправлено',
  'Созвонился. Закупают. Целевой. Отправил КП  Совзонится в  среду.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '42a1eb3d-a58f-4ae4-a23e-7a39711b7be8',
  'кп_отправлено',
  'НАПРАВИЛ КП В ВАТСАПП И ПОЧТУ. ЖДУ ОБРАТКУ',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '1edfbbee-9604-44ef-8f01-7d56f64be8a2',
  'заметка',
  'НАПРАВИЛ НА ПОЧТУ. мЕЛКАЯ КОМПАНИЯ НО УЧАСТВУЕТ В ТОРГАХ.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '9fd6de94-7edc-4e94-aee7-fe67d8d0fe65',
  'кп_отправлено',
  'Направил на почту коммерческое предложение. Телефона нет.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '03803a54-ee9a-4b95-afae-ea5ec35d517d',
  'заметка',
  'Очень редко берут трансформаторы. Можно периодически выходить на связь.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '36b4559f-e9a3-41ef-af0e-13afb7b76b5a',
  'кп_отправлено',
  'Созвонился, закупают. Передаст КП менеджерам. Отправляю СЭЩ. Можно позже Уралсилтранс',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e7ced46c-b4e3-41e5-8916-24e3bb0811ff',
  'кп_отправлено',
  'Набрал. Пока заявок, но закупают, можно сотрудничать. Отправил КП на почту. Переодически набирать. СЭЩ отправил, потом пробью СилТрансом',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e620fb38-b438-4197-ab6d-bd02d8584d6f',
  'заметка',
  'Аварийная служба. Есть форма для поставщиков. Заполнил, отправил. Можно позвонить. Отправил от СИЛТРАНСА',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '141cd122-6391-483f-adee-7d18743b3b0d',
  'заметка',
  'Дозвонился. Закупают. Выслал инфу на почту с 2мя предложениями.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'e6a1ab3e-a674-4b74-92f0-ff5014d12070',
  'заметка',
  'Закупают у табриза и поставляют ему. Можно позже пробивать от силтранса и предлагать китай',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'dffe7382-7664-4cab-838f-f67e5eb273ba',
  'звонок',
  'Не дозвонился. Отправить на почту.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'a7b3986e-4315-43b2-bfc2-0f473f2183e1',
  'заметка',
  'Набрать по их времене. Скорее всего закупают.',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '34b373b0-b75a-4af1-93fe-34257f84c596',
  'кп_отправлено',
  'Не закупают, но запросил КП , отправил ему на почту . Можно пробивать',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  'b6c405da-1dc5-4ef7-872b-bee50e4aaad7',
  'заметка',
  'Знает Табриза. Очень редко закупают. Можно бить от уралсилтранса',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '7e43dcf5-b0b8-4e94-935b-946adb77e4ff',
  'заметка',
  'Пока нет потребности, но в будущем может быть',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '611846a3-1a55-409e-8bc8-73a53ac66dc2',
  'кп_отправлено',
  'Не дозвонился. Отправить КП на почту. Дозвонится',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '14dde2b3-9870-406b-966f-4e299923bd84',
  'заметка',
  'Есть в будущем заявка на 2000 ква',
  now()
);

INSERT INTO activities (company_id, type, content, created_at) VALUES (
  '2854ca39-f27d-4f31-be9b-cefe6efac27e',
  'кп_отправлено',
  'Поставляют оборудование. Скинул КП на рассмотерние',
  now()
);

-- ================================================================
-- INSERT PROPOSALS (КП — коммерческие предложения)
-- ================================================================

-- Proposal КП-001 for: ООО "НПО АР-ТЕХНОЛОГИИ" (company_id: b74491f4-8321-4ddd-8c54-c86737e167a9)
INSERT INTO proposals (id, company_id, manager_name, number, status, total_amount, valid_until, notes, created_at) VALUES (
  '999f9d01-7ab3-4399-a580-5b155d843cb5',
  'b74491f4-8321-4ddd-8c54-c86737e167a9',
  'Рам',
  'КП-001',
  'отправлено',
  2952000,
  '2025-09-02',
  'Запрос от 2025-08-29',
  '2025-08-29'
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  '999f9d01-7ab3-4399-a580-5b155d843cb5',
  'ТСЛ 1250/20-10/0.4 Алюминь',
  1,
  'шт.',
  1600000,
  1600000
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  '999f9d01-7ab3-4399-a580-5b155d843cb5',
  'ТСЛ 1250/10/0.4 алюминь',
  1,
  'шт.',
  1352000,
  1352000
);

-- Proposal КП-002 for: ООО "ЦРЗЭ" (company_id: c10a12ba-0957-440c-9f60-7bddc5ade57d)
INSERT INTO proposals (id, company_id, manager_name, number, status, total_amount, valid_until, notes, created_at) VALUES (
  '39b6106d-1808-48ce-9cf9-23c06b01f811',
  'c10a12ba-0957-440c-9f60-7bddc5ade57d',
  'Рам',
  'КП-002',
  'отправлено',
  4380000,
  '2025-09-01',
  'Запрос от 2025-08-29',
  '2025-08-29'
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  '39b6106d-1808-48ce-9cf9-23c06b01f811',
  'ТСЛ 1250/10/0.4 медь',
  2,
  'шт.',
  2190000,
  4380000
);

-- Proposal КП-003 for: ООО "ПЭП" (company_id: 2a9e107f-16d7-4d23-a7f8-ebc4e6371744)
INSERT INTO proposals (id, company_id, manager_name, number, status, total_amount, valid_until, notes, created_at) VALUES (
  'e8386499-ffe0-41e6-b05c-6f0f544381c4',
  '2a9e107f-16d7-4d23-a7f8-ebc4e6371744',
  'Рам',
  'КП-003',
  'отправлено',
  0,
  NULL,
  'Запрос от 2025-09-11',
  '2025-09-11'
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  'e8386499-ffe0-41e6-b05c-6f0f544381c4',
  'трднс 25 000',
  1,
  'шт.',
  0,
  0
);

-- Proposal КП-004 for: ООО "РиМтехЭнерго" (company_id: d15c1ee7-88bd-477e-9f5a-f7fd5840e798)
INSERT INTO proposals (id, company_id, manager_name, number, status, total_amount, valid_until, notes, created_at) VALUES (
  '13806372-04d0-4ceb-b891-777f78790ce5',
  'd15c1ee7-88bd-477e-9f5a-f7fd5840e798',
  'Рам',
  'КП-004',
  'отправлено',
  0,
  NULL,
  'Запрос от 2025-09-30',
  '2025-09-30'
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  '13806372-04d0-4ceb-b891-777f78790ce5',
  '2ктп 3150 сухари',
  1,
  'шт.',
  0,
  0
);

-- Proposal КП-005 for: ООО "ПКФ "ТСК" (company_id: a373c577-d9d7-4085-ba83-9ffe33e35116)
INSERT INTO proposals (id, company_id, manager_name, number, status, total_amount, valid_until, notes, created_at) VALUES (
  '0dad2a1b-f313-4fdb-9fe4-0a9b66f8819f',
  'a373c577-d9d7-4085-ba83-9ffe33e35116',
  'Рам',
  'КП-005',
  'отправлено',
  0,
  NULL,
  'Запрос от неизвестно',
  now()
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  '0dad2a1b-f313-4fdb-9fe4-0a9b66f8819f',
  'Прошу дать цену на трансформаторы',
  1,
  'шт.',
  0,
  0
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  '0dad2a1b-f313-4fdb-9fe4-0a9b66f8819f',
  '1. ТМГ-630 10/0,4 D/Yн  -  (S9-630 10/0,4 D/Yн)',
  2,
  'шт.',
  0,
  0
);

INSERT INTO proposal_items (proposal_id, product_name, quantity, unit, price_per_unit, total_price) VALUES (
  '0dad2a1b-f313-4fdb-9fe4-0a9b66f8819f',
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

