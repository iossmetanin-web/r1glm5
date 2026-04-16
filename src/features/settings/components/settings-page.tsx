'use client'

import { useState } from 'react'
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
} from 'lucide-react'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { Input } from '@/components/ui/input'
import { Switch } from '@/components/ui/switch'
import { Label } from '@/components/ui/label'
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
  badge?: string
}

// ─── Data ────────────────────────────────────────────────────────────────────

const CATEGORIES: CategoryItem[] = [
  { id: 'profile', title: 'Профиль', description: 'Имя, email, роль и аватар', icon: User, color: 'bg-gray-500' },
  { id: 'users', title: 'Пользователи и роли', description: 'Управление командой и доступом', icon: Users, color: 'bg-blue-500', badge: '3' },
  { id: 'crm', title: 'CRM', description: 'Сделки, воронки и этапы', icon: Kanban, color: 'bg-amber-500' },
  { id: 'contacts', title: 'Контакты и компании', description: 'Поля, теги и сегменты', icon: Contact, color: 'bg-emerald-500' },
  { id: 'tasks', title: 'Задачи', description: 'Статусы, приоритеты и сроки', icon: CheckSquare, color: 'bg-violet-500' },
  { id: 'automation', title: 'Автоматизация', description: 'Правила и триггеры', icon: Zap, color: 'bg-orange-500' },
  { id: 'notifications', title: 'Уведомления', description: 'События и каналы оповещения', icon: Bell, color: 'bg-pink-500' },
  { id: 'tags', title: 'Теги и сегменты', description: 'Категоризация клиентов', icon: Tag, color: 'bg-cyan-500' },
  { id: 'files', title: 'Файлы', description: 'Хранилище и вложения', icon: FileText, color: 'bg-slate-500' },
  { id: 'logs', title: 'История и логи', description: 'Действия и изменения', icon: Clock, color: 'bg-indigo-500' },
]

// ─── Mock Data (UI only) ────────────────────────────────────────────────────

const MOCK_USERS = [
  { id: '1', name: 'Иван Петров', email: 'ivan@company.ru', role: 'admin' as const },
  { id: '2', name: 'Анна Сидорова', email: 'anna@company.ru', role: 'manager' as const },
  { id: '3', name: 'Дмитрий Козлов', email: 'dmitry@company.ru', role: 'manager' as const },
]

const MOCK_PIPELINES = [
  {
    id: '1',
    name: 'Основная воронка',
    stages: [
      { id: 's1', name: 'Новая заявка', color: '#94a3b8', count: 5 },
      { id: 's2', name: 'Квалификация', color: '#3b82f6', count: 3 },
      { id: 's3', name: 'Переговоры', color: '#f59e0b', count: 2 },
      { id: 's4', name: 'Договор', color: '#10b981', count: 1 },
      { id: 's5', name: 'Успешно', color: '#22c55e', count: 8 },
      { id: 's6', name: 'Проиграно', color: '#ef4444', count: 2 },
    ],
  },
]

const MOCK_CUSTOM_FIELDS = [
  { id: 'f1', name: 'Источник', type: 'select' },
  { id: 'f2', name: 'Компания', type: 'text' },
  { id: 'f3', name: 'Бюджет', type: 'number' },
]

const MOCK_TASK_STATUSES = [
  { id: 'ts1', name: 'К выполнению', color: '#94a3b8' },
  { id: 'ts2', name: 'В работе', color: '#3b82f6' },
  { id: 'ts3', name: 'На проверке', color: '#f59e0b' },
  { id: 'ts4', name: 'Выполнено', color: '#22c55e' },
]

const MOCK_AUTOMATION_RULES = [
  { id: 'a1', name: 'Новая сделка → задача', trigger: 'Новая заявка', action: 'Создать задачу «Связаться»', enabled: true },
  { id: 'a2', name: 'Сделка выиграна → уведомление', trigger: 'Успешно', action: 'Уведомить менеджера', enabled: true },
  { id: 'a3', name: 'Просрочка → напоминание', trigger: 'Просрочен срок', action: 'Отправить напоминание', enabled: false },
]

const MOCK_NOTIFICATIONS = [
  { id: 'n1', event: 'Новая сделка', channel: 'Push', enabled: true },
  { id: 'n2', event: 'Сделка перемещена', channel: 'Push', enabled: true },
  { id: 'n3', event: 'Просрочка задачи', channel: 'Email', enabled: true },
  { id: 'n4', event: 'Новый комментарий', channel: 'Push', enabled: false },
  { id: 'n5', event: 'Ежедневный отчёт', channel: 'Email', enabled: true },
]

