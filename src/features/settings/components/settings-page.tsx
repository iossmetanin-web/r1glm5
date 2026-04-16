'use client'

import {
  User,
  Mail,
  Shield,
  LogOut,
  Zap,
  Info,
} from 'lucide-react'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Separator } from '@/components/ui/separator'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { useAuthStore } from '@/lib/store'

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
      <Card className="rounded-2xl border-border/60 shadow-sm transition-shadow duration-200 hover:shadow-md">
        <CardHeader>
          <CardTitle className="text-base flex items-center gap-2">
            <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-gray-500">
              <User className="h-4 w-4 text-white" />
            </div>
            Профиль
          </CardTitle>
          <CardDescription>Информация о вашем аккаунте</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-4">
            <Avatar className="h-14 w-14 ring-2 ring-primary/10">
              <AvatarFallback className="bg-primary text-primary-foreground text-lg font-semibold">
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
                  className="text-xs bg-primary/10 text-primary border-primary/20 hover:bg-primary/15"
                >
                  {roleLabel[currentUser?.role ?? ''] ?? currentUser?.role}
                </Badge>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* ── About ──────────────────────────────────────────── */}
      <Card className="rounded-2xl border-border/60 shadow-sm transition-shadow duration-200 hover:shadow-md">
        <CardHeader>
          <CardTitle className="text-base flex items-center gap-2">
            <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-primary">
              <Info className="h-4 w-4 text-primary-foreground" />
            </div>
            О приложении
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-primary shadow-sm shadow-primary/25">
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
        className="w-full rounded-xl text-destructive hover:text-destructive hover:bg-destructive/10 border-destructive/20 transition-all duration-200"
        onClick={logout}
      >
        <LogOut className="mr-2 h-4 w-4" />
        Выйти
      </Button>
    </div>
  )
}
