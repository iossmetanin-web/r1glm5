'use client'

import {
  ChevronLeft,
  ChevronRight,
  Zap,
  LogOut,
} from 'lucide-react'
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from '@/components/ui/tooltip'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Separator } from '@/components/ui/separator'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { useNavigationStore, useAuthStore, useUIStore } from '@/lib/store'
import { NAV_SECTIONS } from '@/lib/section-colors'

export function Sidebar() {
  const currentView = useNavigationStore((s) => s.currentView)
  const navigate = useNavigationStore((s) => s.navigate)
  const currentUser = useAuthStore((s) => s.currentUser)
  const logout = useAuthStore((s) => s.logout)
  const sidebarCollapsed = useUIStore((s) => s.sidebarCollapsed)
  const toggleSidebar = useUIStore((s) => s.toggleSidebar)

  const userInitials = currentUser?.name
    ? currentUser.name
        .split(' ')
        .map((n) => n[0])
        .join('')
        .slice(0, 2)
        .toUpperCase()
    : '??'

  return (
    <aside
      className={`hidden md:flex fixed inset-y-0 left-0 z-40 flex-col bg-sidebar border-r border-sidebar-border transition-all duration-300 ease-in-out ${
        sidebarCollapsed ? 'w-[72px]' : 'w-[248px]'
      }`}
    >
      {/* ── Logo ─────────────────────────────────────────── */}
      <div className="flex h-14 shrink-0 items-center gap-3 border-b border-sidebar-border px-4">
        <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-primary">
          <Zap className="h-[18px] w-[18px] text-primary-foreground" />
        </div>
        {!sidebarCollapsed && (
          <span className="text-sm font-bold tracking-tight text-sidebar-foreground">
            PulseCRM
          </span>
        )}
      </div>

      {/* ── Navigation (Telegram-style colored icons) ────── */}
      <ScrollArea className="flex-1 py-3">
        <nav className="flex flex-col gap-1 px-3">
          {NAV_SECTIONS.map((section) => {
            const Icon = section.icon
            const isActive = currentView === section.view

            const button = (
              <button
                key={section.view}
                onClick={() => navigate(section.view)}
                className={`relative flex items-center gap-3 rounded-xl transition-all duration-200 ease-in-out ${
                  sidebarCollapsed
                    ? 'h-11 w-11 justify-center p-0 mx-auto'
                    : 'h-11 px-3 w-full'
                } ${
                  isActive
                    ? `${section.tintClass}`
                    : 'hover:bg-muted/60'
                }`}
              >
                {/* Colored circle with white icon — Telegram style */}
                <div
                  className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-full transition-all duration-200 ease-in-out ${
                    sidebarCollapsed ? 'h-9 w-9' : 'h-8 w-8'
                  } ${section.bgClass} ${
                    isActive ? 'shadow-md' : 'shadow-sm opacity-80'
                  }`}
                >
                  <Icon className="h-[16px] w-[16px] text-white" />
                </div>
                {!sidebarCollapsed && (
                  <span
                    className={`truncate text-[13px] font-medium transition-colors duration-200 ${
                      isActive ? 'text-foreground' : 'text-muted-foreground'
                    }`}
                  >
                    {section.label}
                  </span>
                )}
              </button>
            )

            if (sidebarCollapsed) {
              return (
                <Tooltip key={section.view}>
                  <TooltipTrigger asChild>{button}</TooltipTrigger>
                  <TooltipContent side="right" sideOffset={8}>
                    {section.label}
                  </TooltipContent>
                </Tooltip>
              )
            }

            return button
          })}
        </nav>
      </ScrollArea>

      {/* ── Collapse Toggle ──────────────────────────────── */}
      <Separator className="bg-sidebar-border" />
      <div className="flex shrink-0 justify-center py-2">
        <button
          onClick={toggleSidebar}
          className="flex h-8 w-8 items-center justify-center rounded-lg text-muted-foreground transition-all duration-200 hover:bg-muted hover:text-foreground hover:scale-105"
        >
          {sidebarCollapsed ? (
            <ChevronRight className="h-4 w-4" />
          ) : (
            <ChevronLeft className="h-4 w-4" />
          )}
        </button>
      </div>

      {/* ── User Section ─────────────────────────────────── */}
      <Separator className="bg-sidebar-border" />
      <div
        className={`flex shrink-0 items-center gap-3 px-3 py-3 ${
          sidebarCollapsed ? 'justify-center' : ''
        }`}
      >
        {sidebarCollapsed ? (
          <Tooltip>
            <TooltipTrigger asChild>
              <Avatar className="h-9 w-9 cursor-default">
                <AvatarFallback className="bg-gray-500 text-white text-xs font-semibold">
                  {userInitials}
                </AvatarFallback>
              </Avatar>
            </TooltipTrigger>
            <TooltipContent side="right" sideOffset={8}>
              {currentUser?.name ?? 'Пользователь'}
            </TooltipContent>
          </Tooltip>
        ) : (
          <>
            <Avatar className="h-9 w-9 shrink-0">
              <AvatarFallback className="bg-gray-500 text-white text-xs font-semibold">
                {userInitials}
              </AvatarFallback>
            </Avatar>
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm font-medium text-sidebar-foreground">
                {currentUser?.name ?? 'Пользователь'}
              </p>
              <p className="truncate text-xs text-muted-foreground">
                {currentUser?.email ?? ''}
              </p>
            </div>
          </>
        )}

        <button
          onClick={logout}
          className={`shrink-0 flex h-8 w-8 items-center justify-center rounded-lg text-muted-foreground transition-all duration-200 hover:bg-red-50 hover:text-red-500 hover:scale-105 ${
            sidebarCollapsed ? '' : 'ml-auto'
          }`}
        >
          <LogOut className="h-4 w-4" />
        </button>
      </div>
    </aside>
  )
}