const MOCK_TAGS = [
  { id: 't1', name: 'VIP', color: '#f59e0b', count: 12 },
  { id: 't2', name: 'B2B', color: '#3b82f6', count: 34 },
  { id: 't3', name: 'B2C', color: '#8b5cf6', count: 28 },
  { id: 't4', name: 'Потенциальный', color: '#10b981', count: 15 },
  { id: 't5', name: 'Холодный', color: '#94a3b8', count: 7 },
]

const MOCK_SEGMENTS = [
  { id: 'seg1', name: 'Активные клиенты', count: 45 },
  { id: 'seg2', name: 'Неактивные 30 дней', count: 12 },
  { id: 'seg3', name: 'Крупные сделки', count: 8 },
]

const MOCK_LOGS = [
  { id: 'l1', user: 'Иван Петров', action: 'Создал сделку «Реклама 2025»', time: '10 мин назад' },
  { id: 'l2', user: 'Анна Сидорова', action: 'Переместила сделку в «Переговоры»', time: '25 мин назад' },
  { id: 'l3', user: 'Дмитрий Козлов', action: 'Выполнил задачу «Подготовить КП»', time: '1 час назад' },
  { id: 'l4', user: 'Иван Петров', action: 'Добавил контакт «ООО Альфа»', time: '2 часа назад' },
  { id: 'l5', user: 'Анна Сидорова', action: 'Изменила приоритет задачи', time: '3 часа назад' },
]

// ─── Helper ──────────────────────────────────────────────────────────────────

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

// ─── Sub-section Components ─────────────────────────────────────────────────

function ProfileSection() {
  const currentUser = useAuthStore((s) => s.currentUser)
  const logout = useAuthStore((s) => s.logout)

  const userInitials = currentUser?.name
    ? currentUser.name.split(' ').map((n) => n[0]).join('').slice(0, 2).toUpperCase()
    : '??'

  const roleLabel: Record<string, string> = {
    admin: 'Администратор',
    manager: 'Менеджер',
    user: 'Пользователь',
  }

  return (
    <>
      <SectionHeader icon={User} title="Профиль" description="Информация о вашем аккаунте" color="bg-gray-500" />

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardContent className="p-5">
          <div className="flex items-center gap-4 mb-6">
            <Avatar className="h-16 w-16 ring-2 ring-primary/10">
              <AvatarFallback className="bg-primary text-primary-foreground text-xl font-semibold">
                {userInitials}
              </AvatarFallback>
            </Avatar>
            <div className="min-w-0 flex-1">
              <p className="text-base font-semibold text-foreground truncate">
                {currentUser?.name ?? 'Пользователь'}
              </p>
              <div className="flex items-center gap-2 mt-1">
                <Mail className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
                <p className="text-sm text-muted-foreground truncate">{currentUser?.email ?? ''}</p>
              </div>
              <Badge variant="secondary" className="mt-1.5 text-xs bg-primary/10 text-primary border-primary/20">
                {roleLabel[currentUser?.role ?? ''] ?? currentUser?.role}
              </Badge>
            </div>
          </div>

          <Separator className="my-4" />

          <div className="space-y-0">
            <SettingRow label="Имя">
              <Input defaultValue={currentUser?.name ?? ''} className="max-w-[200px] h-9 text-sm rounded-lg" readOnly />
            </SettingRow>
            <SettingRow label="Email">
              <Input defaultValue={currentUser?.email ?? ''} className="max-w-[200px] h-9 text-sm rounded-lg" readOnly />
            </SettingRow>
            <SettingRow label="Роль">
              <Badge variant="secondary">{roleLabel[currentUser?.role ?? ''] ?? '—'}</Badge>
            </SettingRow>
          </div>

          <Separator className="my-4" />

          <Button
            variant="outline"
            className="w-full rounded-xl text-destructive hover:text-destructive hover:bg-destructive/10 border-destructive/20"
            onClick={logout}
          >
            <LogOut className="mr-2 h-4 w-4" />
            Выйти из аккаунта
          </Button>
        </CardContent>
      </Card>
    </>
  )
}

function UsersSection() {
  return (
    <>
      <SectionHeader icon={Users} title="Пользователи и роли" description="Управление командой и доступом" color="bg-blue-500" />

      <div className="flex items-center justify-between mb-4">
        <p className="text-sm text-muted-foreground">{MOCK_USERS.length} пользователей</p>
        <Button size="sm" className="rounded-xl gap-1.5">
          <Plus className="h-3.5 w-3.5" />
          Добавить
        </Button>
      </div>

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardContent className="p-0">
          {MOCK_USERS.map((user, i) => (
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
                <button className="h-8 w-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                  <MoreHorizontal className="h-4 w-4" />
                </button>
              </div>
            </div>
          ))}
        </CardContent>
      </Card>

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
    </>
  )
}

