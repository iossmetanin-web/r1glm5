'use client'

import { useUIStore } from '@/lib/store'
import { Sidebar } from './sidebar'
import { Header } from './header'

interface AppShellProps {
  children: React.ReactNode
}

export function AppShell({ children }: AppShellProps) {
  const sidebarCollapsed = useUIStore((s) => s.sidebarCollapsed)

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
    </div>
  )
}
