'use client'

import { useEffect, useRef } from 'react'
import { useSyncExternalStore } from 'react'
import { AppShell } from '@/features/layout/components/app-shell'
import { MobileNav } from '@/features/layout/components/mobile-nav'
import { LoginForm } from '@/features/auth/components/login-form'
import { useNavigationStore, useAuthStore, restoreSession } from '@/lib/store'
import { DashboardPage } from '@/features/dashboard/components/dashboard-page'
import { CompaniesPage } from '@/features/companies/components/companies-page'
import { CompanyDetailPage } from '@/features/companies/components/company-detail-page'
import { ProposalsPage } from '@/features/proposals/components/proposals-page'
import TasksPage from '@/features/tasks/components/tasks-page'
import { SettingsPage } from '@/features/settings/components/settings-page'
import { WorkspacePage } from '@/features/workspace/components/workspace-page'
import { Loader2 } from 'lucide-react'

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
  const currentUser = useAuthStore((s) => s.currentUser)
  const loading = useAuthStore((s) => s.loading)
  const hydrated = useAuthStore((s) => s.hydrated)
  const currentView = useNavigationStore((s) => s.currentView)
  const restoreRef = useRef(false)

  // Restore Supabase Auth session — runs once, guarded by ref (safe against HMR)
  useEffect(() => {
    if (restoreRef.current) return
    restoreRef.current = true
    restoreSession()
  }, [])

  // Waiting for Supabase session check
  if (!hydrated || loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <Loader2 className="h-5 w-5 animate-spin text-primary" />
      </div>
    )
  }

  // NOT authenticated → show login page
  if (!currentUser) {
    return <LoginForm />
  }

  // Authenticated → show CRM app
  const views: Record<string, React.ReactNode> = {
    dashboard: <DashboardPage />,
    companies: <CompaniesPage />,
    companyDetail: <CompanyDetailPage />,
    proposals: <ProposalsPage />,
    tasks: <TasksPage />,
    settings: <SettingsPage />,
    workspace: <WorkspacePage />,
  }

  return (
    <>
      <AppShell>{views[currentView] || <DashboardPage />}</AppShell>
      <MobileNav />
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
