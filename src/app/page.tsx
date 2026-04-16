'use client'

import { useSyncExternalStore } from 'react'
import { AppShell } from '@/features/layout/components/app-shell'
import { MobileNav } from '@/features/layout/components/mobile-nav'
import { useNavigationStore, useAuthStore } from '@/lib/store'
import { DashboardPage } from '@/features/dashboard/components/dashboard-page'
import DealsPage from '@/features/deals/components/deals-page'
import ContactsPage from '@/features/contacts/components/contacts-page'
import TasksPage from '@/features/tasks/components/tasks-page'
import { SettingsPage } from '@/features/settings/components/settings-page'

// SSR-safe mounted detection using useSyncExternalStore
const emptySubscribe = () => () => {}
function useIsMounted() {
  return useSyncExternalStore(
    emptySubscribe,
    () => true,
    () => false,
  )
}

function AppContent() {
  const currentView = useNavigationStore((s) => s.currentView)
  const currentUser = useAuthStore((s) => s.currentUser)

  const views: Record<string, React.ReactNode> = {
    dashboard: <DashboardPage />,
    deals: <DealsPage />,
    contacts: <ContactsPage />,
    tasks: <TasksPage />,
    settings: <SettingsPage />,
  }

  return (
    <>
      <AppShell>{views[currentView] || <DashboardPage />}</AppShell>
      {currentUser && <MobileNav />}
    </>
  )
}

export default function Home() {
  const mounted = useIsMounted()

  // Prevent hydration mismatch — render nothing on server
  if (!mounted) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <div className="h-5 w-5 animate-spin rounded-full border-2 border-muted-foreground border-t-transparent" />
      </div>
    )
  }

  return <AppContent />
}
