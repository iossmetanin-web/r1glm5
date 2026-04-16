'use client'

import { useSyncExternalStore } from 'react'
import { AppShell } from '@/features/layout/components/app-shell'
import { useNavigationStore } from '@/lib/store'
import { DashboardPage } from '@/features/dashboard/components/dashboard-page'
import DealsPage from '@/features/deals/components/deals-page'
import ContactsPage from '@/features/contacts/components/contacts-page'
import TasksPage from '@/features/tasks/components/tasks-page'

// SSR-safe mounted detection using useSyncExternalStore
// Returns false during SSR/static generation, true on client
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

  const views: Record<string, React.ReactNode> = {
    dashboard: <DashboardPage />,
    deals: <DealsPage />,
    contacts: <ContactsPage />,
    tasks: <TasksPage />,
    settings: (
      <div className="space-y-6">
        <div>
          <h2 className="text-lg font-semibold">Настройки</h2>
          <p className="text-sm text-muted-foreground mt-1">
            Настройки приложения будут доступны здесь.
          </p>
        </div>
      </div>
    ),
  }

  return <AppShell>{views[currentView] || <DashboardPage />}</AppShell>
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
