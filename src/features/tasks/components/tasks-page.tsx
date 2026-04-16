'use client'

import { useState, useEffect, useMemo } from 'react'
import { supabase } from '@/lib/supabase/client'
import type { Task, TaskInsert, TaskUpdate } from '@/lib/supabase/database.types'
import { useAuthStore } from '@/lib/store'
import { Card, CardContent } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
import { Checkbox } from '@/components/ui/checkbox'
import { Separator } from '@/components/ui/separator'
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
  Plus,
  MoreHorizontal,
  Pencil,
  Trash2,
  CheckSquare,
  AlertCircle,
  Calendar,
} from 'lucide-react'

// ─── Types ─────────────────────────────────────────────────────────────────────

type TaskStatus = 'todo' | 'in_progress' | 'done'
type TaskPriority = 'low' | 'medium' | 'high'
type FilterTab = 'all' | TaskStatus

interface TaskFormData {
  title: string
  description: string
  priority: TaskPriority
  deadline: string
}

const STATUS_TABS: { value: FilterTab; label: string }[] = [
  { value: 'all', label: 'Все' },
  { value: 'todo', label: 'К выполнению' },
  { value: 'in_progress', label: 'В работе' },
  { value: 'done', label: 'Выполнено' },
]

const PRIORITY_OPTIONS: TaskPriority[] = ['low', 'medium', 'high']

const PRIORITY_BADGE: Record<TaskPriority, string> = {
  low: 'bg-muted text-muted-foreground',
  medium: 'bg-amber-500/10 text-amber-600 dark:text-amber-400',
  high: 'bg-red-500/10 text-red-600 dark:text-red-400',
}

const EMPTY_FORM: TaskFormData = {
  title: '',
  description: '',
  priority: 'medium',
  deadline: '',
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

function formatDeadline(dateStr: string | null): string {
  if (!dateStr) return ''
  const date = new Date(dateStr + 'T00:00:00')
  const now = new Date()
  now.setHours(0, 0, 0, 0)
  const diffDays = Math.floor((date.getTime() - now.getTime()) / (1000 * 60 * 60 * 24))

  const formatted = date.toLocaleDateString('ru-RU', {
    month: 'short',
    day: 'numeric',
  })

  if (diffDays < 0) return `${formatted} (просрочено)`
  if (diffDays === 0) return `${formatted} (сегодня)`
  if (diffDays === 1) return `${formatted} (завтра)`
  return formatted
}

function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('ru-RU', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  })
}

function isOverdue(deadline: string | null, status: string): boolean {
  if (!deadline || status === 'done') return false
  const date = new Date(deadline + 'T23:59:59')
  return date < new Date()
}

// ─── Component ────────────────────────────────────────────────────────────────

