'use client'

import { useTheme } from 'next-themes'
import {
  User,
  Mail,
  Shield,
  Sun,
  Moon,
  Monitor,
  LogOut,
  Zap,
  Info,
} from 'lucide-react'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectItem,
} from '@/components/ui/select'
import { useAuthStore } from '@/lib/store'

export function SettingsPage() {
  const { setTheme, theme, resolvedTheme } = useTheme()
  const currentUser = useAuthStore((s) => s.currentUser)
  const logout = useAuthStore((s) => s.logout)

  const userInitials = currentUser?.name
    ? currentUser.name
        .split(' ')
        .map((n) => n[0])
        .join('')
        .slice(0, 2)
        .toUpperCase()
    : '??'

  const roleLabel: Record<string, string> = {
    admin: 'Администратор',
    manager: 'Менеджер',
    user: 'Пользователь',
  }

  return (
    <div className="space-y-6 max-w-2xl">
      {/* ── Profile ────────────────────────────────────────── */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base flex items-center gap-2">
            <User className="h-4 w-4 text-muted-foreground" />
            Профиль
          </CardTitle>
          <CardDescription>Информация о вашем аккаунте</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-4">
            <Avatar className="h-14 w-14">
              <AvatarFallback className="bg-primary text-primary-foreground text-lg font-semibold">
                {userInitials}
              </AvatarFallback>
            </Avatar>
            <div className="min-w-0 flex-1">
              <p className="text-base font-semibold text-foreground truncate">
                {currentUser?.name ?? 'Пользователь'}
              </p>
              <div className="flex items-center gap-2 mt-1">
                <Mail className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
                <p className="text-sm text-muted-foreground truncate">
                  {currentUser?.email ?? ''}
                </p>
              </div>
              <div className="flex items-center gap-2 mt-1">
                <Shield className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
                <Badge variant="secondary" className="text-xs">
                  {roleLabel[currentUser?.role ?? ''] ?? currentUser?.role}
                </Badge>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* ── Appearance ─────────────────────────────────────── */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base flex items-center gap-2">
            <Sun className="h-4 w-4 text-muted-foreground" />
            Внешний вид
          </CardTitle>
          <CardDescription>Настройте тему приложения</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-muted">
                {resolvedTheme === 'dark' ? (
                  <Moon className="h-4 w-4 text-foreground" />
                ) : (
                  <Sun className="h-4 w-4 text-foreground" />
                )}
              </div>
              <div>
                <p className="text-sm font-medium text-foreground">Тема</p>
                <p className="text-xs text-muted-foreground">
                  {resolvedTheme === 'dark' ? 'Тёмная тема' : 'Светлая тема'}
                </p>
              </div>
            </div>
            <Select value={theme ?? 'system'} onValueChange={setTheme}>
              <SelectTrigger className="w-[140px] h-9">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="light">
                  <span className="flex items-center gap-2">
                    <Sun className="h-3.5 w-3.5" />
                    Светлая
                  </span>
                </SelectItem>
                <SelectItem value="dark">
                  <span className="flex items-center gap-2">
                    <Moon className="h-3.5 w-3.5" />
                    Тёмная
                  </span>
                </SelectItem>
                <SelectItem value="system">
                  <span className="flex items-center gap-2">
                    <Monitor className="h-3.5 w-3.5" />
                    Системная
                  </span>
                </SelectItem>
              </SelectContent>
            </Select>
          </div>
        </CardContent>
      </Card>

      {/* ── Quick Theme Toggle Buttons ─────────────────────── */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base flex items-center gap-2">
            <Monitor className="h-4 w-4 text-muted-foreground" />
            Быстрое переключение
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-3 gap-3">
            <button
              onClick={() => setTheme('light')}
              className={`flex flex-col items-center gap-2 rounded-xl border p-4 transition-all hover:bg-accent ${
                resolvedTheme === 'light'
                  ? 'border-primary bg-primary/5'
                  : 'border-border'
              }`}
            >
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-amber-100 dark:bg-amber-500/20">
                <Sun className="h-5 w-5 text-amber-600 dark:text-amber-400" />
              </div>
              <span className="text-xs font-medium text-foreground">Светлая</span>
            </button>
            <button
              onClick={() => setTheme('dark')}
              className={`flex flex-col items-center gap-2 rounded-xl border p-4 transition-all hover:bg-accent ${
                resolvedTheme === 'dark'
                  ? 'border-primary bg-primary/5'
                  : 'border-border'
              }`}
            >
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-indigo-100 dark:bg-indigo-500/20">
                <Moon className="h-5 w-5 text-indigo-600 dark:text-indigo-400" />
              </div>
              <span className="text-xs font-medium text-foreground">Тёмная</span>
            </button>
            <button
              onClick={() => setTheme('system')}
              className={`flex flex-col items-center gap-2 rounded-xl border p-4 transition-all hover:bg-accent ${
                theme === 'system'
                  ? 'border-primary bg-primary/5'
                  : 'border-border'
              }`}
            >
              <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-muted">
                <Monitor className="h-5 w-5 text-foreground" />
              </div>
              <span className="text-xs font-medium text-foreground">Система</span>
            </button>
          </div>
        </CardContent>
      </Card>

      {/* ── About ──────────────────────────────────────────── */}
      <Card>
        <CardHeader>
          <CardTitle className="text-base flex items-center gap-2">
            <Info className="h-4 w-4 text-muted-foreground" />
            О приложении
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-3">
            <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-primary">
              <Zap className="h-4 w-4 text-primary-foreground" />
            </div>
            <div>
              <p className="text-sm font-medium text-foreground">PulseCRM</p>
              <p className="text-xs text-muted-foreground">Версия 0.3.0</p>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* ── Logout ─────────────────────────────────────────── */}
      <Separator />
      <Button
        variant="outline"
        className="w-full text-destructive hover:text-destructive hover:bg-destructive/10 border-destructive/20"
        onClick={logout}
      >
        <LogOut className="mr-2 h-4 w-4" />
        Выйти из аккаунта
      </Button>
    </div>
  )
}
