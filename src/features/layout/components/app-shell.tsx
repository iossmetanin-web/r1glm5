'use client'

import { Loader2 } from 'lucide-react'
import { useAuthStore, useUIStore } from '@/lib/store'
import { LoginForm } from '@/features/auth/components/login-form'
import { Sidebar } from './sidebar'
import { Header } from './header'

interface AppShellProps {
  children: React.ReactNode
}

export function AppShell({ children }: AppShellProps) {
  const currentUser = useAuthStore((s) => s.currentUser)
  const loading = useAuthStore((s) => s.loading)
  const sidebarCollapsed = useUIStore((s) => s.sidebarCollapsed)

  // Still restoring session
  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
      </div>
    )
  }

  // Not authenticated — show login
  if (!currentUser) {
    return <LoginForm />
  }

  // Authenticated — render shell
  return (
    <div className="min-h-screen bg-background">
      <Sidebar />
      <div
        className={`flex min-h-screen flex-col transition-[margin-left] duration-300 ${
          sidebarCollapsed ? 'ml-16' : 'ml-60'
        }`}
      >
        <Header />
        <main className="flex-1 p-6">{children}</main>
      </div>
    </div>
  )
}
