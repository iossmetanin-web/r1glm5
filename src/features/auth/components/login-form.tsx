'use client'

import { useState } from 'react'
import { supabase } from '@/lib/supabase/client'
import { useAuthStore } from '@/lib/store'
import type { User } from '@/lib/supabase/database.types'
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
    <div
      className="relative flex min-h-screen items-center justify-center overflow-hidden px-4 py-12"
      style={{
        background: 'linear-gradient(135deg, oklch(0.975 0.002 250) 0%, oklch(0.96 0.015 240) 30%, oklch(0.975 0.005 260) 60%, oklch(0.97 0.002 250) 100%)',
        backgroundSize: '300% 300%',
        animation: 'login-bg-shift 20s ease-in-out infinite',
      }}
    >
      {/* Radial glow behind card — the "wow" element */}
      <div
        className="pointer-events-none absolute top-1/2 left-1/2 -z-0"
        style={{
          width: 'min(600px, 90vw)',
          height: 'min(600px, 90vw)',
          borderRadius: '50%',
          background: 'radial-gradient(circle, oklch(0.55 0.22 260 / 0.12) 0%, oklch(0.65 0.15 240 / 0.06) 40%, transparent 70%)',
          animation: 'login-glow-pulse 8s ease-in-out infinite',
        }}
      />

      {/* Content wrapper — fade-up entrance */}
      <div
        className="relative z-10 w-full max-w-[380px]"
        style={{ animation: 'login-fade-up 0.6s cubic-bezier(0.16, 1, 0.3, 1) both' }}
      >
        {/* ── Logo ── */}
        <div className="flex flex-col items-center mb-10">
          <div
            className="flex h-[60px] w-[60px] items-center justify-center rounded-[18px] mb-5"
            style={{
              background: 'linear-gradient(145deg, oklch(0.55 0.22 260), oklch(0.62 0.18 240))',
              boxShadow: '0 4px 24px oklch(0.55 0.22 260 / 0.3), 0 1px 3px oklch(0.55 0.22 260 / 0.2)',
              animation: 'login-icon-pulse 4s ease-in-out infinite',
            }}
          >
            <Zap className="h-7 w-7 text-white" style={{ filter: 'drop-shadow(0 1px 2px oklch(0 0 0 / 0.15))' }} />
          </div>
          <h1 className="text-[26px] font-semibold tracking-[-0.02em] text-foreground leading-tight">
            Добро пожаловать 👋
          </h1>
          <p className="text-[15px] text-muted-foreground/70 mt-2 leading-relaxed">
            Управляйте сделками быстрее и проще
          </p>
        </div>

        {/* ── Card ── */}
        <div
          className="rounded-[24px] bg-white/70 border border-white/60 p-7 sm:p-8"
          style={{
            backdropFilter: 'blur(24px) saturate(1.4)',
            WebkitBackdropFilter: 'blur(24px) saturate(1.4)',
            boxShadow: '0 8px 40px oklch(0 0 0 / 0.06), 0 1px 3px oklch(0 0 0 / 0.04), inset 0 1px 0 oklch(1 0 0 / 0.6)',
            animation: 'login-card-float 6s ease-in-out infinite',
          }}
        >
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Error */}
            {error && (
              <div
                className="flex items-center gap-2 rounded-2xl bg-destructive/[0.07] border border-destructive/10 px-4 py-3.5"
                style={{ animation: 'login-fade-up 0.25s cubic-bezier(0.16, 1, 0.3, 1) both' }}
              >
                <span className="text-sm font-medium text-destructive">{error}</span>
              </div>
            )}

            {/* Email */}
            <div className="space-y-2.5">
              <Label htmlFor="email" className="text-[13px] font-medium text-foreground/80 pl-1">
                Email
              </Label>
              <div className="relative">
                <Mail className="absolute left-3.5 top-1/2 h-[18px] w-[18px] -translate-y-1/2 text-muted-foreground/50" />
                <Input
                  id="email"
                  type="email"
                  value={email}
                  onChange={(e) => { setEmail(e.target.value); setError('') }}
                  placeholder="name@company.ru"
                  autoComplete="email"
                  autoFocus
                  className="h-[52px] rounded-2xl pl-11 pr-4 text-[15px] bg-muted/40 border-white/60 placeholder:text-muted-foreground/40 focus-visible:bg-white focus-visible:border-primary/40 focus-visible:ring-[3px] focus-visible:ring-primary/10 transition-all duration-200"
                  disabled={loading}
                />
              </div>
            </div>

            {/* Password */}
            <div className="space-y-2.5">
              <Label htmlFor="password" className="text-[13px] font-medium text-foreground/80 pl-1">
                Пароль
              </Label>
              <div className="relative">
                <Lock className="absolute left-3.5 top-1/2 h-[18px] w-[18px] -translate-y-1/2 text-muted-foreground/50" />
                <Input
                  id="password"
                  type={showPassword ? 'text' : 'password'}
                  value={password}
                  onChange={(e) => { setPassword(e.target.value); setError('') }}
                  placeholder="Введите пароль"
                  autoComplete="current-password"
                  className="h-[52px] rounded-2xl pl-11 pr-12 text-[15px] bg-muted/40 border-white/60 placeholder:text-muted-foreground/40 focus-visible:bg-white focus-visible:border-primary/40 focus-visible:ring-[3px] focus-visible:ring-primary/10 transition-all duration-200"
                  disabled={loading}
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3.5 top-1/2 -translate-y-1/2 text-muted-foreground/50 hover:text-muted-foreground transition-colors duration-200"
                  tabIndex={-1}
                >
                  {showPassword ? (
                    <EyeOff className="h-[18px] w-[18px]" />
                  ) : (
                    <Eye className="h-[18px] w-[18px]" />
                  )}
                </button>
              </div>
            </div>

            {/* Remember Me */}
            <div className="flex items-center gap-2.5 pt-0.5">
              <Checkbox
                id="remember"
                checked={rememberMe}
                onCheckedChange={(checked) => setRememberMe(checked === true)}
                className="data-[state=checked]:bg-primary data-[state=checked]:border-primary h-[18px] w-[18px] rounded-[5px] transition-all duration-200"
              />
              <Label
                htmlFor="remember"
                className="text-[14px] text-muted-foreground/60 cursor-pointer select-none"
              >
                Запомнить меня
              </Label>
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              disabled={loading}
              className="relative w-full h-[52px] rounded-2xl text-[15px] font-semibold text-white cursor-pointer disabled:cursor-not-allowed disabled:opacity-70 overflow-hidden transition-all duration-200 hover:-translate-y-[1px] active:translate-y-0 active:scale-[0.98]"
              style={{
                background: loading ? 'oklch(0.55 0.22 260)' : 'linear-gradient(135deg, oklch(0.55 0.22 260), oklch(0.58 0.19 245))',
                boxShadow: '0 4px 16px oklch(0.55 0.22 260 / 0.3), 0 1px 3px oklch(0.55 0.22 260 / 0.2)',
              }}
            >
              {loading ? (
                <span className="flex items-center justify-center gap-2">
                  <Loader2 className="h-[18px] w-[18px] animate-spin" />
                  Вход...
                </span>
              ) : (
                'Войти'
              )}
            </button>
          </form>
        </div>

        {/* ── Footer ── */}
        <p className="text-center text-[12px] text-muted-foreground/40 mt-8 tracking-wide">
          PulseCRM &copy; {new Date().getFullYear()}
        </p>
      </div>
    </div>
  )
}
