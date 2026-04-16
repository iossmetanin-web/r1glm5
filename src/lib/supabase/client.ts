import { createClient } from '@supabase/supabase-js'
import type { Database } from './database.types'

// Lazy singleton — safe for SSR/static generation.
// Only creates the client when actually called, never at import time.
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
    // During build/static generation, return a no-op-like client
    // that won't crash. Real calls will fail gracefully at runtime.
    _client = createClient<Database>(
      'https://placeholder.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.placeholder',
    )
    return _client
  }

  _client = createClient<Database>(url, key)
  return _client
}

// Convenience alias for existing imports
export const supabase = new Proxy({} as ReturnType<typeof createClient<Database>>, {
  get(_target, prop) {
    return Reflect.get(getSupabaseClient(), prop)
  },
})
