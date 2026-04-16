import { createClient } from '@supabase/supabase-js'
import type { Database } from './database.types'

// ── Anon client (respects RLS) ──────────────────────────────────────
let _client: ReturnType<typeof createClient<Database>> | null = null

function getSupabaseUrl(): string {
  return process.env.NEXT_PUBLIC_SUPABASE_URL ?? ''
}

function getSupabaseAnonKey(): string {
  return process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ?? ''
}

export function getSupabaseClient() {
  if (_client) return _client

  const url = getSupabaseUrl()
  const key = getSupabaseAnonKey()

  if (!url || !key) {
    _client = createClient<Database>(
      'https://placeholder.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.placeholder',
    )
    return _client
  }

  _client = createClient<Database>(url, key)
  return _client
}

// Convenience alias
export const supabase = new Proxy({} as ReturnType<typeof createClient<Database>>, {
  get(_target, prop) {
    return Reflect.get(getSupabaseClient(), prop)
  },
})

// ── Admin client (bypasses RLS — service_role) ─────────────────────
let _adminClient: ReturnType<typeof createClient<Database>> | null = null

export function getSupabaseAdminClient() {
  if (_adminClient) return _adminClient

  const url = getSupabaseUrl()
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY

  if (!url || !key) {
    console.warn('[supabase] SUPABASE_SERVICE_ROLE_KEY not set, falling back to anon client')
    return getSupabaseClient()
  }

  _adminClient = createClient<Database>(url, key)
  return _adminClient
}

export const adminSupabase = new Proxy({} as ReturnType<typeof createClient<Database>>, {
  get(_target, prop) {
    return Reflect.get(getSupabaseAdminClient(), prop)
  },
})