function CrmSection() {
  return (
    <>
      <SectionHeader icon={Kanban} title="CRM" description="Сделки, воронки и этапы" color="bg-amber-500" />

      {MOCK_PIPELINES.map((pipeline) => (
        <Card key={pipeline.id} className="rounded-2xl border-border/60 shadow-sm">
          <CardHeader className="pb-3">
            <div className="flex items-center justify-between">
              <CardTitle className="text-sm font-medium text-foreground">{pipeline.name}</CardTitle>
              <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs text-muted-foreground">
                <Pencil className="h-3 w-3" />
                Изменить
              </Button>
            </div>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              {pipeline.stages.map((stage) => (
                <div key={stage.id} className="flex items-center gap-3 py-1.5">
                  <Circle className="h-3 w-3 shrink-0" style={{ color: stage.color, fill: stage.color }} />
                  <span className="text-sm text-foreground flex-1">{stage.name}</span>
                  <Badge variant="secondary" className="text-xs tabular-nums">{stage.count}</Badge>
                </div>
              ))}
            </div>
            <Separator className="my-3" />
            <Button variant="outline" size="sm" className="w-full rounded-xl text-xs gap-1.5">
              <Plus className="h-3 w-3" />
              Добавить этап
            </Button>
          </CardContent>
        </Card>
      ))}

      <Button variant="outline" className="w-full rounded-xl gap-1.5 mt-3">
        <Plus className="h-4 w-4" />
        Новая воронка
      </Button>
    </>
  )
}