export default function TasksPage() {
  const currentUser = useAuthStore((s) => s.currentUser)

  // ─── State ─────────────────────────────────────────────────────────────────

  const [tasks, setTasks] = useState<Task[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [activeTab, setActiveTab] = useState<FilterTab>('all')

  // Dialog state
  const [dialogOpen, setDialogOpen] = useState(false)
  const [editingTask, setEditingTask] = useState<Task | null>(null)
  const [form, setForm] = useState<TaskFormData>(EMPTY_FORM)
  const [saving, setSaving] = useState(false)

  // Fetch trigger pattern (avoids React 19 lint warnings)
  const [fetchTrigger, setFetchTrigger] = useState(0)

  // ─── Data Fetching ────────────────────────────────────────────────────────

  useEffect(() => {
    let cancelled = false
    async function load() {
      try {
        const { data, error: fetchError } = await supabase
          .from('tasks')
          .select('*')
          .order('created_at', { ascending: false })

        if (cancelled) return

        if (fetchError) {
          setError(fetchError.message)
        } else {
          setTasks(data ?? [])
          setError(null)
        }
      } catch (err: unknown) {
        if (cancelled) return
        const message = err instanceof Error ? err.message : 'Не удалось загрузить задачи'
        setError(message)
      }
      setLoading(false)
    }
    load()
    return () => {
      cancelled = true
    }
  }, [fetchTrigger])

  const refresh = () => {
    setLoading(true)
    setFetchTrigger((n) => n + 1)
  }

  // ─── Filtered Tasks ───────────────────────────────────────────────────────

  const filteredTasks = useMemo(() => {
    if (activeTab === 'all') return tasks
    return tasks.filter((t) => t.status === activeTab)
  }, [tasks, activeTab])

  // ─── Status Counts ────────────────────────────────────────────────────────

  const statusCounts = useMemo(() => {
    const counts: Record<string, number> = { all: tasks.length, todo: 0, in_progress: 0, done: 0 }
    for (const t of tasks) {
      if (t.status in counts) counts[t.status]++
    }
    return counts
  }, [tasks])

  // ─── Toggle Done ──────────────────────────────────────────────────────────

  const toggleDone = async (task: Task) => {
    const newStatus: TaskStatus = task.status === 'done' ? 'todo' : 'done'
    const { error: updateError } = await supabase
      .from('tasks')
      .update({ status: newStatus })
      .eq('id', task.id)

    if (!updateError) {
      await supabase.from('activities').insert({
        action: newStatus === 'done'
          ? `Выполнена задача «${task.title}»`
          : `Задача «${task.title}» возвращена в работу`,
        entity_type: 'task',
        entity_id: task.id,
        user_id: currentUser?.id,
      })
      refresh()
    }
  }

  // ─── Create / Update ──────────────────────────────────────────────────────

  const openCreateDialog = () => {
    setEditingTask(null)
    setForm(EMPTY_FORM)
    setDialogOpen(true)
  }

  const openEditDialog = (task: Task) => {
    setEditingTask(task)
    setForm({
      title: task.title,
      description: task.description ?? '',
      priority: (task.priority as TaskPriority) || 'medium',
      deadline: task.deadline ?? '',
    })
    setDialogOpen(true)
  }

  const handleSave = async () => {
    if (!form.title.trim()) return
    setSaving(true)

    try {
      if (editingTask) {
        const updates: TaskUpdate = {
          title: form.title.trim(),
          description: form.description.trim() || null,
          priority: form.priority,
          deadline: form.deadline || null,
        }
        const { error: updateError } = await supabase
          .from('tasks')
          .update(updates)
          .eq('id', editingTask.id)

        if (!updateError) {
          await supabase.from('activities').insert({
            action: `Обновлена задача «${form.title.trim()}»`,
            entity_type: 'task',
            entity_id: editingTask.id,
            user_id: currentUser?.id,
          })
        }
      } else {
        const insert: TaskInsert = {
          title: form.title.trim(),
          description: form.description.trim() || null,
          status: 'todo',
          priority: form.priority,
          deadline: form.deadline || null,
          created_by: currentUser?.id,
        }
        const { error: insertError } = await supabase
          .from('tasks')
          .insert(insert)

        if (!insertError) {
          await supabase.from('activities').insert({
            action: `Создана задача «${form.title.trim()}»`,
            entity_type: 'task',
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

  // ─── Delete ───────────────────────────────────────────────────────────────

  const handleDelete = async (task: Task) => {
    if (!window.confirm(`Удалить "${task.title}"? Это действие нельзя отменить.`)) return

    const { error: deleteError } = await supabase
      .from('tasks')
      .delete()
      .eq('id', task.id)

    if (!deleteError) {
      await supabase.from('activities').insert({
        action: `Удалена задача «${task.title}»`,
        entity_type: 'task',
        entity_id: task.id,
        user_id: currentUser?.id,
      })
      refresh()
    }
  }

  // ─── Render ───────────────────────────────────────────────────────────────

  return (
    <div className="flex flex-col gap-4 md:h-full">
      {/* ── Top Bar ────────────────────────────────────────────────────────── */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
        <div>
          <h2 className="text-xl font-semibold tracking-tight flex items-center gap-2">
            <CheckSquare className="h-5 w-5 text-muted-foreground" />
            Задачи
          </h2>
          <p className="text-sm text-muted-foreground mt-0.5">
            {tasks.length} задач всего
          </p>
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          {/* Status Tabs */}
          <div className="flex items-center gap-1 bg-muted/50 rounded-lg p-1">
            {STATUS_TABS.map((tab) => (
              <button
                key={tab.value}
                onClick={() => setActiveTab(tab.value)}
                className={`px-3 py-1.5 text-xs font-medium rounded-md transition-colors whitespace-nowrap ${
                  activeTab === tab.value
                    ? 'bg-background text-foreground shadow-sm'
                    : 'text-muted-foreground hover:text-foreground'
                }`}
              >
                {tab.label}
                <span className="ml-1.5 opacity-60">
                  ({statusCounts[tab.value]})
                </span>
              </button>
            ))}
          </div>
          <Button size="sm" onClick={openCreateDialog} className="gap-1.5">
            <Plus className="h-4 w-4" />
            Добавить задачу
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
            <Card key={i} className="border border-border">
              <CardContent className="p-4 flex items-start gap-3">
                <Skeleton className="h-5 w-5 rounded-[4px] mt-0.5 shrink-0" />
                <div className="flex-1 min-w-0 space-y-2">
                  <Skeleton className="h-4 w-3/4" />
                  <Skeleton className="h-3 w-1/2" />
                </div>
                <div className="flex items-center gap-2 shrink-0">
                  <Skeleton className="h-5 w-14 rounded-full" />
                  <Skeleton className="h-8 w-8 rounded-md" />
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      {/* ── Empty State ────────────────────────────────────────────────────── */}
      {!loading && !error && tasks.length === 0 && (
        <div className="flex flex-col items-center justify-center py-20 gap-4">
          <div className="h-14 w-14 rounded-full bg-muted/50 flex items-center justify-center">
            <CheckSquare className="h-7 w-7 text-muted-foreground" />
          </div>
          <div className="text-center">
            <p className="text-base font-medium text-foreground">Нет задач</p>
            <p className="text-sm text-muted-foreground mt-1">
              Создайте первую задачу
            </p>
          </div>
          <Button size="sm" onClick={openCreateDialog} className="gap-1.5">
            <Plus className="h-4 w-4" />
            Добавить задачу
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
            Показать все
          </Button>
        </div>
      )}

      {/* ── Task List ──────────────────────────────────────────────────────── */}
      {!loading && !error && filteredTasks.length > 0 && (
        <div className="space-y-3 flex-1 overflow-y-auto max-h-[calc(100vh-220px)] pr-1">
          {filteredTasks.map((task) => {
            const isDone = task.status === 'done'
            const priority = (task.priority as TaskPriority) || 'medium'
            const overdue = isOverdue(task.deadline, task.status)

            return (
              <Card
                key={task.id}
                className="border border-border transition-colors hover:bg-accent/50"
              >
                <CardContent className="p-4 flex items-start gap-3">
                  {/* Checkbox */}
                  <div className="mt-0.5 shrink-0">
                    <Checkbox
                      checked={isDone}
                      onCheckedChange={() => toggleDone(task)}
                      className="h-5 w-5 rounded-[4px]"
                      aria-label={`${isDone ? 'Отменить выполнение' : 'Выполнить'}: ${task.title}`}
                    />
                  </div>

                  {/* Content */}
                  <div className="flex-1 min-w-0">
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

                      {/* Right side: priority + deadline + actions */}
                      <div className="flex items-center gap-2 shrink-0">
                        <Badge
                          variant="outline"
                          className={`text-[10px] font-medium border-transparent ${PRIORITY_BADGE[priority]}`}
                        >
                          {priority}
                        </Badge>
                        {task.deadline && (
                          <span
                            className={`text-[11px] flex items-center gap-1 whitespace-nowrap ${
                              overdue
                                ? 'text-red-500 dark:text-red-400'
                                : 'text-muted-foreground'
                            }`}
                          >
                            <Calendar className="h-3 w-3" />
                            {formatDeadline(task.deadline)}
                          </span>
                        )}
                        <DropdownMenu>
                          <DropdownMenuTrigger asChild>
                            <button
                              className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors"
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
                      <p className="text-xs text-muted-foreground mt-1 truncate max-w-[600px]">
                        {task.description}
                      </p>
                    )}

                    {/* Bottom meta row */}
                    <div className="flex items-center gap-2 mt-1.5">
                      <span className="text-[11px] text-muted-foreground">
                        Создано {formatDate(task.created_at)}
                      </span>
                    </div>
                  </div>
                </CardContent>
              </Card>
            )
          })}
        </div>
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
        <DialogContent className="sm:max-w-md">
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
                onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))}
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
                onChange={(e) =>
                  setForm((f) => ({ ...f, description: e.target.value }))
                }
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
                  onValueChange={(v) =>
                    setForm((f) => ({ ...f, priority: v as TaskPriority }))
                  }
                >
                  <SelectTrigger className="w-full">
                    <SelectValue placeholder="Выберите приоритет" />
                  </SelectTrigger>
                  <SelectContent>
                    {PRIORITY_OPTIONS.map((p) => (
                      <SelectItem key={p} value={p} className="capitalize">
                        {p}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="task-deadline">Срок</Label>
                <Input
                  id="task-deadline"
                  type="date"
                  value={form.deadline}
                  onChange={(e) =>
                    setForm((f) => ({ ...f, deadline: e.target.value }))
                  }
                />
              </div>
            </div>

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
                disabled={!form.title.trim() || saving}
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
