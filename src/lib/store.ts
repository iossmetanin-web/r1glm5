import { create } from 'zustand'
import type { User } from '@/lib/supabase/database.types'

// ─── Navigation ──────────────────────────────────────────────────────────────

export type AppView = 'dashboard' | 'companies' | 'company-detail' | 'deals' | 'proposals' | 'tasks' | 'settings' | 'workspace'

interface NavigationState {
  currentView: AppView
  selectedCompanyId: string | null
  navigate: (view: AppView) => void
  openCompany: (companyId: string) => void
  goBack: () => void
  previousView: AppView | null
}

export const useNavigationStore = create<NavigationState>((set) => ({
  currentView: 'dashboard',
  selectedCompanyId: null,
  previousView: null,
  navigate: (view) => set((s) => ({ currentView: view, selectedCompanyId: null, previousView: s.currentView })),
  openCompany: (companyId) => set((s) => ({ currentView: 'company-detail', selectedCompanyId: companyId, previousView: s.currentView })),
  goBack: () => set((s) => ({ currentView: s.previousView || 'dashboard', selectedCompanyId: null })),
}))

// ─── Auth (Supabase Auth only — NO fake users, NO localStorage hacks) ─────

interface AuthState {
  currentUser: User | null
  loading: boolean
  hydrated: boolean
  login: (user: User) => void
  logout: () => Promise<void>
  setLoading: (l: boolean) => void
  setHydrated: () => void
}

export const useAuthStore = create<AuthState>((set) => ({
  currentUser: null,
  loading: true,
  hydrated: false,
  login: (user) => {
    set({ currentUser: user })
  },
  logout: async () => {
    // 1. Clear Zustand state immediately
    set({ currentUser: null })
    // 2. Sign out from Supabase Auth (clears refresh token)
    try {
      const { supabase } = await import('@/lib/supabase/client')
      await supabase.auth.signOut()
    } catch { /* ignore */ }
  },
  setLoading: (loading) => set({ loading }),
  setHydrated: () => set({ hydrated: true }),
}))

// ─── Session restore — ONLY uses Supabase Auth.getSession() ─────────────────

export async function restoreSession() {
  // Only runs in browser, never during SSR
  if (typeof window === 'undefined') {
    useAuthStore.getState().setLoading(false)
    useAuthStore.getState().setHydrated()
    return
  }

  try {
    const { supabase } = await import('@/lib/supabase/client')

    // ONLY source of truth: Supabase Auth session
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
    // If no session → currentUser stays null → login page shows
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
