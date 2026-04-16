'use client'

import { useEffect, useState, useCallback } from 'react'
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
  Legend,
} from 'recharts'
import {
  TrendingUp,
  DollarSign,
  Trophy,
  Target,
  Package,
  Clock,
  MessageSquare,
  UserPlus,
  FileEdit,
  CheckCircle2,
  AlertCircle,
} from 'lucide-react'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
import { ScrollArea } from '@/components/ui/scroll-area'
import { supabase } from '@/lib/supabase/client'
import { useNavigationStore } from '@/lib/store'
import type {
  Deal,
  PipelineStage,
  Activity,
  DealWithStage,
} from '@/lib/supabase/database.types'

// ── Local types for Supabase join responses ──────────────────────────────────

interface ActivityWithUser extends Activity {
  users: { name: string }[]
}

// ── Helper functions ─────────────────────────────────────────────────────────

function formatCurrency(value: number): string {
  return new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: 'RUB',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(value)
}

function formatRelativeTime(dateStr: string): string {
  const now = Date.now()
  const then = new Date(dateStr).getTime()
  const diffMs = now - then
  const seconds = Math.floor(diffMs / 1000)
  const minutes = Math.floor(seconds / 60)
  const hours = Math.floor(minutes / 60)
  const days = Math.floor(hours / 24)

  if (seconds < 60) return 'только что'
  if (minutes < 60) return `${minutes} мин. назад`
  if (hours < 24) return `${hours} ч. назад`
  if (days < 30) return `${days} дн. назад`
  return new Date(dateStr).toLocaleDateString('ru-RU', {
    month: 'short',
    day: 'numeric',
  })
}

function getActivityIcon(action: string) {
  const lower = action.toLowerCase()
  if (lower.includes('created') || lower.includes('add') || lower.includes('new')) return UserPlus
  if (lower.includes('updated') || lower.includes('edit') || lower.includes('changed')) return FileEdit
  if (lower.includes('won') || lower.includes('closed') || lower.includes('completed')) return CheckCircle2
  if (lower.includes('comment') || lower.includes('message') || lower.includes('note')) return MessageSquare
  return Clock
}

// ── Stat card config ────────────────────────────────────────────────────────

interface StatCardConfig {
  title: string
  value: string
  subtitle: string
  icon: React.ElementType
  iconBg: string
  iconColor: string
}

// ── Component ───────────────────────────────────────────────────────────────