function ContactsSection() {
  return (
    <>
      <SectionHeader icon={Contact} title="Контакты и компании" description="Поля, теги и сегменты" color="bg-emerald-500" />

      {/* Custom fields */}
      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <CardTitle className="text-sm font-medium text-foreground">Пользовательские поля</CardTitle>
            <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs text-muted-foreground">
              <Plus className="h-3 w-3" />
              Добавить
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          <div className="space-y-0">
            {MOCK_CUSTOM_FIELDS.map((field, i) => (
              <div key={field.id}>
                {i > 0 && <Separator className="my-0" />}
                <div className="flex items-center justify-between py-3">
                  <div>
                    <p className="text-sm text-foreground">{field.name}</p>
                    <p className="text-xs text-muted-foreground">{field.type === 'text' ? 'Текст' : field.type === 'number' ? 'Число' : 'Список'}</p>
                  </div>
                  <button className="h-8 w-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                    <MoreHorizontal className="h-4 w-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Tags preview */}
      <Card className="rounded-2xl border-border/60 shadow-sm mt-4">
        <CardHeader className="pb-3">
          <CardTitle className="text-sm font-medium text-foreground">Теги контактов</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex flex-wrap gap-2">
            {MOCK_TAGS.slice(0, 4).map((tag) => (
              <Badge key={tag.id} variant="secondary" className="gap-1.5 text-xs" style={{ borderColor: tag.color + '40', backgroundColor: tag.color + '15', color: tag.color }}>
                <Circle className="h-2 w-2" style={{ fill: tag.color, color: tag.color }} />
                {tag.name}
              </Badge>
            ))}
          </div>
        </CardContent>
      </Card>
    </>
  )
}

function TasksSection() {
  return (
    <>
      <SectionHeader icon={CheckSquare} title="Задачи" description="Статусы, приоритеты и сроки" color="bg-violet-500" />

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <CardTitle className="text-sm font-medium text-foreground">Статусы задач</CardTitle>
            <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs text-muted-foreground">
              <Plus className="h-3 w-3" />
              Добавить
            </Button>
          </div>
        </CardHeader>
        <CardContent>
          <div className="space-y-0">
            {MOCK_TASK_STATUSES.map((status, i) => (
              <div key={status.id}>
                {i > 0 && <Separator className="my-0" />}
                <div className="flex items-center gap-3 py-3">
                  <Circle className="h-3 w-3 shrink-0" style={{ color: status.color, fill: status.color }} />
                  <span className="text-sm text-foreground flex-1">{status.name}</span>
                  <button className="h-8 w-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                    <MoreHorizontal className="h-4 w-4" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      <Card className="rounded-2xl border-border/60 shadow-sm mt-4">
        <CardHeader className="pb-3">
          <CardTitle className="text-sm font-medium text-foreground">Приоритеты</CardTitle>
        </CardHeader>
        <CardContent className="space-y-2">
          {[
            { label: 'Высокий', className: 'bg-red-500/10 text-red-600 border-red-500/20' },
            { label: 'Средний', className: 'bg-amber-500/10 text-amber-600 border-amber-500/20' },
            { label: 'Низкий', className: 'bg-slate-500/10 text-slate-600 border-slate-500/20' },
          ].map((p) => (
            <div key={p.label} className="flex items-center justify-between py-1">
              <Badge variant="outline" className={`text-xs border ${p.className}`}>{p.label}</Badge>
              <button className="h-7 w-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                <Pencil className="h-3 w-3" />
              </button>
            </div>
          ))}
        </CardContent>
      </Card>

      <Card className="rounded-2xl border-border/60 shadow-sm mt-4">
        <CardContent className="p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-foreground">Напоминания о сроках</p>
              <p className="text-xs text-muted-foreground mt-0.5">Уведомлять за 1 день до дедлайна</p>
            </div>
            <Switch defaultChecked />
          </div>
        </CardContent>
      </Card>
    </>
  )
}

function AutomationSection() {
  return (
    <>
      <SectionHeader icon={Zap} title="Автоматизация" description="Правила и триггеры" color="bg-orange-500" />

      <div className="flex items-center justify-between mb-4">
        <p className="text-sm text-muted-foreground">{MOCK_AUTOMATION_RULES.length} правил</p>
        <Button size="sm" className="rounded-xl gap-1.5">
          <Plus className="h-3.5 w-3.5" />
          Новое правило
        </Button>
      </div>

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardContent className="p-0">
          {MOCK_AUTOMATION_RULES.map((rule, i) => (
            <div key={rule.id}>
              {i > 0 && <Separator className="mx-5" />}
              <div className="p-4">
                <div className="flex items-center justify-between mb-2">
                  <p className="text-sm font-medium text-foreground">{rule.name}</p>
                  <Switch defaultChecked={rule.enabled} />
                </div>
                <div className="flex items-center gap-2 text-xs text-muted-foreground">
                  <Badge variant="secondary" className="text-xs">{rule.trigger}</Badge>
                  <ArrowRight className="h-3 w-3" />
                  <span>{rule.action}</span>
                </div>
              </div>
            </div>
          ))}
        </CardContent>
      </Card>

      <Card className="rounded-2xl border-border/60 shadow-sm mt-4">
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
    </>
  )
}

function NotificationsSection() {
  return (
    <>
      <SectionHeader icon={Bell} title="Уведомления" description="События и каналы оповещения" color="bg-pink-500" />

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardHeader className="pb-3">
          <CardTitle className="text-sm font-medium text-foreground">События</CardTitle>
          <CardDescription className="text-xs">Настройте, о каких событиях уведомлять</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-0">
            {MOCK_NOTIFICATIONS.map((notif, i) => (
              <div key={notif.id}>
                {i > 0 && <Separator className="my-0" />}
                <div className="flex items-center justify-between py-3">
                  <div>
                    <p className="text-sm text-foreground">{notif.event}</p>
                    <p className="text-xs text-muted-foreground">{notif.channel}</p>
                  </div>
                  <Switch defaultChecked={notif.enabled} />
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
            <Switch />
          </div>
        </CardContent>
      </Card>
    </>
  )
}

function TagsSection() {
  return (
    <>
      <SectionHeader icon={Tag} title="Теги и сегменты" description="Категоризация клиентов" color="bg-cyan-500" />

      {/* Tags */}
      <div className="flex items-center justify-between mb-3">
        <p className="text-sm font-medium text-foreground">Теги</p>
        <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs text-muted-foreground">
          <Plus className="h-3 w-3" />
          Добавить
        </Button>
      </div>
      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardContent className="p-0">
          {MOCK_TAGS.map((tag, i) => (
            <div key={tag.id}>
              {i > 0 && <Separator className="mx-5" />}
              <div className="flex items-center gap-3 p-3.5">
                <Circle className="h-3.5 w-3.5 shrink-0" style={{ color: tag.color, fill: tag.color }} />
                <span className="text-sm text-foreground flex-1">{tag.name}</span>
                <span className="text-xs text-muted-foreground tabular-nums">{tag.count}</span>
                <button className="h-7 w-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
                  <MoreHorizontal className="h-3.5 w-3.5" />
                </button>
              </div>
            </div>
          ))}
        </CardContent>
      </Card>

      {/* Segments */}
      <div className="flex items-center justify-between mb-3 mt-5">
        <p className="text-sm font-medium text-foreground">Сегменты</p>
        <Button variant="ghost" size="sm" className="h-7 gap-1 text-xs text-muted-foreground">
          <Plus className="h-3 w-3" />
          Создать
        </Button>
      </div>
      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardContent className="p-0">
          {MOCK_SEGMENTS.map((seg, i) => (
            <div key={seg.id}>
              {i > 0 && <Separator className="mx-5" />}
              <div className="flex items-center gap-3 p-3.5">
                <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-muted">
                  <Users className="h-3.5 w-3.5 text-muted-foreground" />
                </div>
                <span className="text-sm text-foreground flex-1">{seg.name}</span>
                <Badge variant="secondary" className="text-xs tabular-nums">{seg.count}</Badge>
              </div>
            </div>
          ))}
        </CardContent>
      </Card>
    </>
  )
}

function FilesSection() {
  return (
    <>
      <SectionHeader icon={FileText} title="Файлы" description="Хранилище и вложения" color="bg-slate-500" />

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardContent className="p-5">
          <div className="flex flex-col items-center justify-center py-8 border-2 border-dashed border-border/60 rounded-xl">
            <div className="flex h-12 w-12 items-center justify-center rounded-xl bg-muted mb-3">
              <Upload className="h-6 w-6 text-muted-foreground" />
            </div>
            <p className="text-sm font-medium text-foreground">Загрузить файл</p>
            <p className="text-xs text-muted-foreground mt-1">Перетащите или нажмите для выбора</p>
            <Button variant="outline" size="sm" className="mt-4 rounded-xl text-xs gap-1.5">
              <Upload className="h-3 w-3" />
              Выбрать файл
            </Button>
          </div>
        </CardContent>
      </Card>

      <Card className="rounded-2xl border-border/60 shadow-sm mt-4">
        <CardHeader className="pb-3">
          <CardTitle className="text-sm font-medium text-foreground">Последние файлы</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-0">
            {[
              { name: 'КП_Альфа.pdf', size: '2.4 МБ', time: 'Сегодня' },
              { name: 'Договор_Бета.docx', size: '1.1 МБ', time: 'Вчера' },
              { name: 'Презентация.pptx', size: '5.7 МБ', time: '3 дня назад' },
            ].map((file, i) => (
              <div key={i}>
                {i > 0 && <Separator className="my-0" />}
                <div className="flex items-center gap-3 py-3">
                  <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-muted shrink-0">
                    <FileText className="h-4 w-4 text-muted-foreground" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm text-foreground truncate">{file.name}</p>
                    <p className="text-xs text-muted-foreground">{file.size} · {file.time}</p>
                  </div>
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
              <p className="text-sm font-medium text-foreground">Использовано хранилища</p>
              <p className="text-xs text-muted-foreground mt-0.5">9.2 МБ из 1 ГБ</p>
            </div>
            <Badge variant="secondary" className="text-xs">0.9%</Badge>
          </div>
          <div className="mt-3 h-2 bg-muted rounded-full overflow-hidden">
            <div className="h-full bg-primary rounded-full" style={{ width: '0.9%' }} />
          </div>
        </CardContent>
      </Card>
    </>
  )
}

function LogsSection() {
  return (
    <>
      <SectionHeader icon={Clock} title="История и логи" description="Действия и изменения" color="bg-indigo-500" />

      <Card className="rounded-2xl border-border/60 shadow-sm">
        <CardHeader className="pb-3">
          <div className="flex items-center justify-between">
            <CardTitle className="text-sm font-medium text-foreground">Последние действия</CardTitle>
            <button className="h-8 w-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors duration-200">
              <Search className="h-4 w-4" />
            </button>
          </div>
        </CardHeader>
        <CardContent className="p-0">
          {MOCK_LOGS.map((log, i) => (
            <div key={log.id}>
              {i > 0 && <Separator className="mx-5" />}
              <div className="flex items-start gap-3 p-4">
                <Avatar className="h-7 w-7 mt-0.5 shrink-0">
                  <AvatarFallback className="bg-muted text-muted-foreground text-[10px]">
                    {log.user.split(' ').map((n) => n[0]).join('').slice(0, 2)}
                  </AvatarFallback>
                </Avatar>
                <div className="flex-1 min-w-0">
                  <p className="text-sm text-foreground">{log.action}</p>
                  <p className="text-xs text-muted-foreground mt-0.5">{log.user} · {log.time}</p>
                </div>
              </div>
            </div>
          ))}
        </CardContent>
      </Card>
    </>
  )
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
                    <div className="flex items-center gap-2">
                      <p className="text-sm font-medium text-foreground">{cat.title}</p>
                      {cat.badge && (
                        <Badge variant="secondary" className="text-[10px] px-1.5 py-0">{cat.badge}</Badge>
                      )}
                    </div>
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
