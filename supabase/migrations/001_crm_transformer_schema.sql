-- ================================================================
-- PulseCRM — Transformer Equipment Business Schema Migration
-- Run this SQL in Supabase SQL Editor
-- ================================================================

-- ── 1. COMPANIES (replaces clients) ─────────────────────────────
CREATE TABLE IF NOT EXISTS companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,                          -- Название компании
  inn TEXT,                                    -- ИНН
  city TEXT,                                   -- Город
  website TEXT,                                -- Сайт
  contact_phone TEXT,                          -- Основной телефон
  contact_email TEXT,                          -- Основной email
  source TEXT DEFAULT 'холодный обзвон',       -- Источник: входящая заявка / реклама / холодный обзвон / личный контакт
  status TEXT DEFAULT 'слабый интерес',        -- Статус: слабый интерес / надо залечивать / сделал запрос / сделал заказ
  manager_id UUID REFERENCES users(id),        -- Ответственный менеджер
  next_contact_date DATE,                      -- Дата следующего контакта
  lost_reason TEXT,                            -- Причина отказа
  notes TEXT,                                  -- Заметки
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Index for INN duplicate detection
CREATE INDEX IF NOT EXISTS idx_companies_inn ON companies(inn) WHERE inn IS NOT NULL;
-- Index for manager filtering
CREATE INDEX IF NOT EXISTS idx_companies_manager ON companies(manager_id);
-- Index for overdue detection (next_contact_date)
CREATE INDEX IF NOT EXISTS idx_companies_next_contact ON companies(next_contact_date) WHERE next_contact_date IS NOT NULL;
-- Index for status filtering
CREATE INDEX IF NOT EXISTS idx_companies_status ON companies(status);

-- ── 2. COMPANY CONTACTS (ЛПР — multiple per company) ──────────
CREATE TABLE IF NOT EXISTS company_contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  name TEXT NOT NULL,                          -- ФИО
  position TEXT,                               -- Должность (закупщик, гл. инженер, директор и т.д.)
  phone TEXT,                                  -- Телефон
  email TEXT,                                  -- Email
  whatsapp TEXT,                               -- WhatsApp номер
  notes TEXT,                                  -- Заметки о контакте
  is_primary BOOLEAN DEFAULT false,            -- Основной ЛПР
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_contacts_company ON company_contacts(company_id);

-- ── 3. ACTIVITIES (enhanced timeline) ───────────────────────────
-- Replaces the old activities table
CREATE TABLE IF NOT EXISTS activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID REFERENCES companies(id) ON DELETE SET NULL,
  contact_id UUID REFERENCES company_contacts(id) ON DELETE SET NULL,
  user_id UUID REFERENCES users(id),
  type TEXT DEFAULT 'звонок',                  -- Тип: звонок / письмо / whatsapp / встреча / кп_отправлено / заметка / статус_изменен
  content TEXT NOT NULL,                       -- Содержание
  next_contact_date DATE,                      -- Если из активности следует следующий контакт
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_activities_company ON activities(company_id);
CREATE INDEX IF NOT EXISTS idx_activities_user ON activities(user_id);
CREATE INDEX IF NOT EXISTS idx_activities_date ON activities(created_at DESC);

-- ── 4. PROPOSALS (КП — коммерческие предложения) ───────────────
CREATE TABLE IF NOT EXISTS proposals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  manager_id UUID REFERENCES users(id),
  number TEXT,                                 -- Номер КП
  status TEXT DEFAULT 'отправлено',            -- отправлено / рассматривается / принято / отклонено
  total_amount BIGINT DEFAULT 0,               -- Общая сумма в рублях
  valid_until DATE,                            -- Срок действия
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_proposals_company ON proposals(company_id);

-- ── 5. PROPOSAL ITEMS (позиции КП) ─────────────────────────────
CREATE TABLE IF NOT EXISTS proposal_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  proposal_id UUID NOT NULL REFERENCES proposals(id) ON DELETE CASCADE,
  product_name TEXT NOT NULL,                  -- Наименование товара
  description TEXT,                            -- Описание
  quantity INT DEFAULT 1,                      -- Количество
  unit TEXT DEFAULT 'шт.',                     -- Единица измерения
  price_per_unit BIGINT DEFAULT 0,             -- Цена за единицу
  total_price BIGINT DEFAULT 0,                -- Сумма (quantity * price_per_unit)
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_proposal_items_proposal ON proposal_items(proposal_id);

-- ── 6. ENHANCED TASKS ───────────────────────────────────────────
-- Add columns to existing tasks table
ALTER TABLE tasks ADD COLUMN IF NOT EXISTS company_id UUID REFERENCES companies(id) ON DELETE SET NULL;
ALTER TABLE tasks ADD COLUMN IF NOT EXISTS is_recurring BOOLEAN DEFAULT false;
ALTER TABLE tasks ADD COLUMN IF NOT EXISTS recurrence_days INT DEFAULT 0;   -- Repeat every N days (0 = not recurring)
ALTER TABLE tasks ADD COLUMN IF NOT EXISTS last_recurrence DATE;
ALTER TABLE tasks ADD COLUMN IF NOT EXISTS is_shared BOOLEAN DEFAULT false;   -- Visible to all managers

-- ── 7. ENABLE ROW LEVEL SECURITY ────────────────────────────────
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE company_contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;

