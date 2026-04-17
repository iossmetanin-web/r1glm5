'use client'

import { useState, useEffect, useRef } from 'react'
import {
  Search,
  Bell,
  Plus,
  Menu,
  Settings,
  LogOut,
  Building2,
  FileText,
  CheckSquare,
  Users,
  X,
  Loader2,
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
import {
  Dialog,
  DialogContent,
} from '@/components/ui/dialog'
import { useAuthStore, useNavigationStore, useUIStore } from '@/lib/store'
import { useNavigate } from 'next/navigation'
import { toast } from 'sonner'
import type { LucideIcon } from 'lucide-react'
import { supabase } from '@/lib/supabase/client'

const viewTitles: Record<string, string> = {
  dashboard: 'Панель',
  companies: 'Клиенты',
  'company-detail': 'Карточка клиента',
  proposals: 'Коммерческие предложения',
  tasks: 'Задачи',
  settings: 'Настройки',
  workspace: 'Рабочая область',
}

const viewColors: Record<string, string> = {
  dashboard: 'bg-blue-500',
  companies: 'bg-sky-500',
  'company-detail': 'bg-sky-500',
  proposals: 'bg-amber-500',
  tasks: 'bg-violet-500',
  settings: 'bg-gray-500',
  workspace: 'bg-emerald-500',
}

export function Header() {
  const currentUser = useAuthStore((s) => s.currentUser)
  const logout = useAuthStore((s) => s.logout)
  const currentView = useNavigationStore((s) => s.currentView)
  const navigate = useNavigationStore((s) => s.navigate)
  const goBack = useNavigationStore((s) => s.goBack)
  const openCompany = useNavigationStore((s) => s.openCompany)
  const sidebarCollapsed = useUIStore((s) => s.sidebarCollapsed)
  const toggleSidebar = useUIStore((s) => s.toggleSidebar)
  const nextNavigate = useNavigate()

  const userInitials = currentUser?.name
    ? currentUser.name
        .split(' ')
        .map((n) => n[0])
        .join('')
        .slice(0, 2)
        .toUpperCase()
    : '??'

  // ── Global Search State ──────────────────────────────────────────────
  const [searchOpen, setSearchOpen] = useState(false)
  const [searchQuery, setSearchQuery] = useState('')
  const [searchResults, setSearchResults] = useState<
    { type: 'company' | 'proposal' | 'task'; id: string; title: string; subtitle: string }[]
  >([])
  const [searching, setSearching] = useState(false)
  const searchInputRef = useRef<HTMLInputElement>(null)

  const handleSearch = async (query: string) => {
    setSearchQuery(query)
    if (!query.trim()) { setSearchResults([]); return }
    setSearching(true)
    try {
      const q = query.toLowerCase()
      const results: typeof searchResults extends (infer U)[] ? U : never[] = []

      // Search companies
      const { data: companies } = await supabase
        .from('companies')
        .select('id, name, city, status, manager_name')
        .or(`name.ilike.%${q}%,city.ilike.%${q}%,inn.ilike.%${q}%`)
        .limit(10)
      if (companies) {
        for (const c of companies) {
          results.push({ type: 'company', id: c.id, title: c.name, subtitle: c.city || c.status || '' })
        }
      }

      // Search proposals
      const { data: proposals } = await supabase
        .from('proposals')
        .select('id, number, status, total_amount, company_id')
        .or(`number.ilike.%${q}%`)
        .limit(10)
      if (proposals) {
        // Get company names for proposals
        const companyIds = proposals.map((p: any) => p.company_id).filter(Boolean)
        const companyMap: Record<string, string> = {}
        if (companyIds.length > 0) {
          const { data: cData } = await supabase.from('companies').select('id, name').in('id', companyIds)
          if (cData) cData.forEach((c: any) => { companyMap[c.id] = c.name })
        }
        for (const p of proposals) {
          results.push({
            type: 'proposal',
            id: p.id,
            title: p.number ? `КП №${p.number}` : 'КП',
            subtitle: `${companyMap[p.company_id] || '—'} · ${formatCurrency(p.total_amount || 0)}`,
          })
        }
      }

      // Search tasks
      const { data: tasks } = await supabase
        .from('tasks')
        .select('id, title, status, priority, deadline, company_id')
        .ilike('title', `%${q}%`)
        .limit(10)
      if (tasks) {
        const companyIds = tasks.map((t: any) => t.company_id).filter(Boolean)
        const companyMap: Record<string, string> = {}
        if (companyIds.length > 0) {
          const { data: cData } = await supabase.from('companies').select('id, name').in('id', companyIds)
          if (cData) cData.forEach((c: any) => { companyMap[c.id] = c.name })
        }
        for (const t of tasks) {
          results.push({
            type: 'task',
            id: t.id,
            title: t.title,
            subtitle: `${companyMap[t.company_id] || ''} · ${t.priority} · ${t.deadline || ''}`,
          })
        }
      }

      setSearchResults(results)
    } catch {
      // silent
    }
    setSearching(false)
  }

  const openSearch = () => {
    setSearchOpen(true)
    setTimeout(() => searchInputRef.current?.focus(), 100)
  }

  const closeSearch = () => {
    setSearchOpen(false)
    setSearchQuery('')
    setSearchResults([])
  }

  const handleResultClick = (result: typeof searchResults extends (infer U)[] ? U : never) => {
    closeSearch()
    if (result.type === 'company') {
      openCompany(result.id)
    } else if (result.type === 'proposal') {
      // Navigate to company then proposals tab
      // For now just show toast
      toast.info('Откройте клиент этого КП для просмотра')
    } else if (result.type === 'task') {
      // Navigate to workspace
      if (result.company_id) {
        openCompany(result.company_id)
      }
      toast.info('Перейдите в «Рабочая область» для просмотра задачи')
    }
  }

  useEffect(() => {
    if (!searchOpen) return
    const handler = (e: KeyboardEvent) => {
      if (e.key === 'Escape') closeSearch()
      if (e.key === 'k' && (e.metaKey || e.ctrlKey)) {
        e.preventDefault()
        openSearch()
      }
    }
    document.addEventListener('keydown', handler)
    return () => document.removeEventListener('keydown', handler)
  }, [searchOpen])

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

        {currentView === 'company-detail' && (
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
