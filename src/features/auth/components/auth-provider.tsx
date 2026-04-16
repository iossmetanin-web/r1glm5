'use client'

import { createContext, useContext, useEffect, useState, useCallback } from 'react'
import type { User } from '@supabase/supabase-js'
import { createClient } from '@/lib/supabase/client'
import type { User as CrmUser } from '@/lib/supabase/database.types'

interface AuthContextType {
  user: User | null
  crmUser: CrmUser | null
  loading: boolean
  signOut: () => Promise<void>
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  crmUser: null,
  loading: true,
  signOut: async () => {},
})

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [crmUser, setCrmUser] = useState<CrmUser | null>(null)
  const [loading, setLoading] = useState(true)
  const supabase = createClient()

  const fetchCrmUser = useCallback(
    async (authUserId: string) => {
      const { data } = await supabase
        .from('users')
        .select('*')
        .eq('id', authUserId)
        .single()
      setCrmUser(data ?? null)
    },
    [supabase],
  )

  useEffect(() => {
    const getUser = async () => {
      const {
        data: { user },
      } = await supabase.auth.getUser()
      setUser(user)
      if (user) {
        await fetchCrmUser(user.id)
      }
      setLoading(false)
    }
    getUser()

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(async (event, session) => {
      setUser(session?.user ?? null)
      if (session?.user) {
        await fetchCrmUser(session.user.id)
      } else {
        setCrmUser(null)
      }
      setLoading(false)
    })

    return () => subscription.unsubscribe()
  }, [supabase, fetchCrmUser])

  const signOut = async () => {
    await supabase.auth.signOut()
  }

  return (
    <AuthContext.Provider value={{ user, crmUser, loading, signOut }}>
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => useContext(AuthContext)
