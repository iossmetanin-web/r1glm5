'use client'

import { useState, useEffect, useMemo, useCallback, useRef } from 'react'
import { supabase } from '@/lib/supabase/client'
import type {
  Company,
  CompanyInsert,
  CompanyUpdate,
  CompanyWithManager,
  User,
} from '@/lib/supabase/database.types'
import { useAuthStore, useNavigationStore } from '@/lib/store'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
import { Textarea } from '@/components/ui/textarea'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectItem,
} from '@/components/ui/select'
import {
  Table,
  TableHeader,
  TableBody,
  TableRow,
  TableHead,
  TableCell,
} from '@/components/ui/table'
import { ScrollArea } from '@/components/ui/scroll-area'
import {
  Plus,
  Search,
  Pencil,
  Eye,
  Users,
  AlertCircle,
  AlertTriangle,
  Building2,
} from 'lucide-react'

// ─── Constants ─────────────────────────────────────────────────────────────────

const SOURCES = [
  'входящая заявка',
  'реклама',
  'холодный обзвон',
  'личный контакт',
] as const

const STATUSES = [
  'слабый интерес',
  'надо залечивать',
  'сделал запрос',
  'сделал заказ',
] as const

type StatusFilter = 'Все' | typeof STATUSES[number]
type ManagerFilter = 'Мои' | 'Все'

// ─── Status badge styling ─────────────────────────────────────────────────────

const STATUS_BADGE_MAP: Record<string, { cls: string }> = {
  'слабый интерес': {
    cls: 'bg-muted text-muted-foreground border-transparent',
  },
  'надо залечивать': {
    cls: 'bg-amber-500/10 text-amber-700 border-amber-500/20',
  },
  'сделал запрос': {
    cls: 'bg-sky-500/10 text-sky-700 border-sky-500/20',
  },
  'сделал заказ': {
    cls: 'bg-emerald-500/10 text-emerald-700 border-emerald-500/20',
  },
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('ru-RU', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  })
}

function getStatusBadge(status: string | null): { cls: string } {
  if (!status) return STATUS_BADGE_MAP['слабый интерес']
  return STATUS_BADGE_MAP[status.toLowerCase()] ?? STATUS_BADGE_MAP['слабый интерес']
}

function isOverdue(nextContactDate: string | null): boolean {
  if (!nextContactDate) return false
  const now = new Date()
  now.setHours(0, 0, 0, 0)
  const contact = new Date(nextContactDate)
  const diffDays = Math.floor((now.getTime() - contact.getTime()) / (1000 * 60 * 60 * 24))
  return diffDays > 3
}

function getNextContactLabel(nextContactDate: string | null): {
  text: string
  className: string
} {
  if (!nextContactDate) return { text: '—', className: 'text-muted-foreground' }

  const now = new Date()
  now.setHours(0, 0, 0, 0)
  const contact = new Date(nextContactDate)
  contact.setHours(0, 0, 0, 0)
  const diffMs = now.getTime() - contact.getTime()
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24))

  if (diffDays > 3) {
    return { text: `Просрочено: ${formatDate(nextContactDate)}`, className: 'text-red-600 font-medium' }
  }
  if (diffDays === 0) {
    return { text: 'Сегодня', className: 'text-amber-600 font-medium' }
  }
  if (diffDays === -1) {
    return { text: 'Завтра', className: 'text-foreground' }
  }
  if (diffDays < -1) {
    return { text: formatDate(nextContactDate), className: 'text-muted-foreground' }
  }
  // 1-3 days overdue
  return { text: formatDate(nextContactDate), className: 'text-red-500' }
}

function pluralizeCompanies(n: number): string {
  const abs = Math.abs(n)
  const mod10 = abs % 10
  const mod100 = abs % 100
  if (mod10 === 1 && mod100 !== 11) return 'компания'
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) return 'компании'
  return 'компаний'
}

// ─── Form types ───────────────────────────────────────────────────────────────

interface CompanyFormData {
  name: string
  inn: string
  city: string
  website: string
  contact_phone: string
  contact_email: string
  source: string
  status: string
  manager_id: string
  next_contact_date: string
  notes: string
}