-- ── 8. RLS POLICIES ─────────────────────────────────────────────
-- Companies: manager sees own, all see overdue (>3 days past next_contact_date)
CREATE POLICY "companies_select" ON companies FOR SELECT USING (
  manager_id = auth.uid()
  OR next_contact_date < (CURRENT_DATE - INTERVAL '3 days')
  OR status = 'сделал заказ'
);

CREATE POLICY "companies_insert" ON companies FOR INSERT WITH CHECK (manager_id = auth.uid());
CREATE POLICY "companies_update" ON companies FOR UPDATE USING (
  manager_id = auth.uid()
  OR next_contact_date < (CURRENT_DATE - INTERVAL '3 days')
);
CREATE POLICY "companies_delete" ON companies FOR DELETE USING (manager_id = auth.uid());

-- Company contacts: accessible if company is accessible
CREATE POLICY "contacts_select" ON company_contacts FOR SELECT USING (
  EXISTS (SELECT 1 FROM companies WHERE companies.id = company_contacts.company_id AND (
    companies.manager_id = auth.uid()
    OR companies.next_contact_date < (CURRENT_DATE - INTERVAL '3 days')
    OR companies.status = 'сделал заказ'
  ))
);
CREATE POLICY "contacts_insert" ON company_contacts FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM companies WHERE companies.id = company_contacts.company_id AND companies.manager_id = auth.uid())
);
CREATE POLICY "contacts_update" ON company_contacts FOR UPDATE USING (
  EXISTS (SELECT 1 FROM companies WHERE companies.id = company_contacts.company_id AND (
    companies.manager_id = auth.uid()
    OR companies.next_contact_date < (CURRENT_DATE - INTERVAL '3 days')
  ))
);
CREATE POLICY "contacts_delete" ON company_contacts FOR DELETE USING (
  EXISTS (SELECT 1 FROM companies WHERE companies.id = company_contacts.company_id AND companies.manager_id = auth.uid())
);

-- Activities: see activities for accessible companies + own activities
CREATE POLICY "activities_select" ON activities FOR SELECT USING (
  user_id = auth.uid()
  OR EXISTS (SELECT 1 FROM companies WHERE companies.id = activities.company_id AND (
    companies.manager_id = auth.uid()
    OR companies.next_contact_date < (CURRENT_DATE - INTERVAL '3 days')
    OR companies.status = 'сделал заказ'
  ))
);
CREATE POLICY "activities_insert" ON activities FOR INSERT WITH CHECK (user_id = auth.uid());

-- Proposals: accessible if company is accessible
CREATE POLICY "proposals_select" ON proposals FOR SELECT USING (
  manager_id = auth.uid()
  OR EXISTS (SELECT 1 FROM companies WHERE companies.id = proposals.company_id AND (
    companies.manager_id = auth.uid()
    OR companies.next_contact_date < (CURRENT_DATE - INTERVAL '3 days')
    OR companies.status = 'сделал заказ'
  ))
);
CREATE POLICY "proposals_insert" ON proposals FOR INSERT WITH CHECK (manager_id = auth.uid());
CREATE POLICY "proposals_update" ON proposals FOR UPDATE USING (manager_id = auth.uid());
CREATE POLICY "proposals_delete" ON proposals FOR DELETE USING (manager_id = auth.uid());

-- Proposal items: accessible via proposal
CREATE POLICY "proposal_items_select" ON proposal_items FOR SELECT USING (
  EXISTS (SELECT 1 FROM proposals WHERE proposals.id = proposal_items.proposal_id AND proposals.manager_id = auth.uid())
);
CREATE POLICY "proposal_items_insert" ON proposal_items FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM proposals WHERE proposals.id = proposal_items.proposal_id AND proposals.manager_id = auth.uid())
);
CREATE POLICY "proposal_items_update" ON proposal_items FOR UPDATE USING (
  EXISTS (SELECT 1 FROM proposals WHERE proposals.id = proposal_items.proposal_id AND proposals.manager_id = auth.uid())
);
CREATE POLICY "proposal_items_delete" ON proposal_items FOR DELETE USING (
  EXISTS (SELECT 1 FROM proposals WHERE proposals.id = proposal_items.proposal_id AND proposals.manager_id = auth.uid())
);

-- ── 9. UPDATED_AT TRIGGER ───────────────────────────────────────
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER companies_updated_at BEFORE UPDATE ON companies
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER proposals_updated_at BEFORE UPDATE ON proposals
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ── 10. SEED PIPELINE STAGES (if not exist) ─────────────────────
INSERT INTO pipeline_stages (pipeline_id, name, position, probability, color, is_won, is_closed)
SELECT
  'default',
  stage_name,
  stage_pos,
  stage_prob,
  stage_color,
  stage_won,
  stage_closed
FROM (VALUES
  ('Слабый интерес', 1, 10, '#94a3b8', false, false),
  ('Надо залечивать', 2, 30, '#f59e0b', false, false),
  ('Запрос КП', 3, 50, '#3b82f6', false, false),
  ('В работе', 4, 70, '#8b5cf6', false, false),
  ('Заказ', 5, 100, '#22c55e', true, false),
  ('Отказ', 6, 0, '#ef4444', false, true)
) AS t(stage_name, stage_pos, stage_prob, stage_color, stage_won, stage_closed)
WHERE NOT EXISTS (SELECT 1 FROM pipeline_stages WHERE name = stage_name AND pipeline_id = 'default');
