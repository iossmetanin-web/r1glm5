'use client'

import { useState, useEffect, useMemo, useCallback } from 'react'
import { supabase } from '@/lib/supabase/client'
import type {
  Proposal,
  ProposalInsert,
  ProposalUpdate,
  ProposalItem,
  ProposalItemInsert,
  Company,
  User,
  PROPOSAL_STATUSES,
} from '@/lib/supabase/database.types'
import { useAuthStore, useNavigationStore } from '@/lib/store'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
import { Textarea } from '@/components/ui/textarea'
import { Separator } from '@/components/ui/separator'
import { ScrollArea } from '@/components/ui/scroll-area'
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
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import {
  Table,
  TableHeader,
  TableBody,
  TableRow,
  TableHead,
  TableCell,
} from '@/components/ui/table'
import { toast } from 'sonner'
import {
  Plus,
  Pencil,
  Trash2,
  Eye,
  ChevronDown,
  ChevronUp,
  FileText,
  AlertCircle,
  Building2,
  Calendar,
  Package,
  X,
} from 'lucide-react'

// ─── Constants ─────────────────────────────────────────────────────────────────

const STATUSES = ['отправлено', 'рассматривается', 'принято', 'отклонено'] as const

type StatusFilter = 'Все' | (typeof STATUSES)[number]
type ManagerFilter = 'Все' | 'Мои'

// ─── Status badge styling ─────────────────────────────────────────────────────

const STATUS_BADGE_MAP: Record<string, string> = {
  отправлено: 'bg-sky-500/10 text-sky-700 border-sky-500/20',
  рассматривается: 'bg-amber-500/10 text-amber-700 border-amber-500/20',
  принято: 'bg-emerald-500/10 text-emerald-700 border-emerald-500/20',
  отклонено: 'bg-red-500/10 text-red-700 border-red-500/20',
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

const formatCurrency = (v: number) =>
  new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: 'RUB',
    maximumFractionDigits: 0,
  }).format(v || 0)

const formatDate = (dateStr: string) =>
  new Date(dateStr).toLocaleDateString('ru-RU', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  })

const formatShortDate = (dateStr: string) => {
  const d = new Date(dateStr)
  return `до ${String(d.getDate()).padStart(2, '0')}.${String(d.getMonth() + 1).padStart(2, '0')}`
}

function getStatusBadge(status: string | null): string {
  if (!status) return STATUS_BADGE_MAP['отправлено']
  return STATUS_BADGE_MAP[status] ?? STATUS_BADGE_MAP['отправлено']
}

function pluralizeProposals(n: number): string {
  const abs = Math.abs(n)
  const mod10 = abs % 10
  const mod100 = abs % 100
  if (mod10 === 1 && mod100 !== 11) return 'предложение'
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20)) return 'предложения'
  return 'предложений'
}

// ─── Form types ───────────────────────────────────────────────────────────────

interface ProposalFormItem {
  product_name: string
  description: string
  quantity: number
  unit: string
  price_per_unit: number
}

interface ProposalFormData {
  company_id: string
  number: string
  status: string
  valid_until: string
  notes: string
  items: ProposalFormItem[]
}

const EMPTY_ITEM: ProposalFormItem = {
  product_name: '',
  description: '',
  quantity: 1,
  unit: 'шт',
  price_per_unit: 0,
}

const EMPTY_FORM: ProposalFormData = {
  company_id: '',
  number: '',
  status: 'отправлено',
  valid_until: '',
  notes: '',
  items: [{ ...EMPTY_ITEM }],
}

// ─── Extended proposal type ───────────────────────────────────────────────────

interface ProposalWithRelations extends Proposal {
  company?: Pick<Company, 'id' | 'name' | 'inn' | 'city'> | null
  manager?: Pick<User, 'id' | 'name'> | null
  items?: ProposalItem[]
}

// ─── Component ────────────────────────────────────────────────────────────────

