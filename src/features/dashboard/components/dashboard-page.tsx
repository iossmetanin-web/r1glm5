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
  Building2,
  TrendingUp,
  AlertTriangle,
  CheckSquare,
  Phone,
  Mail,
  MessageCircle,
  User,
  FileText,
  StickyNote,
  CheckCircle2,
  AlertCircle,
  RefreshCw,
  Users,
} from 'lucide-react'
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Checkbox } from '@/components/ui/checkbox'
import { supabase } from '@/lib/supabase/client'
import type {
  Activity,
  Task,
  Proposal,
  User as UserType,
} from '@/lib/supabase/database.types'

// ── Local types for Supabase join responses ──────────────────────────────────

interface ActivityWithUser extends Activity {
  user: Pick<UserType, 'id' | 'name'> | null
}

// ── Constants ────────────────────────────────────────────────────────────────

const STATUS_COLORS: Record<string, string> = {
  'слабый интерес': '#94a3b8',
  'надо залечивать': '#f59e0b',
  'сделал запрос': '#0ea5e9',
  'сделал заказ': '#22c55e',
}

const STATUS_ORDER = [
  'слабый интерес',
  'надо залечивать',
  'сделал запрос',
  'сделал заказ',
]

const SOURCE_COLORS: Record<string, string> = {
  'входящая заявка': '#0ea5e9',
  'реклама': '#f59e0b',
  'холодный обзвон': '#94a3b8',
  'личный контакт': '#22c55e',
}

const PRIORITY_LABELS: Record<string, string> = {
  low: 'Низкий',
  medium: 'Средний',
  high: 'Высокий',
}

const PRIORITY_VARIANTS: Record<string, 'secondary' | 'outline' | 'destructive'> = {
  low: 'secondary',
  medium: 'outline',
  high: 'destructive',
}

// ── Helper functions ─────────────────────────────────────────────────────────

function formatCurrency(value: number): string {
  return new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: 'RUB',
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
  if (days < 7) return `${days} дн. назад`
  if (days < 30) return `${Math.floor(days / 7)} нед. назад`
  return new Date(dateStr).toLocaleDateString('ru-RU', {
    day: 'numeric',
    month: 'short',
  })
}

function getActivityIcon(type: string | null) {
  switch (type) {
    case 'звонок':
      return Phone
    case 'письмо':
      return Mail
    case 'whatsapp':
      return MessageCircle
    case 'встреча':
      return User
    case 'кп_отправлено':
      return FileText
    case 'заметка':
      return StickyNote
    case 'статус_изменен':
      return CheckCircle2
    default:
      return StickyNote
  }
}

function getActivityTypeLabel(type: string | null): string {
  switch (type) {
    case 'звонок':
      return 'Звонок'
    case 'письмо':
      return 'Письмо'
    case 'whatsapp':
      return 'WhatsApp'
    case 'встреча':
      return 'Встреча'
    case 'кп_отправлено':
      return 'КП отправлено'
    case 'заметка':
      return 'Заметка'
    case 'статус_изменен':
      return 'Статус изменен'
    default:
      return 'Активность'
  }
}

function getTodayString(): string {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}

