'use client'

import { createContext, useContext, useEffect, useState, useCallback } from 'react'
import type { User as SupabaseUser } from '@supabase/supabase-js'
import { createClient } from '@/lib/supabase/client'
import type { User as CrmUser } from '@/lib/supabase/database.types'
import { useAuthStore } from '@/lib/store'

interface AuthContextType {
  user: SupabaseUser | null
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
    async (authUserId: string, authEmail: string) => {
      // Try to find CRM user by email first, then by ID
      let { data } = await supabase
        .from('users')
        .select('*')
        .eq('email', authEmail)
        .single()

      if (!data) {
        const { data: dataById } = await supabase
          .from('users')
          .select('*')
          .eq('id', authUserId)
          .single()
        data = dataById
      }

      if (data) {
        setCrmUser(data)
      }
    },
    [supabase],
  )

  useEffect(() => {
    const getUser = async () => {
      const {
        data: { user },
      } = await supabase.auth.getUser()
      setUser(user)
      if (user?.email) {
        await fetchCrmUser(user.id, user.email)
      }
      setLoading(false)
    }
    getUser()

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange(async (event, session) => {
      if (event === 'SIGNED_OUT') {
        setUser(null)
        setCrmUser(null)
        return
      }

      const authUser = session?.user ?? null
      setUser(authUser)

      if (authUser?.email) {
        await fetchCrmUser(authUser.id, authUser.email)
      } else {
        setCrmUser(null)
      }
      setLoading(false)
    })

    return () => subscription.unsubscribe()
  }, [supabase, fetchCrmUser])

  const signOut = async () => {
    await supabase.auth.signOut()
    useAuthStore.getState().logout()
  }

  return (
    <AuthContext.Provider value={{ user, crmUser, loading, signOut }}>
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => useContext(AuthContext)
