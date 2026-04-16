'use client'

import { useState, useEffect, useMemo } from 'react'
import { supabase } from '@/lib/supabase/client'
import type { Client, ClientInsert, ClientUpdate } from '@/lib/supabase/database.types'
import { useAuthStore } from '@/lib/store'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
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
  Table,
  TableHeader,
  TableBody,
  TableRow,
  TableHead,
  TableCell,
} from '@/components/ui/table'
import { Plus, Search, Pencil, Trash2, Users, AlertCircle } from 'lucide-react'

// ─── Types ─────────────────────────────────────────────────────────────────────

type ContactStage = 'Лид' | 'Переговоры' | 'Клиент' | 'Отток'

interface ContactFormData {
  name: string
  company: string
  phone: string
  email: string
  stage: ContactStage
}

const STAGE_OPTIONS: ContactStage[] = ['Лид', 'Переговоры', 'Клиент', 'Отток']

const STAGE_BADGE_MAP: Record<string, { cls: string }> = {
  'лид': { cls: 'bg-muted text-muted-foreground hover:bg-muted/80' },
  'переговоры': { cls: 'bg-amber-500/15 text-amber-600 dark:text-amber-400 hover:bg-amber-500/20 border-amber-500/25' },
  'клиент': { cls: 'bg-emerald-500/15 text-emerald-600 dark:text-emerald-400 hover:bg-emerald-500/20 border-emerald-500/25' },
  'отток': { cls: 'bg-red-500/15 text-red-600 dark:text-red-400 hover:bg-red-500/20 border-red-500/25' },
}

const EMPTY_FORM: ContactFormData = {
  name: '',
  company: '',
  phone: '',
  email: '',
  stage: 'Лид',
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

function formatDate(dateStr: string): string {
  const date = new Date(dateStr)
  return date.toLocaleDateString('ru-RU', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  })
}

function getStageBadgeVariant(stage: string | null): string {
  if (!stage) return ''
  return STAGE_BADGE_MAP[stage.toLowerCase()]?.cls ?? STAGE_BADGE_MAP['лид'].cls
}

// ─── Component ────────────────────────────────────────────────────────────────