function getMonthStartString(): string {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-01`
}

function getThreeDaysAgoString(): string {
  const d = new Date()
  d.setDate(d.getDate() - 3)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

// ── Component ───────────────────────────────────────────────────────────────

export function DashboardPage() {
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  // Data state
  const [totalCompanies, setTotalCompanies] = useState(0)
  const [newThisMonth, setNewThisMonth] = useState(0)
  const [overdueCount, setOverdueCount] = useState(0)
  const [funnelAmount, setFunnelAmount] = useState(0)
  const [activeProposals, setActiveProposals] = useState(0)
  const [todayTasks, setTodayTasks] = useState<Task[]>([])
  const [todayTasksTotal, setTodayTasksTotal] = useState(0)
  const [todayTasksDone, setTodayTasksDone] = useState(0)
  const [companiesByStatus, setCompaniesByStatus] = useState<
    { name: string; count: number; fill: string }[]
  >([])
  const [companiesBySource, setCompaniesBySource] = useState<
    { name: string; value: number; fill: string }[]
  >([])
  const [activities, setActivities] = useState<ActivityWithUser[]>([])

  const fetchData = useCallback(async () => {
    setLoading(true)
    setError(null)

    const today = getTodayString()
    const monthStart = getMonthStartString()
    const threeDaysAgo = getThreeDaysAgoString()

    try {
      // ── Companies (core data — must succeed) ──────────────────────────
      const [companiesCountRes, companiesNewRes, overdueRes, proposalsRes, activeProposalsRes] =
        await Promise.all([
          supabase.from('companies').select('*', { count: 'exact', head: true }),
          supabase.from('companies').select('*', { count: 'exact', head: true }).gte('created_at', monthStart),
          supabase.from('companies').select('*', { count: 'exact', head: true }).not('next_contact_date', 'is', null).lt('next_contact_date', threeDaysAgo),
          supabase.from('proposals').select('total_amount').neq('status', 'отклонено'),
          supabase.from('proposals').select('*', { count: 'exact', head: true }).neq('status', 'отклонено'),
        ])

      if (companiesCountRes.error) throw companiesCountRes.error
      if (proposalsRes.error) throw proposalsRes.error

      setTotalCompanies(companiesCountRes.count ?? 0)
      setNewThisMonth(companiesNewRes.count ?? 0)
      setOverdueCount(overdueRes.count ?? 0)
      const proposals = proposalsRes.data ?? []
      setFunnelAmount(proposals.reduce((sum, p) => sum + (p.total_amount ?? 0), 0))
      setActiveProposals(activeProposalsRes.count ?? 0)

      // ── Chart data ─────────────────────────────────────────────────────
      const [companiesByStatusRes, companiesBySourceRes] = await Promise.all([
        supabase.from('companies').select('status'),
        supabase.from('companies').select('source'),
      ])

      const statusCounts: Record<string, number> = {}
      for (const s of STATUS_ORDER) statusCounts[s] = 0
      for (const c of companiesByStatusRes.data ?? []) {
        if (c.status && statusCounts[c.status] !== undefined) statusCounts[c.status]++
      }
      setCompaniesByStatus(STATUS_ORDER.map((s) => ({ name: s, count: statusCounts[s], fill: STATUS_COLORS[s] })))

      const sourceCounts: Record<string, number> = {}
      for (const s of Object.keys(SOURCE_COLORS)) sourceCounts[s] = 0
      for (const c of companiesBySourceRes.data ?? []) {
        if (c.source && sourceCounts[c.source] !== undefined) sourceCounts[c.source]++
      }
      setCompaniesBySource(Object.keys(SOURCE_COLORS).map((s) => ({ name: s, value: sourceCounts[s], fill: SOURCE_COLORS[s] })).filter((d) => d.value > 0))

      // ── Tasks (optional — table may not exist yet) ─────────────────────
      try {
        const [tasksRes, tasksAllRes] = await Promise.all([
          supabase.from('tasks').select('*').neq('status', 'done').lte('deadline', today).order('priority', { ascending: false }),
          supabase.from('tasks').select('status').lte('deadline', today),
        ])
        if (!tasksRes.error) {
          const taskData = (tasksRes.data as Task[]) ?? []
          setTodayTasks(taskData)
          setTodayTasksTotal(taskData.length)
          if (!tasksAllRes.error) {
            const doneCount = (tasksAllRes.data ?? []).filter((t) => t.status === 'done').length
            setTodayTasksDone(doneCount)
          }
        }
      } catch { /* tasks table may not exist */ }

      // ── Activities (optional — users table may not be accessible) ──────
      try {
        const activitiesRes = await supabase.from('activities').select('*, user:users!user_id(id, name)').order('created_at', { ascending: false }).limit(10)
        if (!activitiesRes.error) {
          setActivities((activitiesRes.data as unknown as ActivityWithUser[]) ?? [])
        }
      } catch { /* activities/users may not be accessible */ }

    } catch (err) {
      setError(err instanceof Error ? err.message : 'Не удалось загрузить данные')
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    fetchData()
  }, [fetchData])

  // ── Toggle task done ───────────────────────────────────────────────────

  const toggleTaskDone = useCallback(
    async (taskId: string, currentlyDone: boolean) => {
      const newStatus = currentlyDone ? 'todo' : 'done'
      const { error: updateError } = await supabase
        .from('tasks')
        .update({ status: newStatus })
        .eq('id', taskId)

      if (updateError) return

      setTodayTasks((prev) =>
        prev.map((t) => (t.id === taskId ? { ...t, status: newStatus } : t)),
      )
    },
    [],
  )

  // ── Custom tooltip for bar chart ───────────────────────────────────────

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
      <div className="rounded-lg border border-border bg-popover px-3 py-2 text-sm shadow-lg">
        <p className="font-medium text-popover-foreground">{label}</p>
        <p className="text-muted-foreground">
          {payload[0].value}{' '}
          {payload[0].value === 1 ? 'клиент' : payload[0].value < 5 ? 'клиента' : 'клиентов'}
        </p>
      </div>
    )
  }

  // ── Custom tooltip for pie chart ───────────────────────────────────────

  function CustomPieTooltip({
    active,
    payload,
  }: {
    active?: boolean
    payload?: { name: string; value: number }[]
  }) {
    if (!active || !payload?.length) return null
    const d = payload[0]
    return (
      <div className="rounded-lg border border-border bg-popover px-3 py-2 text-sm shadow-lg">
        <p className="font-medium text-popover-foreground">{d.name}</p>
        <p className="text-muted-foreground">
          {d.value}{' '}
          {d.value === 1 ? 'клиент' : d.value < 5 ? 'клиента' : 'клиентов'}
        </p>
      </div>
    )
  }

  // ── Stat card configs ──────────────────────────────────────────────────

  const statCards = [
    {
      title: 'Всего клиентов',
      value: totalCompanies.toLocaleString('ru-RU'),
      subtitle: `${newThisMonth} новых за месяц`,
      icon: Building2,
      iconBg: 'bg-sky-500/10',
      iconColor: 'text-sky-600 dark:text-sky-400',
    },
    {
      title: 'Воронка',
      value: formatCurrency(funnelAmount),
      subtitle: `${activeProposals} активных КП`,
      icon: TrendingUp,
      iconBg: 'bg-emerald-500/10',
      iconColor: 'text-emerald-600 dark:text-emerald-400',
    },
    {
      title: 'Просрочено',
      value: overdueCount.toString(),
      subtitle: 'контакт просрочен',
      icon: AlertTriangle,
      iconBg: 'bg-amber-500/10',
      iconColor: 'text-amber-600 dark:text-amber-400',
    },
    {
      title: 'Задачи на сегодня',
      value: todayTasksTotal.toString(),
      subtitle: `${todayTasksDone} выполнено`,
      icon: CheckSquare,
      iconBg: 'bg-violet-500/10',
      iconColor: 'text-violet-600 dark:text-violet-400',
    },
  ]

  // ── Render: Loading skeleton ───────────────────────────────────────────

  if (loading) {
    return (
      <div className="space-y-6">
        {/* Stats row skeleton */}
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {Array.from({ length: 4 }).map((_, i) => (
            <Card
              key={i}
              className="shadow-sm transition-shadow duration-200 hover:shadow-md"
            >
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <Skeleton className="h-4 w-28" />
                <Skeleton className="h-9 w-9 rounded-lg" />
              </CardHeader>
              <CardContent>
                <Skeleton className="mb-2 h-7 w-24" />
                <Skeleton className="h-3.5 w-36" />
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Charts skeleton */}
        <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
          {Array.from({ length: 2 }).map((_, i) => (
            <Card
              key={i}
              className="shadow-sm transition-shadow duration-200 hover:shadow-md"
            >
              <CardHeader>
                <Skeleton className="h-5 w-40" />
              </CardHeader>
              <CardContent>
                <Skeleton className="h-[300px] w-full" />
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Bottom section skeleton */}
        <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
          {Array.from({ length: 2 }).map((_, i) => (
            <Card
              key={i}
              className="shadow-sm transition-shadow duration-200 hover:shadow-md"
            >
              <CardHeader>
                <Skeleton className="h-5 w-44" />
              </CardHeader>
              <CardContent className="space-y-3">
                {Array.from({ length: 5 }).map((_, j) => (
                  <div key={j} className="flex items-start gap-3">
                    <Skeleton className="h-8 w-8 shrink-0 rounded-lg" />
                    <div className="flex-1 space-y-2">
                      <Skeleton className="h-4 w-full" />
                      <Skeleton className="h-3 w-28" />
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

  // ── Render: Error state ────────────────────────────────────────────────

  if (error) {
    return (
      <Card className="flex flex-col items-center justify-center py-16 shadow-sm">
        <AlertCircle className="mb-4 h-10 w-10 text-destructive" />
        <h3 className="mb-1 text-lg font-semibold">Что-то пошло не так</h3>
        <p className="mb-5 max-w-md text-center text-sm text-muted-foreground">
          {error}
        </p>
        <button
          onClick={fetchData}
          className="inline-flex items-center gap-2 rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground shadow-sm transition-colors hover:bg-primary/90"
        >
          <RefreshCw className="h-4 w-4" />
          Попробовать снова
        </button>
      </Card>
    )
  }

  // ── Render: Main dashboard ─────────────────────────────────────────────

  return (
    <div className="space-y-6">
      {/* ── Row 1: Stat Cards ──────────────────────────────────────────── */}
      <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
        {statCards.map((card) => {
          const Icon = card.icon
          return (
            <Card
              key={card.title}
              className="shadow-sm transition-all duration-200 hover:shadow-md hover:scale-[1.01]"
            >
              <CardHeader className="flex flex-row items-center justify-between pb-2">
                <span className="text-sm font-medium text-muted-foreground">
                  {card.title}
                </span>
                <div
                  className={`flex h-9 w-9 items-center justify-center rounded-lg ${card.iconBg}`}
                >
                  <Icon className={`h-4.5 w-4.5 ${card.iconColor}`} />
                </div>
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold tracking-tight">
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

      {/* ── Row 2: Charts ──────────────────────────────────────────────── */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Horizontal Bar Chart — Воронка продаж */}
        <Card className="shadow-sm transition-shadow duration-200 hover:shadow-md">
          <CardHeader>
            <CardTitle className="text-base">Воронка продаж</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="h-[300px]">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart
                  data={companiesByStatus}
                  layout="vertical"
                  barCategoryGap="25%"
                  margin={{ top: 0, right: 20, bottom: 0, left: 0 }}
                >
                  <CartesianGrid
                    strokeDasharray="3 3"
                    stroke="hsl(var(--border))"
                    horizontal={false}
                  />
                  <XAxis
                    type="number"
                    allowDecimals={false}
                    tick={{ fill: 'hsl(var(--muted-foreground))', fontSize: 12 }}
                    axisLine={false}
                    tickLine={false}
                  />
                  <YAxis
                    type="category"
                    dataKey="name"
                    width={130}
                    tick={{ fill: 'hsl(var(--muted-foreground))', fontSize: 12 }}
                    axisLine={false}
                    tickLine={false}
                  />
                  <Tooltip content={<CustomBarTooltip />} cursor={false} />
                  <Bar dataKey="count" radius={[0, 6, 6, 0]} maxBarSize={36}>
                    {companiesByStatus.map((entry, index) => (
                      <Cell key={index} fill={entry.fill} />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        {/* Pie/Donut Chart — Клиенты по источникам */}
        <Card className="shadow-sm transition-shadow duration-200 hover:shadow-md">
          <CardHeader>
            <CardTitle className="text-base">
              Клиенты по источникам
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="h-[300px]">
              {companiesBySource.length > 0 ? (
                <ResponsiveContainer width="100%" height="100%">
                  <PieChart>
                    <Pie
                      data={companiesBySource}
                      cx="50%"
                      cy="50%"
                      innerRadius={65}
                      outerRadius={100}
                      paddingAngle={3}
                      dataKey="value"
                      strokeWidth={0}
                    >
                      {companiesBySource.map((entry, index) => (
                        <Cell key={index} fill={entry.fill} />
                      ))}
                    </Pie>
                    <Tooltip content={<CustomPieTooltip />} />
                    <Legend
                      verticalAlign="bottom"
                      iconType="circle"
                      iconSize={8}
                      wrapperStyle={{ paddingTop: '8px' }}
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
                  Нет данных об источниках
                </div>
              )}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* ── Row 3: Activities + Tasks ──────────────────────────────────── */}
      <div className="grid grid-cols-1 gap-6 lg:grid-cols-2">
        {/* Последние активности */}
        <Card className="shadow-sm transition-shadow duration-200 hover:shadow-md">
          <CardHeader className="flex flex-row items-center gap-2">
            <Users className="h-4.5 w-4.5 text-muted-foreground" />
            <CardTitle className="text-base">Последние активности</CardTitle>
          </CardHeader>
          <CardContent>
            <ScrollArea className="h-[380px]">
              {activities.length === 0 ? (
                <div className="flex h-32 items-center justify-center text-sm text-muted-foreground">
                  Нет активностей
                </div>
              ) : (
                <div className="space-y-1 pr-3">
                  {activities.map((activity) => {
                    const Icon = getActivityIcon(activity.type)
                    const typeLabel = getActivityTypeLabel(activity.type)
                    return (
                      <div
                        key={activity.id}
                        className="flex items-start gap-3 rounded-lg p-3 transition-colors hover:bg-muted/50"
                      >
                        <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-muted">
                          <Icon className="h-4 w-4 text-muted-foreground" />
                        </div>
                        <div className="min-w-0 flex-1">
                          <div className="flex items-center gap-2">
                            <span className="text-xs font-medium text-muted-foreground">
                              {typeLabel}
                            </span>
                            {activity.user && (
                              <>
                                <span className="text-muted-foreground/50">·</span>
                                <span className="text-xs text-muted-foreground">
                                  {activity.user.name}
                                </span>
                              </>
                            )}
                          </div>
                          <p className="mt-0.5 line-clamp-2 text-sm leading-snug">
                            {activity.content}
                          </p>
                          <p className="mt-1 text-xs text-muted-foreground/70">
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

        {/* Задачи на сегодня */}
        <Card className="shadow-sm transition-shadow duration-200 hover:shadow-md">
          <CardHeader className="flex flex-row items-center gap-2">
            <CheckSquare className="h-4.5 w-4.5 text-muted-foreground" />
            <CardTitle className="text-base">Задачи на сегодня</CardTitle>
          </CardHeader>
          <CardContent>
            <ScrollArea className="h-[380px]">
              {todayTasks.length === 0 ? (
                <div className="flex h-32 items-center justify-center text-sm text-muted-foreground">
                  Нет задач на сегодня — отлично! 🎉
                </div>
              ) : (
                <div className="space-y-1 pr-3">
                  {todayTasks.map((task) => {
                    const isDone = task.status === 'done'
                    const priorityLabel =
                      PRIORITY_LABELS[task.priority] ?? task.priority
                    const priorityVariant =
                      PRIORITY_VARIANTS[task.priority] ?? 'secondary'
                    const isOverdue =
                      task.deadline &&
                      task.deadline < getTodayString() &&
                      !isDone

                    return (
                      <div
                        key={task.id}
                        className={`flex items-start gap-3 rounded-lg p-3 transition-colors hover:bg-muted/50 ${isDone ? 'opacity-60' : ''}`}
                      >
                        <div className="mt-0.5">
                          <Checkbox
                            checked={isDone}
                            onCheckedChange={() =>
                              toggleTaskDone(task.id, isDone)
                            }
                          />
                        </div>
                        <div className="min-w-0 flex-1">
                          <p
                            className={`text-sm leading-snug ${isDone ? 'line-through text-muted-foreground' : ''}`}
                          >
                            {task.title}
                          </p>
                          <div className="mt-1.5 flex flex-wrap items-center gap-1.5">
                            <Badge variant={priorityVariant} className="text-[10px] px-1.5 py-0">
                              {priorityLabel}
                            </Badge>
                            {task.company_id && (
                              <span className="text-xs text-muted-foreground">
                                ID: {task.company_id.slice(0, 8)}
                              </span>
                            )}
                            {isOverdue && (
                              <Badge
                                variant="destructive"
                                className="text-[10px] px-1.5 py-0"
                              >
                                Просрочено
                              </Badge>
                            )}
                            {task.is_recurring && (
                              <Badge
                                variant="secondary"
                                className="text-[10px] px-1.5 py-0"
                              >
                                Повторяющаяся
                              </Badge>
                            )}
                          </div>
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
