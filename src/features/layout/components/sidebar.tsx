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
}

const navItems: NavItem[] = [
  { view: 'dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { view: 'deals', label: 'Deals', icon: Kanban },
  { view: 'contacts', label: 'Contacts', icon: Users },
  { view: 'tasks', label: 'Tasks', icon: CheckSquare },
  { view: 'settings', label: 'Settings', icon: Settings },
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
      className={`hidden md:flex fixed inset-y-0 left-0 z-40 flex-col border-r border-border bg-card transition-all duration-300 ${
        sidebarCollapsed ? 'w-16' : 'w-60'
      }`}
    >
      {/* ── Logo ─────────────────────────────────────────── */}
      <div className="flex h-14 shrink-0 items-center gap-3 border-b border-border px-4">
        <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-primary">
          <Zap className="h-4 w-4 text-primary-foreground" />
        </div>
        {!sidebarCollapsed && (
          <span className="text-sm font-semibold tracking-tight text-foreground">
            PulseCRM
          </span>
        )}
      </div>

      {/* ── Navigation ───────────────────────────────────── */}
      <ScrollArea className="flex-1 py-2">
        <nav className="flex flex-col gap-1 px-2">
          {navItems.map((item) => {
            const Icon = item.icon
            const isActive = currentView === item.view

            const button = (
              <Button
                key={item.view}
                variant="ghost"
                onClick={() => navigate(item.view)}
                className={`relative w-full justify-start gap-3 ${
                  sidebarCollapsed ? 'h-10 w-10 px-0' : 'h-9 px-3'
                } ${
                  isActive
                    ? 'bg-primary text-primary-foreground hover:bg-primary/90 hover:text-primary-foreground'
                    : 'text-muted-foreground hover:bg-accent hover:text-accent-foreground'
                }`}
              >
                <Icon className="h-4 w-4 shrink-0" />
                {!sidebarCollapsed && (
                  <span className="truncate text-sm">{item.label}</span>
                )}
              </Button>
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
      <Separator />
      <div className="flex shrink-0 justify-center py-2">
        <Button
          variant="ghost"
          size="icon"
          className="h-8 w-8 text-muted-foreground hover:bg-accent hover:text-accent-foreground"
          onClick={toggleSidebar}
        >
          {sidebarCollapsed ? (
            <ChevronRight className="h-4 w-4" />
          ) : (
            <ChevronLeft className="h-4 w-4" />
          )}
        </Button>
      </div>

      {/* ── User Section ─────────────────────────────────── */}
      <Separator />
      <div
        className={`flex shrink-0 items-center gap-3 px-3 py-3 ${
          sidebarCollapsed ? 'justify-center' : ''
        }`}
      >
        {sidebarCollapsed ? (
          <Tooltip>
            <TooltipTrigger asChild>
              <Avatar className="h-8 w-8 cursor-default">
                <AvatarFallback className="bg-primary text-primary-foreground text-xs font-medium">
                  {userInitials}
                </AvatarFallback>
              </Avatar>
            </TooltipTrigger>
            <TooltipContent side="right" sideOffset={8}>
              {currentUser?.name ?? 'User'}
            </TooltipContent>
          </Tooltip>
        ) : (
          <>
            <Avatar className="h-8 w-8 shrink-0">
              <AvatarFallback className="bg-primary text-primary-foreground text-xs font-medium">
                {userInitials}
              </AvatarFallback>
            </Avatar>
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm font-medium text-foreground">
                {currentUser?.name ?? 'User'}
              </p>
              <p className="truncate text-xs text-muted-foreground">
                {currentUser?.email ?? ''}
              </p>
            </div>
          </>
        )}

        <Button
          variant="ghost"
          size="icon"
          onClick={logout}
          className={`shrink-0 text-muted-foreground hover:bg-destructive/10 hover:text-destructive ${
            sidebarCollapsed ? 'h-8 w-8' : 'h-8 w-8 ml-auto'
          }`}
        >
          <LogOut className="h-4 w-4" />
        </Button>
      </div>
    </aside>
  )
}