export function DashboardPage() {
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [deals, setDeals] = useState<DealWithStage[]>([])
  const [stages, setStages] = useState<PipelineStage[]>([])
  const [activities, setActivities] = useState<ActivityWithUser[]>([])
  const [clientCount, setClientCount] = useState(0)
  const [taskCount, setTaskCount] = useState(0)
  const openDeal = useNavigationStore((s) => s.openDeal)

  const fetchData = useCallback(async () => {
    setLoading(true)
    setError(null)

    try {
      const [dealsRes, stagesRes, activitiesRes, clientsRes, tasksRes] =
        await Promise.all([
          supabase
            .from('deals')
            .select('*, pipeline_stages(name, is_won, is_closed, color)'),
          supabase
            .from('pipeline_stages')
            .select('*')
            .order('position'),
          supabase
            .from('activities')
            .select('*, users(name)')
            .order('created_at', { ascending: false })
            .limit(10),
          supabase.from('clients').select('*', { count: 'exact', head: true }),
          supabase.from('tasks').select('*', { count: 'exact', head: true }),
        ])

      if (dealsRes.error) throw dealsRes.error
      if (stagesRes.error) throw stagesRes.error
      if (activitiesRes.error) throw activitiesRes.error
      if (clientsRes.error) throw clientsRes.error
      if (tasksRes.error) throw tasksRes.error

      setDeals((dealsRes.data as DealWithStage[]) ?? [])
      setStages(stagesRes.data ?? [])
      setActivities((activitiesRes.data as ActivityWithUser[]) ?? [])
      setClientCount(clientsRes.count ?? 0)
      setTaskCount(tasksRes.count ?? 0)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Не удалось загрузить данные')
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    fetchData()
  }, [fetchData])

  // ── Computed metrics ─────────────────────────────────────────────────────

  const totalDeals = deals.length
  const openDeals = deals.filter((d) => d.status === 'open').length
  const wonDeals = deals.filter((d) => d.pipeline_stages?.is_won).length
  const lostDeals = deals.filter((d) => d.status === 'lost').length
  const totalRevenue = deals
    .filter((d) => d.pipeline_stages?.is_won)
    .reduce((sum, d) => sum + d.value, 0)
  const pipelineValue = deals
    .filter((d) => d.status === 'open')
    .reduce((sum, d) => sum + d.value, 0)
  const conversionRate =
    totalDeals > 0 ? Math.round((wonDeals / totalDeals) * 100) : 0

  // ── Chart data ───────────────────────────────────────────────────────────

  const dealsByStage = stages.map((stage) => ({
    name: stage.name,
    count: deals.filter((d) => d.stage_id === stage.id).length,
    color: stage.color || '#888',
  }))

  const pieData = [
    { name: 'Выиграно', value: wonDeals, color: 'oklch(0.696 0.17 162.48)' },
    { name: 'Проиграно', value: lostDeals, color: 'oklch(0.577 0.245 27.325)' },
    { name: 'Открытые', value: openDeals, color: 'oklch(0.627 0.265 303.9)' },
  ].filter((d) => d.value > 0)

  // ── Stat cards ───────────────────────────────────────────────────────────

  const statCards: StatCardConfig[] = [
    {
      title: 'Все сделки',
      value: totalDeals.toString(),
      subtitle: `${openDeals} откр. \u00B7 ${lostDeals} проигр.`,
      icon: Package,
      iconBg: 'bg-primary/10',
      iconColor: 'text-primary',
    },
    {
      title: 'Воронка',
      value: formatCurrency(pipelineValue),
      subtitle: `${openDeals} активных сделок`,
      icon: DollarSign,
      iconBg: 'bg-emerald-500/10',
      iconColor: 'text-emerald-500',
    },
    {
      title: 'Выиграно',
      value: wonDeals.toString(),
      subtitle: `${formatCurrency(totalRevenue)} выручка`,
      icon: Trophy,
      iconBg: 'bg-amber-500/10',
      iconColor: 'text-amber-500',
    },
    {
      title: 'Конверсия',
      value: `${conversionRate}%`,
      subtitle: 'Выиграно / Всего',
      icon: Target,
      iconBg: 'bg-violet-500/10',
      iconColor: 'text-violet-500',
    },
  ]

  // ── Recent deals (sorted by created_at, take 5) ─────────────────────────

  const recentDeals = [...deals]
    .sort(
      (a, b) =>
        new Date(b.created_at).getTime() - new Date(a.created_at).getTime(),
    )
    .slice(0, 5)

  // ── Custom tooltip for bar chart ─────────────────────────────────────────

  function CustomBarTooltip({
    active,
    payload,
    label,
  }: {
    active?: boolean
    payload?: { value: number }[]
    label?: string
  }) {
    if (!active || !payload?.length) return null
    return (
      <div className="rounded-lg border border-border bg-card px-3 py-2 text-sm shadow-lg">
        <p className="font-medium text-foreground">{label}</p>
        <p className="text-muted-foreground">
          {payload[0].value} сделок
        </p>
      </div>
    )
  }

  // ── Render ───────────────────────────────────────────────────────────────

  // Loading skeleton
  if (loading) {
    return (
      <div className="space-y-6">
        {/* Stats row skeleton */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {Array.from({ length: 4 }).map((_, i) => (
            <Card key={i} className="transition-shadow hover:shadow-md">
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <Skeleton className="h-4 w-24" />
                <Skeleton className="h-8 w-8 rounded-lg" />
              </CardHeader>
              <CardContent>
                <Skeleton className="mb-1 h-7 w-20" />
                <Skeleton className="h-3 w-32" />
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Charts skeleton */}
        <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
          {Array.from({ length: 2 }).map((_, i) => (
            <Card key={i}>
              <CardHeader>
                <Skeleton className="h-5 w-36" />
              </CardHeader>
              <CardContent>
                <Skeleton className="h-[280px] w-full" />
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Bottom section skeleton */}
        <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
          {Array.from({ length: 2 }).map((_, i) => (
            <Card key={i}>
              <CardHeader>
                <Skeleton className="h-5 w-32" />
              </CardHeader>
              <CardContent className="space-y-3">
                {Array.from({ length: 4 }).map((_, j) => (
                  <div key={j} className="flex items-start gap-3">
                    <Skeleton className="h-8 w-8 rounded-lg" />
                    <div className="flex-1 space-y-1">
                      <Skeleton className="h-4 w-full" />
                      <Skeleton className="h-3 w-24" />
                    </div>
                  </div>
                ))}
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    )
  }

  // Error state
  if (error) {
    return (
      <Card className="flex flex-col items-center justify-center py-16">
        <AlertCircle className="mb-4 h-10 w-10 text-destructive" />
        <h3 className="mb-1 text-lg font-semibold text-foreground">
          Что-то пошло не так
        </h3>
        <p className="mb-4 text-sm text-muted-foreground">{error}</p>
        <button
          onClick={fetchData}
          className="inline-flex items-center gap-2 rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90"
        >
          <TrendingUp className="h-4 w-4" />
          Попробовать снова
        </button>
      </Card>
    )
  }

  return (
    <div className="space-y-6">
      {/* ── Stats Cards Row ──────────────────────────────────────────────── */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {statCards.map((card) => {
          const Icon = card.icon
          return (
            <Card
              key={card.title}
              className="transition-shadow hover:shadow-md"
            >
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <span className="text-sm font-medium text-muted-foreground">
                  {card.title}
                </span>
                <div
                  className={`flex h-8 w-8 items-center justify-center rounded-lg ${card.iconBg}`}
                >
                  <Icon className={`h-4 w-4 ${card.iconColor}`} />
                </div>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold tracking-tight text-foreground">
                  {card.value}
                </div>
                <p className="mt-1 text-xs text-muted-foreground">
                  {card.subtitle}
                </p>
              </CardContent>
            </Card>
          )
        })}
      </div>

      {/* ── Charts Section ───────────────────────────────────────────────── */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Bar Chart — Deals by Stage */}
        <Card>
          <CardHeader>
            <CardTitle className="text-base">Сделки по этапам</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="h-[280px]">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={dealsByStage} barCategoryGap="20%">
                  <CartesianGrid
                    strokeDasharray="3 3"
                    stroke="oklch(0.5 0 0 / 15%)"
                    vertical={false}
                  />
                  <XAxis
                    dataKey="name"
                    tick={{ fill: 'oklch(0.556 0 0)', fontSize: 12 }}
                    axisLine={false}
                    tickLine={false}
                  />
                  <YAxis
                    allowDecimals={false}
                    tick={{ fill: 'oklch(0.556 0 0)', fontSize: 12 }}
                    axisLine={false}
                    tickLine={false}
                  />
                  <Tooltip content={<CustomBarTooltip />} cursor={false} />
                  <Bar dataKey="count" radius={[6, 6, 0, 0]} maxBarSize={48}>
                    {dealsByStage.map((entry, index) => (
                      <Cell key={index} fill={entry.color} />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        {/* Pie Chart — Deal Status Distribution */}
        <Card>
          <CardHeader>
            <CardTitle className="text-base">
              Статус сделок
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="h-[280px]">
              {pieData.length > 0 ? (
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={pieData}
                      cx="50%"
                      cy="50%"
                      innerRadius={60}
                      outerRadius={95}
                      paddingAngle={4}
                      dataKey="value"
                      strokeWidth={0}
                    >
                      {pieData.map((entry, index) => (
                        <Cell key={index} fill={entry.color} />
                      ))}
                    </Pie>
                    <Tooltip
                      content={({ active, payload }) => {
                        if (!active || !payload?.length) return null
                        const d = payload[0]
                        return (
                          <div className="rounded-lg border border-border bg-card px-3 py-2 text-sm shadow-lg">
                            <p className="font-medium text-foreground">
                              {d.name}
                            </p>
                            <p className="text-muted-foreground">
                              {d.value} сделок
                            </p>
                          </div>
                        )
                      }}
                    />
                    <Legend
                      verticalAlign="bottom"
                      iconType="circle"
                      iconSize={8}
                      formatter={(value: string) => (
                        <span className="text-sm text-muted-foreground">
                          {value}
                        </span>
                      )}
                    />
                  </PieChart>
                </ResponsiveContainer>
              ) : (
                <div className="flex h-full items-center justify-center text-sm text-muted-foreground">
                  Нет данных о сделках
                </div>
              )}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* ── Bottom Section ───────────────────────────────────────────────── */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Recent Deals */}
        <Card>
          <CardHeader>
            <CardTitle className="text-base">Последние сделки</CardTitle>
          </CardHeader>
          <CardContent>
            <ScrollArea className="max-h-[340px]">
              {recentDeals.length === 0 ? (
                <div className="flex h-24 items-center justify-center text-sm text-muted-foreground">
                  Сделок пока нет
                </div>
              ) : (
                <div className="space-y-1">
                  {recentDeals.map((deal) => (
                    <button
                      key={deal.id}
                      onClick={() => openDeal(deal.id)}
                      className="flex w-full items-center justify-between rounded-lg p-3 text-left transition-colors hover:bg-accent"
                    >
                      <div className="min-w-0 flex-1">
                        <p className="truncate text-sm font-medium text-foreground">
                          {deal.title}
                        </p>
                        <p className="text-xs text-muted-foreground">
                          {formatCurrency(deal.value)}
                        </p>
                      </div>
                      {deal.pipeline_stages && (
                        <Badge
                          variant="secondary"
                          className="ml-3 shrink-0 text-xs"
                          style={{
                            backgroundColor: `${deal.pipeline_stages.color}20`,
                            color: deal.pipeline_stages.color,
                            borderColor: `${deal.pipeline_stages.color}40`,
                          }}
                        >
                          {deal.pipeline_stages.name}
                        </Badge>
                      )}
                    </button>
                  ))}
                </div>
              )}
            </ScrollArea>
          </CardContent>
        </Card>

        {/* Activity Feed */}
        <Card>
          <CardHeader>
            <CardTitle className="text-base">Лента активности</CardTitle>
          </CardHeader>
          <CardContent>
            <ScrollArea className="max-h-[340px]">
              {activities.length === 0 ? (
                <div className="flex h-24 items-center justify-center text-sm text-muted-foreground">
                  Нет активности
                </div>
              ) : (
                <div className="space-y-1">
                  {activities.map((activity) => {
                    const Icon = getActivityIcon(activity.action)
                    const actorName =
                      activity.users?.[0]?.name ?? 'Неизвестно'
                    return (
                      <div
                        key={activity.id}
                        className="flex items-start gap-3 rounded-lg p-3"
                      >
                        <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-accent">
                          <Icon className="h-4 w-4 text-muted-foreground" />
                        </div>
                        <div className="min-w-0 flex-1">
                          <p className="text-sm text-foreground">
                            <span className="font-medium">{actorName}</span>{' '}
                            <span className="text-muted-foreground">
                              {activity.action}
                            </span>
                          </p>
                          <p className="mt-0.5 text-xs text-muted-foreground">
                            {formatRelativeTime(activity.created_at)}
                          </p>
                        </div>
                      </div>
                    )
                  })}
                </div>
              )}
            </ScrollArea>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
