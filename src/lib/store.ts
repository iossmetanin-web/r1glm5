import { create } from 'zustand'
import type { User } from '@/lib/supabase/database.types'

// ─── Navigation ──────────────────────────────────────────────────────────────

export type AppView = 'dashboard' | 'deals' | 'deal-detail' | 'contacts' | 'tasks' | 'settings'

interface NavigationState {
  currentView: AppView
  selectedDealId: string | null
  navigate: (view: AppView) => void
  openDeal: (dealId: string) => void
  goBack: () => void
  previousView: AppView | null
}

export const useNavigationStore = create<NavigationState>((set) => ({
  currentView: 'dashboard',
  selectedDealId: null,
  previousView: null,
  navigate: (view) => set((s) => ({ currentView: view, selectedDealId: null, previousView: s.currentView })),
  openDeal: (dealId) => set((s) => ({ currentView: 'deal-detail', selectedDealId: dealId, previousView: s.currentView })),
  goBack: () => set((s) => ({ currentView: s.previousView || 'dashboard', selectedDealId: null })),
}))

// ─── Auth (Supabase Auth + CRM users table) ──────────────────────────────────

interface AuthState {
  currentUser: User | null
  loading: boolean
  hydrated: boolean
  login: (user: User) => void
  logout: () => void
  setLoading: (l: boolean) => void
  setHydrated: () => void
}

export const useAuthStore = create<AuthState>((set) => ({
  currentUser: null,
  loading: true,
  hydrated: false,
  login: (user) => {
    if (typeof window !== 'undefined') {
      try { localStorage.setItem('crm_user_id', user.id) } catch { /* ignore */ }
    }
    set({ currentUser: user })
  },
  logout: () => {
    if (typeof window !== 'undefined') {
      try { localStorage.removeItem('crm_user_id') } catch { /* ignore */ }
    }
    set({ currentUser: null })
    // Sign out from Supabase Auth (fire-and-forget)
    import('@/lib/supabase/client').then(({ supabase }) => {
      supabase.auth.signOut().catch(() => {})
    })
  },
  setLoading: (loading) => set({ loading }),
  setHydrated: () => set({ hydrated: true }),
}))

// ─── Session restore (called from client components only via useEffect) ──────

let _restoreStarted = false

export async function restoreSession() {
  if (_restoreStarted) return
  _restoreStarted = true

  // Only runs in browser, never during SSR
  if (typeof window === 'undefined') {
    useAuthStore.getState().setLoading(false)
    useAuthStore.getState().setHydrated()
    return
  }

  try {
    // Dynamic import to avoid SSR issues — Supabase client only loaded in browser
    const { supabase } = await import('@/lib/supabase/client')

    // Check for active Supabase Auth session
    const { data: { session } } = await supabase.auth.getSession()

    if (session?.user) {
      const authEmail = session.user.email
      if (authEmail) {
        // Fetch CRM user by matching email
        const { data: crmUser } = await supabase
          .from('users')
          .select('*')
          .eq('email', authEmail)
          .single()

        if (crmUser) {
          useAuthStore.getState().login(crmUser)
        } else {
          // Auth session exists but no CRM profile — create one
          const newUser = {
            id: session.user.id,
            name: session.user.user_metadata?.full_name || authEmail.split('@')[0],
            email: authEmail,
            role: 'admin' as const,
          }
          const { data: createdUser } = await supabase
            .from('users')
            .insert(newUser)
            .select()
            .single()

          if (createdUser) {
            useAuthStore.getState().login(createdUser)
          }
        }
      }
    }
  } catch {
    // Session restore failed — user will see login page
  } finally {
    useAuthStore.getState().setLoading(false)
    useAuthStore.getState().setHydrated()
  }
}

// ─── UI ──────────────────────────────────────────────────────────────────────

interface UIState {
  sidebarCollapsed: boolean
  toggleSidebar: () => void
  setSidebarCollapsed: (collapsed: boolean) => void
}

export const useUIStore = create<UIState>((set) => ({
  sidebarCollapsed: false,
  toggleSidebar: () => set((s) => ({ sidebarCollapsed: !s.sidebarCollapsed })),
  setSidebarCollapsed: (collapsed) => set({ sidebarCollapsed: collapsed }),
}))
