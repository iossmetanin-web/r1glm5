'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import type { Deal, DealInsert, PipelineStage, Company } from '@/lib/supabase/database.types'
import { useNavigationStore, useAuthStore } from '@/lib/store'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectItem,
} from '@/components/ui/select'
import { Badge } from '@/components/ui/badge'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { Skeleton } from '@/components/ui/skeleton'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Separator } from '@/components/ui/separator'
import { toast } from 'sonner'
import { Plus, MoreHorizontal, Trash2, AlertCircle, Package } from 'lucide-react'

// ─── Helpers ──────────────────────────────────────────────────────────────────

const formatCurrency = (v: number) =>
  new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: 'RUB',
    maximumFractionDigits: 0,
  }).format(v || 0)

type FilterType = 'all' | 'open' | 'won' | 'lost'

// ─── Component ────────────────────────────────────────────────────────────────

export default function DealsPage() {
  const currentUser = useAuthStore((s) => s.currentUser)
  const openCompany = useNavigationStore((s) => s.openCompany)

  const [stages, setStages] = useState<PipelineStage[]>([])
  const [deals, setDeals] = useState<Deal[]>([])
  const [companies, setCompanies] = useState<Company[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [filter, setFilter] = useState<FilterType>('all')
  const [createOpen, setCreateOpen] = useState(false)

  // Create deal form state
  const [newTitle, setNewTitle] = useState('')
  const [newValue, setNewValue] = useState(0)
  const [newCompanyId, setNewCompanyId] = useState<string | null>(null)
  const [newPriority, setNewPriority] = useState('Medium')
  const [newStageId, setNewStageId] = useState<string>('')
  const [creating, setCreating] = useState(false)

  // ─── Data Fetching (NO JOINs — separate queries) ────────────────────────────

  const [fetchTrigger, setFetchTrigger] = useState(0)

  useEffect(() => {
    let cancelled = false
    async function load() {
      try {
        // Separate queries — no fragile JOINs
        const [stagesRes, dealsRes, companiesRes] = await Promise.all([
          supabase.from('pipeline_stages').select('*').order('position'),
          supabase.from('deals').select('*').order('created_at', { ascending: false }),
          supabase.from('companies').select('id, name').order('name'),
        ])

        if (cancelled) return

        if (stagesRes.error) throw stagesRes.error
        if (dealsRes.error) throw dealsRes.error

        setStages(stagesRes.data ?? [])
        setDeals(dealsRes.data ?? [])
        setCompanies(companiesRes.data ?? [])
        setError(null)
      } catch (err: unknown) {
        if (cancelled) return
        setError(err instanceof Error ? err.message : 'Не удалось загрузить данные')
      }
      setLoading(false)
    }
    load()
    return () => { cancelled = true }
  }, [fetchTrigger])

  const fetchData = () => {
    setLoading(true)
    setFetchTrigger((n) => n + 1)
  }

  // ─── Computed maps ─────────────────────────────────────────────────────────

  const stageMap = new Map<string, PipelineStage>()
  for (const s of stages) stageMap.set(s.id, s)

  const companyMap = new Map<string, Company>()
  for (const c of companies) companyMap.set(c.id, c)

  // ─── Filter Logic ─────────────────────────────────────────────────────────

  const filteredDeals = deals.filter((deal) => {
    const stage = stageMap.get(deal.stage_id)
    if (filter === 'all') return true
    if (filter === 'open') {
      return stage && !stage.is_won && !stage.is_closed
    }
    if (filter === 'won') return stage && stage.is_won === true
    if (filter === 'lost') return stage && stage.is_closed === true && !stage.is_won
    return true
  })

  // Group deals by stage_id
  const dealsByStage = stages.map((stage) => ({
    stage,
    deals: filteredDeals.filter((d) => d.stage_id === stage.id),
  }))

  // ─── Move Deal ────────────────────────────────────────────────────────────

  const moveDeal = async (deal: Deal, newIndex: number) => {
    if (newIndex < 0 || newIndex >= stages.length) return
    const newStage = stages[newIndex]
    const { error } = await supabase
      .from('deals')
      .update({ stage_id: newStage.id })
      .eq('id', deal.id)
    if (!error) {
      toast.success(`Сделка «${deal.title}» перемещена в «${newStage.name}»`)
      await supabase.from('activities').insert({
        content: `Перемещена сделка «${deal.title}» в ${newStage.name}`,
        type: 'заметка',
        user_id: currentUser?.id,
      } as any).catch(() => {})
      fetchData()
    } else {
      toast.error('Ошибка: ' + error.message)
    }
  }

  // ─── Delete Deal ──────────────────────────────────────────────────────────

  const deleteDeal = async (deal: Deal) => {
    if (!window.confirm(`Удалить "${deal.title}"? Это действие нельзя отменить.`))
      return
    const { error } = await supabase
      .from('deals')
      .delete()
      .eq('id', deal.id)
    if (!error) {
      toast.success(`Сделка «${deal.title}» удалена`)
      await supabase.from('activities').insert({
        content: `Удалена сделка «${deal.title}»`,
        type: 'заметка',
        user_id: currentUser?.id,
      } as any).catch(() => {})
      fetchData()
    } else {
      toast.error('Ошибка: ' + error.message)
    }
  }

  // ─── Create Deal ──────────────────────────────────────────────────────────

  const handleCreateDeal = async () => {
    if (!newTitle.trim()) return
    setCreating(true)
    const stageId = newStageId || stages[0]?.id
    if (!stageId) {
      toast.error('Нет этапов воронки. Создайте их в Настройках → CRM.')
      setCreating(false)
      return
    }
    const { error } = await supabase.from('deals').insert({
      title: newTitle.trim(),
      value: newValue || 0,
      client_id: newCompanyId || null,
      priority: newPriority,
      stage_id: stageId,
      owner_id: currentUser?.id,
      status: 'open',
      currency: 'RUB',
      pipeline_id: stages[0]?.pipeline_id || '',
    } as DealInsert)
    if (!error) {
      toast.success(`Сделка «${newTitle.trim()}» создана`)
      await supabase.from('activities').insert({
        content: `Создана сделка «${newTitle.trim()}» на ${formatCurrency(newValue || 0)}`,
        type: 'заметка',
        user_id: currentUser?.id,
      } as any).catch(() => {})
      setNewTitle('')
      setNewValue(0)
      setNewCompanyId(null)
      setNewPriority('Medium')
      setNewStageId('')
      setCreateOpen(false)
      fetchData()
    } else {
      toast.error('Ошибка: ' + error.message)
    }
    setCreating(false)
  }

  const openCreateDialog = () => {
    setNewTitle('')
    setNewValue(0)
    setNewCompanyId(null)
    setNewPriority('Medium')
    setNewStageId(stages[0]?.id || '')
    setCreateOpen(true)
  }

  // ─── Render ───────────────────────────────────────────────────────────────

  return (
    <div className="flex flex-col gap-4 md:h-full">
      {/* ── Top Bar ────────────────────────────────────────────────────────── */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
        <div>
          <h2 className="text-xl font-semibold tracking-tight flex items-center gap-2">
            <Package className="h-5 w-5 text-amber-500" />
            Воронка сделок
          </h2>
          <p className="text-sm text-muted-foreground mt-0.5">
            {deals.length}{' '}
            {deals.length === 1 ? 'сделка' : deals.length < 5 ? 'сделки' : 'сделок'} &middot;{' '}
            {formatCurrency(
              deals.reduce((sum, d) => sum + (d.value || 0), 0)
            )}{' '}
            всего
          </p>
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          {/* Filter Buttons */}
          <div className="flex items-center gap-1 bg-muted/60 rounded-xl p-1">
            {([
              { key: 'all', label: 'Все' },
              { key: 'open', label: 'Открытые' },
              { key: 'won', label: 'Выигранные' },
              { key: 'lost', label: 'Проигранные' },
            ] as const).map((f) => (
              <button
                key={f.key}
                onClick={() => setFilter(f.key as FilterType)}
                className={`px-3 py-1.5 text-xs font-medium rounded-md transition-colors ${
                  filter === f.key
                    ? 'bg-primary text-primary-foreground shadow-sm shadow-primary/20'
                    : 'text-muted-foreground hover:text-foreground hover:bg-primary/5'
                }`}
              >
                {f.label}
              </button>
            ))}
          </div>
          <Button size="sm" onClick={openCreateDialog} className="gap-1.5 rounded-xl">
            <Plus className="h-4 w-4" />
            Новая сделка
          </Button>
        </div>
      </div>

      <Separator />

      {/* ── Error State ────────────────────────────────────────────────────── */}
      {error && !loading && (
        <div className="flex flex-col items-center justify-center py-16 gap-3">
          <AlertCircle className="h-10 w-10 text-destructive" />
          <p className="text-sm text-muted-foreground">{error}</p>
          <Button variant="outline" size="sm" onClick={fetchData}>
            Повторить
          </Button>
        </div>
      )}

      {/* ── Loading State ──────────────────────────────────────────────────── */}
      {loading && (
        <div className="flex gap-4 overflow-x-auto pb-2">
          {Array.from({ length: 4 }).map((_, i) => (
            <div
              key={i}
              className="min-w-[280px] flex-shrink-0 bg-muted/30 rounded-2xl p-3"
            >
              <div className="flex items-center gap-2 mb-3">
                <Skeleton className="h-3 w-3 rounded-full" />
                <Skeleton className="h-4 w-24" />
                <Skeleton className="h-5 w-6 rounded-full ml-auto" />
              </div>
              <div className="space-y-2">
                {Array.from({ length: 3 }).map((_, j) => (
                  <Card key={j} className="border-l-4 rounded-xl shadow-sm transition-all duration-200 hover:shadow-md">
                    <CardContent className="p-3">
                      <Skeleton className="h-4 w-full" />
                      <Skeleton className="h-3 w-20 mt-2" />
                      <div className="flex justify-between mt-3">
                        <Skeleton className="h-4 w-12 rounded-full" />
                        <Skeleton className="h-6 w-12" />
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* ── Empty state ──────────────────────────────────────────────────── */}
      {!loading && !error && stages.length === 0 && (
        <div className="flex flex-col items-center justify-center py-20 gap-4">
          <div className="h-14 w-14 rounded-full bg-muted/50 flex items-center justify-center">
            <Package className="h-7 w-7 text-muted-foreground" />
          </div>
          <div className="text-center">
            <p className="text-base font-medium text-foreground">Нет этапов воронки</p>
            <p className="text-sm text-muted-foreground mt-1">
              Сначала создайте этапы в Настройках → CRM
            </p>
          </div>
        </div>
      )}

      {/* ── Kanban Board ───────────────────────────────────────────────────── */}
      {!loading && !error && stages.length > 0 && (
        <div className="flex gap-4 overflow-x-auto pb-2 flex-1">
          {dealsByStage.map(({ stage, deals: stageDeals }, stageIndex) => {
            const stageValue = stageDeals.reduce(
              (sum, d) => sum + (d.value || 0),
              0
            )
            return (
              <div
                key={stage.id}
                className="min-w-[280px] flex-shrink-0 bg-primary/3 rounded-2xl p-3 flex flex-col"
              >
                {/* Column Header */}
                <div className="flex items-center gap-2 mb-1">
                  <span
                    className="h-3 w-3 rounded-full flex-shrink-0"
                    style={{ backgroundColor: stage.color || '#888' }}
                  />
                  <span className="text-sm font-medium truncate">
                    {stage.name}
                  </span>
                  <Badge
                    variant="secondary"
                    className="ml-auto text-[10px] h-5 min-w-[20px] flex items-center justify-center px-1.5"
                  >
                    {stageDeals.length}
                  </Badge>
                </div>
                <p className="text-[11px] text-muted-foreground mb-3">
                  {formatCurrency(stageValue)}
                </p>

                {/* Column Body */}
                <ScrollArea className="flex-1 max-h-[calc(100vh-240px)]">
                  <div className="space-y-2 pr-2">
                    {stageDeals.length === 0 && (
                      <div className="flex items-center justify-center h-24 text-xs text-muted-foreground rounded-xl border border-dashed">
                        Пусто
                      </div>
                    )}
                    {stageDeals.map((deal) => {
                      const dealCompany = deal.client_id ? companyMap.get(deal.client_id) : null
                      return (
                        <Card
                          key={deal.id}
                          className="border-l-4 rounded-xl shadow-sm transition-all duration-200 hover:shadow-md active:scale-[0.99] bg-card cursor-pointer"
                          style={{
                            borderLeftColor: stage.color || '#888',
                          }}
                          onClick={() => {
                            if (deal.client_id) openCompany(deal.client_id)
                          }}
                        >
                          <CardContent className="p-3">
                            <p className="text-sm font-medium truncate">
                              {deal.title}
                            </p>
                            <p className="text-xs text-muted-foreground mt-1">
                              {formatCurrency(deal.value)}
                            </p>
                            {dealCompany && (
                              <p className="text-xs text-muted-foreground truncate">
                                {dealCompany.name}
                              </p>
                            )}
                            <div className="flex items-center justify-between mt-2">
                              <Badge
                                variant="outline"
                                className="text-[10px] capitalize"
                              >
                                {deal.priority || 'medium'}
                              </Badge>
                              <div className="flex items-center gap-1">
                                <button
                                  onClick={(e) => {
                                    e.stopPropagation()
                                    moveDeal(deal, stageIndex - 1)
                                  }}
                                  disabled={stageIndex === 0}
                                  className="h-6 w-6 rounded hover:bg-muted flex items-center justify-center text-muted-foreground disabled:opacity-30 transition-colors"
                                >
                                  &lsaquo;
                                </button>
                                <button
                                  onClick={(e) => {
                                    e.stopPropagation()
                                    moveDeal(deal, stageIndex + 1)
                                  }}
                                  disabled={stageIndex === stages.length - 1}
                                  className="h-6 w-6 rounded hover:bg-muted flex items-center justify-center text-muted-foreground disabled:opacity-30 transition-colors"
                                >
                                  &rsaquo;
                                </button>
                                <DropdownMenu>
                                  <DropdownMenuTrigger asChild>
                                    <button
                                      onClick={(e) => e.stopPropagation()}
                                      className="h-6 w-6 rounded hover:bg-muted flex items-center justify-center text-muted-foreground transition-colors"
                                    >
                                      <MoreHorizontal className="h-3.5 w-3.5" />
                                    </button>
                                  </DropdownMenuTrigger>
                                  <DropdownMenuContent align="end">
                                    <DropdownMenuItem
                                      className="text-destructive focus:text-destructive"
                                      onClick={(e) => {
                                        e.stopPropagation()
                                        deleteDeal(deal)
                                      }}
                                    >
                                      <Trash2 className="h-3.5 w-3.5 mr-2" />
                                      Удалить
                                    </DropdownMenuItem>
                                  </DropdownMenuContent>
                                </DropdownMenu>
                              </div>
                            </div>
                          </CardContent>
                        </Card>
                      )
                    })}
                  </div>
                </ScrollArea>
              </div>
            )
          })}
        </div>
      )}

      {/* ── Create Deal Dialog ─────────────────────────────────────────────── */}
      <Dialog open={createOpen} onOpenChange={setCreateOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Plus className="h-5 w-5" />
              Новая сделка
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {/* Title */}
            <div className="space-y-2">
              <Label htmlFor="deal-title">
                Название <span className="text-destructive">*</span>
              </Label>
              <Input
                id="deal-title"
                placeholder="напр. Корпоративная лицензия"
                value={newTitle}
                onChange={(e) => setNewTitle(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') handleCreateDeal()
                }}
              />
            </div>

            {/* Value */}
            <div className="space-y-2">
              <Label htmlFor="deal-value">Сумма (₽)</Label>
              <Input
                id="deal-value"
                type="number"
                min={0}
                step={100}
                placeholder="0"
                value={newValue || ''}
                onChange={(e) => setNewValue(Number(e.target.value) || 0)}
              />
            </div>

            {/* Company */}
            <div className="space-y-2">
              <Label>Клиент (компания)</Label>
              <Select
                value={newCompanyId || '__none__'}
                onValueChange={(v) =>
                  setNewCompanyId(v === '__none__' ? null : v)
                }
              >
                <SelectTrigger>
                  <SelectValue placeholder="Выберите компанию (необязательно)" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="__none__">Нет</SelectItem>
                  {companies.map((c) => (
                    <SelectItem key={c.id} value={c.id}>
                      {c.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {/* Priority + Stage */}
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Приоритет</Label>
                <Select
                  value={newPriority}
                  onValueChange={setNewPriority}
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Low">Низкий</SelectItem>
                    <SelectItem value="Medium">Средний</SelectItem>
                    <SelectItem value="High">Высокий</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Этап</Label>
                <Select
                  value={newStageId || stages[0]?.id || ''}
                  onValueChange={setNewStageId}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Выберите этап" />
                  </SelectTrigger>
                  <SelectContent>
                    {stages.map((s) => (
                      <SelectItem key={s.id} value={s.id}>
                        {s.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>

            {/* Actions */}
            <div className="flex justify-end gap-2 pt-2">
              <Button
                variant="outline"
                onClick={() => setCreateOpen(false)}
              >
                Отмена
              </Button>
              <Button
                onClick={handleCreateDeal}
                disabled={!newTitle.trim() || creating}
                className="rounded-xl"
              >
                {creating ? 'Создание...' : 'Создать сделку'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