export default function ContactsPage() {
  const currentUser = useAuthStore((s) => s.currentUser)

  // ─── State ─────────────────────────────────────────────────────────────────

  const [contacts, setContacts] = useState<Client[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [searchQuery, setSearchQuery] = useState('')

  // Dialog state
  const [dialogOpen, setDialogOpen] = useState(false)
  const [editingContact, setEditingContact] = useState<Client | null>(null)
  const [form, setForm] = useState<ContactFormData>(EMPTY_FORM)
  const [saving, setSaving] = useState(false)

  // Fetch trigger pattern (avoids React 19 lint warnings)
  const [fetchTrigger, setFetchTrigger] = useState(0)

  // ─── Data Fetching ────────────────────────────────────────────────────────

  useEffect(() => {
    let cancelled = false
    async function load() {
      try {
        const { data, error: fetchError } = await supabase
          .from('clients')
          .select('*')
          .order('created_at', { ascending: false })

        if (cancelled) return

        if (fetchError) {
          setError(fetchError.message)
        } else {
          setContacts(data ?? [])
          setError(null)
        }
      } catch (err: unknown) {
        if (cancelled) return
        const message = err instanceof Error ? err.message : 'Не удалось загрузить контакты'
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

  // ─── Search (client-side) ─────────────────────────────────────────────────

  const filteredContacts = useMemo(() => {
    if (!searchQuery.trim()) return contacts
    const q = searchQuery.toLowerCase()
    return contacts.filter(
      (c) =>
        c.name?.toLowerCase().includes(q) ||
        c.company?.toLowerCase().includes(q) ||
        c.email?.toLowerCase().includes(q)
    )
  }, [contacts, searchQuery])

  // ─── Create / Update ──────────────────────────────────────────────────────

  const openCreateDialog = () => {
    setEditingContact(null)
    setForm(EMPTY_FORM)
    setDialogOpen(true)
  }

  const openEditDialog = (contact: Client) => {
    setEditingContact(contact)
    setForm({
      name: contact.name ?? '',
      company: contact.company ?? '',
      phone: contact.phone ?? '',
      email: contact.email ?? '',
      stage: (contact.stage as ContactStage) || 'Лид',
    })
    setDialogOpen(true)
  }

  const handleSave = async () => {
    if (!form.name.trim()) return
    setSaving(true)

    try {
      if (editingContact) {
        // Update
        const updates: ClientUpdate = {
          name: form.name.trim(),
          company: form.company.trim() || null,
          phone: form.phone.trim() || null,
          email: form.email.trim() || null,
          stage: form.stage,
        }
        const { error: updateError } = await supabase
          .from('clients')
          .update(updates)
          .eq('id', editingContact.id)

        if (!updateError) {
          await supabase.from('activities').insert({
            action: `Обновлён контакт «${form.name.trim()}»`,
            entity_type: 'client',
            entity_id: editingContact.id,
            user_id: currentUser?.id,
          })
        }
      } else {
        // Create
        const insert: ClientInsert = {
          name: form.name.trim(),
          company: form.company.trim() || null,
          phone: form.phone.trim() || null,
          email: form.email.trim() || null,
          stage: form.stage,
        }
        const { error: insertError } = await supabase
          .from('clients')
          .insert(insert)

        if (!insertError) {
          await supabase.from('activities').insert({
            action: `Создан контакт «${form.name.trim()}»`,
            entity_type: 'client',
            user_id: currentUser?.id,
          })
        }
      }

      setDialogOpen(false)
      setEditingContact(null)
      setForm(EMPTY_FORM)
      refresh()
    } catch {
      // silent — refresh will show latest state
    }
    setSaving(false)
  }

  // ─── Delete ───────────────────────────────────────────────────────────────

  const handleDelete = async (contact: Client) => {
    if (!window.confirm(`Удалить "${contact.name}"? Это действие нельзя отменить.`)) return

    const { error: deleteError } = await supabase
      .from('clients')
      .delete()
      .eq('id', contact.id)

    if (!deleteError) {
      await supabase.from('activities').insert({
        action: `Удалён контакт «${contact.name}»`,
        entity_type: 'client',
        entity_id: contact.id,
        user_id: currentUser?.id,
      })
      refresh()
    }
  }

  // ─── Render ───────────────────────────────────────────────────────────────

  return (
    <div className="flex flex-col gap-4 h-full">
      {/* ── Top Bar ────────────────────────────────────────────────────────── */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
        <div>
          <h2 className="text-xl font-semibold tracking-tight flex items-center gap-2">
            <Users className="h-5 w-5 text-muted-foreground" />
            Контакты
          </h2>
          <p className="text-sm text-muted-foreground mt-0.5">
            {contacts.length}{' '}
            {contacts.length === 1 ? 'контакт' : contacts.length < 5 ? 'контакта' : 'контактов'}
            {searchQuery.trim() && filteredContacts.length !== contacts.length
              ? ` · ${filteredContacts.length} найдено`
              : ''}
          </p>
        </div>
        <div className="flex items-center gap-2 flex-wrap">
          <div className="relative">
            <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="Поиск контактов…"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-8 w-full sm:w-[220px] h-9"
            />
          </div>
          <Button size="sm" onClick={openCreateDialog} className="gap-1.5">
            <Plus className="h-4 w-4" />
            Добавить контакт
          </Button>
        </div>
      </div>

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
        <div className="border border-border rounded-lg overflow-hidden">
          <div className="bg-muted/50 px-4 py-3 flex gap-6">
            {['Имя', 'Компания', 'Телефон', 'Email', 'Этап', 'Создан', ''].map(
              (col) => (
                <Skeleton key={col} className="h-4 w-16" />
              )
            )}
          </div>
          {Array.from({ length: 5 }).map((_, i) => (
            <div key={i} className="px-4 py-3 flex gap-6 border-b border-border last:border-0">
              {Array.from({ length: 7 }).map((_, j) => (
                <Skeleton key={j} className="h-4 flex-1" />
              ))}
            </div>
          ))}
        </div>
      )}

      {/* ── Empty State ────────────────────────────────────────────────────── */}
      {!loading && !error && contacts.length === 0 && (
        <div className="flex flex-col items-center justify-center py-20 gap-4">
          <div className="h-14 w-14 rounded-full bg-muted/50 flex items-center justify-center">
            <Users className="h-7 w-7 text-muted-foreground" />
          </div>
          <div className="text-center">
            <p className="text-base font-medium text-foreground">Нет контактов</p>
            <p className="text-sm text-muted-foreground mt-1">
              Добавьте первый контакт, чтобы начать
            </p>
          </div>
          <Button size="sm" onClick={openCreateDialog} className="gap-1.5">
            <Plus className="h-4 w-4" />
            Добавить контакт
          </Button>
        </div>
      )}

      {/* ── Search No Results ──────────────────────────────────────────────── */}
      {!loading && !error && contacts.length > 0 && filteredContacts.length === 0 && (
        <div className="flex flex-col items-center justify-center py-16 gap-3">
          <Search className="h-8 w-8 text-muted-foreground" />
          <p className="text-sm text-muted-foreground">
            Контакты по запросу &ldquo;{searchQuery}&rdquo; не найдены
          </p>
          <Button
            variant="outline"
            size="sm"
            onClick={() => setSearchQuery('')}
          >
            Очистить
          </Button>
        </div>
      )}

      {/* ── Table ──────────────────────────────────────────────────────────── */}
      {!loading && !error && filteredContacts.length > 0 && (
        <div className="border border-border rounded-lg overflow-hidden flex-1">
          <div className="overflow-x-auto">
            <Table>
              <TableHeader>
                <TableRow className="bg-muted/50 hover:bg-muted/50">
                  <TableHead className="pl-4">Имя</TableHead>
                  <TableHead>Компания</TableHead>
                  <TableHead>Телефон</TableHead>
                  <TableHead>Email</TableHead>
                  <TableHead>Этап</TableHead>
                  <TableHead>Создан</TableHead>
                  <TableHead className="pr-4 text-right"></TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredContacts.map((contact) => (
                  <TableRow key={contact.id} className="hover:bg-accent/50">
                    <TableCell className="pl-4 font-medium text-foreground">
                      {contact.name}
                    </TableCell>
                    <TableCell className="text-muted-foreground">
                      {contact.company || '—'}
                    </TableCell>
                    <TableCell className="text-muted-foreground">
                      {contact.phone || '—'}
                    </TableCell>
                    <TableCell className="text-muted-foreground">
                      {contact.email || '—'}
                    </TableCell>
                    <TableCell>
                      <Badge
                        variant="outline"
                        className={`text-xs capitalize ${getStageBadgeVariant(contact.stage)}`}
                      >
                        {contact.stage || 'Лид'}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-muted-foreground text-xs">
                      {formatDate(contact.created_at)}
                    </TableCell>
                    <TableCell className="pr-4 text-right">
                      <div className="flex items-center justify-end gap-1">
                        <button
                          onClick={() => openEditDialog(contact)}
                          className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted transition-colors"
                          aria-label={`Редактировать ${contact.name}`}
                        >
                          <Pencil className="h-3.5 w-3.5" />
                        </button>
                        <button
                          onClick={() => handleDelete(contact)}
                          className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                          aria-label={`Удалить ${contact.name}`}
                        >
                          <Trash2 className="h-3.5 w-3.5" />
                        </button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </div>
        </div>
      )}

      {/* ── Create / Edit Dialog ───────────────────────────────────────────── */}
      <Dialog open={dialogOpen} onOpenChange={(open) => {
        setDialogOpen(open)
        if (!open) {
          setEditingContact(null)
          setForm(EMPTY_FORM)
        }
      }}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              {editingContact ? (
                <>
                  <Pencil className="h-5 w-5" />
                  Редактировать контакт
                </>
              ) : (
                <>
                  <Plus className="h-5 w-5" />
                  Новый контакт
                </>
              )}
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            {/* Name */}
            <div className="space-y-2">
              <Label htmlFor="contact-name">
                Имя <span className="text-destructive">*</span>
              </Label>
              <Input
                id="contact-name"
                placeholder="напр. Иван Иванов"
                value={form.name}
                onChange={(e) => setForm((f) => ({ ...f, name: e.target.value }))}
                onKeyDown={(e) => {
                  if (e.key === 'Enter') handleSave()
                }}
              />
            </div>

            {/* Company */}
            <div className="space-y-2">
              <Label htmlFor="contact-company">Компания</Label>
              <Input
                id="contact-company"
                placeholder={'напр. ООО "Вектор"'}
                value={form.company}
                onChange={(e) => setForm((f) => ({ ...f, company: e.target.value }))}
              />
            </div>

            {/* Phone + Email */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="contact-phone">Телефон</Label>
                <Input
                  id="contact-phone"
                  placeholder="+7 (999) 000-0000"
                  value={form.phone}
                  onChange={(e) => setForm((f) => ({ ...f, phone: e.target.value }))}
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="contact-email">Email</Label>
                <Input
                  id="contact-email"
                  type="email"
                  placeholder="user@example.com"
                  value={form.email}
                  onChange={(e) => setForm((f) => ({ ...f, email: e.target.value }))}
                />
              </div>
            </div>

            {/* Stage */}
            <div className="space-y-2">
              <Label>Этап</Label>
              <Select
                value={form.stage}
                onValueChange={(v) => setForm((f) => ({ ...f, stage: v as ContactStage }))}
              >
                <SelectTrigger className="w-full">
                  <SelectValue placeholder="Выберите этап" />
                </SelectTrigger>
                <SelectContent>
                  {STAGE_OPTIONS.map((stage) => (
                    <SelectItem key={stage} value={stage}>
                      {stage}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            {/* Actions */}
            <div className="flex justify-end gap-2 pt-2">
              <Button
                variant="outline"
                onClick={() => {
                  setDialogOpen(false)
                  setEditingContact(null)
                  setForm(EMPTY_FORM)
                }}
              >
                Отмена
              </Button>
              <Button
                onClick={handleSave}
                disabled={!form.name.trim() || saving}
              >
                {saving
                  ? 'Сохранение...'
                  : editingContact
                    ? 'Обновить контакт'
                    : 'Создать контакт'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