const EMPTY_FORM: CompanyFormData = {
  name: '',
  inn: '',
  city: '',
  website: '',
  contact_phone: '',
  contact_email: '',
  source: '',
  status: 'слабый интерес',
  manager_id: '',
  next_contact_date: '',
  notes: '',
}

// ─── Component ────────────────────────────────────────────────────────────────

export function CompaniesPage() {
  const currentUser = useAuthStore((s) => s.currentUser)
  const openCompany = useNavigationStore((s) => s.openCompany)

  // ─── State ───────────────────────────────────────────────────────────────

  const [companies, setCompanies] = useState<CompanyWithManager[]>([])
  const [managers, setManagers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [searchQuery, setSearchQuery] = useState('')
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('Все')
  const [managerFilter, setManagerFilter] = useState<ManagerFilter>('Все')
  const [sourceFilter, setSourceFilter] = useState('')

  // Dialog state
  const [dialogOpen, setDialogOpen] = useState(false)
  const [editingCompany, setEditingCompany] = useState<CompanyWithManager | null>(null)
  const [form, setForm] = useState<CompanyFormData>(EMPTY_FORM)
  const [saving, setSaving] = useState(false)
  const [innWarning, setInnWarning] = useState<string | null>(null)

  // Overdue highlight
  const [showOverdue, setShowOverdue] = useState(false)
  const overdueRef = useRef<HTMLDivElement>(null)

  // Fetch trigger
  const [fetchTrigger, setFetchTrigger] = useState(0)

  // ─── Data Fetching ────────────────────────────────────────────────────────

  const refresh = useCallback(() => {
    setLoading(true)
    setFetchTrigger((n) => n + 1)
  }, [])

  useEffect(() => {
    let cancelled = false
    async function load() {
      try {
        const [companiesRes, managersRes] = await Promise.all([
          supabase
            .from('companies')
            .select('*, manager:users!manager_id(id, name, email)')
            .order('created_at', { ascending: false }),
          supabase.from('users').select('*').order('name'),
        ])

        if (cancelled) return

        if (companiesRes.error) throw companiesRes.error
        if (managersRes.error) throw managersRes.error

        setCompanies((companiesRes.data as CompanyWithManager[]) ?? [])
        setManagers(managersRes.data ?? [])
        setError(null)
      } catch (err: unknown) {
        if (cancelled) return
        const message =
          err instanceof Error ? err.message : 'Не удалось загрузить компании'
        setError(message)
      } finally {
        if (!cancelled) setLoading(false)
      }
    }
    load()
    return () => {
      cancelled = true
    }
  }, [fetchTrigger])

  // ─── Computed: Filtered & Counted ────────────────────────────────────────

  const statusCounts = useMemo(() => {
    const counts: Record<string, number> = { Все: 0 }
    for (const s of STATUSES) counts[s] = 0
    for (const c of companies) {
      const st = c.status || 'слабый интерес'
      counts[st] = (counts[st] || 0) + 1
      counts['Все']++
    }
    return counts
  }, [companies])

  const overdueCount = useMemo(
    () => companies.filter((c) => isOverdue(c.next_contact_date)).length,
    [companies],
  )

  const filteredCompanies = useMemo(() => {
    let result = [...companies]

    // Search
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase()
      result = result.filter(
        (c) =>
          c.name?.toLowerCase().includes(q) ||
          c.inn?.toLowerCase().includes(q) ||
          c.city?.toLowerCase().includes(q),
      )
    }

    // Status filter
    if (statusFilter !== 'Все') {
      result = result.filter((c) => (c.status || 'слабый интерес') === statusFilter)
    }

    // Manager filter
    if (managerFilter === 'Мои' && currentUser) {
      result = result.filter((c) => c.manager_id === currentUser.id)
    }

    // Source filter
    if (sourceFilter) {
      result = result.filter((c) => c.source === sourceFilter)
    }

    // Sort: overdue first, then by created_at desc
    result.sort((a, b) => {
      const aOverdue = isOverdue(a.next_contact_date) ? 0 : 1
      const bOverdue = isOverdue(b.next_contact_date) ? 0 : 1
      if (aOverdue !== bOverdue) return aOverdue - bOverdue
      return new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
    })

    return result
  }, [companies, searchQuery, statusFilter, managerFilter, sourceFilter, currentUser])

  // ─── INN Duplicate Check ─────────────────────────────────────────────────

  const checkInnDuplicate = useCallback(
    async (inn: string, excludeId?: string) => {
      if (!inn.trim()) {
        setInnWarning(null)
        return
      }
      try {
        const { data: existing } = await supabase
          .from('companies')
          .select('id, name, inn')
          .eq('inn', inn.trim())
          .limit(1)

        if (existing && existing.length > 0 && existing[0].id !== excludeId) {
          setInnWarning(
            `Компания «${existing[0].name}» уже зарегистрирована с этим ИНН`,
          )
        } else {
          setInnWarning(null)
        }
      } catch {
        // Silently ignore check errors
      }
    },
    [],
  )

  // ─── Create / Update ─────────────────────────────────────────────────────

  const openCreateDialog = () => {
    setEditingCompany(null)
    setForm({
      ...EMPTY_FORM,
      manager_id: currentUser?.id || '',
    })
    setInnWarning(null)
    setDialogOpen(true)
  }

  const openEditDialog = (company: CompanyWithManager) => {
    setEditingCompany(company)
    setForm({
      name: company.name ?? '',
      inn: company.inn ?? '',
      city: company.city ?? '',
      website: company.website ?? '',
      contact_phone: company.contact_phone ?? '',
      contact_email: company.contact_email ?? '',
      source: company.source ?? '',
      status: company.status ?? 'слабый интерес',
      manager_id: company.manager_id ?? '',
      next_contact_date: company.next_contact_date
        ? company.next_contact_date.split('T')[0]
        : '',
      notes: company.notes ?? '',
    })
    setInnWarning(null)
    setDialogOpen(true)
  }

  const handleSave = async () => {
    if (!form.name.trim()) return
    setSaving(true)

    try {
      if (editingCompany) {
        // Update
        const updates: CompanyUpdate = {
          name: form.name.trim(),
          inn: form.inn.trim() || null,
          city: form.city.trim() || null,
          website: form.website.trim() || null,
          contact_phone: form.contact_phone.trim() || null,
          contact_email: form.contact_email.trim() || null,
          source: form.source || null,
          status: form.status || null,
          manager_id: form.manager_id || null,
          next_contact_date: form.next_contact_date || null,
          notes: form.notes.trim() || null,
        }
        const { error: updateError } = await supabase
          .from('companies')
          .update(updates)
          .eq('id', editingCompany.id)

        if (!updateError) {
          await supabase.from('activities').insert({
            company_id: editingCompany.id,
            user_id: currentUser?.id,
            type: 'статус_изменен',
            content: `Обновлена компания «${form.name.trim()}»`,
          })
        }
      } else {
        // Create
        const insert: CompanyInsert = {
          name: form.name.trim(),
          inn: form.inn.trim() || null,
          city: form.city.trim() || null,
          website: form.website.trim() || null,
          contact_phone: form.contact_phone.trim() || null,
          contact_email: form.contact_email.trim() || null,
          source: form.source || null,
          status: form.status || null,
          manager_id: form.manager_id || null,
          next_contact_date: form.next_contact_date || null,
          notes: form.notes.trim() || null,
        }
        const { data: createdCompany, error: insertError } = await supabase
          .from('companies')
          .insert(insert)
          .select('id')
          .single()

        if (!insertError && createdCompany) {
          await supabase.from('activities').insert({
            company_id: createdCompany.id,
            user_id: currentUser?.id,
            type: 'статус_изменен',
            content: `Создана компания «${form.name.trim()}»`,
          })
        }
      }

      setDialogOpen(false)
      setEditingCompany(null)
      setForm(EMPTY_FORM)
      setInnWarning(null)
      refresh()
    } catch {
      // silent
    }
    setSaving(false)
  }

  // ─── Overdue scroll ──────────────────────────────────────────────────────

  const handleOverdueClick = () => {
    setShowOverdue(true)
    setTimeout(() => {
      overdueRef.current?.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }, 100)
    // Reset after a few seconds
    setTimeout(() => setShowOverdue(false), 3000)
  }

  // ─── Render: Loading ─────────────────────────────────────────────────────

  if (loading) {
    return (
      <div className="space-y-4">
        {/* Top bar skeleton */}
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
          <div>
            <Skeleton className="h-6 w-32 mb-1" />
            <Skeleton className="h-4 w-48" />
          </div>
          <div className="flex items-center gap-2">
            <Skeleton className="h-9 w-[220px] rounded-xl" />
            <Skeleton className="h-9 w-36 rounded-xl" />
          </div>
        </div>
        {/* Filter bar skeleton */}
        <div className="flex items-center gap-2 flex-wrap">
          {Array.from({ length: 5 }).map((_, i) => (
            <Skeleton key={i} className="h-8 w-24 rounded-lg" />
          ))}
        </div>
        {/* Table skeleton */}
        <div className="border border-border/60 rounded-2xl shadow-sm overflow-hidden">
          <div className="bg-muted/40 px-4 py-3 flex gap-4">
            {Array.from({ length: 6 }).map((_, i) => (
              <Skeleton key={i} className="h-4 flex-1" />
            ))}
          </div>
          {Array.from({ length: 6 }).map((_, i) => (
            <div
              key={i}
              className="px-4 py-4 flex gap-4 border-b border-border last:border-0"
            >
              {Array.from({ length: 6 }).map((_, j) => (
                <Skeleton key={j} className="h-4 flex-1" />
              ))}
            </div>
          ))}
        </div>
      </div>
    )
  }

  // ─── Render: Error ───────────────────────────────────────────────────────

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center py-16 gap-3">
        <AlertCircle className="h-10 w-10 text-destructive" />
        <h3 className="text-lg font-semibold text-foreground">
          Что-то пошло не так
        </h3>
        <p className="text-sm text-muted-foreground max-w-md text-center">
          {error}
        </p>
        <Button variant="outline" size="sm" onClick={refresh}>
          Попробовать снова
        </Button>
      </div>
    )
  }

  // ─── Render: Main ────────────────────────────────────────────────────────

  return (
    <div className="flex flex-col gap-4 md:h-full">
      {/* ── Top Bar ────────────────────────────────────────────────────────── */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
        <div>
          <h2 className="text-xl font-semibold tracking-tight flex items-center gap-2">
            <Users className="h-5 w-5 text-emerald-500" />
            Клиенты
          </h2>
          <p className="text-sm text-muted-foreground mt-0.5">
            {companies.length}{' '}
            {pluralizeCompanies(companies.length)}
            {searchQuery.trim() ||
            statusFilter !== 'Все' ||
            sourceFilter ||
            managerFilter !== 'Все'
              ? ` · ${filteredCompanies.length} найдено`
              : ''}
          </p>
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          <div className="relative">
            <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground pointer-events-none" />
            <Input
              placeholder="Поиск по названию, ИНН, городу…"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-8 w-full sm:w-[260px] h-9 rounded-xl"
            />
          </div>
          <Button
            size="sm"
            onClick={openCreateDialog}
            className="gap-1.5 rounded-xl"
          >
            <Plus className="h-4 w-4" />
            Добавить клиента
          </Button>
        </div>
      </div>

      {/* ── Filter Bar ─────────────────────────────────────────────────────── */}
      <div className="flex flex-col sm:flex-row sm:items-center gap-3 flex-wrap">
        {/* Status filter pills */}
        <div className="flex items-center gap-1.5 bg-muted/60 rounded-xl p-1 overflow-x-auto">
          {(STATUSES as unknown as string[]).map((status) => (
            <button
              key={status}
              onClick={() =>
                setStatusFilter(
                  statusFilter === status ? 'Все' : (status as StatusFilter),
                )
              }
              className={`px-3 py-1.5 text-xs font-medium rounded-lg whitespace-nowrap transition-colors ${
                statusFilter === status
                  ? 'bg-primary text-primary-foreground shadow-sm shadow-primary/20'
                  : 'text-muted-foreground hover:text-foreground hover:bg-primary/5'
              }`}
            >
              {status} ({statusCounts[status] ?? 0})
            </button>
          ))}
          {statusFilter !== 'Все' && (
            <button
              onClick={() => setStatusFilter('Все')}
              className={`px-3 py-1.5 text-xs font-medium rounded-lg whitespace-nowrap transition-colors text-muted-foreground hover:text-foreground hover:bg-primary/5`}
            >
              Все
            </button>
          )}
        </div>

        {/* Manager toggle */}
        {currentUser && (
          <div className="flex items-center gap-1.5 bg-muted/60 rounded-xl p-1">
            {(['Мои', 'Все'] as ManagerFilter[]).map((f) => (
              <button
                key={f}
                onClick={() => setManagerFilter(f)}
                className={`px-3 py-1.5 text-xs font-medium rounded-lg transition-colors ${
                  managerFilter === f
                    ? 'bg-primary text-primary-foreground shadow-sm shadow-primary/20'
                    : 'text-muted-foreground hover:text-foreground hover:bg-primary/5'
                }`}
              >
                {f}
              </button>
            ))}
          </div>
        )}

        {/* Source filter */}
        <Select value={sourceFilter} onValueChange={(v) => setSourceFilter(v === '__none__' ? '' : v)}>
          <SelectTrigger className="w-auto h-8 rounded-xl text-xs min-w-[150px]">
            <SelectValue placeholder="Все источники" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="__none__">Все источники</SelectItem>
            {SOURCES.map((s) => (
              <SelectItem key={s} value={s}>
                {s}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      {/* ── Overdue Banner ─────────────────────────────────────────────────── */}
      {overdueCount > 0 && (
        <button
          onClick={handleOverdueClick}
          className="w-full flex items-center gap-2.5 px-4 py-3 rounded-2xl bg-red-50 border border-red-200 text-red-700 hover:bg-red-100 transition-colors text-left"
        >
          <AlertTriangle className="h-5 w-5 shrink-0 text-red-500" />
          <span className="text-sm font-medium">
            {overdueCount}{' '}
            {overdueCount === 1
              ? 'клиент с просроченным контактом'
              : overdueCount < 5
                ? 'клиента с просроченным контактом'
                : 'клиентов с просроченным контактом'}
          </span>
        </button>
      )}

      {/* ── Empty State ────────────────────────────────────────────────────── */}
      {!loading && !error && companies.length === 0 && (
        <div className="flex flex-col items-center justify-center py-20 gap-4">
          <div className="h-14 w-14 rounded-full bg-muted/50 flex items-center justify-center">
            <Building2 className="h-7 w-7 text-muted-foreground" />
          </div>
          <div className="text-center">
            <p className="text-base font-medium text-foreground">Нет компаний</p>
            <p className="text-sm text-muted-foreground mt-1">
              Добавьте первую компанию, чтобы начать работу
            </p>
          </div>
          <Button
            size="sm"
            onClick={openCreateDialog}
            className="gap-1.5 rounded-xl"
          >
            <Plus className="h-4 w-4" />
            Добавить клиента
          </Button>
        </div>
      )}

      {/* ── Search No Results ──────────────────────────────────────────────── */}
      {!loading && !error && companies.length > 0 && filteredCompanies.length === 0 && (
        <div className="flex flex-col items-center justify-center py-16 gap-3">
          <Search className="h-8 w-8 text-muted-foreground" />
          <p className="text-sm text-muted-foreground">
            Компании по запросу &ldquo;{searchQuery}&rdquo; не найдены
          </p>
          <Button
            variant="outline"
            size="sm"
            onClick={() => {
              setSearchQuery('')
              setStatusFilter('Все')
              setSourceFilter('')
              setManagerFilter('Все')
            }}
          >
            Сбросить фильтры
          </Button>
        </div>
      )}

      {/* ── Company List ───────────────────────────────────────────────────── */}
      {!loading && !error && filteredCompanies.length > 0 && (
        <>
          {/* Desktop Table */}
          <div className="hidden md:block border border-border/60 rounded-2xl shadow-sm overflow-hidden flex-1">
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow className="bg-muted/40 hover:bg-muted/40">
                    <TableHead className="pl-4 min-w-[200px]">Компания</TableHead>
                    <TableHead className="min-w-[120px]">Статус</TableHead>
                    <TableHead className="min-w-[100px]">Источник</TableHead>
                    <TableHead className="min-w-[120px]">Менеджер</TableHead>
                    <TableHead className="min-w-[140px]">След. контакт</TableHead>
                    <TableHead className="pr-4 text-right w-[100px]"></TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredCompanies.map((company) => {
                    const overdue = isOverdue(company.next_contact_date)
                    const contactLabel = getNextContactLabel(company.next_contact_date)
                    const statusBadge = getStatusBadge(company.status)

                    return (
                      <TableRow
                        key={company.id}
                        ref={overdue && showOverdue ? overdueRef : undefined}
                        className={`cursor-pointer hover:bg-primary/5 transition-colors ${
                          overdue ? 'border-l-4 border-l-red-400 bg-red-50/30' : ''
                        } ${showOverdue && overdue ? 'ring-2 ring-inset ring-red-300' : ''}`}
                        onClick={() => openCompany(company.id)}
                      >
                        <TableCell className="pl-4">
                          <div className="flex flex-col">
                            <span className="font-medium text-foreground truncate max-w-[260px]">
                              {company.name}
                            </span>
                            <span className="text-xs text-muted-foreground flex items-center gap-1.5 mt-0.5">
                              {company.inn && (
                                <>
                                  ИНН {company.inn}
                                  {company.city && <span className="text-border">·</span>}
                                </>
                              )}
                              {company.city && <span>{company.city}</span>}
                            </span>
                          </div>
                        </TableCell>
                        <TableCell>
                          <Badge
                            variant="outline"
                            className={`text-xs whitespace-nowrap ${statusBadge.cls}`}
                          >
                            {company.status || 'слабый интерес'}
                          </Badge>
                        </TableCell>
                        <TableCell>
                          {company.source ? (
                            <Badge variant="secondary" className="text-[11px] whitespace-nowrap">
                              {company.source}
                            </Badge>
                          ) : (
                            <span className="text-xs text-muted-foreground">—</span>
                          )}
                        </TableCell>
                        <TableCell>
                          <span className="text-sm text-muted-foreground">
                            {company.manager?.name || company.manager_name || '—'}
                          </span>
                        </TableCell>
                        <TableCell>
                          <span className={`text-xs ${contactLabel.className}`}>
                            {contactLabel.text}
                          </span>
                        </TableCell>
                        <TableCell className="pr-4 text-right">
                          <div className="flex items-center justify-end gap-1">
                            <button
                              onClick={(e) => {
                                e.stopPropagation()
                                openCompany(company.id)
                              }}
                              className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-primary/10 transition-colors"
                              aria-label={`Просмотреть ${company.name}`}
                            >
                              <Eye className="h-3.5 w-3.5" />
                            </button>
                            <button
                              onClick={(e) => {
                                e.stopPropagation()
                                openEditDialog(company)
                              }}
                              className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-primary/10 transition-colors"
                              aria-label={`Редактировать ${company.name}`}
                            >
                              <Pencil className="h-3.5 w-3.5" />
                            </button>
                          </div>
                        </TableCell>
                      </TableRow>
                    )
                  })}
                </TableBody>
              </Table>
            </div>
          </div>

          {/* Mobile Cards */}
          <div className="md:hidden space-y-3">
            {filteredCompanies.map((company) => {
              const overdue = isOverdue(company.next_contact_date)
              const contactLabel = getNextContactLabel(company.next_contact_date)
              const statusBadge = getStatusBadge(company.status)

              return (
                <div
                  key={company.id}
                  ref={overdue && showOverdue ? overdueRef : undefined}
                  className={`rounded-2xl border border-border/60 shadow-sm p-4 transition-all hover:shadow-md cursor-pointer active:scale-[0.99] bg-card ${
                    overdue ? 'border-l-4 border-l-red-400 bg-red-50/30' : ''
                  } ${showOverdue && overdue ? 'ring-2 ring-inset ring-red-300' : ''}`}
                  onClick={() => openCompany(company.id)}
                >
                  {/* Header: name + actions */}
                  <div className="flex items-start justify-between gap-2 mb-2">
                    <div className="min-w-0 flex-1">
                      <p className="font-medium text-foreground truncate">
                        {company.name}
                      </p>
                      <p className="text-xs text-muted-foreground mt-0.5 flex items-center gap-1.5">
                        {company.inn && (
                          <>
                            ИНН {company.inn}
                            {company.city && <span className="text-border">·</span>}
                          </>
                        )}
                        {company.city && <span>{company.city}</span>}
                      </p>
                    </div>
                    <div className="flex items-center gap-1 shrink-0">
                      <button
                        onClick={(e) => {
                          e.stopPropagation()
                          openCompany(company.id)
                        }}
                        className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-primary/10 transition-colors"
                        aria-label={`Просмотреть ${company.name}`}
                      >
                        <Eye className="h-3.5 w-3.5" />
                      </button>
                      <button
                        onClick={(e) => {
                          e.stopPropagation()
                          openEditDialog(company)
                        }}
                        className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-primary/10 transition-colors"
                        aria-label={`Редактировать ${company.name}`}
                      >
                        <Pencil className="h-3.5 w-3.5" />
                      </button>
                    </div>
                  </div>

                  {/* Badges */}
                  <div className="flex items-center gap-2 flex-wrap mb-2">
                    <Badge
                      variant="outline"
                      className={`text-xs ${statusBadge.cls}`}
                    >
                      {company.status || 'слабый интерес'}
                    </Badge>
                    {company.source && (
                      <Badge variant="secondary" className="text-[11px]">
                        {company.source}
                      </Badge>
                    )}
                  </div>

                  {/* Footer: manager + next contact */}
                  <div className="flex items-center justify-between text-xs">
                    <span className="text-muted-foreground">
                      {company.manager?.name || company.manager_name || 'Без менеджера'}
                    </span>
                    {company.next_contact_date && (
                      <span className={contactLabel.className}>
                        {contactLabel.text}
                      </span>
                    )}
                  </div>
                </div>
              )
            })}
          </div>
        </>
      )}

      {/* ── Create / Edit Dialog ───────────────────────────────────────────── */}
      <Dialog
        open={dialogOpen}
        onOpenChange={(open) => {
          setDialogOpen(open)
          if (!open) {
            setEditingCompany(null)
            setForm(EMPTY_FORM)
            setInnWarning(null)
          }
        }}
      >
        <DialogContent className="sm:max-w-lg max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              {editingCompany ? (
                <>
                  <Pencil className="h-5 w-5" />
                  Редактировать клиента
                </>
              ) : (
                <>
                  <Plus className="h-5 w-5" />
                  Новый клиент
                </>
              )}
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {/* Название компании */}
            <div className="space-y-2">
              <Label htmlFor="company-name">
                Название компании <span className="text-destructive">*</span>
              </Label>
              <Input
                id="company-name"
                placeholder='напр. ООО "Трансформатор"'
                value={form.name}
                onChange={(e) =>
                  setForm((f) => ({ ...f, name: e.target.value }))
                }
              />
            </div>

            {/* ИНН + Город */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="company-inn">ИНН</Label>
                <Input
                  id="company-inn"
                  placeholder="0000000000"
                  value={form.inn}
                  onChange={(e) =>
                    setForm((f) => ({ ...f, inn: e.target.value }))
                  }
                  onBlur={() =>
                    checkInnDuplicate(form.inn, editingCompany?.id)
                  }
                  className={innWarning ? 'border-amber-500' : ''}
                />
                {innWarning && (
                  <p className="text-xs text-amber-600 flex items-center gap-1">
                    <AlertTriangle className="h-3 w-3" />
                    {innWarning}
                  </p>
                )}
              </div>
              <div className="space-y-2">
                <Label htmlFor="company-city">Город</Label>
                <Input
                  id="company-city"
                  placeholder="напр. Москва"
                  value={form.city}
                  onChange={(e) =>
                    setForm((f) => ({ ...f, city: e.target.value }))
                  }
                />
              </div>
            </div>

            {/* Сайт */}
            <div className="space-y-2">
              <Label htmlFor="company-website">Сайт</Label>
              <Input
                id="company-website"
                placeholder="https://example.com"
                value={form.website}
                onChange={(e) =>
                  setForm((f) => ({ ...f, website: e.target.value }))
                }
              />
            </div>

            {/* Телефон + Email */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="company-phone">Телефон</Label>
                <Input
                  id="company-phone"
                  placeholder="+7 (999) 000-0000"
                  value={form.contact_phone}
                  onChange={(e) =>
                    setForm((f) => ({ ...f, contact_phone: e.target.value }))
                  }
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="company-email">Email</Label>
                <Input
                  id="company-email"
                  type="email"
                  placeholder="info@company.ru"
                  value={form.contact_email}
                  onChange={(e) =>
                    setForm((f) => ({ ...f, contact_email: e.target.value }))
                  }
                />
              </div>
            </div>

            {/* Источник + Статус */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Источник</Label>
                <Select
                  value={form.source || '__none__'}
                  onValueChange={(v) =>
                    setForm((f) => ({
                      ...f,
                      source: v === '__none__' ? '' : v,
                    }))
                  }
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Выберите источник" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="__none__">Не указан</SelectItem>
                    {SOURCES.map((s) => (
                      <SelectItem key={s} value={s}>
                        {s}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Статус</Label>
                <Select
                  value={form.status || 'слабый интерес'}
                  onValueChange={(v) =>
                    setForm((f) => ({ ...f, status: v }))
                  }
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {STATUSES.map((s) => (
                      <SelectItem key={s} value={s}>
                        {s}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>

            {/* Ответственный менеджер */}
            <div className="space-y-2">
              <Label>Ответственный менеджер</Label>
              <Select
                value={form.manager_id || '__none__'}
                onValueChange={(v) =>
                  setForm((f) => ({
                    ...f,
                    manager_id: v === '__none__' ? '' : v,
                  }))
                }
              >
                <SelectTrigger>
                  <SelectValue placeholder="Выберите менеджера" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="__none__">Не назначен</SelectItem>
                  {managers.map((m) => (
                    <SelectItem key={m.id} value={m.id}>
                      {m.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {/* Дата следующего контакта */}
            <div className="space-y-2">
              <Label htmlFor="company-next-contact">Дата следующего контакта</Label>
              <Input
                id="company-next-contact"
                type="date"
                value={form.next_contact_date}
                onChange={(e) =>
                  setForm((f) => ({
                    ...f,
                    next_contact_date: e.target.value,
                  }))
                }
              />
            </div>

            {/* Заметки */}
            <div className="space-y-2">
              <Label htmlFor="company-notes">Заметки</Label>
              <Textarea
                id="company-notes"
                placeholder="Дополнительная информация о клиенте…"
                value={form.notes}
                onChange={(e) =>
                  setForm((f) => ({ ...f, notes: e.target.value }))
                }
                rows={3}
                className="resize-none"
              />
            </div>

            {/* Actions */}
            <div className="flex justify-end gap-2 pt-2">
              <Button
                variant="outline"
                onClick={() => {
                  setDialogOpen(false)
                  setEditingCompany(null)
                  setForm(EMPTY_FORM)
                  setInnWarning(null)
                }}
              >
                Отмена
              </Button>
              <Button
                onClick={handleSave}
                disabled={!form.name.trim() || saving}
                className="rounded-xl"
              >
                {saving
                  ? 'Сохранение…'
                  : editingCompany
                    ? 'Обновить'
                    : 'Создать клиента'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
