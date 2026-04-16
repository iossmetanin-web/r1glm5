'use client'

import { AppShell } from '@/features/layout/components/app-shell'
import { useNavigationStore } from '@/lib/store'
import { DashboardPage } from '@/features/dashboard/components/dashboard-page'
import DealsPage from '@/features/deals/components/deals-page'
import ContactsPage from '@/features/contacts/components/contacts-page'
import TasksPage from '@/features/tasks/components/tasks-page'

export default function Home() {
  const currentView = useNavigationStore((s) => s.currentView)

  const views: Record<string, React.ReactNode> = {
    dashboard: <DashboardPage />,
    deals: <DealsPage />,
    contacts: <ContactsPage />,
    tasks: <TasksPage />,
    settings: (
      <div className="space-y-6">
        <div>
          <h2 className="text-lg font-semibold">Settings</h2>
          <p className="text-sm text-muted-foreground mt-1">
            Application settings will be available here.
          </p>
        </div>
      </div>
    ),
  }

  return <AppShell>{views[currentView] || <DashboardPage />}</AppShell>
}
