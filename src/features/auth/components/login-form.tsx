'use client'

import { useState, useEffect } from 'react'
import { supabase } from '@/lib/supabase/client'
import { useAuthStore } from '@/lib/store'
import type { User } from '@/lib/supabase/database.types'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '@/components/ui/card'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { Zap, Loader2 } from 'lucide-react'

export function LoginForm() {
  const [users, setUsers] = useState<User[]>([])
  const [loading, setLoading] = useState(true)
  const login = useAuthStore((s) => s.login)

  useEffect(() => {
    supabase
      .from('users')
      .select('*')
      .order('created_at', { ascending: true })
      .then(({ data }) => {
        setUsers(data ?? [])
        setLoading(false)
      })
  }, [])

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background">
        <Loader2 className="h-6 w-6 animate-spin text-muted-foreground" />
      </div>
    )
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-background px-4">
      <Card className="w-full max-w-sm border-border/50 bg-card/80 backdrop-blur-sm">
        <CardHeader className="text-center pb-2">
          <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-xl bg-primary">
            <Zap className="h-6 w-6 text-primary-foreground" />
          </div>
          <CardTitle className="text-xl font-semibold tracking-tight">
            PulseCRM
          </CardTitle>
          <CardDescription className="text-sm text-muted-foreground">
            Выберите пользователя для входа
          </CardDescription>
        </CardHeader>
        <CardContent className="pt-2">
          <div className="space-y-2">
            {users.map((user) => (
              <button
                key={user.id}
                onClick={() => login(user)}
                className="flex w-full items-center gap-3 rounded-lg border border-border bg-muted/30 px-4 py-3 text-left transition-all hover:bg-accent hover:border-accent-foreground/20"
              >
                <Avatar className="h-9 w-9">
                  <AvatarFallback className="bg-primary text-primary-foreground text-xs font-medium">
                    {user.name.slice(0, 2).toUpperCase()}
                  </AvatarFallback>
                </Avatar>
                <div className="min-w-0 flex-1">
                  <p className="text-sm font-medium truncate">{user.name}</p>
                  <p className="text-xs text-muted-foreground truncate">{user.email}</p>
                </div>
                <span className="text-[10px] uppercase font-medium text-muted-foreground/70 px-1.5 py-0.5 rounded bg-muted">
                  {user.role}
                </span>
              </button>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
