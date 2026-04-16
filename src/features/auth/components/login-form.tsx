'use client'

import { useState } from 'react'
import { supabase } from '@/lib/supabase/client'
import { useAuthStore } from '@/lib/store'
import type { User } from '@/lib/supabase/database.types'
import { Card, CardContent } from '@/components/ui/card'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { Checkbox } from '@/components/ui/checkbox'
import { Label } from '@/components/ui/label'
import { Zap, Mail, Lock, Loader2, Eye, EyeOff } from 'lucide-react'

export function LoginForm() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [rememberMe, setRememberMe] = useState(true)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const login = useAuthStore((s) => s.login)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError('')

    if (!email.trim()) {
      setError('Введите email')
      return
    }
    if (!password) {
      setError('Введите пароль')
      return
    }

    setLoading(true)

    try {
      // 1. Sign in via Supabase Auth
      const { error: authError } = await supabase.auth.signInWithPassword({
        email: email.trim(),
        password,
      })

      if (authError) {
        setError('Неверный email или пароль')
        setLoading(false)
        return
      }

      // 2. Fetch CRM user by email from users table
      const { data: crmUser, error: crmError } = await supabase
        .from('users')
        .select('*')
        .eq('email', email.trim())
        .single()

      if (crmError || !crmUser) {
        // Auth succeeded but no CRM profile — create one
        const {
          data: { user: authUser },
        } = await supabase.auth.getUser()

        if (authUser) {
          const newUser: Omit<User, 'created_at'> = {
            id: authUser.id,
            name: authUser.user_metadata?.full_name || email.split('@')[0],
            email: authUser.email || email.trim(),
            role: 'admin',
          }
          const { data: createdUser } = await supabase
            .from('users')
            .insert(newUser)
            .select()
            .single()

          if (createdUser) {
            login(createdUser)
          }
        }
      } else {
        // CRM user found — set as current user
        login(crmUser)
      }
    } catch {
      setError('Произошла ошибка при входе')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-background via-blue-50/30 to-background px-4">
      <div className="w-full max-w-sm animate-in fade-in-0 zoom-in-95 duration-500">
        {/* Logo */}
        <div className="flex flex-col items-center mb-8">
          <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-primary shadow-lg shadow-primary/25 mb-4">
            <Zap className="h-7 w-7 text-primary-foreground" />
          </div>
          <h1 className="text-2xl font-bold tracking-tight text-foreground">
            Добро пожаловать 👋
          </h1>
          <p className="text-sm text-muted-foreground mt-1.5">
            Войдите в CRM, чтобы продолжить
          </p>
        </div>

        {/* Login Card */}
        <Card className="rounded-2xl border-border/60 shadow-lg shadow-black/[0.04]">
          <CardContent className="p-6">
            <form onSubmit={handleSubmit} className="space-y-5">
              {/* Error */}
              {error && (
                <div className="flex items-center gap-2 rounded-xl bg-destructive/10 px-4 py-3">
                  <span className="text-sm text-destructive">{error}</span>
                </div>
              )}

              {/* Email */}
              <div className="space-y-2">
                <Label htmlFor="email" className="text-sm font-medium text-foreground">
                  Email
                </Label>
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                  <Input
                    id="email"
                    type="email"
                    value={email}
                    onChange={(e) => { setEmail(e.target.value); setError('') }}
                    placeholder="name@company.ru"
                    autoComplete="email"
                    autoFocus
                    className="h-11 rounded-xl pl-10 text-[16px] bg-muted/30 border-border/60 focus-visible:ring-primary/30"
                    disabled={loading}
                  />
                </div>
              </div>

              {/* Password */}
              <div className="space-y-2">
                <Label htmlFor="password" className="text-sm font-medium text-foreground">
                  Пароль
                </Label>
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                  <Input
                    id="password"
                    type={showPassword ? 'text' : 'password'}
                    value={password}
                    onChange={(e) => { setPassword(e.target.value); setError('') }}
                    placeholder="Введите пароль"
                    autoComplete="current-password"
                    className="h-11 rounded-xl pl-10 pr-10 text-[16px] bg-muted/30 border-border/60 focus-visible:ring-primary/30"
                    disabled={loading}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground transition-colors duration-200"
                    tabIndex={-1}
                  >
                    {showPassword ? (
                      <EyeOff className="h-4 w-4" />
                    ) : (
                      <Eye className="h-4 w-4" />
                    )}
                  </button>
                </div>
              </div>

              {/* Remember Me */}
              <div className="flex items-center gap-2">
                <Checkbox
                  id="remember"
                  checked={rememberMe}
                  onCheckedChange={(checked) => setRememberMe(checked === true)}
                  className="data-[state=checked]:bg-primary data-[state=checked]:border-primary"
                />
                <Label
                  htmlFor="remember"
                  className="text-sm text-muted-foreground cursor-pointer select-none"
                >
                  Запомнить меня
                </Label>
              </div>

              {/* Submit Button */}
              <Button
                type="submit"
                disabled={loading}
                className="w-full h-11 rounded-xl text-sm font-semibold shadow-md shadow-primary/20 hover:shadow-lg hover:shadow-primary/25 transition-all duration-200"
              >
                {loading ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    Вход...
                  </>
                ) : (
                  'Войти'
                )}
              </Button>
            </form>
          </CardContent>
        </Card>

        {/* Footer */}
        <p className="text-center text-xs text-muted-foreground/60 mt-6">
          PulseCRM &copy; {new Date().getFullYear()}
        </p>
      </div>
    </div>
  )
}
