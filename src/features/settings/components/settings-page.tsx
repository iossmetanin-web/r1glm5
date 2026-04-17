'use client'
/* eslint-disable react-hooks/set-state-in-effect */

import { useState, useEffect, useRef } from 'react'
import {
  User,
  Users,
  Kanban,
  Contact,
  CheckSquare,
  Zap,
  Bell,
  Tag,
  FileText,
  Clock,
  Mail,
  Shield,
  LogOut,
  ChevronRight,
  ChevronLeft,
  Plus,
  Pencil,
  Trash2,
  MoreHorizontal,
  Circle,
  ArrowRight,
  AlertCircle,
  Upload,
  Search,
  Loader2,
} from 'lucide-react'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { Input } from '@/components/ui/input'
import { Switch } from '@/components/ui/switch'
import { Label } from '@/components/ui/label'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from '@/components/ui/dialog'
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select'
import { supabase } from '@/lib/supabase/client'
import { useAuthStore } from '@/lib/store'
import type { LucideIcon } from 'lucide-react'

// ─── Types ───────────────────────────────────────────────────────────────────

type SettingsSection =
  | 'main'
  | 'profile'
  | 'users'
  | 'crm'
  | 'contacts'
  | 'tasks'
  | 'automation'
  | 'notifications'
  | 'tags'
  | 'files'
  | 'logs'

interface CategoryItem {
  id: SettingsSection
  title: string
  description: string
  icon: LucideIcon
  color: string
}

interface TagItem { id: string; name: string; color: string }
interface SegmentItem { id: string; name: string }
interface CustomField { id: string; name: string; type: string }
interface TaskStatus { id: string; name: string; color: string }
interface TaskPriority { id: string; name: string }
interface AutomationRule { id: string; name: string; trigger: string; action: string; enabled: boolean }
interface NotificationItem { id: string; event: string; channel: string; enabled: boolean }
interface FileMeta { id: string; name: string; size: string; type: string; data: string; uploaded_at: string }

// ─── Settings Storage Helpers ────────────────────────────────────────────────

const SETTINGS_IDS: Record<string, string> = {
  tags: '00000001-0000-0000-0000-000000000001',
  segments: '00000001-0000-0000-0000-000000000002',
  custom_fields: '00000001-0000-0000-0000-000000000003',
  task_statuses: '00000001-0000-0000-0000-000000000004',
  task_priorities: '00000001-0000-0000-0000-000000000005',
  automation_rules: '00000001-0000-0000-0000-000000000006',
  notifications: '00000001-0000-0000-0000-000000000007',
  files_metadata: '00000001-0000-0000-0000-000000000008',
}

async function loadSettings<T>(category: string, fallback: T): Promise<T> {
  try {
    const { data } = await supabase
      .from('activities')
      .select('content, type')
      .eq('id', SETTINGS_IDS[category])
      .eq('type', 'settings')
      .single()
    if (!data?.content) return fallback
    try { return JSON.parse(data.content) as T }
    catch { return fallback }
  } catch { return fallback }
}

async function saveSettings(category: string, data: unknown): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('activities')
      .upsert(
        { id: SETTINGS_IDS[category], content: JSON.stringify(data), type: 'settings', user_id: null, company_id: null },
        { onConflict: 'id' }
      )
    return !error
  } catch { return false }
}

// ─── Defaults ────────────────────────────────────────────────────────────────

const DEFAULT_STATUSES: TaskStatus[] = [
  { id: '1', name: 'К выполнению', color: '#94a3b8' },
  { id: '2', name: 'В работе', color: '#3b82f6' },
  { id: '3', name: 'Выполнено', color: '#22c55e' },
]

const DEFAULT_PRIORITIES: TaskPriority[] = [
  { id: '1', name: 'Высокий' },
  { id: '2', name: 'Средний' },
  { id: '3', name: 'Низкий' },
]

const DEFAULT_NOTIFICATIONS: NotificationItem[] = [
  { id: '1', event: 'Новая сделка', channel: 'Push', enabled: true },
  { id: '2', event: 'Сделка перемещена', channel: 'Push', enabled: true },
  { id: '3', event: 'Просрочка задачи', channel: 'Email', enabled: true },
  { id: '4', event: 'Новый комментарий', channel: 'Push', enabled: false },
  { id: '5', event: 'Ежедневный отчёт', channel: 'Email', enabled: true },
]

// ─── Categories ──────────────────────────────────────────────────────────────

const CATEGORIES: CategoryItem[] = [
  { id: 'profile', title: 'Профиль', description: 'Имя, email, роль и аватар', icon: User, color: 'bg-gray-500' },
  { id: 'users', title: 'Пользователи и роли', description: 'Управление командой и доступом', icon: Users, color: 'bg-blue-500' },
  { id: 'crm', title: 'CRM', description: 'Сделки, воронки и этапы', icon: Kanban, color: 'bg-amber-500' },
  { id: 'contacts', title: 'Контакты и компании', description: 'Поля, теги и сегменты', icon: Contact, color: 'bg-emerald-500' },
  { id: 'tasks', title: 'Задачи', description: 'Статусы, приоритеты и сроки', icon: CheckSquare, color: 'bg-violet-500' },
  { id: 'automation', title: 'Автоматизация', description: 'Правила и триггеры', icon: Zap, color: 'bg-orange-500' },
  { id: 'notifications', title: 'Уведомления', description: 'События и каналы оповещения', icon: Bell, color: 'bg-pink-500' },
  { id: 'tags', title: 'Теги и сегменты', description: 'Категоризация клиентов', icon: Tag, color: 'bg-cyan-500' },
  { id: 'files', title: 'Файлы', description: 'Хранилище и вложения', icon: FileText, color: 'bg-slate-500' },
  { id: 'logs', title: 'История и логи', description: 'Действия и изменения', icon: Clock, color: 'bg-indigo-500' },
]

// ─── Helper Components ───────────────────────────────────────────────────────

function BackButton({ onClick }: { onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className="flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground mb-4 transition-colors duration-200"
    >
      <ChevronLeft className="h-4 w-4" />
      Назад
    </button>
  )
}

function SectionHeader({ icon: Icon, title, description, color }: { icon: LucideIcon; title: string; description: string; color: string }) {
  return (
    <div className="mb-6">
      <div className="flex items-center gap-3">
        <div className={`flex h-8 w-8 items-center justify-center rounded-lg ${color}`}>
          <Icon className="h-4 w-4 text-white" />
        </div>
        <div>
          <h2 className="text-lg font-semibold text-foreground">{title}</h2>
          <p className="text-sm text-muted-foreground">{description}</p>
        </div>
      </div>
    </div>
  )
}

function SettingRow({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div className="flex items-center justify-between py-3">
      <span className="text-sm text-foreground">{label}</span>
      <div className="flex items-center gap-2">{children}</div>
    </div>
  )
}

function LoadingSpinner() {
  return (
    <div className="flex items-center justify-center py-12">
      <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
      <span className="ml-2 text-sm text-muted-foreground">Загрузка...</span>
    </div>
  )
}

function ErrorMessage({ message }: { message: string }) {
  return (
    <div className="flex items-center gap-2 rounded-xl bg-destructive/10 text-destructive px-4 py-3 mb-4">
      <AlertCircle className="h-4 w-4 shrink-0" />
      <p className="text-sm">{message}</p>
    </div>
  )
}

// ─── 1. ПРОФИЛЬ ──────────────────────────────────────────────────────────────

