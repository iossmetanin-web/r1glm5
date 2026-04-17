'use client'

import { useState, useEffect, useMemo, useCallback } from 'react'
import { supabase } from '@/lib/supabase/client'
import type { TaskWithRelations, Company } from '@/lib/supabase/database.types'
import { useAuthStore, useNavigationStore } from '@/lib/store'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
import { Checkbox } from '@/components/ui/checkbox'
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
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import {
  Plus,
  MoreHorizontal,
  Pencil,
  Trash2,
  CheckSquare,
  AlertCircle,
  Calendar,
  RefreshCw,
  Users,
  Building2,
  ArrowRight,
  Clock,
} from 'lucide-react'

// ─── Types ─────────────────────────────────────────────────────────────────────

type TaskStatus = 'todo' | 'in_progress' | 'done'
type TaskPriority = 'low' | 'medium' | 'high'
type FilterTab = 'all' | 'today' | 'overdue' | 'done'

interface TaskFormData {
  title: string
  description: string
  priority: TaskPriority
  deadline: string
  company_id: string
  status: TaskStatus
  is_recurring: boolean
  recurrence_days: number
  is_shared: boolean
}

// ─── Constants ────────────────────────────────────────────────────────────────

const FILTER_TABS: { value: FilterTab; label: string }[] = [
  { value: 'all', label: 'Все' },
  { value: 'today', label: 'На сегодня' },
  { value: 'overdue', label: 'Просроченные' },
  { value: 'done', label: 'Выполненные' },
]

const PRIORITY_LABELS: Record<TaskPriority, string> = {
  low: 'Низкий',
  medium: 'Средний',
  high: 'Высокий',
}

const STATUS_LABELS: Record<TaskStatus, string> = {
  todo: 'К выполнению',
  in_progress: 'В работе',
  done: 'Выполнено',
}

const PRIORITY_BADGE_CLASSES: Record<TaskPriority, string> = {
  low: 'bg-muted text-muted-foreground',
  medium: 'bg-amber-500/10 text-amber-600 dark:text-amber-400',
  high: 'bg-red-500/10 text-red-600 dark:text-red-400',
}

const EMPTY_FORM: TaskFormData = {
  title: '',
  description: '',
  priority: 'medium',
  deadline: '',
  company_id: '',
  status: 'todo',
  is_recurring: false,
  recurrence_days: 1,
  is_shared: false,
}

// ─── Date Helpers ─────────────────────────────────────────────────────────────

function getTodayStr(): string {
  const now = new Date()
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')}`
}

function isToday(dateStr: string): boolean {
  return dateStr === getTodayStr()
}

function isOverdue(deadline: string | null, status: string): boolean {
  if (!deadline || status === 'done') return false
  return deadline < getTodayStr()
}

function getDeadlineLabel(dateStr: string, status: string): {
  display: string
  isOverdueFlag: boolean
} {
  const date = new Date(dateStr + 'T00:00:00')
  const now = new Date()
  now.setHours(0, 0, 0, 0)
  const diffDays = Math.floor((date.getTime() - now.getTime()) / (1000 * 60 * 60 * 24))

  const formatted = date.toLocaleDateString('ru-RU', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  })

  if (status === 'done') {
    return { display: formatted, isOverdueFlag: false }
  }

  if (diffDays < 0) {
    return { display: 'просрочено', isOverdueFlag: true }
  }
  if (diffDays === 0) {
    return { display: 'сегодня', isOverdueFlag: false }
  }
  if (diffDays === 1) {
    return { display: 'завтра', isOverdueFlag: false }
  }
  return { display: formatted, isOverdueFlag: false }
}

function formatCreatedDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('ru-RU', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
  })
}

