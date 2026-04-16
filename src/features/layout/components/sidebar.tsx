'use client'

import {
  LayoutDashboard,
  Kanban,
  Users,
  CheckSquare,
  Settings,
  ChevronLeft,
  ChevronRight,
  Zap,
  LogOut,
} from 'lucide-react'
import { Button } from '@/components/ui/button'
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from '@/components/ui/tooltip'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Separator } from '@/components/ui/separator'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { useNavigationStore, useAuthStore, useUIStore } from '@/lib/store'
import type { AppView } from '@/lib/store'
import type { LucideIcon } from 'lucide-react'

interface NavItem {
  view: AppView
  label: string
  icon: LucideIcon
  color: string   // Tailwind bg class for icon circle
  tint: string    // Tailwind bg class for active tint
  text: string    // Tailwind text class for active label
}

const navItems: NavItem[] = [
  { view: 'dashboard', label: 'Панель', icon: LayoutDashboard, color: 'bg-blue-500', tint: 'bg-blue-50', text: 'text-blue-600' },
  { view: 'deals', label: 'Сделки', icon: Kanban, color: 'bg-amber-500', tint: 'bg-amber-50', text: 'text-amber-600' },
  { view: 'companies', label: 'Клиенты', icon: Users, color: 'bg-emerald-500', tint: 'bg-emerald-50', text: 'text-emerald-600' },
  { view: 'tasks', label: 'Задачи', icon: CheckSquare, color: 'bg-violet-500', tint: 'bg-violet-50', text: 'text-violet-600' },
  { view: 'settings', label: 'Настройки', icon: Settings, color: 'bg-gray-500', tint: 'bg-gray-50', text: 'text-gray-600' },
]

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
        sidebarCollapsed ? 'w-[68px]' : 'w-[240px]'
      }`}
    >
      {/* ── Logo ─────────────────────────────────────────── */}
      <div className="flex h-14 shrink-0 items-center gap-3 border-b border-sidebar-border px-4">
        <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-primary shadow-sm shadow-primary/25 transition-transform duration-200 hover:scale-105">
          <Zap className="h-[18px] w-[18px] text-primary-foreground" />
        </div>
        {!sidebarCollapsed && (
          <span className="text-sm font-bold tracking-tight text-sidebar-foreground">
            PulseCRM
          </span>
        )}
      </div>

      {/* ── Navigation ───────────────────────────────────── */}
      <ScrollArea className="flex-1 py-3">
        <nav className="flex flex-col gap-1 px-3">
          {navItems.map((item) => {
            const Icon = item.icon
            const isActive = currentView === item.view

            const button = (
              <button
                key={item.view}
                onClick={() => navigate(item.view)}
                className={`relative flex items-center gap-3 rounded-xl transition-all duration-200 ease-in-out ${
                  sidebarCollapsed
                    ? 'h-11 w-11 justify-center p-0 mx-auto'
                    : 'h-11 px-3 w-full'
                } ${
                  isActive
                    ? item.tint
                    : 'hover:bg-muted/60'
                }`}
              >
                <div className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-full ${item.color} ${
                  sidebarCollapsed ? 'h-9 w-9' : 'h-8 w-8'
                } transition-all duration-200 ${isActive ? 'shadow-md' : 'shadow-sm opacity-75'}`}>
                  <Icon className="h-4 w-4 text-white" />
                </div>
                {!sidebarCollapsed && (
                  <span className={`truncate text-[13px] font-medium transition-colors duration-200 ${isActive ? 'text-foreground' : 'text-muted-foreground'}`}>
                    {item.label}
                  </span>
                )}
              </button>
            )

            if (sidebarCollapsed) {
              return (
                <Tooltip key={item.view}>
                  <TooltipTrigger asChild>{button}</TooltipTrigger>
                  <TooltipContent side="right" sideOffset={8}>
                    {item.label}
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
              <Avatar className="h-9 w-9 cursor-default transition-transform duration-200 hover:scale-105">
                <AvatarFallback className="bg-primary text-primary-foreground text-xs font-semibold">
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
              <AvatarFallback className="bg-primary text-primary-foreground text-xs font-semibold">
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
          className={`shrink-0 flex h-8 w-8 items-center justify-center rounded-lg text-muted-foreground transition-all duration-200 hover:bg-destructive/10 hover:text-destructive hover:scale-105 ${
            sidebarCollapsed ? '' : 'ml-auto'
          }`}
        >
          <LogOut className="h-4 w-4" />
        </button>
      </div>
    </aside>
  )
}