function ProfileSection() {
  const currentUser = useAuthStore((s) => s.currentUser)
  const login = useAuthStore((s) => s.login)
  const logout = useAuthStore((s) => s.logout)

  const [name, setName] = useState(currentUser?.name ?? '')
  const [email, setEmail] = useState(currentUser?.email ?? '')
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  useEffect(() => {
    if (currentUser) {
      setName(currentUser.name)
      setEmail(currentUser.email)
    }
  }, [currentUser])

  const userInitials = name
    ? name.split(' ').map((n) => n[0]).join('').slice(0, 2).toUpperCase()
    : '??'

  const roleLabel: Record<string, string> = {
    admin: 'Администратор',
    manager: 'Менеджер',
    user: 'Пользователь',
  }

  const handleSave = async () => {
    if (!name.trim()) { setError('Имя не может быть пустым'); return }
    if (!email.trim()) { setError('Email не может быть пустым'); return }

    setSaving(true)
    setError('')
    setSuccess('')

    const { error: dbError } = await supabase
      .from('users')
      .update({ name: name.trim(), email: email.trim() })
      .eq('id', currentUser?.id)

    setSaving(false)

    if (dbError) {
      setError('Ошибка сохранения: ' + dbError.message)
      return
    }

    // Update Zustand store
    login({ ...currentUser!, name: name.trim(), email: email.trim() })
    setSuccess('Профиль обновлён')
    setTimeout(() => setSuccess(''), 3000)
  }

  if (!currentUser) return <LoadingSpinner />

  return (
    <>
      <SectionHeader icon={User} title="Профиль" description="Информация о вашем аккаунте" color="bg-gray-500" />

      {error && <ErrorMessage message={error} />}
      {success && (
        <div className="flex items-center gap-2 rounded-xl bg-emerald-500/10 text-emerald-600 px-4 py-3 mb-4">
          <p className="text-sm">{success}</p>
        </div>
      )}

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardContent className="p-5">
          <div className="flex items-center gap-4 mb-6">
            <Avatar className="h-16 w-16 ring-2 ring-primary/10">
              <AvatarFallback className="bg-primary text-primary-foreground text-xl font-semibold">
                {userInitials}
              </AvatarFallback>
            </Avatar>
            <div className="min-w-0 flex-1">
              <p className="text-base font-semibold text-foreground truncate">{name}</p>
              <div className="flex items-center gap-2 mt-1">
                <Mail className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
                <p className="text-sm text-muted-foreground truncate">{email}</p>
              </div>
              <Badge variant="secondary" className="mt-1.5 text-xs bg-primary/10 text-primary border-primary/20">
                {roleLabel[currentUser.role ?? ''] ?? currentUser.role}
              </Badge>
            </div>
          </div>

          <Separator className="my-4" />

          <div className="space-y-0">
            <SettingRow label="Имя">
              <Input
                value={name}
                onChange={(e) => { setName(e.target.value); setError('') }}
                className="max-w-[200px] h-9 text-sm rounded-lg"
                placeholder="Введите имя"
              />
            </SettingRow>
            <SettingRow label="Email">
              <Input
                value={email}
                onChange={(e) => { setEmail(e.target.value); setError('') }}
                className="max-w-[200px] h-9 text-sm rounded-lg"
                placeholder="Введите email"
              />
            </SettingRow>
            <SettingRow label="Роль">
              <Badge variant="secondary">{roleLabel[currentUser.role ?? ''] ?? '—'}</Badge>
            </SettingRow>
          </div>

          <Separator className="my-4" />

          <div className="flex gap-3">
            <Button
              onClick={handleSave}
              disabled={saving}
              className="flex-1 rounded-xl"
            >
              {saving && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Сохранить
            </Button>
            <Button
              variant="outline"
              className="rounded-xl text-destructive hover:text-destructive hover:bg-destructive/10 border-destructive/20"
              onClick={logout}
            >
              <LogOut className="mr-2 h-4 w-4" />
              Выйти
            </Button>
          </div>
        </CardContent>
      </Card>
    </>
  )
}

// ─── 2. ПОЛЬЗОВАТЕЛИ ─────────────────────────────────────────────────────────

function UsersSection() {
  const [users, setUsers] = useState<{ id: string; name: string; email: string; role: string }[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  // Dialog state
  const [dialogOpen, setDialogOpen] = useState(false)
  const [editingUser, setEditingUser] = useState<{ id: string; name: string; email: string; role: string } | null>(null)
  const [formName, setFormName] = useState('')
  const [formEmail, setFormEmail] = useState('')
  const [formRole, setFormRole] = useState('manager')
  const [saving, setSaving] = useState(false)

  const [initialized, setInitialized] = useState(false)

  if (!initialized) {
    setInitialized(true)
    supabase.from('users').select('*').then(({ data, error: err }) => {
      if (err) setError('Ошибка загрузки: ' + err.message)
      else setUsers(data ?? [])
      setLoading(false)
    })
  }

  const openAdd = () => {
    setEditingUser(null)
    setFormName('')
    setFormEmail('')
    setFormRole('manager')
    setError('')
    setDialogOpen(true)
  }

  const openEdit = (user: { id: string; name: string; email: string; role: string }) => {
    setEditingUser(user)
    setFormName(user.name)
    setFormEmail(user.email)
    setFormRole(user.role)
    setError('')
    setDialogOpen(true)
  }

  const handleSave = async () => {
    if (!formName.trim()) { setError('Имя не может быть пустым'); return }
    if (!formEmail.trim()) { setError('Email не может быть пустым'); return }

    setSaving(true)
    setError('')

    let dbError: any

    if (editingUser) {
      const res = await supabase.from('users').update({ name: formName.trim(), email: formEmail.trim(), role: formRole }).eq('id', editingUser.id)
      dbError = res.error
    } else {
      const res = await supabase.from('users').insert({ name: formName.trim(), email: formEmail.trim(), role: formRole })
      dbError = res.error
    }

    setSaving(false)

    if (dbError) {
      setError('Ошибка сохранения: ' + dbError.message)
      return
    }

    setDialogOpen(false)
    // Reload users
    supabase.from('users').select('*').order('name').then(({ data: d }) => {
      if (d) setUsers(d)
    })
  }

  const handleDelete = async (id: string) => {
    await supabase.from('users').delete().eq('id', id)
    supabase.from('users').select('*').order('name').then(({ data: d }) => {
      if (d) setUsers(d)
    })
  }

  return (
    <>
      <SectionHeader icon={Users} title="Пользователи и роли" description="Управление командой и доступом" color="bg-blue-500" />

      {error && <ErrorMessage message={error} />}

      <div className="flex items-center justify-between mb-4">
        <p className="text-sm text-muted-foreground">{users.length} пользователей</p>
        <Button size="sm" className="rounded-xl gap-1.5" onClick={openAdd}>
          <Plus className="h-3.5 w-3.5" />
          Добавить
        </Button>
      </div>

      {loading ? (
        <Card className="rounded-2xl border-border/60 shadow-sm"><CardContent className="p-8"><LoadingSpinner /></CardContent></Card>
      ) : (
        <Card className="rounded-2xl border-border/60 shadow-sm">
          <CardContent className="p-0">
            {users.length === 0 ? (
              <div className="p-6 text-center text-sm text-muted-foreground">Нет пользователей</div>
            ) : (
              users.map((user, i) => (
                <div key={user.id}>
                  {i > 0 && <Separator className="mx-5" />}
                  <div className="flex items-center gap-3 p-4">
                    <Avatar className="h-9 w-9">
                      <AvatarFallback className="bg-primary/10 text-primary text-xs font-medium">
                        {user.name.split(' ').map((n) => n[0]).join('').slice(0, 2)}
                      </AvatarFallback>
                    </Avatar>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm font-medium text-foreground truncate">{user.name}</p>
                      <p className="text-xs text-muted-foreground truncate">{user.email}</p>
                    </div>
                    <Badge variant="secondary" className={`text-xs shrink-0 ${user.role === 'admin' ? 'bg-primary/10 text-primary' : ''}`}>
                      {user.role === 'admin' ? 'Администратор' : 'Менеджер'}
                    </Badge>
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <button className="h-8 w-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                          <MoreHorizontal className="h-4 w-4" />
                        </button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem onClick={() => openEdit(user)}>
                          <Pencil className="mr-2 h-3.5 w-3.5" />
                          Редактировать
                        </DropdownMenuItem>
                        <AlertDialog>
                          <AlertDialogTrigger asChild>
                            <DropdownMenuItem className="text-destructive" onSelect={(e) => e.preventDefault()}>
                              <Trash2 className="mr-2 h-3.5 w-3.5" />
                              Удалить
                            </DropdownMenuItem>
                          </AlertDialogTrigger>
                          <AlertDialogContent>
                            <AlertDialogHeader>
                              <AlertDialogTitle>Удалить пользователя?</AlertDialogTitle>
                              <AlertDialogDescription>Это действие нельзя отменить. Пользователь «{user.name}» будет удалён.</AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                              <AlertDialogCancel>Отмена</AlertDialogCancel>
                              <AlertDialogAction onClick={() => handleDelete(user.id)} className="bg-destructive">Удалить</AlertDialogAction>
                            </AlertDialogFooter>
                          </AlertDialogContent>
                        </AlertDialog>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </div>
                </div>
              ))
            )}
          </CardContent>
        </Card>
      )}

      {/* Roles summary */}
      <Card className="rounded-2xl border-border/60 shadow-sm mt-4">
        <CardHeader className="pb-3">
          <CardTitle className="text-sm font-medium text-foreground">Роли и права</CardTitle>
        </CardHeader>
        <CardContent className="space-y-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Shield className="h-4 w-4 text-primary" />
              <span className="text-sm text-foreground">Администратор</span>
            </div>
            <span className="text-xs text-muted-foreground">Полный доступ</span>
          </div>
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <Shield className="h-4 w-4 text-muted-foreground" />
              <span className="text-sm text-foreground">Менеджер</span>
            </div>
            <span className="text-xs text-muted-foreground">Сделки, контакты, задачи</span>
          </div>
        </CardContent>
      </Card>

      {/* Add/Edit Dialog */}
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>{editingUser ? 'Редактировать пользователя' : 'Добавить пользователя'}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {error && <ErrorMessage message={error} />}
            <div className="space-y-2">
              <Label>Имя</Label>
              <Input value={formName} onChange={(e) => { setFormName(e.target.value); setError('') }} placeholder="Введите имя" />
            </div>
            <div className="space-y-2">
              <Label>Email</Label>
              <Input value={formEmail} onChange={(e) => { setFormEmail(e.target.value); setError('') }} placeholder="Введите email" type="email" />
            </div>
            <div className="space-y-2">
              <Label>Роль</Label>
              <Select value={formRole} onValueChange={setFormRole}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="admin">Администратор</SelectItem>
                  <SelectItem value="manager">Менеджер</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>Отмена</Button>
            <Button onClick={handleSave} disabled={saving || !formName.trim() || !formEmail.trim()}>
              {saving && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Сохранить
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  )
}

// ─── 3. CRM (Pipeline Stages) ────────────────────────────────────────────────

function CrmSection() {
  const PIPELINE_ID = '6cf3b065-4be3-4832-949d-4b036a19d6ab'
  const [stages, setStages] = useState<{ id: string; name: string; color: string; position: number; probability: number; is_won: boolean; is_closed: boolean }[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [dialogOpen, setDialogOpen] = useState(false)
  const [editingStage, setEditingStage] = useState<typeof stages[0] | null>(null)
  const [formName, setFormName] = useState('')
  const [formColor, setFormColor] = useState('#3b82f6')
  const [formPosition, setFormPosition] = useState(0)
  const [saving, setSaving] = useState(false)

  const [stagesInitialized, setStagesInitialized] = useState(false)

  if (!stagesInitialized) {
    setStagesInitialized(true)
    supabase
      .from('pipeline_stages')
      .select('*')
      .eq('pipeline_id', PIPELINE_ID)
      .order('position')
      .then(({ data, error: err }) => {
        if (err) setError('Ошибка загрузки: ' + err.message)
        else setStages(data ?? [])
        setLoading(false)
      })
  }

  const openAdd = () => {
    setEditingStage(null)
    setFormName('')
    setFormColor('#3b82f6')
    setFormPosition(stages.length + 1)
    setError('')
    setDialogOpen(true)
  }

  const openEdit = (stage: typeof stages[0]) => {
    setEditingStage(stage)
    setFormName(stage.name)
    setFormColor(stage.color)
    setFormPosition(stage.position)
    setError('')
    setDialogOpen(true)
  }

  const handleSave = async () => {
    if (!formName.trim()) { setError('Название не может быть пустым'); return }

    setSaving(true)
    setError('')

    let dbError: any

    if (editingStage) {
      const res = await supabase.from('pipeline_stages').update({
        name: formName.trim(),
        color: formColor,
        position: Number(formPosition),
      }).eq('id', editingStage.id)
      dbError = res.error
    } else {
      const res = await supabase.from('pipeline_stages').insert({
        pipeline_id: PIPELINE_ID,
        name: formName.trim(),
        color: formColor,
        position: Number(formPosition),
        probability: 0,
        is_won: false,
        is_closed: false,
      })
      dbError = res.error
    }

    setSaving(false)

    if (dbError) { setError('Ошибка сохранения: ' + dbError.message); return }

    setDialogOpen(false)
    // Reload stages
    supabase.from('pipeline_stages').select('*').eq('pipeline_id', PIPELINE_ID).order('position').then(({ data: d }) => {
      if (d) setStages(d)
    })
  }

  const handleDelete = async (id: string) => {
    await supabase.from('pipeline_stages').delete().eq('id', id)
    supabase.from('pipeline_stages').select('*').eq('pipeline_id', PIPELINE_ID).order('position').then(({ data: d }) => {
      if (d) setStages(d)
    })
  }

  return (
    <>
      <SectionHeader icon={Kanban} title="CRM" description="Сделки, воронки и этапы" color="bg-amber-500" />

      {error && <ErrorMessage message={error} />}

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <CardTitle className="text-sm font-medium text-foreground">Основная воронка</CardTitle>
            <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs text-muted-foreground" onClick={openAdd}>
              <Pencil className="h-3 w-3" />
              Изменить
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          {loading ? (
            <LoadingSpinner />
          ) : (
            <>
              <div className="space-y-2">
                {stages.map((stage) => (
                  <div key={stage.id} className="flex items-center gap-3 py-1.5">
                    <Circle className="h-3 w-3 shrink-0" style={{ color: stage.color, fill: stage.color }} />
                    <span className="text-sm text-foreground flex-1">{stage.name}</span>
                    <Badge variant="secondary" className="text-xs tabular-nums">0</Badge>
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <button className="h-7 w-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                          <MoreHorizontal className="h-3.5 w-3.5" />
                        </button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem onClick={() => openEdit(stage)}>
                          <Pencil className="mr-2 h-3.5 w-3.5" />
                          Редактировать
                        </DropdownMenuItem>
                        <AlertDialog>
                          <AlertDialogTrigger asChild>
                            <DropdownMenuItem className="text-destructive" onSelect={(e) => e.preventDefault()}>
                              <Trash2 className="mr-2 h-3.5 w-3.5" />
                              Удалить
                            </DropdownMenuItem>
                          </AlertDialogTrigger>
                          <AlertDialogContent>
                            <AlertDialogHeader>
                              <AlertDialogTitle>Удалить этап?</AlertDialogTitle>
                              <AlertDialogDescription>Это действие нельзя отменить. Этап «{stage.name}» будет удалён.</AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                              <AlertDialogCancel>Отмена</AlertDialogCancel>
                              <AlertDialogAction onClick={() => handleDelete(stage.id)} className="bg-destructive">Удалить</AlertDialogAction>
                            </AlertDialogFooter>
                          </AlertDialogContent>
                        </AlertDialog>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </div>
                ))}
                {stages.length === 0 && (
                  <p className="text-sm text-muted-foreground text-center py-4">Нет этапов</p>
                )}
              </div>
              <Separator className="my-3" />
              <Button variant="outline" size="sm" className="w-full rounded-xl text-xs gap-1.5" onClick={openAdd}>
                <Plus className="h-3 w-3" />
                Добавить этап
              </Button>
            </>
          )}
        </CardContent>
      </Card>

      {/* Add/Edit Stage Dialog */}
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>{editingStage ? 'Редактировать этап' : 'Добавить этап'}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {error && <ErrorMessage message={error} />}
            <div className="space-y-2">
              <Label>Название</Label>
              <Input value={formName} onChange={(e) => { setFormName(e.target.value); setError('') }} placeholder="Введите название" />
            </div>
            <div className="space-y-2">
              <Label>Цвет</Label>
              <div className="flex items-center gap-3">
                <input type="color" value={formColor} onChange={(e) => setFormColor(e.target.value)} className="h-9 w-14 rounded-lg cursor-pointer border-0" />
                <Input value={formColor} onChange={(e) => setFormColor(e.target.value)} className="flex-1" />
              </div>
            </div>
            <div className="space-y-2">
              <Label>Позиция</Label>
              <Input type="number" value={formPosition} onChange={(e) => setFormPosition(Number(e.target.value))} className="max-w-[120px]" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>Отмена</Button>
            <Button onClick={handleSave} disabled={saving || !formName.trim()}>
              {saving && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Сохранить
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  )
}

// ─── 4. КОНТАКТЫ (Custom Fields) ─────────────────────────────────────────────

function ContactsSection() {
  const [fields, setFields] = useState<CustomField[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [dialogOpen, setDialogOpen] = useState(false)
  const [editingField, setEditingField] = useState<CustomField | null>(null)
  const [formName, setFormName] = useState('')
  const [saving, setSaving] = useState(false)

  const [fieldsInitialized, setFieldsInitialized] = useState(false)

  if (!fieldsInitialized) {
    setFieldsInitialized(true)
    loadSettings<CustomField[]>('custom_fields', []).then((data) => {
      setFields(data)
      setLoading(false)
    })
  }

  const openAdd = () => {
    setEditingField(null)
    setFormName('')
    setError('')
    setDialogOpen(true)
  }

  const openEdit = (field: CustomField) => {
    setEditingField(field)
    setFormName(field.name)
    setError('')
    setDialogOpen(true)
  }

  const handleSave = async () => {
    if (!formName.trim()) { setError('Название не может быть пустым'); return }

    setSaving(true)
    setError('')

    let updated: CustomField[]
    if (editingField) {
      updated = fields.map((f) => f.id === editingField.id ? { ...f, name: formName.trim() } : f)
    } else {
      updated = [...fields, { id: crypto.randomUUID(), name: formName.trim(), type: 'text' }]
    }

    const ok = await saveSettings('custom_fields', updated)
    setSaving(false)

    if (!ok) { setError('Ошибка сохранения'); return }

    setFields(updated)
    setDialogOpen(false)
  }

  const handleDelete = async (id: string) => {
    const updated = fields.filter((f) => f.id !== id)
    await saveSettings('custom_fields', updated)
    setFields(updated)
  }

  return (
    <>
      <SectionHeader icon={Contact} title="Контакты и компании" description="Поля, теги и сегменты" color="bg-emerald-500" />

      {error && <ErrorMessage message={error} />}

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <CardTitle className="text-sm font-medium text-foreground">Пользовательские поля</CardTitle>
            <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs text-muted-foreground" onClick={openAdd}>
              <Plus className="h-3 w-3" />
              Добавить
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          {loading ? (
            <LoadingSpinner />
          ) : fields.length === 0 ? (
            <p className="text-sm text-muted-foreground text-center py-4">Нет пользовательских полей</p>
          ) : (
            <div className="space-y-0">
              {fields.map((field, i) => (
                <div key={field.id}>
                  {i > 0 && <Separator className="my-0" />}
                  <div className="flex items-center justify-between py-3">
                    <div>
                      <p className="text-sm text-foreground">{field.name}</p>
                      <p className="text-xs text-muted-foreground">{field.type === 'text' ? 'Текст' : field.type === 'number' ? 'Число' : 'Список'}</p>
                    </div>
                    <DropdownMenu>
                      <DropdownMenuTrigger asChild>
                        <button className="h-8 w-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                          <MoreHorizontal className="h-4 w-4" />
                        </button>
                      </DropdownMenuTrigger>
                      <DropdownMenuContent align="end">
                        <DropdownMenuItem onClick={() => openEdit(field)}>
                          <Pencil className="mr-2 h-3.5 w-3.5" />
                          Редактировать
                        </DropdownMenuItem>
                        <AlertDialog>
                          <AlertDialogTrigger asChild>
                            <DropdownMenuItem className="text-destructive" onSelect={(e) => e.preventDefault()}>
                              <Trash2 className="mr-2 h-3.5 w-3.5" />
                              Удалить
                            </DropdownMenuItem>
                          </AlertDialogTrigger>
                          <AlertDialogContent>
                            <AlertDialogHeader>
                              <AlertDialogTitle>Удалить поле?</AlertDialogTitle>
                              <AlertDialogDescription>Это действие нельзя отменить.</AlertDialogDescription>
                            </AlertDialogHeader>
                            <AlertDialogFooter>
                              <AlertDialogCancel>Отмена</AlertDialogCancel>
                              <AlertDialogAction onClick={() => handleDelete(field.id)} className="bg-destructive">Удалить</AlertDialogAction>
                            </AlertDialogFooter>
                          </AlertDialogContent>
                        </AlertDialog>
                      </DropdownMenuContent>
                    </DropdownMenu>
                  </div>
                </div>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Add/Edit Field Dialog */}
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>{editingField ? 'Редактировать поле' : 'Добавить поле'}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {error && <ErrorMessage message={error} />}
            <div className="space-y-2">
              <Label>Название</Label>
              <Input value={formName} onChange={(e) => { setFormName(e.target.value); setError('') }} placeholder="Введите название" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>Отмена</Button>
            <Button onClick={handleSave} disabled={saving || !formName.trim()}>
              {saving && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Сохранить
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  )
}

// ─── 5. ЗАДАЧИ (Task Settings) ───────────────────────────────────────────────

function TasksSection() {
  const [statuses, setStatuses] = useState<TaskStatus[]>([])
  const [priorities, setPriorities] = useState<TaskPriority[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  // Status dialog
  const [statusDialogOpen, setStatusDialogOpen] = useState(false)
  const [editingStatus, setEditingStatus] = useState<TaskStatus | null>(null)
  const [statusFormName, setStatusFormName] = useState('')
  const [statusFormColor, setStatusFormColor] = useState('#3b82f6')
  const [savingStatus, setSavingStatus] = useState(false)

  // Priority dialog
  const [priorityDialogOpen, setPriorityDialogOpen] = useState(false)
  const [editingPriority, setEditingPriority] = useState<TaskPriority | null>(null)
  const [priorityFormName, setPriorityFormName] = useState('')
  const [savingPriority, setSavingPriority] = useState(false)

  // Reminder toggle
  const [reminderOn, setReminderOn] = useState(true)

  const [tasksInitialized, setTasksInitialized] = useState(false)

  if (!tasksInitialized) {
    setTasksInitialized(true)
    Promise.all([
      loadSettings<TaskStatus[]>('task_statuses', DEFAULT_STATUSES),
      loadSettings<TaskPriority[]>('task_priorities', DEFAULT_PRIORITIES),
    ]).then(([s, p]) => {
      setStatuses(s)
      setPriorities(p)
      setLoading(false)
    })
  }

  // ── Status handlers ──
  const openAddStatus = () => {
    setEditingStatus(null)
    setStatusFormName('')
    setStatusFormColor('#3b82f6')
    setError('')
    setStatusDialogOpen(true)
  }

  const openEditStatus = (s: TaskStatus) => {
    setEditingStatus(s)
    setStatusFormName(s.name)
    setStatusFormColor(s.color)
    setError('')
    setStatusDialogOpen(true)
  }

  const handleSaveStatus = async () => {
    if (!statusFormName.trim()) { setError('Название не может быть пустым'); return }
    setSavingStatus(true)
    setError('')

    let updated: TaskStatus[]
    if (editingStatus) {
      updated = statuses.map((s) => s.id === editingStatus.id ? { ...s, name: statusFormName.trim(), color: statusFormColor } : s)
    } else {
      updated = [...statuses, { id: crypto.randomUUID(), name: statusFormName.trim(), color: statusFormColor }]
    }

    const ok = await saveSettings('task_statuses', updated)
    setSavingStatus(false)
    if (!ok) { setError('Ошибка сохранения'); return }
    setStatuses(updated)
    setStatusDialogOpen(false)
  }

  const handleDeleteStatus = async (id: string) => {
    const updated = statuses.filter((s) => s.id !== id)
    await saveSettings('task_statuses', updated)
    setStatuses(updated)
  }

  // ── Priority handlers ──
  const openAddPriority = () => {
    setEditingPriority(null)
    setPriorityFormName('')
    setError('')
    setPriorityDialogOpen(true)
  }

  const openEditPriority = (p: TaskPriority) => {
    setEditingPriority(p)
    setPriorityFormName(p.name)
    setError('')
    setPriorityDialogOpen(true)
  }

  const handleSavePriority = async () => {
    if (!priorityFormName.trim()) { setError('Название не может быть пустым'); return }
    setSavingPriority(true)
    setError('')

    let updated: TaskPriority[]
    if (editingPriority) {
      updated = priorities.map((p) => p.id === editingPriority.id ? { ...p, name: priorityFormName.trim() } : p)
    } else {
      updated = [...priorities, { id: crypto.randomUUID(), name: priorityFormName.trim() }]
    }

    const ok = await saveSettings('task_priorities', updated)
    setSavingPriority(false)
    if (!ok) { setError('Ошибка сохранения'); return }
    setPriorities(updated)
    setPriorityDialogOpen(false)
  }

  const handleDeletePriority = async (id: string) => {
    const updated = priorities.filter((p) => p.id !== id)
    await saveSettings('task_priorities', updated)
    setPriorities(updated)
  }

  const priorityColorMap: Record<string, string> = {
    'Высокий': 'bg-red-500/10 text-red-600 border-red-500/20',
    'Средний': 'bg-amber-500/10 text-amber-600 border-amber-500/20',
    'Низкий': 'bg-slate-500/10 text-slate-600 border-slate-500/20',
  }

  if (loading) {
    return (
      <>
        <SectionHeader icon={CheckSquare} title="Задачи" description="Статусы, приоритеты и сроки" color="bg-violet-500" />
        <Card className="rounded-2xl border-border/60 shadow-sm"><CardContent className="p-8"><LoadingSpinner /></CardContent></Card>
      </>
    )
  }

  return (
    <>
      <SectionHeader icon={CheckSquare} title="Задачи" description="Статусы, приоритеты и сроки" color="bg-violet-500" />

      {error && <ErrorMessage message={error} />}

      {/* Statuses */}
      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <CardTitle className="text-sm font-medium text-foreground">Статусы задач</CardTitle>
            <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs text-muted-foreground" onClick={openAddStatus}>
              <Plus className="h-3 w-3" />
              Добавить
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          <div className="space-y-0">
            {statuses.map((status, i) => (
              <div key={status.id}>
                {i > 0 && <Separator className="my-0" />}
                <div className="flex items-center gap-3 py-3">
                  <Circle className="h-3 w-3 shrink-0" style={{ color: status.color, fill: status.color }} />
                  <span className="text-sm text-foreground flex-1">{status.name}</span>
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <button className="h-8 w-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                        <MoreHorizontal className="h-4 w-4" />
                      </button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end">
                      <DropdownMenuItem onClick={() => openEditStatus(status)}>
                        <Pencil className="mr-2 h-3.5 w-3.5" />
                        Редактировать
                      </DropdownMenuItem>
                      <AlertDialog>
                        <AlertDialogTrigger asChild>
                          <DropdownMenuItem className="text-destructive" onSelect={(e) => e.preventDefault()}>
                            <Trash2 className="mr-2 h-3.5 w-3.5" />
                            Удалить
                          </DropdownMenuItem>
                        </AlertDialogTrigger>
                        <AlertDialogContent>
                          <AlertDialogHeader>
                            <AlertDialogTitle>Удалить статус?</AlertDialogTitle>
                            <AlertDialogDescription>Это действие нельзя отменить.</AlertDialogDescription>
                          </AlertDialogHeader>
                          <AlertDialogFooter>
                            <AlertDialogCancel>Отмена</AlertDialogCancel>
                            <AlertDialogAction onClick={() => handleDeleteStatus(status.id)} className="bg-destructive">Удалить</AlertDialogAction>
                          </AlertDialogFooter>
                        </AlertDialogContent>
                      </AlertDialog>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </div>
              </div>
            ))}
            {statuses.length === 0 && (
              <p className="text-sm text-muted-foreground text-center py-4">Нет статусов</p>
            )}
          </div>
        </CardContent>
      </Card>

      {/* Priorities */}
      <Card className="rounded-2xl border-border/60 shadow-sm mt-4">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <CardTitle className="text-sm font-medium text-foreground">Приоритеты</CardTitle>
            <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs text-muted-foreground" onClick={openAddPriority}>
              <Plus className="h-3 w-3" />
              Добавить
            </Button>
          </div>
        </CardHeader>
        <CardContent className="space-y-2">
          {priorities.map((p) => (
            <div key={p.id} className="flex items-center justify-between py-1">
              <Badge variant="outline" className={`text-xs border ${priorityColorMap[p.name] ?? 'bg-muted text-muted-foreground'}`}>{p.name}</Badge>
              <DropdownMenu>
                <DropdownMenuTrigger asChild>
                  <button className="h-7 w-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                    <Pencil className="h-3 w-3" />
                  </button>
                </DropdownMenuTrigger>
                <DropdownMenuContent align="end">
                  <DropdownMenuItem onClick={() => openEditPriority(p)}>
                    <Pencil className="mr-2 h-3.5 w-3.5" />
                    Редактировать
                  </DropdownMenuItem>
                  <AlertDialog>
                    <AlertDialogTrigger asChild>
                      <DropdownMenuItem className="text-destructive" onSelect={(e) => e.preventDefault()}>
                        <Trash2 className="mr-2 h-3.5 w-3.5" />
                        Удалить
                      </DropdownMenuItem>
                    </AlertDialogTrigger>
                    <AlertDialogContent>
                      <AlertDialogHeader>
                        <AlertDialogTitle>Удалить приоритет?</AlertDialogTitle>
                        <AlertDialogDescription>Это действие нельзя отменить.</AlertDialogDescription>
                      </AlertDialogHeader>
                      <AlertDialogFooter>
                        <AlertDialogCancel>Отмена</AlertDialogCancel>
                        <AlertDialogAction onClick={() => handleDeletePriority(p.id)} className="bg-destructive">Удалить</AlertDialogAction>
                      </AlertDialogFooter>
                    </AlertDialogContent>
                  </AlertDialog>
                </DropdownMenuContent>
              </DropdownMenu>
            </div>
          ))}
          {priorities.length === 0 && (
            <p className="text-sm text-muted-foreground text-center py-4">Нет приоритетов</p>
          )}
        </CardContent>
      </Card>

      {/* Reminder toggle */}
      <Card className="rounded-2xl border-border/60 shadow-sm mt-4">
        <CardContent className="p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-foreground">Напоминания о сроках</p>
              <p className="text-xs text-muted-foreground mt-0.5">Уведомлять за 1 день до дедлайна</p>
            </div>
            <Switch checked={reminderOn} onCheckedChange={setReminderOn} />
          </div>
        </CardContent>
      </Card>

      {/* Status Dialog */}
      <Dialog open={statusDialogOpen} onOpenChange={setStatusDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>{editingStatus ? 'Редактировать статус' : 'Добавить статус'}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {error && <ErrorMessage message={error} />}
            <div className="space-y-2">
              <Label>Название</Label>
              <Input value={statusFormName} onChange={(e) => { setStatusFormName(e.target.value); setError('') }} placeholder="Введите название" />
            </div>
            <div className="space-y-2">
              <Label>Цвет</Label>
              <div className="flex items-center gap-3">
                <input type="color" value={statusFormColor} onChange={(e) => setStatusFormColor(e.target.value)} className="h-9 w-14 rounded-lg cursor-pointer border-0" />
                <Input value={statusFormColor} onChange={(e) => setStatusFormColor(e.target.value)} className="flex-1" />
              </div>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setStatusDialogOpen(false)}>Отмена</Button>
            <Button onClick={handleSaveStatus} disabled={savingStatus || !statusFormName.trim()}>
              {savingStatus && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Сохранить
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Priority Dialog */}
      <Dialog open={priorityDialogOpen} onOpenChange={setPriorityDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>{editingPriority ? 'Редактировать приоритет' : 'Добавить приоритет'}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {error && <ErrorMessage message={error} />}
            <div className="space-y-2">
              <Label>Название</Label>
              <Input value={priorityFormName} onChange={(e) => { setPriorityFormName(e.target.value); setError('') }} placeholder="Введите название" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setPriorityDialogOpen(false)}>Отмена</Button>
            <Button onClick={handleSavePriority} disabled={savingPriority || !priorityFormName.trim()}>
              {savingPriority && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Сохранить
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  )
}

// ─── 6. АВТОМАТИЗАЦИЯ ─────────────────────────────────────────────────────────

function AutomationSection() {
  const [rules, setRules] = useState<AutomationRule[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [dialogOpen, setDialogOpen] = useState(false)
  const [formName, setFormName] = useState('')
  const [formTrigger, setFormTrigger] = useState('')
  const [formAction, setFormAction] = useState('')
  const [saving, setSaving] = useState(false)

  const [autoInitialized, setAutoInitialized] = useState(false)

  if (!autoInitialized) {
    setAutoInitialized(true)
    loadSettings<AutomationRule[]>('automation_rules', []).then((data) => {
      setRules(data)
      setLoading(false)
    })
  }

  const openAdd = () => {
    setFormName('')
    setFormTrigger('')
    setFormAction('')
    setError('')
    setDialogOpen(true)
  }

  const handleSave = async () => {
    if (!formName.trim()) { setError('Название не может быть пустым'); return }
    if (!formTrigger.trim()) { setError('Триггер не может быть пустым'); return }
    if (!formAction.trim()) { setError('Действие не может быть пустым'); return }

    setSaving(true)
    setError('')

    const updated = [...rules, {
      id: crypto.randomUUID(),
      name: formName.trim(),
      trigger: formTrigger.trim(),
      action: formAction.trim(),
      enabled: true,
    }]

    const ok = await saveSettings('automation_rules', updated)
    setSaving(false)
    if (!ok) { setError('Ошибка сохранения'); return }
    setRules(updated)
    setDialogOpen(false)
  }

  const handleToggle = async (id: string) => {
    const updated = rules.map((r) => r.id === id ? { ...r, enabled: !r.enabled } : r)
    setRules(updated)
    await saveSettings('automation_rules', updated)
  }

  const handleDelete = async (id: string) => {
    const updated = rules.filter((r) => r.id !== id)
    await saveSettings('automation_rules', updated)
    setRules(updated)
  }

  return (
    <>
      <SectionHeader icon={Zap} title="Автоматизация" description="Правила и триггеры" color="bg-orange-500" />

      {error && <ErrorMessage message={error} />}

      <div className="flex items-center justify-between mb-4">
        <p className="text-sm text-muted-foreground">{rules.length} правил</p>
        <Button size="sm" className="rounded-xl gap-1.5" onClick={openAdd}>
          <Plus className="h-3.5 w-3.5" />
          Новое правило
        </Button>
      </div>

      {loading ? (
        <Card className="rounded-2xl border-border/60 shadow-sm"><CardContent className="p-8"><LoadingSpinner /></CardContent></Card>
      ) : rules.length === 0 ? (
        <Card className="rounded-2xl border-border/60 shadow-sm">
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-muted">
                <Zap className="h-4 w-4 text-muted-foreground" />
              </div>
              <div className="flex-1">
                <p className="text-sm font-medium text-foreground">Создайте первое правило</p>
                <p className="text-xs text-muted-foreground">Автоматизируйте рутинные действия в CRM</p>
              </div>
            </div>
          </CardContent>
        </Card>
      ) : (
        <Card className="rounded-2xl border-border/60 shadow-sm">
          <CardContent className="p-0">
            {rules.map((rule, i) => (
              <div key={rule.id}>
                {i > 0 && <Separator className="mx-5" />}
                <div className="p-4">
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-2 flex-1 min-w-0">
                      <p className="text-sm font-medium text-foreground truncate">{rule.name}</p>
                      <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                          <button className="h-7 w-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200 shrink-0">
                            <MoreHorizontal className="h-3.5 w-3.5" />
                          </button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                          <AlertDialog>
                            <AlertDialogTrigger asChild>
                              <DropdownMenuItem className="text-destructive" onSelect={(e) => e.preventDefault()}>
                                <Trash2 className="mr-2 h-3.5 w-3.5" />
                                Удалить
                              </DropdownMenuItem>
                            </AlertDialogTrigger>
                            <AlertDialogContent>
                              <AlertDialogHeader>
                                <AlertDialogTitle>Удалить правило?</AlertDialogTitle>
                                <AlertDialogDescription>Это действие нельзя отменить.</AlertDialogDescription>
                              </AlertDialogHeader>
                              <AlertDialogFooter>
                                <AlertDialogCancel>Отмена</AlertDialogCancel>
                                <AlertDialogAction onClick={() => handleDelete(rule.id)} className="bg-destructive">Удалить</AlertDialogAction>
                              </AlertDialogFooter>
                            </AlertDialogContent>
                          </AlertDialog>
                        </DropdownMenuContent>
                      </DropdownMenu>
                    </div>
                    <Switch checked={rule.enabled} onCheckedChange={() => handleToggle(rule.id)} className="ml-2" />
                  </div>
                  <div className="flex items-center gap-2 text-xs text-muted-foreground">
                    <Badge variant="secondary" className="text-xs">{rule.trigger}</Badge>
                    <ArrowRight className="h-3 w-3" />
                    <span className="truncate">{rule.action}</span>
                  </div>
                </div>
              </div>
            ))}
          </CardContent>
        </Card>
      )}

      {/* Add Rule Dialog */}
      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Новое правило</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {error && <ErrorMessage message={error} />}
            <div className="space-y-2">
              <Label>Название</Label>
              <Input value={formName} onChange={(e) => { setFormName(e.target.value); setError('') }} placeholder="Введите название" />
            </div>
            <div className="space-y-2">
              <Label>Триггер</Label>
              <Input value={formTrigger} onChange={(e) => { setFormTrigger(e.target.value); setError('') }} placeholder="Когда произойдёт" />
            </div>
            <div className="space-y-2">
              <Label>Действие</Label>
              <Input value={formAction} onChange={(e) => { setFormAction(e.target.value); setError('') }} placeholder="Что сделать" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>Отмена</Button>
            <Button onClick={handleSave} disabled={saving || !formName.trim() || !formTrigger.trim() || !formAction.trim()}>
              {saving && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Создать
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  )
}

// ─── 7. УВЕДОМЛЕНИЯ ───────────────────────────────────────────────────────────

function NotificationsSection() {
  const [notifications, setNotifications] = useState<NotificationItem[]>([])
  const [dndMode, setDndMode] = useState(false)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [notifInitialized, setNotifInitialized] = useState(false)

  if (!notifInitialized) {
    setNotifInitialized(true)
    loadSettings<NotificationItem[]>('notifications', DEFAULT_NOTIFICATIONS).then((data) => {
      setNotifications(data)
      setLoading(false)
    })
  }

  const handleToggle = async (id: string) => {
    const updated = notifications.map((n) => n.id === id ? { ...n, enabled: !n.enabled } : n)
    setNotifications(updated)
    await saveSettings('notifications', updated)
  }

  const handleDndToggle = async (enabled: boolean) => {
    setDndMode(enabled)
  }

  if (loading) {
    return (
      <>
        <SectionHeader icon={Bell} title="Уведомления" description="События и каналы оповещения" color="bg-pink-500" />
        <Card className="rounded-2xl border-border/60 shadow-sm"><CardContent className="p-8"><LoadingSpinner /></CardContent></Card>
      </>
    )
  }

  return (
    <>
      <SectionHeader icon={Bell} title="Уведомления" description="События и каналы оповещения" color="bg-pink-500" />

      {error && <ErrorMessage message={error} />}

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardHeader className="pb-3">
          <CardTitle className="text-sm font-medium text-foreground">События</CardTitle>
          <CardDescription className="text-xs">Настройте, о каких событиях уведомлять</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-0">
            {notifications.map((notif, i) => (
              <div key={notif.id}>
                {i > 0 && <Separator className="my-0" />}
                <div className="flex items-center justify-between py-3">
                  <div>
                    <p className="text-sm text-foreground">{notif.event}</p>
                    <p className="text-xs text-muted-foreground">{notif.channel}</p>
                  </div>
                  <Switch checked={notif.enabled} onCheckedChange={() => handleToggle(notif.id)} />
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      <Card className="rounded-2xl border-border/60 shadow-sm mt-4">
        <CardContent className="p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-foreground">Режим «Не беспокоить»</p>
              <p className="text-xs text-muted-foreground mt-0.5">Отключить все уведомления</p>
            </div>
            <Switch checked={dndMode} onCheckedChange={handleDndToggle} />
          </div>
        </CardContent>
      </Card>
    </>
  )
}

// ─── 8. ТЕГИ И СЕГМЕНТЫ ──────────────────────────────────────────────────────

function TagsSection() {
  const [tags, setTags] = useState<TagItem[]>([])
  const [segments, setSegments] = useState<SegmentItem[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  // Tag dialog
  const [tagDialogOpen, setTagDialogOpen] = useState(false)
  const [editingTag, setEditingTag] = useState<TagItem | null>(null)
  const [tagName, setTagName] = useState('')
  const [tagColor, setTagColor] = useState('#3b82f6')
  const [savingTag, setSavingTag] = useState(false)

  // Segment dialog
  const [segmentDialogOpen, setSegmentDialogOpen] = useState(false)
  const [editingSegment, setEditingSegment] = useState<SegmentItem | null>(null)
  const [segmentName, setSegmentName] = useState('')
  const [savingSegment, setSavingSegment] = useState(false)

  const [tagsInitialized, setTagsInitialized] = useState(false)

  if (!tagsInitialized) {
    setTagsInitialized(true)
    Promise.all([
      loadSettings<TagItem[]>('tags', []),
      loadSettings<SegmentItem[]>('segments', []),
    ]).then(([t, s]) => {
      setTags(t)
      setSegments(s)
      setLoading(false)
    })
  }

  // ── Tag handlers ──
  const openAddTag = () => {
    setEditingTag(null)
    setTagName('')
    setTagColor('#3b82f6')
    setError('')
    setTagDialogOpen(true)
  }

  const openEditTag = (t: TagItem) => {
    setEditingTag(t)
    setTagName(t.name)
    setTagColor(t.color)
    setError('')
    setTagDialogOpen(true)
  }

  const handleSaveTag = async () => {
    if (!tagName.trim()) { setError('Название не может быть пустым'); return }
    setSavingTag(true)
    setError('')

    let updated: TagItem[]
    if (editingTag) {
      updated = tags.map((t) => t.id === editingTag.id ? { ...t, name: tagName.trim(), color: tagColor } : t)
    } else {
      updated = [...tags, { id: crypto.randomUUID(), name: tagName.trim(), color: tagColor }]
    }

    const ok = await saveSettings('tags', updated)
    setSavingTag(false)
    if (!ok) { setError('Ошибка сохранения'); return }
    setTags(updated)
    setTagDialogOpen(false)
  }

  const handleDeleteTag = async (id: string) => {
    const updated = tags.filter((t) => t.id !== id)
    await saveSettings('tags', updated)
    setTags(updated)
  }

  // ── Segment handlers ──
  const openAddSegment = () => {
    setEditingSegment(null)
    setSegmentName('')
    setError('')
    setSegmentDialogOpen(true)
  }

  const openEditSegment = (s: SegmentItem) => {
    setEditingSegment(s)
    setSegmentName(s.name)
    setError('')
    setSegmentDialogOpen(true)
  }

  const handleSaveSegment = async () => {
    if (!segmentName.trim()) { setError('Название не может быть пустым'); return }
    setSavingSegment(true)
    setError('')

    let updated: SegmentItem[]
    if (editingSegment) {
      updated = segments.map((s) => s.id === editingSegment.id ? { ...s, name: segmentName.trim() } : s)
    } else {
      updated = [...segments, { id: crypto.randomUUID(), name: segmentName.trim() }]
    }

    const ok = await saveSettings('segments', updated)
    setSavingSegment(false)
    if (!ok) { setError('Ошибка сохранения'); return }
    setSegments(updated)
    setSegmentDialogOpen(false)
  }

  const handleDeleteSegment = async (id: string) => {
    const updated = segments.filter((s) => s.id !== id)
    await saveSettings('segments', updated)
    setSegments(updated)
  }

  if (loading) {
    return (
      <>
        <SectionHeader icon={Tag} title="Теги и сегменты" description="Категоризация клиентов" color="bg-cyan-500" />
        <Card className="rounded-2xl border-border/60 shadow-sm"><CardContent className="p-8"><LoadingSpinner /></CardContent></Card>
      </>
    )
  }

  return (
    <>
      <SectionHeader icon={Tag} title="Теги и сегменты" description="Категоризация клиентов" color="bg-cyan-500" />

      {error && <ErrorMessage message={error} />}

      {/* Tags */}
      <div className="flex items-center justify-between mb-3">
        <p className="text-sm font-medium text-foreground">Теги</p>
        <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs text-muted-foreground" onClick={openAddTag}>
          <Plus className="h-3 w-3" />
          Добавить
        </Button>
      </div>
      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardContent className="p-0">
          {tags.length === 0 ? (
            <div className="p-6 text-center text-sm text-muted-foreground">Нет тегов</div>
          ) : (
            tags.map((tag, i) => (
              <div key={tag.id}>
                {i > 0 && <Separator className="mx-5" />}
                <div className="flex items-center gap-3 p-3.5">
                  <Circle className="h-3.5 w-3.5 shrink-0" style={{ color: tag.color, fill: tag.color }} />
                  <span className="text-sm text-foreground flex-1">{tag.name}</span>
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <button className="h-7 w-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                        <MoreHorizontal className="h-3.5 w-3.5" />
                      </button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end">
                      <DropdownMenuItem onClick={() => openEditTag(tag)}>
                        <Pencil className="mr-2 h-3.5 w-3.5" />
                        Редактировать
                      </DropdownMenuItem>
                      <AlertDialog>
                        <AlertDialogTrigger asChild>
                          <DropdownMenuItem className="text-destructive" onSelect={(e) => e.preventDefault()}>
                            <Trash2 className="mr-2 h-3.5 w-3.5" />
                            Удалить
                          </DropdownMenuItem>
                        </AlertDialogTrigger>
                        <AlertDialogContent>
                          <AlertDialogHeader>
                            <AlertDialogTitle>Удалить тег?</AlertDialogTitle>
                            <AlertDialogDescription>Это действие нельзя отменить.</AlertDialogDescription>
                          </AlertDialogHeader>
                          <AlertDialogFooter>
                            <AlertDialogCancel>Отмена</AlertDialogCancel>
                            <AlertDialogAction onClick={() => handleDeleteTag(tag.id)} className="bg-destructive">Удалить</AlertDialogAction>
                          </AlertDialogFooter>
                        </AlertDialogContent>
                      </AlertDialog>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </div>
              </div>
            ))
          )}
        </CardContent>
      </Card>

      {/* Segments */}
      <div className="flex items-center justify-between mb-3 mt-5">
        <p className="text-sm font-medium text-foreground">Сегменты</p>
        <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs text-muted-foreground" onClick={openAddSegment}>
          <Plus className="h-3 w-3" />
          Создать
        </Button>
      </div>
      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardContent className="p-0">
          {segments.length === 0 ? (
            <div className="p-6 text-center text-sm text-muted-foreground">Нет сегментов</div>
          ) : (
            segments.map((seg, i) => (
              <div key={seg.id}>
                {i > 0 && <Separator className="mx-5" />}
                <div className="flex items-center gap-3 p-3.5">
                  <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-muted">
                    <Users className="h-3.5 w-3.5 text-muted-foreground" />
                  </div>
                  <span className="text-sm text-foreground flex-1">{seg.name}</span>
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <button className="h-7 w-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                        <MoreHorizontal className="h-3.5 w-3.5" />
                      </button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end">
                      <DropdownMenuItem onClick={() => openEditSegment(seg)}>
                        <Pencil className="mr-2 h-3.5 w-3.5" />
                        Редактировать
                      </DropdownMenuItem>
                      <AlertDialog>
                        <AlertDialogTrigger asChild>
                          <DropdownMenuItem className="text-destructive" onSelect={(e) => e.preventDefault()}>
                            <Trash2 className="mr-2 h-3.5 w-3.5" />
                            Удалить
                          </DropdownMenuItem>
                        </AlertDialogTrigger>
                        <AlertDialogContent>
                          <AlertDialogHeader>
                            <AlertDialogTitle>Удалить сегмент?</AlertDialogTitle>
                            <AlertDialogDescription>Это действие нельзя отменить.</AlertDialogDescription>
                          </AlertDialogHeader>
                          <AlertDialogFooter>
                            <AlertDialogCancel>Отмена</AlertDialogCancel>
                            <AlertDialogAction onClick={() => handleDeleteSegment(seg.id)} className="bg-destructive">Удалить</AlertDialogAction>
                          </AlertDialogFooter>
                        </AlertDialogContent>
                      </AlertDialog>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </div>
              </div>
            ))
          )}
        </CardContent>
      </Card>

      {/* Tag Dialog */}
      <Dialog open={tagDialogOpen} onOpenChange={setTagDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>{editingTag ? 'Редактировать тег' : 'Добавить тег'}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {error && <ErrorMessage message={error} />}
            <div className="space-y-2">
              <Label>Название</Label>
              <Input value={tagName} onChange={(e) => { setTagName(e.target.value); setError('') }} placeholder="Введите название" />
            </div>
            <div className="space-y-2">
              <Label>Цвет</Label>
              <div className="flex items-center gap-3">
                <input type="color" value={tagColor} onChange={(e) => setTagColor(e.target.value)} className="h-9 w-14 rounded-lg cursor-pointer border-0" />
                <Input value={tagColor} onChange={(e) => setTagColor(e.target.value)} className="flex-1" />
              </div>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setTagDialogOpen(false)}>Отмена</Button>
            <Button onClick={handleSaveTag} disabled={savingTag || !tagName.trim()}>
              {savingTag && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Сохранить
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Segment Dialog */}
      <Dialog open={segmentDialogOpen} onOpenChange={setSegmentDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>{editingSegment ? 'Редактировать сегмент' : 'Создать сегмент'}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {error && <ErrorMessage message={error} />}
            <div className="space-y-2">
              <Label>Название</Label>
              <Input value={segmentName} onChange={(e) => { setSegmentName(e.target.value); setError('') }} placeholder="Введите название" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setSegmentDialogOpen(false)}>Отмена</Button>
            <Button onClick={handleSaveSegment} disabled={savingSegment || !segmentName.trim()}>
              {savingSegment && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Сохранить
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </>
  )
}

// ─── 9. ФАЙЛЫ ─────────────────────────────────────────────────────────────────

function FilesSection() {
  const [files, setFiles] = useState<FileMeta[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')
  const [uploading, setUploading] = useState(false)
  const fileInputRef = useRef<HTMLInputElement>(null)

  const [filesInitialized, setFilesInitialized] = useState(false)

  if (!filesInitialized) {
    setFilesInitialized(true)
    loadSettings<FileMeta[]>('files_metadata', []).then((data) => {
      setFiles(data)
      setLoading(false)
    })
  }

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFiles = e.target.files
    if (!selectedFiles || selectedFiles.length === 0) return

    setUploading(true)
    setError('')

    const newFiles: FileMeta[] = []

    for (const file of Array.from(selectedFiles)) {
      try {
        const base64 = await new Promise<string>((resolve, reject) => {
          const reader = new FileReader()
          reader.onload = () => resolve(reader.result as string)
          reader.onerror = reject
          reader.readAsDataURL(file)
        })

        newFiles.push({
          id: crypto.randomUUID(),
          name: file.name,
          size: formatFileSize(file.size),
          type: file.type || 'application/octet-stream',
          data: base64,
          uploaded_at: new Date().toISOString(),
        })
      } catch {
        setError('Ошибка чтения файла: ' + file.name)
      }
    }

    if (newFiles.length > 0) {
      const updated = [...files, ...newFiles]
      const ok = await saveSettings('files_metadata', updated)
      if (ok) setFiles(updated)
      else setError('Ошибка сохранения файлов')
    }

    setUploading(false)
    // Reset input
    if (fileInputRef.current) fileInputRef.current.value = ''
  }

  const handleDelete = async (id: string) => {
    const updated = files.filter((f) => f.id !== id)
    const ok = await saveSettings('files_metadata', updated)
    if (ok) setFiles(updated)
    else setError('Ошибка удаления файла')
  }

  // Calculate total storage
  const totalSize = files.reduce((acc, f) => {
    // Try to estimate bytes from the base64 string
    const base64Length = f.data.length - (f.data.indexOf(',') + 1)
    return acc + Math.floor(base64Length * 3 / 4)
  }, 0)

  const storagePercent = Math.min((totalSize / (1024 * 1024 * 1024)) * 100, 100)
  const storageMB = (totalSize / (1024 * 1024)).toFixed(1)

  return (
    <>
      <SectionHeader icon={FileText} title="Файлы" description="Хранилище и вложения" color="bg-slate-500" />

      {error && <ErrorMessage message={error} />}

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardContent className="p-5">
          <div
            className="flex flex-col items-center justify-center py-8 border-2 border-dashed border-border/60 rounded-xl cursor-pointer hover:bg-muted/30 transition-colors"
            onClick={() => fileInputRef.current?.click()}
          >
            {uploading ? (
              <Loader2 className="h-6 w-6 animate-spin text-muted-foreground mb-3" />
            ) : (
              <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-muted mb-3">
                <Upload className="h-6 w-6 text-muted-foreground" />
              </div>
            )}
            <p className="text-sm font-medium text-foreground">
              {uploading ? 'Загрузка...' : 'Загрузить файл'}
            </p>
            <p className="text-xs text-muted-foreground mt-1">Перетащите или нажмите для выбора</p>
            <input
              ref={fileInputRef}
              type="file"
              accept="*/*"
              multiple
              className="hidden"
              onChange={handleFileUpload}
            />
          </div>
        </CardContent>
      </Card>

      {loading ? (
        <Card className="rounded-2xl border-border/60 shadow-sm mt-4"><CardContent className="p-8"><LoadingSpinner /></CardContent></Card>
      ) : files.length > 0 ? (
        <Card className="rounded-2xl border-border/60 shadow-sm mt-4">
          <CardHeader className="pb-3">
            <CardTitle className="text-sm font-medium text-foreground">Загруженные файлы</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-0">
              {files.map((file, i) => (
                <div key={file.id}>
                  {i > 0 && <Separator className="my-0" />}
                  <div className="flex items-center gap-3 py-3">
                    <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-muted shrink-0">
                      <FileText className="h-4 w-4 text-muted-foreground" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-sm text-foreground truncate">{file.name}</p>
                      <p className="text-xs text-muted-foreground">{file.size} · {new Date(file.uploaded_at).toLocaleDateString('ru-RU')}</p>
                    </div>
                    <AlertDialog>
                      <AlertDialogTrigger asChild>
                        <button className="h-7 w-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors duration-200">
                          <Trash2 className="h-3.5 w-3.5" />
                        </button>
                      </AlertDialogTrigger>
                      <AlertDialogContent>
                        <AlertDialogHeader>
                          <AlertDialogTitle>Удалить файл?</AlertDialogTitle>
                          <AlertDialogDescription>Файл «{file.name}» будет удалён навсегда.</AlertDialogDescription>
                        </AlertDialogHeader>
                        <AlertDialogFooter>
                          <AlertDialogCancel>Отмена</AlertDialogCancel>
                          <AlertDialogAction onClick={() => handleDelete(file.id)} className="bg-destructive">Удалить</AlertDialogAction>
                        </AlertDialogFooter>
                      </AlertDialogContent>
                    </AlertDialog>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      ) : null}

      {/* Storage usage */}
      <Card className="rounded-2xl border-border/60 shadow-sm mt-4">
        <CardContent className="p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-foreground">Использовано хранилища</p>
              <p className="text-xs text-muted-foreground mt-0.5">{storageMB} МБ из 1 ГБ</p>
            </div>
            <Badge variant="secondary" className="text-xs">{storagePercent.toFixed(1)}%</Badge>
          </div>
          <div className="mt-3 h-2 bg-muted rounded-full overflow-hidden">
            <div className="h-full bg-primary rounded-full transition-all duration-300" style={{ width: `${Math.max(storagePercent, 0.5)}%` }} />
          </div>
        </CardContent>
      </Card>
    </>
  )
}

// ─── 10. ИСТОРИЯ (Logs) ──────────────────────────────────────────────────────

function LogsSection() {
  const [logs, setLogs] = useState<{ id: string; action: string; user_id: string | null; created_at: string; entity_type: string | null; entity_id: string | null; user_name?: string }[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  const [logsInitialized, setLogsInitialized] = useState(false)

  const loadLogs = async () => {
    setLoading(true)
    const { data, error: err } = await supabase
      .from('activities')
      .select('*')
      .neq('entity_type', 'settings_v1')
      .order('created_at', { ascending: false })
      .limit(20)

    if (err) {
      setError('Ошибка загрузки: ' + err.message)
      setLoading(false)
      return
    }

    // Resolve user names
    const userIds = [...new Set((data ?? []).map((d) => d.user_id).filter(Boolean))] as string[]
    let userMap: Record<string, string> = {}

    if (userIds.length > 0) {
      const { data: users } = await supabase.from('users').select('id, name').in('id', userIds)
      if (users) {
        userMap = Object.fromEntries(users.map((u) => [u.id, u.name]))
      }
    }

    const enriched = (data ?? []).map((log) => ({
      ...log,
      user_name: log.user_id ? userMap[log.user_id] ?? 'Неизвестный' : 'Система',
    }))

    setLogs(enriched)
    setLoading(false)
  }

  if (!logsInitialized) {
    setLogsInitialized(true)
    loadLogs()
  }

  return (
    <>
      <SectionHeader icon={Clock} title="История и логи" description="Действия и изменения" color="bg-indigo-500" />

      {error && <ErrorMessage message={error} />}

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <CardTitle className="text-sm font-medium text-foreground">Последние действия</CardTitle>
            <button
              className="h-8 w-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200"
              onClick={loadLogs}
            >
              <Search className="h-4 w-4" />
            </button>
          </div>
        </CardHeader>
        <CardContent className="p-0">
          {loading ? (
            <div className="p-8"><LoadingSpinner /></div>
          ) : logs.length === 0 ? (
            <div className="p-6 text-center text-sm text-muted-foreground">Нет записей</div>
          ) : (
            logs.map((log, i) => (
              <div key={log.id}>
                {i > 0 && <Separator className="mx-5" />}
                <div className="flex items-start gap-3 p-4">
                  <Avatar className="h-7 w-7 mt-0.5 shrink-0">
                    <AvatarFallback className="bg-muted text-muted-foreground text-[10px]">
                      {log.user_name?.split(' ').map((n) => n[0]).join('').slice(0, 2) ?? '??'}
                    </AvatarFallback>
                  </Avatar>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm text-foreground">{log.action}</p>
                    <p className="text-xs text-muted-foreground mt-0.5">
                      {log.user_name} · {new Date(log.created_at).toLocaleDateString('ru-RU')}
                    </p>
                  </div>
                </div>
              </div>
            ))
          )}
        </CardContent>
      </Card>
    </>
  )
}

// ─── Utility ─────────────────────────────────────────────────────────────────

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return bytes + ' Б'
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' КБ'
  return (bytes / (1024 * 1024)).toFixed(1) + ' МБ'
}

// ─── Section Router ──────────────────────────────────────────────────────────

function SectionContent({ section }: { section: SettingsSection }) {
  switch (section) {
    case 'profile': return <ProfileSection />
    case 'users': return <UsersSection />
    case 'crm': return <CrmSection />
    case 'contacts': return <ContactsSection />
    case 'tasks': return <TasksSection />
    case 'automation': return <AutomationSection />
    case 'notifications': return <NotificationsSection />
    case 'tags': return <TagsSection />
    case 'files': return <FilesSection />
    case 'logs': return <LogsSection />
    default: return null
  }
}

// ─── Main Settings Page ──────────────────────────────────────────────────────

export function SettingsPage() {
  const [activeSection, setActiveSection] = useState<SettingsSection>('main')

  // Category list view
  if (activeSection === 'main') {
    return (
      <div className="space-y-3 max-w-2xl">
        {CATEGORIES.map((cat) => {
          const Icon = cat.icon
          return (
            <button
              key={cat.id}
              onClick={() => setActiveSection(cat.id)}
              className="w-full text-left"
            >
              <Card className="rounded-2xl border-border/60 shadow-sm transition-shadow duration-200 hover:shadow-md py-0 overflow-hidden">
                <CardContent className="flex items-center gap-3.5 p-4">
                  <div className={`flex h-9 w-9 items-center justify-center rounded-xl ${cat.color} shrink-0`}>
                    <Icon className="h-4.5 w-4.5 text-white" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium text-foreground">{cat.title}</p>
                    <p className="text-xs text-muted-foreground mt-0.5">{cat.description}</p>
                  </div>
                  <ChevronRight className="h-4 w-4 text-muted-foreground shrink-0" />
                </CardContent>
              </Card>
            </button>
          )
        })}
      </div>
    )
  }

  // Sub-section detail view
  const currentCategory = CATEGORIES.find((c) => c.id === activeSection)

  return (
    <div className="space-y-4 max-w-2xl">
      <BackButton onClick={() => setActiveSection('main')} />
      {currentCategory && (
        <SectionContent key={activeSection} section={activeSection} />
      )}
    </div>
  )
}