function addDays(dateStr: string, days: number): string {
  const date = new Date(dateStr + 'T00:00:00')
  date.setDate(date.getDate() + days)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

// ─── Component ────────────────────────────────────────────────────────────────

export default function TasksPage() {
  const currentUser = useAuthStore((s) => s.currentUser)
  const openCompany = useNavigationStore((s) => s.openCompany)

  // ─── State ─────────────────────────────────────────────────────────────────

  const [tasks, setTasks] = useState<TaskWithRelations[]>([])
  const [companies, setCompanies] = useState<Company[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [activeTab, setActiveTab] = useState<FilterTab>('all')

  // Dialog state
  const [dialogOpen, setDialogOpen] = useState(false)
  const [editingTask, setEditingTask] = useState<TaskWithRelations | null>(null)
  const [form, setForm] = useState<TaskFormData>(EMPTY_FORM)
  const [saving, setSaving] = useState(false)

  // Fetch trigger pattern (avoids React 19 lint warnings)
  const [fetchTrigger, setFetchTrigger] = useState(0)

  // ─── Data Fetching ────────────────────────────────────────────────────────

  const fetchTasks = useCallback(async () => {
    try {
      // Tasks - critical (no fragile JOINs on users table)
      const { data, error: fetchError } = await supabase
        .from('tasks')
        .select('*')
        .order('created_at', { ascending: false })

      if (fetchError) {
        setError(fetchError.message)
      } else {
        const taskData = (data ?? []) as TaskWithRelations[]
        setTasks(taskData)
        setError(null)
      }
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : 'Не удалось загрузить задачи'
      setError(message)
    }
  }, [])

  const fetchCompanies = useCallback(async () => {
    try {
      const { data } = await supabase
        .from('companies')
        .select('id, name')
        .order('name')
      if (data) setCompanies(data)
    } catch {
      // non-critical
    }
  }, [])

  useEffect(() => {
    let cancelled = false

    async function load() {
      // Companies fetch is non-critical — run independently
      fetchCompanies().catch(() => {})
      await fetchTasks()
      if (!cancelled) setLoading(false)
    }
    load()
    return () => { cancelled = true }
  }, [fetchTrigger, fetchTasks, fetchCompanies])

  // ─── Company Lookup Map ────────────────────────────────────────────────

  const companyMap = useMemo(() => {
    const map = new Map<string, { id: string; name: string }>()
    for (const c of companies) {
      map.set(c.id, { id: c.id, name: c.name })
    }
    return map
  }, [companies])

  const refresh = () => {
    setLoading(true)
    setFetchTrigger((n) => n + 1)
  }

  // ─── Computed Counts ──────────────────────────────────────────────────────

  const { totalCount, overdueCount, tabCounts } = useMemo(() => {
    let overdue = 0
    const counts: Record<FilterTab, number> = { all: 0, today: 0, overdue: 0, done: 0 }

    for (const t of tasks) {
      counts.all++

      if (t.status === 'done') {
        counts.done++
        continue
      }

      const taskOverdue = isOverdue(t.deadline, t.status)
      if (taskOverdue) overdue++

      if (taskOverdue) {
        counts.overdue++
      }

      if (t.deadline && isToday(t.deadline)) {
        counts.today++
      }

      // "На сегодня" also includes overdue tasks
      if (taskOverdue) {
        counts.today++
      }
    }

    return { totalCount: counts.all, overdueCount: overdue, tabCounts: counts }
  }, [tasks])

  // ─── Filtered Tasks ───────────────────────────────────────────────────────

  const filteredTasks = useMemo(() => {
    const todayStr = getTodayStr()

    switch (activeTab) {
      case 'today':
        return tasks.filter((t) => {
          if (t.status === 'done') return false
          // Today's tasks
          if (t.deadline && t.deadline === todayStr) return true
          // Shared tasks from other managers due today
          if (t.is_shared && t.deadline && t.deadline === todayStr) return true
          // Overdue tasks
          if (t.deadline && t.deadline < todayStr) return true
          // Shared overdue tasks
          if (t.is_shared && t.deadline && t.deadline < todayStr) return true
          return false
        })
      case 'overdue':
        return tasks.filter((t) => isOverdue(t.deadline, t.status))
      case 'done':
        return tasks.filter((t) => t.status === 'done')
      default:
        return tasks
    }
  }, [tasks, activeTab])

  // ─── Recurring Task Logic ─────────────────────────────────────────────────

  const toggleDone = async (task: TaskWithRelations) => {
    const wasDone = task.status === 'done'
    const newStatus: TaskStatus = wasDone ? 'in_progress' : 'done'

    const { error: updateError } = await supabase
      .from('tasks')
      .update({ status: newStatus })
      .eq('id', task.id)

    if (updateError) return

    // Log activity
    await supabase.from('activities').insert({
      content: newStatus === 'done'
        ? `Выполнена задача «${task.title}»`
        : `Задача «${task.title}» возвращена в работу`,
      type: 'заметка',
      user_id: currentUser?.id,
    })

    // Recurring: when marking done, create next occurrence
    if (newStatus === 'done' && task.is_recurring && task.recurrence_days && task.deadline) {
      const newDeadline = addDays(task.deadline, task.recurrence_days)

      // Set last_recurrence on completed task
      await supabase
        .from('tasks')
        .update({ last_recurrence: task.deadline })
        .eq('id', task.id)

      // Create next task
      await supabase.from('tasks').insert({
        title: task.title,
        description: task.description,
        priority: task.priority,
        status: 'todo',
        deadline: newDeadline,
        company_id: task.company_id,
        client_id: task.client_id,
        project_id: task.project_id,
        created_by: currentUser?.id,
        is_recurring: true,
        recurrence_days: task.recurrence_days,
        is_shared: task.is_shared ?? false,
      })

      await supabase.from('activities').insert({
        content: `Создана повторяющаяся задача «${task.title}» на ${newDeadline}`,
        type: 'заметка',
        user_id: currentUser?.id,
      })
    }

    refresh()
  }

  // ─── Create / Update ──────────────────────────────────────────────────────

  const openCreateDialog = () => {
    setEditingTask(null)
    setForm({
      ...EMPTY_FORM,
      deadline: getTodayStr(),
    })
    setDialogOpen(true)
  }

  const openEditDialog = (task: TaskWithRelations) => {
    setEditingTask(task)
    setForm({
      title: task.title,
      description: task.description ?? '',
      priority: (task.priority as TaskPriority) || 'medium',
      deadline: task.deadline ?? '',
      company_id: task.company_id ?? '',
      status: (task.status as TaskStatus) || 'todo',
      is_recurring: task.is_recurring ?? false,
      recurrence_days: task.recurrence_days ?? 1,
      is_shared: task.is_shared ?? false,
    })
    setDialogOpen(true)
  }

  const handleSave = async () => {
    if (!form.title.trim() || !form.deadline) return
    setSaving(true)

    try {
      if (editingTask) {
        const { error: updateError } = await supabase
          .from('tasks')
          .update({
            title: form.title.trim(),
            description: form.description.trim() || null,
            priority: form.priority,
            deadline: form.deadline || null,
            company_id: form.company_id || null,
            status: form.status,
            is_recurring: form.is_recurring || null,
            recurrence_days: form.is_recurring ? form.recurrence_days : null,
            is_shared: form.is_shared || null,
          })
          .eq('id', editingTask.id)

        if (!updateError) {
          await supabase.from('activities').insert({
            content: `Обновлена задача «${form.title.trim()}»`,
            type: 'заметка',
            user_id: currentUser?.id,
          })
        }
      } else {
        const { error: insertError } = await supabase
          .from('tasks')
          .insert({
            title: form.title.trim(),
            description: form.description.trim() || null,
            status: 'todo',
            priority: form.priority,
            deadline: form.deadline || null,
            company_id: form.company_id || null,
            created_by: currentUser?.id,
            is_recurring: form.is_recurring || null,
            recurrence_days: form.is_recurring ? form.recurrence_days : null,
            is_shared: form.is_shared || null,
          })

        if (!insertError) {
          await supabase.from('activities').insert({
            content: `Создана задача «${form.title.trim()}»`,
            type: 'заметка',
            user_id: currentUser?.id,
          })
        }
      }

      setDialogOpen(false)
      setEditingTask(null)
      setForm(EMPTY_FORM)
      refresh()
    } catch {
      // silent — refresh will show latest state
    }
    setSaving(false)
  }

  // ─── Mark as In Progress ──────────────────────────────────────────────────

  const markInProgress = async (task: TaskWithRelations) => {
    if (task.status === 'in_progress') return

    const { error } = await supabase
      .from('tasks')
      .update({ status: 'in_progress' })
      .eq('id', task.id)

    if (!error) {
      await supabase.from('activities').insert({
        content: `Задача «${task.title}» взята в работу`,
        type: 'заметка',
        user_id: currentUser?.id,
      })
      refresh()
    }
  }

  // ─── Delete ───────────────────────────────────────────────────────────────

  const handleDelete = async (task: TaskWithRelations) => {
    if (!window.confirm(`Удалить «${task.title}»? Это действие нельзя отменить.`)) return

    const { error: deleteError } = await supabase
      .from('tasks')
      .delete()
      .eq('id', task.id)

    if (!deleteError) {
      await supabase.from('activities').insert({
        content: `Удалена задача «${task.title}»`,
        type: 'заметка',
        user_id: currentUser?.id,
      })
      refresh()
    }
  }

  // ─── Form Helpers ─────────────────────────────────────────────────────────

  const updateForm = (patch: Partial<TaskFormData>) =>
    setForm((prev) => ({ ...prev, ...patch }))

  // ─── Render ───────────────────────────────────────────────────────────────

  return (
    <div className="flex flex-col gap-4 md:h-full">
      {/* ── Top Bar ────────────────────────────────────────────────────────── */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
        <div>
          <h2 className="text-xl font-semibold tracking-tight flex items-center gap-2">
            <CheckSquare className="h-5 w-5 text-violet-500" />
            Задачи
          </h2>
          <p className="text-sm text-muted-foreground mt-0.5">
            {totalCount} задач
            {overdueCount > 0 && (
              <span className="text-red-500 dark:text-red-400 ml-1">
                · {overdueCount} просрочено
              </span>
            )}
          </p>
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          {/* Filter Tabs */}
          <div className="flex items-center gap-1 bg-muted/60 rounded-xl p-1">
            {FILTER_TABS.map((tab) => (
              <button
                key={tab.value}
                onClick={() => setActiveTab(tab.value)}
                className={`px-3 py-1.5 text-xs font-medium rounded-md transition-colors whitespace-nowrap ${
                  activeTab === tab.value
                    ? 'bg-primary text-primary-foreground shadow-sm shadow-primary/20'
                    : 'text-muted-foreground hover:text-foreground hover:bg-primary/5'
                }`}
              >
                {tab.label}
                <span className="ml-1.5 opacity-60">
                  ({tabCounts[tab.value]})
                </span>
              </button>
            ))}
          </div>
          <Button size="sm" onClick={openCreateDialog} className="gap-1.5 rounded-xl">
            <Plus className="h-4 w-4" />
            Новая задача
          </Button>
        </div>
      </div>

      <Separator />

      {/* ── Error State ────────────────────────────────────────────────────── */}
      {error && !loading && (
        <div className="flex flex-col items-center justify-center py-16 gap-3">
          <AlertCircle className="h-10 w-10 text-destructive" />
          <p className="text-sm text-muted-foreground max-w-md text-center">{error}</p>
          <Button variant="outline" size="sm" onClick={refresh}>
            Повторить
          </Button>
        </div>
      )}

      {/* ── Loading State ──────────────────────────────────────────────────── */}
      {loading && (
        <div className="space-y-3">
          {Array.from({ length: 5 }).map((_, i) => (
            <Card key={i} className="rounded-xl shadow-sm border border-border/60">
              <CardContent className="p-4 flex items-start gap-3">
                <Skeleton className="h-5 w-5 rounded-[4px] mt-0.5 shrink-0" />
                <div className="flex-1 min-w-0 space-y-2">
                  <div className="flex items-center gap-2">
                    <Skeleton className="h-4 w-2/3" />
                    <Skeleton className="h-5 w-16 rounded-full" />
                  </div>
                  <Skeleton className="h-3 w-1/2" />
                  <div className="flex items-center gap-2">
                    <Skeleton className="h-3 w-20" />
                    <Skeleton className="h-5 w-14 rounded-full" />
                  </div>
                </div>
                <Skeleton className="h-8 w-8 rounded-md shrink-0" />
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      {/* ── Empty State (no tasks at all) ─────────────────────────────────── */}
      {!loading && !error && tasks.length === 0 && (
        <div className="flex flex-col items-center justify-center py-20 gap-4">
          <div className="h-14 w-14 rounded-full bg-primary/10 flex items-center justify-center">
            <CheckSquare className="h-7 w-7 text-muted-foreground" />
          </div>
          <div className="text-center">
            <p className="text-base font-medium text-foreground">Нет задач</p>
            <p className="text-sm text-muted-foreground mt-1">
              Создайте первую задачу для начала работы
            </p>
          </div>
          <Button size="sm" onClick={openCreateDialog} className="gap-1.5 rounded-xl">
            <Plus className="h-4 w-4" />
            Новая задача
          </Button>
        </div>
      )}

      {/* ── Filtered Empty State ───────────────────────────────────────────── */}
      {!loading && !error && tasks.length > 0 && filteredTasks.length === 0 && (
        <div className="flex flex-col items-center justify-center py-16 gap-3">
          <CheckSquare className="h-8 w-8 text-muted-foreground" />
          <p className="text-sm text-muted-foreground">
            Нет задач в этой категории
          </p>
          <Button
            variant="outline"
            size="sm"
            onClick={() => setActiveTab('all')}
          >
            Сбросить фильтр
          </Button>
        </div>
      )}

      {/* ── Task List ──────────────────────────────────────────────────────── */}
      {!loading && !error && filteredTasks.length > 0 && (
        <ScrollArea className="flex-1 max-h-[calc(100vh-240px)]">
          <div className="space-y-3 pr-1">
            {filteredTasks.map((task) => {
              const isDone = task.status === 'done'
              const priority = (task.priority as TaskPriority) || 'medium'
              const overdue = isOverdue(task.deadline, task.status)
              const deadlineInfo = task.deadline
                ? getDeadlineLabel(task.deadline, task.status)
                : null

              return (
                <Card
                  key={task.id}
                  className={`rounded-xl border shadow-sm transition-all duration-200 hover:shadow-md hover:bg-primary/[0.02] ${
                    overdue
                      ? 'border-l-4 border-l-red-500 border-t-border border-r-border border-b-border'
                      : 'border-border/60'
                  }`}
                >
                  <CardContent className="p-4">
                    <div className="flex items-start gap-3">
                      {/* Checkbox */}
                      <div className="mt-0.5 shrink-0">
                        <Checkbox
                          checked={isDone}
                          onCheckedChange={() => toggleDone(task)}
                          className="h-5 w-5 rounded-[4px]"
                          aria-label={
                            isDone
                              ? `Отменить выполнение: ${task.title}`
                              : `Выполнить: ${task.title}`
                          }
                        />
                      </div>

                      {/* Content */}
                      <div className="flex-1 min-w-0">
                        {/* Title Row */}
                        <div className="flex items-start justify-between gap-2">
                          <p
                            className={`text-sm font-medium leading-snug ${
                              isDone
                                ? 'line-through text-muted-foreground'
                                : 'text-foreground'
                            }`}
                          >
                            {task.title}
                          </p>

                          {/* Actions */}
                          <div className="flex items-center gap-2 shrink-0">
                            {/* Overdue Badge */}
                            {overdue && (
                              <Badge
                                variant="outline"
                                className="text-[10px] font-medium border-red-300 bg-red-500/10 text-red-600 dark:text-red-400 dark:border-red-800"
                              >
                                Просрочено
                              </Badge>
                            )}

                            <DropdownMenu>
                              <DropdownMenuTrigger asChild>
                                <button
                                  className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-primary/10 transition-colors"
                                  aria-label="Действия с задачей"
                                >
                                  <MoreHorizontal className="h-4 w-4" />
                                </button>
                              </DropdownMenuTrigger>
                              <DropdownMenuContent align="end">
                                <DropdownMenuItem onClick={() => openEditDialog(task)}>
                                  <Pencil className="h-3.5 w-3.5 mr-2" />
                                  Изменить
                                </DropdownMenuItem>
                                {task.status !== 'in_progress' && task.status !== 'done' && (
                                  <DropdownMenuItem onClick={() => markInProgress(task)}>
                                    <ArrowRight className="h-3.5 w-3.5 mr-2" />
                                    Взять в работу
                                  </DropdownMenuItem>
                                )}
                                <DropdownMenuSeparator />
                                <DropdownMenuItem
                                  className="text-destructive focus:text-destructive"
                                  onClick={() => handleDelete(task)}
                                >
                                  <Trash2 className="h-3.5 w-3.5 mr-2" />
                                  Удалить
                                </DropdownMenuItem>
                              </DropdownMenuContent>
                            </DropdownMenu>
                          </div>
                        </div>

                        {/* Description */}
                        {task.description && (
                          <p className="text-xs text-muted-foreground mt-1 line-clamp-2">
                            {task.description}
                          </p>
                        )}

                        {/* Meta Row: priority, deadline, badges, created date */}
                        <div className="flex flex-wrap items-center gap-2 mt-2">
                          {/* Priority Badge */}
                          <Badge
                            variant="outline"
                            className={`text-[10px] font-medium border-transparent ${PRIORITY_BADGE_CLASSES[priority]}`}
                          >
                            {PRIORITY_LABELS[priority]}
                          </Badge>

                          {/* Deadline */}
                          {deadlineInfo && (
                            <span
                              className={`text-[11px] flex items-center gap-1 ${
                                deadlineInfo.isOverdueFlag
                                  ? 'text-red-500 dark:text-red-400'
                                  : 'text-muted-foreground'
                              }`}
                            >
                              <Calendar className="h-3 w-3" />
                              {deadlineInfo.display}
                            </span>
                          )}

                          {/* Company Badge */}
                          {task.company_id && companyMap.get(task.company_id) && (
                            <Badge
                              variant="outline"
                              className="text-[10px] font-medium gap-1 cursor-pointer hover:bg-primary/10 transition-colors"
                              onClick={() => openCompany(task.company_id!)}
                            >
                              <Building2 className="h-3 w-3" />
                              {companyMap.get(task.company_id!)!.name}
                            </Badge>
                          )}

                          {/* Recurring Badge */}
                          {task.is_recurring && task.recurrence_days && (
                            <Badge
                              variant="outline"
                              className="text-[10px] font-medium gap-1 border-emerald-300 bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 dark:border-emerald-800"
                            >
                              <RefreshCw className="h-3 w-3" />
                              каждые {task.recurrence_days} дн.
                            </Badge>
                          )}

                          {/* Shared Badge */}
                          {task.is_shared && (
                            <Badge
                              variant="outline"
                              className="text-[10px] font-medium gap-1 border-blue-300 bg-blue-500/10 text-blue-600 dark:text-blue-400 dark:border-blue-800"
                            >
                              <Users className="h-3 w-3" />
                              Общая
                            </Badge>
                          )}

                          {/* Created Date */}
                          <span className="text-[11px] text-muted-foreground flex items-center gap-1 ml-auto">
                            <Clock className="h-3 w-3" />
                            {formatCreatedDate(task.created_at)}
                          </span>
                        </div>

                        {/* Created by (if shared and not current user) — requires user lookup */}
                        {/* Removed: created_by_user join was fragile; display skipped gracefully */}
                      </div>
                    </div>
                  </CardContent>
                </Card>
              )
            })}
          </div>
        </ScrollArea>
      )}

      {/* ── Create / Edit Dialog ───────────────────────────────────────────── */}
      <Dialog
        open={dialogOpen}
        onOpenChange={(open) => {
          setDialogOpen(open)
          if (!open) {
            setEditingTask(null)
            setForm(EMPTY_FORM)
          }
        }}
      >
        <DialogContent className="sm:max-w-md max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              {editingTask ? (
                <>
                  <Pencil className="h-5 w-5" />
                  Редактировать задачу
                </>
              ) : (
                <>
                  <Plus className="h-5 w-5" />
                  Новая задача
                </>
              )}
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {/* Title */}
            <div className="space-y-2">
              <Label htmlFor="task-title">
                Название <span className="text-destructive">*</span>
              </Label>
              <Input
                id="task-title"
                placeholder="напр. Связаться с клиентом"
                value={form.title}
                onChange={(e) => updateForm({ title: e.target.value })}
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault()
                    handleSave()
                  }
                }}
              />
            </div>

            {/* Description */}
            <div className="space-y-2">
              <Label htmlFor="task-description">Описание</Label>
              <Textarea
                id="task-description"
                placeholder="Добавьте описание задачи (необязательно)"
                value={form.description}
                onChange={(e) => updateForm({ description: e.target.value })}
                rows={3}
                className="resize-none"
              />
            </div>

            {/* Priority + Deadline */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Приоритет</Label>
                <Select
                  value={form.priority}
                  onValueChange={(v) => updateForm({ priority: v as TaskPriority })}
                >
                  <SelectTrigger className="w-full">
                    <SelectValue placeholder="Выберите приоритет" />
                  </SelectTrigger>
                  <SelectContent>
                    {(['low', 'medium', 'high'] as TaskPriority[]).map((p) => (
                      <SelectItem key={p} value={p}>
                        {PRIORITY_LABELS[p]}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="task-deadline">
                  Срок <span className="text-destructive">*</span>
                </Label>
                <Input
                  id="task-deadline"
                  type="date"
                  value={form.deadline}
                  onChange={(e) => updateForm({ deadline: e.target.value })}
                  className={form.deadline ? '' : 'border-destructive/50 focus-visible:ring-destructive/30'}
                />
                {!form.deadline && (
                  <p className="text-[11px] text-destructive">Укажите срок выполнения</p>
                )}
              </div>
            </div>

            {/* Company */}
            <div className="space-y-2">
              <Label>Компания</Label>
              <Select
                value={form.company_id}
                onValueChange={(v) => updateForm({ company_id: v })}
              >
                <SelectTrigger className="w-full">
                  <SelectValue placeholder="Выберите компанию (необязательно)" />
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

            {/* Recurring */}
            <div className="space-y-2">
              <div className="flex items-center gap-2">
                <Checkbox
                  id="task-recurring"
                  checked={form.is_recurring}
                  onCheckedChange={(checked) =>
                    updateForm({ is_recurring: !!checked })
                  }
                />
                <Label htmlFor="task-recurring" className="cursor-pointer">
                  Повторяющаяся задача
                </Label>
              </div>
              {form.is_recurring && (
                <div className="flex items-center gap-2 pl-6">
                  <Label className="text-sm text-muted-foreground whitespace-nowrap">
                    каждые
                  </Label>
                  <Input
                    type="number"
                    min={1}
                    value={form.recurrence_days}
                    onChange={(e) =>
                      updateForm({
                        recurrence_days: Math.max(1, parseInt(e.target.value) || 1),
                      })
                    }
                    className="w-20"
                  />
                  <Label className="text-sm text-muted-foreground whitespace-nowrap">
                    дн.
                  </Label>
                </div>
              )}
            </div>

            {/* Shared */}
            <div className="flex items-center gap-2">
              <Checkbox
                id="task-shared"
                checked={form.is_shared}
                onCheckedChange={(checked) =>
                  updateForm({ is_shared: !!checked })
                }
              />
              <Label htmlFor="task-shared" className="cursor-pointer">
                Видна всем менеджерам
              </Label>
            </div>

            {/* Status (only in edit mode) */}
            {editingTask && (
              <>
                <Separator />
                <div className="space-y-2">
                  <Label>Статус</Label>
                  <Select
                    value={form.status}
                    onValueChange={(v) => updateForm({ status: v as TaskStatus })}
                  >
                    <SelectTrigger className="w-full">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      {(['todo', 'in_progress', 'done'] as TaskStatus[]).map((s) => (
                        <SelectItem key={s} value={s}>
                          {STATUS_LABELS[s]}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              </>
            )}

            {/* Actions */}
            <div className="flex justify-end gap-2 pt-2">
              <Button
                variant="outline"
                onClick={() => {
                  setDialogOpen(false)
                  setEditingTask(null)
                  setForm(EMPTY_FORM)
                }}
              >
                Отмена
              </Button>
              <Button
                onClick={handleSave}
                disabled={!form.title.trim() || !form.deadline || saving}
                className="rounded-xl"
              >
                {saving
                  ? 'Сохранение...'
                  : editingTask
                    ? 'Обновить'
                    : 'Создать задачу'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
