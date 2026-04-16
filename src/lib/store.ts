import { create } from 'zustand'
import type { User } from '@/lib/supabase/database.types'
import { supabase } from '@/lib/supabase/client'

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
  login: (user: User) => void
  logout: () => void
  setLoading: (l: boolean) => void
}

export const useAuthStore = create<AuthState>((set) => ({
  currentUser: null,
  loading: true,
  login: (user) => {
    if (typeof window !== 'undefined') localStorage.setItem('crm_user_id', user.id)
    set({ currentUser: user })
  },
  logout: () => {
    if (typeof window !== 'undefined') localStorage.removeItem('crm_user_id')
    set({ currentUser: null })
  },
  setLoading: (loading) => set({ loading }),
}))

// Restore session from localStorage on load
if (typeof window !== 'undefined') {
  const savedId = localStorage.getItem('crm_user_id')
  if (savedId) {
    supabase.from('users').select('*').eq('id', savedId).single().then(({ data }) => {
      if (data) useAuthStore.getState().login(data)
      useAuthStore.getState().setLoading(false)
    }).catch(() => useAuthStore.getState().setLoading(false))
  } else {
    useAuthStore.getState().setLoading(false)
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
