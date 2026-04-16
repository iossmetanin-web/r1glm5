'use client'

import { useEffect } from 'react'
import { Loader2 } from 'lucide-react'
import { useAuthStore, useUIStore, restoreSession } from '@/lib/store'
import { LoginForm } from '@/features/auth/components/login-form'
import { Sidebar } from './sidebar'
import { Header } from './header'
import { MobileNav } from './mobile-nav'

interface AppShellProps {
  children: React.ReactNode
}

export function AppShell({ children }: AppShellProps) {
  const currentUser = useAuthStore((s) => s.currentUser)
  const loading = useAuthStore((s) => s.loading)
  const hydrated = useAuthStore((s) => s.hydrated)
  const sidebarCollapsed = useUIStore((s) => s.sidebarCollapsed)

  // Restore session from localStorage — runs only in browser
  useEffect(() => {
    restoreSession()
  }, [])

  // Not yet hydrated (still checking localStorage) — show nothing
  if (!hydrated) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <Loader2 className="h-5 w-5 animate-spin text-primary" />
      </div>
    )
  }

  // Still loading session
  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <Loader2 className="h-5 w-5 animate-spin text-primary" />
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
      {/* Sidebar: hidden on mobile (md:block), visible on desktop */}
      <Sidebar />

      {/* Main content area */}
      <div
        className={`flex min-h-screen flex-col transition-[margin-left] duration-300 ease-in-out ${
          sidebarCollapsed ? 'md:ml-[68px]' : 'md:ml-[240px]'
        }`}
      >
        {/* Header: hidden on mobile (md:flex), visible on desktop */}
        <div className="hidden md:block">
          <Header />
        </div>

        {/* Page content: extra bottom padding on mobile for bottom nav */}
        <main className="flex-1 p-4 pb-24 md:p-6 md:pb-6">
          {children}
        </main>
      </div>

      {/* Bottom navigation: visible ONLY on mobile, ALWAYS present */}
      <MobileNav />
    </div>
  )
}
