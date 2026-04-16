'use client'

import {
  User,
  Mail,
  Shield,
  LogOut,
  Zap,
  Info,
  Palette,
  Globe,
  Bell,
  Lock,
} from 'lucide-react'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { useAuthStore } from '@/lib/store'
import { SECTION_COLORS } from '@/lib/section-colors'

const section = SECTION_COLORS.settings

export function SettingsPage() {
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
      <Card className="rounded-2xl border-border/60 shadow-sm transition-all duration-200 hover:shadow-md">
        <CardHeader>
          <CardTitle className="text-base flex items-center gap-2.5">
            <div className={`flex h-7 w-7 items-center justify-center rounded-full ${section.bgClass}`}>
              <User className="h-4 w-4 text-white" />
            </div>
            Профиль
          </CardTitle>
          <CardDescription>Информация о вашем аккаунте</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-4">
            <Avatar className="h-14 w-14 ring-2 ring-gray-200">
              <AvatarFallback className="bg-gray-500 text-white text-lg font-semibold">
                {userInitials}
              </AvatarFallback>
            </Avatar>
            <div className="min-w-0 flex-1">
              <p className="text-base font-semibold text-foreground truncate">
                {currentUser?.name ?? 'Пользователь'}
              </p>
              <div className="flex items-center gap-2 mt-1.5">
                <Mail className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
                <p className="text-sm text-muted-foreground truncate">
                  {currentUser?.email ?? ''}
                </p>
              </div>
              <div className="flex items-center gap-2 mt-1.5">
                <Shield className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
                <Badge
                  variant="secondary"
                  className="text-xs bg-gray-100 text-gray-700 border-gray-200"
                >
                  {roleLabel[currentUser?.role ?? ''] ?? currentUser?.role}
                </Badge>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* ── Quick Settings Grid ───────────────────────────── */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
        {/* Notifications */}
        <Card className="rounded-2xl border-border/60 shadow-sm transition-all duration-200 hover:shadow-md">
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-full bg-amber-500">
                <Bell className="h-5 w-5 text-white" />
              </div>
              <div className="min-w-0 flex-1">
                <p className="text-sm font-medium text-foreground">Уведомления</p>
                <p className="text-xs text-muted-foreground">Push и email</p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Appearance */}
        <Card className="rounded-2xl border-border/60 shadow-sm transition-all duration-200 hover:shadow-md">
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-full bg-violet-500">
                <Palette className="h-5 w-5 text-white" />
              </div>
              <div className="min-w-0 flex-1">
                <p className="text-sm font-medium text-foreground">Внешний вид</p>
                <p className="text-xs text-muted-foreground">Тема оформления</p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Language */}
        <Card className="rounded-2xl border-border/60 shadow-sm transition-all duration-200 hover:shadow-md">
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-full bg-blue-500">
                <Globe className="h-5 w-5 text-white" />
              </div>
              <div className="min-w-0 flex-1">
                <p className="text-sm font-medium text-foreground">Язык</p>
                <p className="text-xs text-muted-foreground">Русский</p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Security */}
        <Card className="rounded-2xl border-border/60 shadow-sm transition-all duration-200 hover:shadow-md">
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="flex h-10 w-10 items-center justify-center rounded-full bg-emerald-500">
                <Lock className="h-5 w-5 text-white" />
              </div>
              <div className="min-w-0 flex-1">
                <p className="text-sm font-medium text-foreground">Безопасность</p>
                <p className="text-xs text-muted-foreground">Пароль и 2FA</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* ── About ──────────────────────────────────────────── */}
      <Card className="rounded-2xl border-border/60 shadow-sm transition-all duration-200 hover:shadow-md">
        <CardHeader>
          <CardTitle className="text-base flex items-center gap-2.5">
            <div className="flex h-7 w-7 items-center justify-center rounded-full bg-primary">
              <Info className="h-4 w-4 text-white" />
            </div>
            О приложении
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-primary">
              <Zap className="h-5 w-5 text-primary-foreground" />
            </div>
            <div>
              <p className="text-sm font-semibold text-foreground">PulseCRM</p>
              <p className="text-xs text-muted-foreground">v0.3.0</p>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* ── Logout ─────────────────────────────────────────── */}
      <Separator />
      <Button
        variant="outline"
        className="w-full rounded-xl text-red-500 hover:text-red-600 hover:bg-red-50 border-red-200/60 transition-all duration-200"
        onClick={logout}
      >
        <LogOut className="mr-2 h-4 w-4" />
        Выйти
      </Button>
    </div>
  )
}