export function ProposalsPage() {
  const currentUser = useAuthStore((s) => s.currentUser)
  const openCompany = useNavigationStore((s) => s.openCompany)

  // ─── State ───────────────────────────────────────────────────────────────

  const [proposals, setProposals] = useState<ProposalWithRelations[]>([])
  const [companies, setCompanies] = useState<Pick<Company, 'id' | 'name' | 'inn' | 'city'>[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [statusFilter, setStatusFilter] = useState<StatusFilter>('Все')
  const [managerFilter, setManagerFilter] = useState<ManagerFilter>('Все')
  const [expandedId, setExpandedId] = useState<string | null>(null)

  // Dialog state
  const [dialogOpen, setDialogOpen] = useState(false)
  const [editingProposal, setEditingProposal] = useState<ProposalWithRelations | null>(null)
  const [form, setForm] = useState<ProposalFormData>(EMPTY_FORM)
  const [saving, setSaving] = useState(false)

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
      let proposalsData: ProposalWithRelations[] = []
      let companiesData: Pick<Company, 'id' | 'name' | 'inn' | 'city'>[] = []
      let loadError: string | null = null

      // Proposals query — critical
      try {
        const res = await supabase
          .from('proposals')
          .select('*')
          .order('created_at', { ascending: false })
        if (res.error) throw res.error
        proposalsData = (res.data as ProposalWithRelations[]) ?? []
      } catch (err: unknown) {
        loadError = err instanceof Error ? err.message : 'Не удалось загрузить предложения'
      }

      // Companies lookup — optional (used for displaying company names)
      try {
        const res = await supabase.from('companies').select('id, name, inn, city').order('name')
        if (!res.error) companiesData = res.data ?? []
      } catch { /* companies lookup optional */ }

      if (cancelled) return
      setProposals(proposalsData)
      setCompanies(companiesData)
      setError(loadError)
      setLoading(false)
    }
    load()
    return () => {
      cancelled = true
    }
  }, [fetchTrigger])

  // ─── Expanded proposal: load items ──────────────────────────────────────

  const [expandedItems, setExpandedItems] = useState<Record<string, ProposalItem[]>>({})

  useEffect(() => {
    if (!expandedId) return
    let cancelled = false
    async function loadItems() {
      const { data } = await supabase
        .from('proposal_items')
        .select('*')
        .eq('proposal_id', expandedId)
        .order('created_at', { ascending: true })
      if (data && !cancelled) {
        setExpandedItems((prev) => ({ ...prev, [expandedId]: data }))
      }
    }
    // Only fetch if not already cached
    if (!expandedItems[expandedId]) {
      loadItems()
    }
    return () => {
      cancelled = true
    }
  }, [expandedId, expandedItems])

  const toggleExpanded = (id: string) => {
    setExpandedId((prev) => (prev === id ? null : id))
  }

  // ─── Computed: Filtered & Counted ────────────────────────────────────────

  const statusCounts = useMemo(() => {
    const counts: Record<string, number> = { Все: 0 }
    for (const s of STATUSES) counts[s] = 0
    for (const p of proposals) {
      const st = p.status || 'отправлено'
      counts[st] = (counts[st] || 0) + 1
      counts['Все']++
    }
    return counts
  }, [proposals])

  const filteredProposals = useMemo(() => {
    let result = [...proposals]

    if (statusFilter !== 'Все') {
      result = result.filter((p) => (p.status || 'отправлено') === statusFilter)
    }

    if (managerFilter === 'Мои' && currentUser) {
      result = result.filter((p) => p.manager_id === currentUser.id)
    }

    return result
  }, [proposals, statusFilter, managerFilter, currentUser])

  const totalAmount = useMemo(
    () => filteredProposals.reduce((sum, p) => sum + (p.total_amount || 0), 0),
    [filteredProposals],
  )

  // Lookup map for company names (since we no longer join)
  const companyMap = useMemo(() => {
    const map = new Map<string, Pick<Company, 'id' | 'name' | 'inn' | 'city'>>()
    for (const c of companies) {
      if (c.id) map.set(c.id, c)
    }
    return map
  }, [companies])

  // ─── Status change ──────────────────────────────────────────────────────

  const handleStatusChange = async (proposal: ProposalWithRelations, newStatus: string) => {
    const oldStatus = proposal.status || 'отправлено'
    if (oldStatus === newStatus) return

    const { error: updateError } = await supabase
      .from('proposals')
      .update({ status: newStatus })
      .eq('id', proposal.id)

    if (updateError) {
      toast.error('Ошибка: ' + updateError.message)
      return
    }
    toast.success(`Статус КП изменён на «${newStatus}»`)
    await supabase.from('activities').insert({
      company_id: proposal.company_id,
      user_id: currentUser?.id,
      type: 'статус_изменен',
      content: `КП${proposal.number ? ` №${proposal.number}` : ''}: статус изменён с «${oldStatus}» на «${newStatus}»`,
    }).catch(() => {})
    refresh()
  }

  // ─── Delete ──────────────────────────────────────────────────────────────

  const handleDelete = async (proposal: ProposalWithRelations) => {
    const label = proposal.number ? `КП №${proposal.number}` : 'КП'
    if (!window.confirm(`Удалить ${label}? Это действие нельзя отменить.`)) return

    const { error } = await supabase
      .from('proposals')
      .delete()
      .eq('id', proposal.id)

    if (error) {
      toast.error('Ошибка: ' + error.message)
      return
    }
    toast.success(`${label} удалено`)
    // Also delete related items
    await supabase.from('proposal_items').delete().eq('proposal_id', proposal.id).catch(() => {})
    await supabase.from('activities').insert({
      company_id: proposal.company_id,
      user_id: currentUser?.id,
      type: 'статус_изменен',
      content: `Удалено ${label} для «${companyMap.get(proposal.company_id)?.name || '—'}»`,
    }).catch(() => {})
    if (expandedId === proposal.id) setExpandedId(null)
    refresh()
  }

  // ─── Create / Edit Dialog ────────────────────────────────────────────────

  const openCreateDialog = () => {
    setEditingProposal(null)
    setForm({ ...EMPTY_FORM, items: [{ ...EMPTY_ITEM }] })
    setDialogOpen(true)
  }

  const openEditDialog = async (proposal: ProposalWithRelations) => {
    setEditingProposal(proposal)

    // Load items for this proposal
    const { data: items } = await supabase
      .from('proposal_items')
      .select('*')
      .eq('proposal_id', proposal.id)
      .order('created_at', { ascending: true })

    setForm({
      company_id: proposal.company_id,
      number: proposal.number ?? '',
      status: proposal.status || 'отправлено',
      valid_until: proposal.valid_until ? proposal.valid_until.split('T')[0] : '',
      notes: proposal.notes ?? '',
      items: items && items.length > 0
        ? items.map((item) => ({
            product_name: item.product_name,
            description: item.description ?? '',
            quantity: item.quantity ?? 1,
            unit: item.unit ?? 'шт',
            price_per_unit: item.price_per_unit ?? 0,
          }))
        : [{ ...EMPTY_ITEM }],
    })
    setDialogOpen(true)
  }

  const handleSave = async () => {
    if (!form.company_id.trim()) return
    setSaving(true)

    const grandTotal = form.items.reduce(
      (sum, item) => sum + (item.quantity || 0) * (item.price_per_unit || 0),
      0,
    )

    try {
      if (editingProposal) {
        // Update proposal
        const updates: ProposalUpdate = {
          company_id: form.company_id,
          number: form.number.trim() || null,
          status: form.status || null,
          valid_until: form.valid_until || null,
          notes: form.notes.trim() || null,
          total_amount: grandTotal,
          manager_id: currentUser?.id || null,
        }
        const { error: updateError } = await supabase
          .from('proposals')
          .update(updates)
          .eq('id', editingProposal.id)

        if (!updateError) {
          // Delete old items and insert new ones
          await supabase.from('proposal_items').delete().eq('proposal_id', editingProposal.id)

          const itemsToInsert: ProposalItemInsert[] = form.items
            .filter((item) => item.product_name.trim())
            .map((item) => ({
              proposal_id: editingProposal.id,
              product_name: item.product_name.trim(),
              description: item.description.trim() || null,
              quantity: item.quantity || 1,
              unit: item.unit || 'шт',
              price_per_unit: item.price_per_unit || 0,
              total_price: (item.quantity || 1) * (item.price_per_unit || 0),
            }))

          if (itemsToInsert.length > 0) {
            await supabase.from('proposal_items').insert(itemsToInsert)
          }

          await supabase.from('activities').insert({
            company_id: form.company_id,
            user_id: currentUser?.id,
            type: 'статус_изменен',
            content: `Обновлено КП${form.number ? ` №${form.number}` : ''} на ${formatCurrency(grandTotal)}`,
          })

          // Refresh expanded items cache
          setExpandedItems((prev) => {
            const next = { ...prev }
            delete next[editingProposal.id]
            return next
          })
        }
      } else {
        // Create proposal
        const insert: ProposalInsert = {
          company_id: form.company_id,
          number: form.number.trim() || null,
          status: form.status || 'отправлено',
          valid_until: form.valid_until || null,
          notes: form.notes.trim() || null,
          total_amount: grandTotal,
          manager_id: currentUser?.id || null,
        }
        const { data: createdProposal, error: insertError } = await supabase
          .from('proposals')
          .insert(insert)
          .select('id')
          .single()

        if (!insertError && createdProposal) {
          const itemsToInsert: ProposalItemInsert[] = form.items
            .filter((item) => item.product_name.trim())
            .map((item) => ({
              proposal_id: createdProposal.id,
              product_name: item.product_name.trim(),
              description: item.description.trim() || null,
              quantity: item.quantity || 1,
              unit: item.unit || 'шт',
              price_per_unit: item.price_per_unit || 0,
              total_price: (item.quantity || 1) * (item.price_per_unit || 0),
            }))

          if (itemsToInsert.length > 0) {
            await supabase.from('proposal_items').insert(itemsToInsert)
          }

          // Activity entry for new proposal
          await supabase.from('activities').insert({
            company_id: form.company_id,
            user_id: currentUser?.id,
            type: 'кп_отправлено',
            content: `Отправлено КП${form.number ? ` №${form.number}` : ''} на ${formatCurrency(grandTotal)}`,
          })
        }
      }

      setDialogOpen(false)
      setEditingProposal(null)
      setForm(EMPTY_FORM)
      toast.success(editingProposal ? 'КП обновлено' : 'КП создано')
      refresh()
    } catch (err) {
      toast.error('Произошла ошибка при сохранении')
    }
    setSaving(false)
  }

  // ─── Form item helpers ──────────────────────────────────────────────────

  const updateItem = (index: number, field: keyof ProposalFormItem, value: string | number) => {
    setForm((prev) => ({
      ...prev,
      items: prev.items.map((item, i) => (i === index ? { ...item, [field]: value } : item)),
    }))
  }

  const addItem = () => {
    setForm((prev) => ({
      ...prev,
      items: [...prev.items, { ...EMPTY_ITEM }],
    }))
  }

  const removeItem = (index: number) => {
    setForm((prev) => ({
      ...prev,
      items: prev.items.filter((_, i) => i !== index),
    }))
  }

  const grandTotal = useMemo(
    () =>
      form.items.reduce(
        (sum, item) => sum + (item.quantity || 0) * (item.price_per_unit || 0),
        0,
      ),
    [form.items],
  )

  // ─── Render: Loading ─────────────────────────────────────────────────────

  if (loading) {
    return (
      <div className="space-y-4">
        {/* Top bar skeleton */}
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
          <div>
            <Skeleton className="h-6 w-56 mb-1" />
            <Skeleton className="h-4 w-48" />
          </div>
          <Skeleton className="h-9 w-32 rounded-xl" />
        </div>
        {/* Filter bar skeleton */}
        <div className="flex items-center gap-2 flex-wrap">
          {Array.from({ length: 5 }).map((_, i) => (
            <Skeleton key={i} className="h-8 w-28 rounded-lg" />
          ))}
        </div>
        {/* Table skeleton */}
        <div className="border border-border/60 rounded-2xl shadow-sm overflow-hidden">
          <div className="bg-muted/40 px-4 py-3 flex gap-4">
            {Array.from({ length: 7 }).map((_, i) => (
              <Skeleton key={i} className="h-4 flex-1" />
            ))}
          </div>
          {Array.from({ length: 5 }).map((_, i) => (
            <div
              key={i}
              className="px-4 py-4 flex gap-4 border-b border-border last:border-0"
            >
              {Array.from({ length: 7 }).map((_, j) => (
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
        <h3 className="text-lg font-semibold text-foreground">Что-то пошло не так</h3>
        <p className="text-sm text-muted-foreground max-w-md text-center">{error}</p>
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
            <FileText className="h-5 w-5 text-sky-500" />
            Коммерческие предложения
          </h2>
          <p className="text-sm text-muted-foreground mt-0.5">
            {proposals.length} {pluralizeProposals(proposals.length)}
            {totalAmount > 0 && <> &middot; {formatCurrency(totalAmount)} всего</>}
          </p>
        </div>
        <Button size="sm" onClick={openCreateDialog} className="gap-1.5 rounded-xl">
          <Plus className="h-4 w-4" />
          Новое КП
        </Button>
      </div>

      {/* ── Filter Bar ─────────────────────────────────────────────────────── */}
      <div className="flex flex-col sm:flex-row sm:items-center gap-3 flex-wrap">
        {/* Status filter pills */}
        <div className="flex items-center gap-1.5 bg-muted/60 rounded-xl p-1 overflow-x-auto">
          {(['Все', ...STATUSES] as const).map((status) => (
            <button
              key={status}
              onClick={() =>
                setStatusFilter(statusFilter === status ? 'Все' : (status as StatusFilter))
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
        </div>

        {/* Manager toggle */}
        {currentUser && (
          <div className="flex items-center gap-1.5 bg-muted/60 rounded-xl p-1">
            {(['Все', 'Мои'] as ManagerFilter[]).map((f) => (
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
      </div>

      {/* ── Empty State ────────────────────────────────────────────────────── */}
      {!loading && !error && proposals.length === 0 && (
        <div className="flex flex-col items-center justify-center py-20 gap-4">
          <div className="h-14 w-14 rounded-full bg-muted/50 flex items-center justify-center">
            <FileText className="h-7 w-7 text-muted-foreground" />
          </div>
          <div className="text-center">
            <p className="text-base font-medium text-foreground">Нет коммерческих предложений</p>
            <p className="text-sm text-muted-foreground mt-1">
              Создайте первое КП, чтобы начать работу
            </p>
          </div>
          <Button size="sm" onClick={openCreateDialog} className="gap-1.5 rounded-xl">
            <Plus className="h-4 w-4" />
            Новое КП
          </Button>
        </div>
      )}

      {/* ── Filter No Results ──────────────────────────────────────────────── */}
      {!loading && !error && proposals.length > 0 && filteredProposals.length === 0 && (
        <div className="flex flex-col items-center justify-center py-16 gap-3">
          <Package className="h-8 w-8 text-muted-foreground" />
          <p className="text-sm text-muted-foreground">Предложения по выбранным фильтрам не найдены</p>
          <Button
            variant="outline"
            size="sm"
            onClick={() => {
              setStatusFilter('Все')
              setManagerFilter('Все')
            }}
          >
            Сбросить фильтры
          </Button>
        </div>
      )}

      {/* ── Proposal List ──────────────────────────────────────────────────── */}
      {!loading && !error && filteredProposals.length > 0 && (
        <>
          {/* Desktop Table */}
          <div className="hidden md:block border border-border/60 rounded-2xl shadow-sm overflow-hidden flex-1">
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow className="bg-muted/40 hover:bg-muted/40">
                    <TableHead className="pl-4 min-w-[50px] w-[50px]" />
                    <TableHead className="min-w-[100px]">Номер</TableHead>
                    <TableHead className="min-w-[200px]">Компания</TableHead>
                    <TableHead className="min-w-[120px]">Менеджер</TableHead>
                    <TableHead className="min-w-[130px]">Статус</TableHead>
                    <TableHead className="min-w-[130px] text-right">Сумма</TableHead>
                    <TableHead className="min-w-[100px]">Создано</TableHead>
                    <TableHead className="min-w-[100px]">Действительно</TableHead>
                    <TableHead className="pr-4 text-right w-[120px]">Действия</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredProposals.map((proposal) => {
                    const isExpanded = expandedId === proposal.id
                    const items = expandedItems[proposal.id] || []

                    return (
                      <>
                        <TableRow
                          key={proposal.id}
                          className={`cursor-pointer hover:bg-primary/5 transition-colors ${
                            isExpanded ? 'bg-primary/[0.03]' : ''
                          }`}
                          onClick={() => toggleExpanded(proposal.id)}
                        >
                          <TableCell className="pl-4">
                            <button
                              className="h-6 w-6 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-primary/10 transition-colors"
                              aria-label={isExpanded ? 'Свернуть' : 'Развернуть'}
                            >
                              {isExpanded ? (
                                <ChevronUp className="h-4 w-4" />
                              ) : (
                                <ChevronDown className="h-4 w-4" />
                              )}
                            </button>
                          </TableCell>
                          <TableCell>
                            <span className="text-sm font-medium">
                              {proposal.number || 'Без номера'}
                            </span>
                          </TableCell>
                          <TableCell>
                            <button
                              onClick={(e) => {
                                e.stopPropagation()
                                openCompany(proposal.company_id)
                              }}
                              className="text-sm font-medium text-foreground hover:text-primary hover:underline transition-colors text-left"
                            >
                              {companyMap.get(proposal.company_id)?.name || '—'}
                            </button>
                          </TableCell>
                          <TableCell>
                            <span className="text-sm text-muted-foreground">
                              {proposal.manager?.name || proposal.manager_name || '—'}
                            </span>
                          </TableCell>
                          <TableCell>
                            <DropdownMenu>
                              <DropdownMenuTrigger asChild>
                                <button
                                  onClick={(e) => e.stopPropagation()}
                                  className="focus:outline-none"
                                >
                                  <Badge
                                    variant="outline"
                                    className={`text-xs whitespace-nowrap cursor-pointer hover:opacity-80 transition-opacity ${getStatusBadge(proposal.status)}`}
                                  >
                                    {proposal.status || 'отправлено'}
                                  </Badge>
                                </button>
                              </DropdownMenuTrigger>
                              <DropdownMenuContent align="start">
                                {STATUSES.map((s) => (
                                  <DropdownMenuItem
                                    key={s}
                                    onClick={(e) => {
                                      e.stopPropagation()
                                      handleStatusChange(proposal, s)
                                    }}
                                    disabled={proposal.status === s}
                                  >
                                    <Badge
                                      variant="outline"
                                      className={`text-xs ${getStatusBadge(s)}`}
                                    >
                                      {s}
                                    </Badge>
                                  </DropdownMenuItem>
                                ))}
                              </DropdownMenuContent>
                            </DropdownMenu>
                          </TableCell>
                          <TableCell className="text-right">
                            <span className="text-sm font-medium">
                              {formatCurrency(proposal.total_amount || 0)}
                            </span>
                          </TableCell>
                          <TableCell>
                            <span className="text-xs text-muted-foreground">
                              {formatDate(proposal.created_at)}
                            </span>
                          </TableCell>
                          <TableCell>
                            {proposal.valid_until ? (
                              <span className="text-xs text-muted-foreground">
                                {formatShortDate(proposal.valid_until)}
                              </span>
                            ) : (
                              <span className="text-xs text-muted-foreground">&mdash;</span>
                            )}
                          </TableCell>
                          <TableCell className="pr-4 text-right">
                            <div className="flex items-center justify-end gap-1">
                              <button
                                onClick={(e) => {
                                  e.stopPropagation()
                                  toggleExpanded(proposal.id)
                                }}
                                className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-primary/10 transition-colors"
                                aria-label="Просмотреть детали"
                              >
                                <Eye className="h-3.5 w-3.5" />
                              </button>
                              <button
                                onClick={(e) => {
                                  e.stopPropagation()
                                  openEditDialog(proposal)
                                }}
                                className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-primary/10 transition-colors"
                                aria-label="Редактировать"
                              >
                                <Pencil className="h-3.5 w-3.5" />
                              </button>
                              <button
                                onClick={(e) => {
                                  e.stopPropagation()
                                  handleDelete(proposal)
                                }}
                                className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                                aria-label="Удалить"
                              >
                                <Trash2 className="h-3.5 w-3.5" />
                              </button>
                            </div>
                          </TableCell>
                        </TableRow>

                        {/* ── Expanded Detail Row ──────────────────────────── */}
                        {isExpanded && (
                          <TableRow key={`${proposal.id}-detail`} className="bg-muted/20 hover:bg-muted/20">
                            <TableCell colSpan={9} className="p-0">
                              <div className="px-6 py-5">
                                {/* Company info */}
                                <div className="flex flex-col sm:flex-row sm:items-center gap-4 mb-4">
                                  <div className="flex items-center gap-2 text-sm">
                                    <Building2 className="h-4 w-4 text-muted-foreground" />
                                    <button
                                      onClick={() => openCompany(proposal.company_id)}
                                      className="font-medium hover:text-primary hover:underline transition-colors"
                                    >
                                      {companyMap.get(proposal.company_id)?.name || '—'}
                                    </button>
                                    {companyMap.get(proposal.company_id)?.inn && (
                                      <span className="text-muted-foreground">
                                        &middot; ИНН {companyMap.get(proposal.company_id)!.inn}
                                      </span>
                                    )}
                                    {companyMap.get(proposal.company_id)?.city && (
                                      <span className="text-muted-foreground">
                                        &middot; {companyMap.get(proposal.company_id)!.city}
                                      </span>
                                    )}
                                  </div>
                                </div>

                                {/* Line items mini-table */}
                                {items.length > 0 ? (
                                  <div className="border border-border/60 rounded-xl overflow-hidden mb-4">
                                    <Table>
                                      <TableHeader>
                                        <TableRow className="bg-muted/40 hover:bg-muted/40">
                                          <TableHead className="pl-4 min-w-[180px]">Наименование</TableHead>
                                          <TableHead className="min-w-[200px]">Описание</TableHead>
                                          <TableHead className="min-w-[70px] text-center">Кол-во</TableHead>
                                          <TableHead className="min-w-[60px] text-center">Ед.</TableHead>
                                          <TableHead className="min-w-[110px] text-right">Цена</TableHead>
                                          <TableHead className="pr-4 min-w-[110px] text-right">Сумма</TableHead>
                                        </TableRow>
                                      </TableHeader>
                                      <TableBody>
                                        {items.map((item) => (
                                          <TableRow key={item.id}>
                                            <TableCell className="pl-4 text-sm font-medium">
                                              {item.product_name}
                                            </TableCell>
                                            <TableCell className="text-sm text-muted-foreground">
                                              {item.description || '—'}
                                            </TableCell>
                                            <TableCell className="text-sm text-center">
                                              {item.quantity ?? 1}
                                            </TableCell>
                                            <TableCell className="text-sm text-center">
                                              {item.unit || 'шт'}
                                            </TableCell>
                                            <TableCell className="text-sm text-right">
                                              {formatCurrency(item.price_per_unit || 0)}
                                            </TableCell>
                                            <TableCell className="pr-4 text-sm text-right font-medium">
                                              {formatCurrency(item.total_price || 0)}
                                            </TableCell>
                                          </TableRow>
                                        ))}
                                        {/* Total row */}
                                        <TableRow className="bg-muted/30 hover:bg-muted/30 font-semibold">
                                          <TableCell className="pl-4" colSpan={5}>
                                            <span className="text-sm">Итого по позициям:</span>
                                          </TableCell>
                                          <TableCell className="pr-4 text-right text-sm">
                                            {formatCurrency(
                                              items.reduce(
                                                (sum, item) => sum + (item.total_price || 0),
                                                0,
                                              ),
                                            )}
                                          </TableCell>
                                        </TableRow>
                                      </TableBody>
                                    </Table>
                                  </div>
                                ) : (
                                  <div className="flex items-center justify-center py-8 border border-dashed border-border/60 rounded-xl mb-4">
                                    <p className="text-sm text-muted-foreground">Нет позиций</p>
                                  </div>
                                )}

                                {/* Notes */}
                                {proposal.notes && (
                                  <div className="mb-3">
                                    <p className="text-xs font-medium text-muted-foreground mb-1">
                                      Примечание:
                                    </p>
                                    <p className="text-sm text-foreground whitespace-pre-wrap">
                                      {proposal.notes}
                                    </p>
                                  </div>
                                )}

                                {/* Valid until + created info */}
                                <div className="flex items-center gap-4 text-xs text-muted-foreground">
                                  {proposal.valid_until && (
                                    <span className="flex items-center gap-1">
                                      <Calendar className="h-3.5 w-3.5" />
                                      Действительно до: {formatDate(proposal.valid_until)}
                                    </span>
                                  )}
                                  <span className="flex items-center gap-1">
                                    <Package className="h-3.5 w-3.5" />
                                    Создано: {formatDate(proposal.created_at)}
                                  </span>
                                </div>
                              </div>
                            </TableCell>
                          </TableRow>
                        )}
                      </>
                    )
                  })}
                </TableBody>
              </Table>
            </div>
          </div>

          {/* Mobile Cards */}
          <div className="md:hidden space-y-3">
            {filteredProposals.map((proposal) => {
              const isExpanded = expandedId === proposal.id
              const items = expandedItems[proposal.id] || []

              return (
                <div
                  key={proposal.id}
                  className="rounded-2xl border border-border/60 shadow-sm transition-all hover:shadow-md bg-card"
                >
                  {/* Card Header */}
                  <div
                    className="p-4 cursor-pointer active:scale-[0.99]"
                    onClick={() => toggleExpanded(proposal.id)}
                  >
                    <div className="flex items-start justify-between gap-2 mb-2">
                      <div className="min-w-0 flex-1">
                        <div className="flex items-center gap-2">
                          <span className="text-sm font-medium">
                            КП {proposal.number ? `№${proposal.number}` : 'Без номера'}
                          </span>
                          <Badge
                            variant="outline"
                            className={`text-[10px] whitespace-nowrap ${getStatusBadge(proposal.status)}`}
                          >
                            {proposal.status || 'отправлено'}
                          </Badge>
                        </div>
                        <button
                          onClick={(e) => {
                            e.stopPropagation()
                            openCompany(proposal.company_id)
                          }}
                          className="text-sm text-muted-foreground hover:text-primary hover:underline transition-colors text-left mt-1 block truncate max-w-[260px]"
                        >
                          {companyMap.get(proposal.company_id)?.name || '—'}
                        </button>
                      </div>
                      <div className="flex items-center gap-1 shrink-0">
                        <button
                          onClick={(e) => {
                            e.stopPropagation()
                            openEditDialog(proposal)
                          }}
                          className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-primary/10 transition-colors"
                          aria-label="Редактировать"
                        >
                          <Pencil className="h-3.5 w-3.5" />
                        </button>
                        <button
                          onClick={(e) => {
                            e.stopPropagation()
                            handleDelete(proposal)
                          }}
                          className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                          aria-label="Удалить"
                        >
                          <Trash2 className="h-3.5 w-3.5" />
                        </button>
                      </div>
                    </div>

                    {/* Amount + dates */}
                    <div className="flex items-center justify-between">
                      <span className="text-sm font-semibold">
                        {formatCurrency(proposal.total_amount || 0)}
                      </span>
                      <div className="flex items-center gap-2 text-xs text-muted-foreground">
                        <span>{formatDate(proposal.created_at)}</span>
                        {proposal.valid_until && (
                          <span>{formatShortDate(proposal.valid_until)}</span>
                        )}
                      </div>
                    </div>

                    {/* Manager */}
                    <div className="mt-2 text-xs text-muted-foreground">
                      Менеджер: {proposal.manager?.name || proposal.manager_name || '—'}
                    </div>

                    {/* Expand/collapse icon */}
                    <div className="flex justify-center mt-2">
                      {isExpanded ? (
                        <ChevronUp className="h-4 w-4 text-muted-foreground" />
                      ) : (
                        <ChevronDown className="h-4 w-4 text-muted-foreground" />
                      )}
                    </div>
                  </div>

                  {/* ── Expanded Detail ──────────────────────────────────── */}
                  {isExpanded && (
                    <div className="px-4 pb-4 border-t border-border/60 pt-3 space-y-3">
                      {/* Company info */}
                      <div className="flex flex-wrap items-center gap-2 text-sm">
                        <Building2 className="h-4 w-4 text-muted-foreground shrink-0" />
                        <button
                          onClick={() => openCompany(proposal.company_id)}
                          className="font-medium hover:text-primary hover:underline transition-colors"
                        >
                          {companyMap.get(proposal.company_id)?.name || '—'}
                        </button>
                        {companyMap.get(proposal.company_id)?.inn && (
                          <span className="text-muted-foreground">ИНН {companyMap.get(proposal.company_id)!.inn}</span>
                        )}
                        {companyMap.get(proposal.company_id)?.city && (
                          <span className="text-muted-foreground">&middot; {companyMap.get(proposal.company_id)!.city}</span>
                        )}
                      </div>

                      {/* Status change */}
                      <div className="flex items-center gap-2">
                        <span className="text-xs text-muted-foreground">Статус:</span>
                        <Select
                          value={proposal.status || 'отправлено'}
                          onValueChange={(v) => handleStatusChange(proposal, v)}
                        >
                          <SelectTrigger className="h-7 w-auto text-xs rounded-lg">
                            <SelectValue />
                          </SelectTrigger>
                          <SelectContent>
                            {STATUSES.map((s) => (
                              <SelectItem key={s} value={s} disabled={proposal.status === s}>
                                {s}
                              </SelectItem>
                            ))}
                          </SelectContent>
                        </Select>
                      </div>

                      {/* Line items */}
                      {items.length > 0 ? (
                        <div className="border border-border/60 rounded-xl overflow-hidden">
                          <Table>
                            <TableHeader>
                              <TableRow className="bg-muted/40 hover:bg-muted/40">
                                <TableHead className="pl-3 text-xs min-w-[100px]">Позиция</TableHead>
                                <TableHead className="text-xs text-center min-w-[50px]">Кол.</TableHead>
                                <TableHead className="text-xs text-center min-w-[40px]">Ед.</TableHead>
                                <TableHead className="text-xs text-right min-w-[80px]">Цена</TableHead>
                                <TableHead className="pr-3 text-xs text-right min-w-[80px]">Сумма</TableHead>
                              </TableRow>
                            </TableHeader>
                            <TableBody>
                              {items.map((item) => (
                                <TableRow key={item.id}>
                                  <TableCell className="pl-3 text-xs font-medium">
                                    {item.product_name}
                                  </TableCell>
                                  <TableCell className="text-xs text-center">
                                    {item.quantity ?? 1}
                                  </TableCell>
                                  <TableCell className="text-xs text-center">
                                    {item.unit || 'шт'}
                                  </TableCell>
                                  <TableCell className="text-xs text-right">
                                    {formatCurrency(item.price_per_unit || 0)}
                                  </TableCell>
                                  <TableCell className="pr-3 text-xs text-right font-medium">
                                    {formatCurrency(item.total_price || 0)}
                                  </TableCell>
                                </TableRow>
                              ))}
                              <TableRow className="bg-muted/30 hover:bg-muted/30 font-semibold">
                                <TableCell className="pl-3 text-xs" colSpan={4}>
                                  Итого:
                                </TableCell>
                                <TableCell className="pr-3 text-xs text-right">
                                  {formatCurrency(
                                    items.reduce(
                                      (sum, item) => sum + (item.total_price || 0),
                                      0,
                                    ),
                                  )}
                                </TableCell>
                              </TableRow>
                            </TableBody>
                          </Table>
                        </div>
                      ) : (
                        <div className="flex items-center justify-center py-6 border border-dashed border-border/60 rounded-xl">
                          <p className="text-xs text-muted-foreground">Нет позиций</p>
                        </div>
                      )}

                      {/* Notes */}
                      {proposal.notes && (
                        <div>
                          <p className="text-xs font-medium text-muted-foreground mb-0.5">
                            Примечание:
                          </p>
                          <p className="text-xs text-foreground whitespace-pre-wrap">{proposal.notes}</p>
                        </div>
                      )}

                      {/* Dates */}
                      <div className="flex items-center gap-3 text-xs text-muted-foreground">
                        {proposal.valid_until && (
                          <span className="flex items-center gap-1">
                            <Calendar className="h-3 w-3" />
                            до {formatShortDate(proposal.valid_until)}
                          </span>
                        )}
                        <span className="flex items-center gap-1">
                          <Package className="h-3 w-3" />
                          {formatDate(proposal.created_at)}
                        </span>
                      </div>
                    </div>
                  )}
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
            setEditingProposal(null)
            setForm(EMPTY_FORM)
          }
        }}
      >
        <DialogContent className="sm:max-w-2xl max-h-[90vh] flex flex-col">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              {editingProposal ? (
                <>
                  <Pencil className="h-5 w-5" />
                  Редактировать КП
                </>
              ) : (
                <>
                  <Plus className="h-5 w-5" />
                  Новое коммерческое предложение
                </>
              )}
            </DialogTitle>
          </DialogHeader>

          <ScrollArea className="flex-1 -mx-6 px-6">
            <div className="space-y-4 pt-2 pb-4">
              {/* Company select */}
              <div className="space-y-2">
                <Label>
                  Компания <span className="text-destructive">*</span>
                </Label>
                <Select
                  value={form.company_id}
                  onValueChange={(v) => setForm((f) => ({ ...f, company_id: v }))}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Выберите компанию" />
                  </SelectTrigger>
                  <SelectContent>
                    {companies.map((c) => (
                      <SelectItem key={c.id} value={c.id}>
                        {c.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              {/* Number + Status */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label htmlFor="proposal-number">Номер КП</Label>
                  <Input
                    id="proposal-number"
                    placeholder="напр. КП-2024-001"
                    value={form.number}
                    onChange={(e) => setForm((f) => ({ ...f, number: e.target.value }))}
                  />
                </div>
                <div className="space-y-2">
                  <Label>Статус</Label>
                  <Select
                    value={form.status}
                    onValueChange={(v) => setForm((f) => ({ ...f, status: v }))}
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

              {/* Valid until */}
              <div className="space-y-2">
                <Label htmlFor="proposal-valid-until">Действительно до</Label>
                <Input
                  id="proposal-valid-until"
                  type="date"
                  value={form.valid_until}
                  onChange={(e) => setForm((f) => ({ ...f, valid_until: e.target.value }))}
                />
              </div>

              {/* Notes */}
              <div className="space-y-2">
                <Label htmlFor="proposal-notes">Примечание</Label>
                <Textarea
                  id="proposal-notes"
                  placeholder="Дополнительная информация..."
                  value={form.notes}
                  onChange={(e) => setForm((f) => ({ ...f, notes: e.target.value }))}
                  rows={3}
                />
              </div>

              <Separator />

              {/* ── Line Items Section ─────────────────────────────────── */}
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <Label className="text-base font-semibold">Позиции</Label>
                  <Button
                    type="button"
                    variant="outline"
                    size="sm"
                    onClick={addItem}
                    className="gap-1.5 h-8 rounded-lg"
                  >
                    <Plus className="h-3.5 w-3.5" />
                    Добавить
                  </Button>
                </div>

                {form.items.map((item, index) => (
                  <div
                    key={index}
                    className="rounded-xl border border-border/60 p-3 space-y-3"
                  >
                    <div className="flex items-center justify-between">
                      <span className="text-xs font-medium text-muted-foreground">
                        Позиция {index + 1}
                      </span>
                      {form.items.length > 1 && (
                        <button
                          type="button"
                          onClick={() => removeItem(index)}
                          className="h-6 w-6 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                          aria-label={`Удалить позицию ${index + 1}`}
                        >
                          <X className="h-3.5 w-3.5" />
                        </button>
                      )}
                    </div>

                    {/* Product name + description */}
                    <div className="space-y-2">
                      <Input
                        placeholder="Наименование *"
                        value={item.product_name}
                        onChange={(e) => updateItem(index, 'product_name', e.target.value)}
                      />
                      <Input
                        placeholder="Описание (необязательно)"
                        value={item.description}
                        onChange={(e) => updateItem(index, 'description', e.target.value)}
                      />
                    </div>

                    {/* Quantity, unit, price, total */}
                    <div className="grid grid-cols-[1fr_auto_1fr] gap-2 items-end">
                      <div className="space-y-1">
                        <Label className="text-xs text-muted-foreground">Кол-во</Label>
                        <Input
                          type="number"
                          min={1}
                          step={1}
                          value={item.quantity || ''}
                          onChange={(e) => updateItem(index, 'quantity', Number(e.target.value) || 0)}
                          className="h-9"
                        />
                      </div>
                      <div className="space-y-1">
                        <Label className="text-xs text-muted-foreground">Ед.</Label>
                        <Input
                          placeholder="шт"
                          value={item.unit}
                          onChange={(e) => updateItem(index, 'unit', e.target.value)}
                          className="h-9 w-16"
                        />
                      </div>
                      <div className="space-y-1">
                        <Label className="text-xs text-muted-foreground">Цена за ед.</Label>
                        <Input
                          type="number"
                          min={0}
                          step={100}
                          placeholder="0"
                          value={item.price_per_unit || ''}
                          onChange={(e) => updateItem(index, 'price_per_unit', Number(e.target.value) || 0)}
                          className="h-9"
                        />
                      </div>
                    </div>

                    {/* Auto-calculated total */}
                    <div className="flex justify-end">
                      <span className="text-sm font-medium text-muted-foreground">
                        Сумма:{' '}
                        <span className="text-foreground">
                          {formatCurrency((item.quantity || 0) * (item.price_per_unit || 0))}
                        </span>
                      </span>
                    </div>
                  </div>
                ))}

                {/* Grand total */}
                <div className="flex justify-end pt-2 border-t border-border/60">
                  <div className="text-right">
                    <span className="text-sm text-muted-foreground">Итого: </span>
                    <span className="text-lg font-bold">{formatCurrency(grandTotal)}</span>
                  </div>
                </div>
              </div>
            </div>
          </ScrollArea>

          {/* Dialog actions */}
          <div className="flex justify-end gap-2 pt-2 border-t border-border/60">
            <Button variant="outline" onClick={() => setDialogOpen(false)}>
              Отмена
            </Button>
            <Button
              onClick={handleSave}
              disabled={!form.company_id || form.items.every((i) => !i.product_name.trim()) || saving}
              className="rounded-xl"
            >
              {saving
                ? 'Сохранение...'
                : editingProposal
                  ? 'Сохранить изменения'
                  : 'Создать КП'}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
