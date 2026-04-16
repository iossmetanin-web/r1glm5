'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import type { Deal, PipelineStage, Client } from '@/lib/supabase/database.types'
import { useNavigationStore, useAuthStore, useUIStore } from '@/lib/store'
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
import { Plus, MoreHorizontal, Trash2, AlertCircle, Package } from 'lucide-react'

// ─── Helpers ──────────────────────────────────────────────────────────────────

const formatCurrency = (v: number) =>
  new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    maximumFractionDigits: 0,
  }).format(v || 0)

type FilterType = 'all' | 'open' | 'won' | 'lost'

// ─── Component ────────────────────────────────────────────────────────────────

export default function DealsPage() {
  const currentUser = useAuthStore((s) => s.currentUser)
  const openDeal = useNavigationStore((s) => s.openDeal)

  const [stages, setStages] = useState<PipelineStage[]>([])
  const [deals, setDeals] = useState<any[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [filter, setFilter] = useState<FilterType>('all')
  const [createOpen, setCreateOpen] = useState(false)

  // Create deal form state
  const [newTitle, setNewTitle] = useState('')
  const [newValue, setNewValue] = useState(0)
  const [newClientId, setNewClientId] = useState<string | null>(null)
  const [newPriority, setNewPriority] = useState('Medium')
  const [newStageId, setNewStageId] = useState<string>('')
  const [clients, setClients] = useState<Pick<Client, 'id' | 'name' | 'company'>[]>([])
  const [creating, setCreating] = useState(false)

  // ─── Data Fetching ────────────────────────────────────────────────────────

  const [fetchTrigger, setFetchTrigger] = useState(0)

  useEffect(() => {
    let cancelled = false
    async function load() {
      try {
        const [stagesRes, dealsRes] = await Promise.all([
          supabase.from('pipeline_stages').select('*').order('position'),
          supabase
            .from('deals')
            .select(
              '*, pipeline_stages(name, color, position, is_won, is_closed), clients(name, company)'
            )
            .order('created_at', { ascending: false }),
        ])
        if (cancelled) return
        setStages(stagesRes.data ?? [])
        setDeals(dealsRes.data ?? [])
        if (stagesRes.error || dealsRes.error) {
          setError(
            stagesRes.error?.message || dealsRes.error?.message || null
          )
        } else {
          setError(null)
        }
      } catch (err: any) {
        if (cancelled) return
        setError(err?.message || 'Failed to fetch data')
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

  useEffect(() => {
    if (!createOpen) return
    let cancelled = false
    async function loadClients() {
      const { data } = await supabase
        .from('clients')
        .select('id, name, company')
        .order('name')
      if (data && !cancelled) setClients(data)
    }
    loadClients()
    return () => { cancelled = true }
  }, [createOpen])

  // ─── Filter Logic ─────────────────────────────────────────────────────────

  const filteredDeals = deals.filter((deal) => {
    if (filter === 'all') return true
    if (filter === 'open') {
      return !deal.pipeline_stages?.is_won && !deal.pipeline_stages?.is_closed
    }
    if (filter === 'won') return deal.pipeline_stages?.is_won === true
    if (filter === 'lost') return deal.pipeline_stages?.is_closed === true && !deal.pipeline_stages?.is_won
    return true
  })

  // Group deals by stage_id
  const dealsByStage = stages.map((stage) => ({
    stage,
    deals: filteredDeals.filter((d) => d.stage_id === stage.id),
  }))

  // ─── Move Deal ────────────────────────────────────────────────────────────

  const moveDeal = async (deal: any, newIndex: number) => {
    if (newIndex < 0 || newIndex >= stages.length) return
    const newStage = stages[newIndex]
    const { error } = await supabase
      .from('deals')
      .update({ stage_id: newStage.id })
      .eq('id', deal.id)
    if (!error) {
      await supabase.from('activities').insert({
        action: `Moved "${deal.title}" to ${newStage.name}`,
        entity_type: 'deal',
        entity_id: deal.id,
        user_id: currentUser?.id,
      })
      fetchData()
    }
  }

  // ─── Delete Deal ──────────────────────────────────────────────────────────

  const deleteDeal = async (deal: any) => {
    if (!window.confirm(`Delete "${deal.title}"? This action cannot be undone.`))
      return
    const { error } = await supabase
      .from('deals')
      .delete()
      .eq('id', deal.id)
    if (!error) {
      await supabase.from('activities').insert({
        action: `Deleted deal "${deal.title}"`,
        entity_type: 'deal',
        entity_id: deal.id,
        user_id: currentUser?.id,
      })
      fetchData()
    }
  }

  // ─── Create Deal ──────────────────────────────────────────────────────────

  const handleCreateDeal = async () => {
    if (!newTitle.trim()) return
    setCreating(true)
    const stageId = newStageId || stages[0]?.id
    if (!stageId) {
      setCreating(false)
      return
    }
    const { error } = await supabase.from('deals').insert({
      title: newTitle.trim(),
      value: newValue || 0,
      client_id: newClientId || null,
      priority: newPriority,
      stage_id: stageId,
      owner_id: currentUser?.id,
      status: 'open',
      currency: 'USD',
      pipeline_id: stages[0]?.pipeline_id || '',
    })
    if (!error) {
      await supabase.from('activities').insert({
        action: `Created deal "${newTitle.trim()}"`,
        entity_type: 'deal',
        user_id: currentUser?.id,
      })
      setNewTitle('')
      setNewValue(0)
      setNewClientId(null)
      setNewPriority('Medium')
      setNewStageId('')
      setCreateOpen(false)
      fetchData()
    }
    setCreating(false)
  }

  const openCreateDialog = () => {
    setNewTitle('')
    setNewValue(0)
    setNewClientId(null)
    setNewPriority('Medium')
    setNewStageId(stages[0]?.id || '')
    setCreateOpen(true)
  }

  // ─── Render ───────────────────────────────────────────────────────────────

  return (
    <div className="flex flex-col gap-4 h-full">
      {/* ── Top Bar ────────────────────────────────────────────────────────── */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
        <div>
          <h2 className="text-xl font-semibold tracking-tight flex items-center gap-2">
            <Package className="h-5 w-5 text-muted-foreground" />
            Воронка сделок
          </h2>
          <p className="text-sm text-muted-foreground mt-0.5">
            {deals.length} deal{deals.length !== 1 ? 's' : ''} &middot;{' '}
            {formatCurrency(
              deals.reduce((sum: number, d: any) => sum + (d.value || 0), 0)
            )}{' '}
            общая сумма
          </p>
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          {/* Filter Buttons */}
          <div className="flex items-center gap-1 bg-muted/50 rounded-lg p-1">
            {(['all', 'open', 'won', 'lost'] as FilterType[]).map((f) => (
              <button
                key={f}
                onClick={() => setFilter(f)}
                className={`px-3 py-1.5 text-xs font-medium rounded-md transition-colors ${
                  filter === f
                    ? 'bg-background text-foreground shadow-sm'
                    : 'text-muted-foreground hover:text-foreground'
                }`}
              >
                {f.charAt(0).toUpperCase() + f.slice(1)}
              </button>
            ))}
          </div>
          <Button size="sm" onClick={openCreateDialog} className="gap-1.5">
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
              className="min-w-[280px] flex-shrink-0 bg-muted/30 rounded-xl p-3"
            >
              <div className="flex items-center gap-2 mb-3">
                <Skeleton className="h-3 w-3 rounded-full" />
                <Skeleton className="h-4 w-24" />
                <Skeleton className="h-5 w-6 rounded-full ml-auto" />
              </div>
              <div className="space-y-2">
                {Array.from({ length: 3 }).map((_, j) => (
                  <Card key={j} className="border-l-4">
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

      {/* ── Kanban Board ───────────────────────────────────────────────────── */}
      {!loading && !error && (
        <div className="flex gap-4 overflow-x-auto pb-2 flex-1">
          {dealsByStage.map(({ stage, deals: stageDeals }, stageIndex) => {
            const stageValue = stageDeals.reduce(
              (sum: number, d: any) => sum + (d.value || 0),
              0
            )
            return (
              <div
                key={stage.id}
                className="min-w-[280px] flex-shrink-0 bg-muted/30 rounded-xl p-3 flex flex-col"
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
                      <div className="flex items-center justify-center h-24 text-xs text-muted-foreground rounded-lg border border-dashed">
                        Пусто
                      </div>
                    )}
                    {stageDeals.map((deal) => (
                      <Card
                        key={deal.id}
                        className="border-l-4 cursor-pointer transition-shadow hover:shadow-md bg-card"
                        style={{
                          borderLeftColor: stage.color || '#888',
                        }}
                        onClick={() => openDeal(deal.id)}
                      >
                        <CardContent className="p-3">
                          <p className="text-sm font-medium truncate">
                            {deal.title}
                          </p>
                          <p className="text-xs text-muted-foreground mt-1">
                            {formatCurrency(deal.value)}
                          </p>
                          {deal.clients && (
                            <p className="text-xs text-muted-foreground truncate">
                              {deal.clients.company || deal.clients.name}
                            </p>
                          )}
                          <div className="flex items-center justify-between mt-2">
                            <Badge
                              variant="outline"
                              className="text-[10px] capitalize"
                            >
                              {deal.priority || 'none'}
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
                                    Delete
                                  </DropdownMenuItem>
                                </DropdownMenuContent>
                              </DropdownMenu>
                            </div>
                          </div>
                        </CardContent>
                      </Card>
                    ))}
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
              New Deal
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {/* Title */}
            <div className="space-y-2">
              <Label htmlFor="deal-title">
                Title <span className="text-destructive">*</span>
              </Label>
              <Input
                id="deal-title"
                placeholder="e.g. Enterprise License"
                value={newTitle}
                onChange={(e) => setNewTitle(e.target.value)}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') handleCreateDeal()
                }}
              />
            </div>

            {/* Value */}
            <div className="space-y-2">
              <Label htmlFor="deal-value">Value (USD)</Label>
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

            {/* Client */}
            <div className="space-y-2">
              <Label>Client</Label>
              <Select
                value={newClientId || '__none__'}
                onValueChange={(v) =>
                  setNewClientId(v === '__none__' ? null : v)
                }
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select a client (optional)" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="__none__">None</SelectItem>
                  {clients.map((c) => (
                    <SelectItem key={c.id} value={c.id}>
                      {c.company || c.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {/* Priority + Stage */}
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Priority</Label>
                <Select
                  value={newPriority}
                  onValueChange={setNewPriority}
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Low">Low</SelectItem>
                    <SelectItem value="Medium">Medium</SelectItem>
                    <SelectItem value="High">High</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Stage</Label>
                <Select
                  value={newStageId || stages[0]?.id || ''}
                  onValueChange={setNewStageId}
                >
                  <SelectTrigger>
                    <SelectValue placeholder="Select stage" />
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
