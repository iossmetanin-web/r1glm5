import { NextResponse } from 'next/server'

// This API route provides the migration SQL for the user to copy-paste
// into Supabase Dashboard → SQL Editor
// 
// We cannot run DDL from the REST API, so this is a helper endpoint.

const MIGRATION_SQL = `-- Run this in Supabase Dashboard → SQL Editor
-- 1. Add deal_id to tasks
ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS deal_id TEXT;
ALTER TABLE public.tasks DROP CONSTRAINT IF EXISTS tasks_deal_id_fkey;
ALTER TABLE public.tasks ADD CONSTRAINT tasks_deal_id_fkey FOREIGN KEY (deal_id) REFERENCES public.deals(id) ON DELETE SET NULL;

-- 2. Add assigned_to to tasks
ALTER TABLE public.tasks ADD COLUMN IF NOT EXISTS assigned_to TEXT;
ALTER TABLE public.tasks DROP CONSTRAINT IF EXISTS tasks_assigned_to_fkey;
ALTER TABLE public.tasks ADD CONSTRAINT tasks_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id) ON DELETE SET NULL;

-- 3. Add deleted_at for soft delete on companies
ALTER TABLE public.companies ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;
CREATE INDEX IF NOT EXISTS idx_companies_deleted_at ON public.companies(deleted_at) WHERE deleted_at IS NOT NULL;

-- 4. Create settings table
CREATE TABLE IF NOT EXISTS public.settings (
  id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
  category TEXT NOT NULL,
  key_name TEXT NOT NULL,
  value JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(category, key_name)
);
ALTER TABLE public.settings ENABLE ROW LEVEL SECURITY;
DO $$ BEGIN CREATE POLICY "settings_allow_all" ON public.settings FOR ALL USING (true) WITH CHECK (true); EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- 5. Migrate settings from activities
INSERT INTO public.settings (id, category, key_name, value) SELECT id, 'tags', 'tags_list', content::jsonb FROM public.activities WHERE id = '00000001-0000-0000-0000-000000000001' AND type = 'settings' AND content IS NOT NULL ON CONFLICT (category, key_name) DO NOTHING;
INSERT INTO public.settings (id, category, key_name, value) SELECT id, 'segments', 'segments_list', content::jsonb FROM public.activities WHERE id = '00000001-0000-0000-0000-000000000002' AND type = 'settings' AND content IS NOT NULL ON CONFLICT (category, key_name) DO NOTHING;
INSERT INTO public.settings (id, category, key_name, value) SELECT id, 'custom_fields', 'custom_fields_list', content::jsonb FROM public.activities WHERE id = '00000001-0000-0000-0000-000000000003' AND type = 'settings' AND content IS NOT NULL ON CONFLICT (category, key_name) DO NOTHING;
INSERT INTO public.settings (id, category, key_name, value) SELECT id, 'task_statuses', 'task_statuses_list', content::jsonb FROM public.activities WHERE id = '00000001-0000-0000-0000-000000000004' AND type = 'settings' AND content IS NOT NULL ON CONFLICT (category, key_name) DO NOTHING;
INSERT INTO public.settings (id, category, key_name, value) SELECT id, 'task_priorities', 'task_priorities_list', content::jsonb FROM public.activities WHERE id = '00000001-0000-0000-0000-000000000005' AND type = 'settings' AND content IS NOT NULL ON CONFLICT (category, key_name) DO NOTHING;
INSERT INTO public.settings (id, category, key_name, value) SELECT id, 'reminder', 'reminder_on', content::jsonb FROM public.activities WHERE id = '00000001-0000-0000-0000-000000000006' AND type = 'settings' AND content IS NOT NULL ON CONFLICT (category, key_name) DO NOTHING;`

export async function GET() {
  return new NextResponse(MIGRATION_SQL, {
    headers: { 'Content-Type': 'text/plain; charset=utf-8' },
  })
}
