'use client'

import {
  Search,
  Bell,
  Plus,
  Menu,
  Settings,
  LogOut,
} from 'lucide-react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { Badge } from '@/components/ui/badge'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { useAuthStore, useNavigationStore, useUIStore } from '@/lib/store'
import type { AppView } from '@/lib/store'

const viewTitles: Record<AppView, string> = {
  dashboard: 'Панель',
  deals: 'Сделки',
  'deal-detail': 'Детали сделки',
  contacts: 'Контакты',
  tasks: 'Задачи',
  settings: 'Настройки',
}

const viewColors: Record<AppView, string> = {
  dashboard: 'bg-blue-500',
  deals: 'bg-amber-500',
  'deal-detail': 'bg-amber-500',
  contacts: 'bg-emerald-500',
  tasks: 'bg-violet-500',
  settings: 'bg-gray-500',
}

export function Header() {
  const currentUser = useAuthStore((s) => s.currentUser)
  const logout = useAuthStore((s) => s.logout)
  const currentView = useNavigationStore((s) => s.currentView)
  const navigate = useNavigationStore((s) => s.navigate)
  const goBack = useNavigationStore((s) => s.goBack)
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
    <header
      className={`sticky top-0 z-30 flex h-14 items-center gap-4 border-b border-border/60 bg-card/80 px-4 backdrop-blur-lg transition-[margin-left] duration-300 ease-in-out ${
        sidebarCollapsed ? 'ml-[68px]' : 'ml-[240px]'
      }`}
    >
      {/* ── Left Section ──────────────────────────────────── */}
      <div className="flex items-center gap-2">
        <Button
          variant="ghost"
          size="icon"
          className="h-8 w-8 rounded-lg text-muted-foreground hover:bg-primary/8 hover:text-foreground md:hidden"
          onClick={toggleSidebar}
        >
          <Menu className="h-4 w-4" />
        </Button>

        {currentView === 'deal-detail' && (
          <Button
            variant="ghost"
            size="icon"
            className="h-8 w-8 rounded-lg text-muted-foreground hover:bg-primary/8 hover:text-foreground"
            onClick={goBack}
          >
            <span className="text-sm">&larr;</span>
          </Button>
        )}

        <div className="flex items-center gap-2">
          <div className={`h-2 w-2 rounded-full ${viewColors[currentView] ?? 'bg-gray-400'}`} />
          <h1 className="text-sm font-semibold tracking-tight text-foreground">
            {viewTitles[currentView] ?? 'PulseCRM'}
          </h1>
        </div>
      </div>

      {/* ── Spacer ────────────────────────────────────────── */}
      <div className="flex-1" />

      {/* ── Right Section ─────────────────────────────────── */}
      <div className="flex items-center gap-1">
        {/* Search */}
        <div className="relative hidden md:block">
          <Search className="absolute left-2.5 top-1/2 h-3.5 w-3.5 -translate-y-1/2 text-muted-foreground" />
          <Input
            type="search"
            placeholder="Поиск..."
            className="h-9 w-56 rounded-lg border-border/50 bg-muted/40 pl-8 text-sm placeholder:text-muted-foreground/60 focus-visible:ring-primary/30 transition-all duration-200"
          />
        </div>

        {/* New button */}
        <Button
          variant="ghost"
          size="icon"
          className="h-8 w-8 rounded-lg text-muted-foreground hover:bg-primary/8 hover:text-foreground"
        >
          <Plus className="h-4 w-4" />
        </Button>

        {/* Notifications */}
        <Button
          variant="ghost"
          size="icon"
          className="relative h-8 w-8 rounded-lg text-muted-foreground hover:bg-primary/8 hover:text-foreground"
        >
          <Bell className="h-4 w-4" />
          <Badge className="absolute -right-1 -top-1 flex h-4 min-w-4 items-center justify-center rounded-full bg-primary px-1 text-[10px] font-medium leading-none text-primary-foreground">
            3
          </Badge>
        </Button>

        {/* User dropdown */}
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button
              variant="ghost"
              className="ml-1 h-8 gap-2 rounded-full pl-1 pr-2 text-muted-foreground hover:bg-primary/8 hover:text-foreground"
            >
              <Avatar className="h-6 w-6">
                <AvatarFallback className="bg-primary text-primary-foreground text-[10px] font-semibold">
                  {userInitials}
                </AvatarFallback>
              </Avatar>
              <span className="hidden text-xs font-medium sm:inline">
                {currentUser?.name ?? 'Пользователь'}
              </span>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-48">
            <DropdownMenuLabel className="text-xs">
              <p className="font-medium">{currentUser?.name ?? 'Пользователь'}</p>
              <p className="text-muted-foreground">{currentUser?.email ?? ''}</p>
            </DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={() => navigate('settings')}>
              <Settings className="mr-2 h-3.5 w-3.5" />
              Настройки
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem variant="destructive" onClick={logout}>
              <LogOut className="mr-2 h-3.5 w-3.5" />
              Выйти
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  )
}
