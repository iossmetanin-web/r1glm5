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

// ─── Auth (simple — custom users table) ──────────────────────────────────────

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
    const savedId = localStorage.getItem('crm_user_id')
    if (savedId) {
      // Dynamic import to avoid SSR issues — Supabase client only loaded in browser
      const { supabase } = await import('@/lib/supabase/client')
      const { data } = await supabase.from('users').select('*').eq('id', savedId).single()
      if (data) {
        useAuthStore.getState().login(data)
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
