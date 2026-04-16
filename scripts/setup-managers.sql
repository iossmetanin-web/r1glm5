-- ================================================================
-- PulseCRM — Setup Manager Accounts + Link to Companies
-- Run this in Supabase SQL Editor AFTER import-data.sql
-- ================================================================
-- This script:
-- 1. Creates 4 auth users (Алик, Магел, Рам, Анар)
-- 2. Creates CRM user profiles
-- 3. Links all companies to their managers by manager_name
-- 4. Links proposals to their managers by manager_name
-- ================================================================

-- ── Step 1: Create Auth Users ────────────────────────────────────
-- Password: Crm2025! for all users (change after first login)

-- Алик
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token,
  recovery_token, email_change_token_new, email_change, last_sign_in_at,
  password_hash, phone, phone_change, phone_change_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-bbbb-4ccc-aaaa-000000000001',
  'authenticated',
  'authenticated',
  'alik@crm.pulse',
  crypt('Crm2025!', gen_salt('bf')),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Алик"}',
  now(),
  now(),
  '',
  '',
  '',
  '',
  now(),
  '',
  '',
  '',
  ''
);

-- Магел
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token,
  recovery_token, email_change_token_new, email_change, last_sign_in_at,
  password_hash, phone, phone_change, phone_change_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-bbbb-4ccc-aaaa-000000000002',
  'authenticated',
  'authenticated',
  'magel@crm.pulse',
  crypt('Crm2025!', gen_salt('bf')),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Магел"}',
  now(),
  now(),
  '',
  '',
  '',
  '',
  now(),
  '',
  '',
  '',
  ''
);

-- Рам
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token,
  recovery_token, email_change_token_new, email_change, last_sign_in_at,
  password_hash, phone, phone_change, phone_change_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-bbbb-4ccc-aaaa-000000000003',
  'authenticated',
  'authenticated',
  'ram@crm.pulse',
  crypt('Crm2025!', gen_salt('bf')),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Рам"}',
  now(),
  now(),
  '',
  '',
  '',
  '',
  now(),
  '',
  '',
  '',
  ''
);

-- Анар
INSERT INTO auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token,
  recovery_token, email_change_token_new, email_change, last_sign_in_at,
  password_hash, phone, phone_change, phone_change_token
) VALUES (
  '00000000-0000-0000-0000-000000000000',
  'aaaaaaaa-bbbb-4ccc-aaaa-000000000004',
  'authenticated',
  'authenticated',
  'anar@crm.pulse',
  crypt('Crm2025!', gen_salt('bf')),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"full_name":"Анар"}',
  now(),
  now(),
  '',
  '',
  '',
  '',
  now(),
  '',
  '',
  '',
  ''
);

-- ── Step 2: Create CRM User Profiles ────────────────────────────

INSERT INTO users (id, name, email, role) VALUES
  ('aaaaaaaa-bbbb-4ccc-aaaa-000000000001', 'Алик', 'alik@crm.pulse', 'admin'),
  ('aaaaaaaa-bbbb-4ccc-aaaa-000000000002', 'Магел', 'magel@crm.pulse', 'admin'),
  ('aaaaaaaa-bbbb-4ccc-aaaa-000000000003', 'Рам', 'ram@crm.pulse', 'admin'),
  ('aaaaaaaa-bbbb-4ccc-aaaa-000000000004', 'Анар', 'anar@crm.pulse', 'admin')
ON CONFLICT (id) DO NOTHING;

-- ── Step 3: Link Companies to Managers ──────────────────────────
-- Update manager_id based on manager_name matching

UPDATE companies SET manager_id = 'aaaaaaaa-bbbb-4ccc-aaaa-000000000001'
WHERE manager_name = 'Алик' AND manager_id IS NULL;

UPDATE companies SET manager_id = 'aaaaaaaa-bbbb-4ccc-aaaa-000000000002'
WHERE manager_name = 'Магел' AND manager_id IS NULL;

UPDATE companies SET manager_id = 'aaaaaaaa-bbbb-4ccc-aaaa-000000000003'
WHERE manager_name = 'Рам' AND manager_id IS NULL;

UPDATE companies SET manager_id = 'aaaaaaaa-bbbb-4ccc-aaaa-000000000004'
WHERE manager_name = 'Анар' AND manager_id IS NULL;

-- ── Step 4: Link Proposals to Managers ─────────────────────────

UPDATE proposals SET manager_id = 'aaaaaaaa-bbbb-4ccc-aaaa-000000000001'
WHERE manager_name = 'Алик' AND manager_id IS NULL;

UPDATE proposals SET manager_id = 'aaaaaaaa-bbbb-4ccc-aaaa-000000000002'
WHERE manager_name = 'Магел' AND manager_id IS NULL;

UPDATE proposals SET manager_id = 'aaaaaaaa-bbbb-4ccc-aaaa-000000000003'
WHERE manager_name = 'Рам' AND manager_id IS NULL;

UPDATE proposals SET manager_id = 'aaaaaaaa-bbbb-4ccc-aaaa-000000000004'
WHERE manager_name = 'Анар' AND manager_id IS NULL;

-- ── Step 5: Verify Results ─────────────────────────────────────

SELECT 'Компании по менеджерам' AS info;
SELECT manager_name, COUNT(*) AS count FROM companies GROUP BY manager_name ORDER BY count DESC;

SELECT 'Компании с manager_id' AS info;
SELECT u.name, COUNT(c.id) AS companies
FROM users u
LEFT JOIN companies c ON c.manager_id = u.id
GROUP BY u.name
ORDER BY companies DESC;

SELECT 'Всего компаний' AS info;
SELECT COUNT(*) FROM companies;

SELECT 'Компании без менеджера' AS info;
SELECT COUNT(*) FROM companies WHERE manager_id IS NULL;
