import { create } from 'zustand'
import { createClient } from '@/lib/supabase/client'

// ─── Navigation Store ────────────────────────────────────────────────────────

export type AppView =
  | 'dashboard'
  | 'deals'
  | 'deal-detail'
  | 'contacts'
  | 'tasks'
  | 'settings'

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
  navigate: (view) =>
    set((state) => ({
      currentView: view,
      selectedDealId: null,
      previousView: state.currentView,
    })),
  openDeal: (dealId) =>
    set((state) => ({
      currentView: 'deal-detail',
      selectedDealId: dealId,
      previousView: state.currentView,
    })),
  goBack: () =>
    set((state) => ({
      currentView: state.previousView || 'dashboard',
      selectedDealId: null,
    })),
}))

// ─── UI Store ────────────────────────────────────────────────────────────────

interface UIState {
  sidebarCollapsed: boolean
  toggleSidebar: () => void
  setSidebarCollapsed: (collapsed: boolean) => void
}

export const useUIStore = create<UIState>((set) => ({
  sidebarCollapsed: false,
  toggleSidebar: () =>
    set((state) => ({ sidebarCollapsed: !state.sidebarCollapsed })),
  setSidebarCollapsed: (collapsed) => set({ sidebarCollapsed: collapsed }),
}))

// ─── Supabase Auth helper ────────────────────────────────────────────────────

export async function signOut() {
  const supabase = createClient()
  await supabase.auth.signOut()
  window.location.href = '/auth'
}
