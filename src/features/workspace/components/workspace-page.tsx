'use client'

import { useState, useEffect, useMemo, useCallback, useRef } from 'react'
import { supabase } from '@/lib/supabase/client'
import type {
  Company,
  CompanyContact,
  Task,
  TaskInsert,
  Proposal,
  ProposalItem,
  Activity,
  ActivityInsert,
  Comment,
  CommentInsert,
  Deal,
  PipelineStage,
} from '@/lib/supabase/database.types'
import { useAuthStore, useNavigationStore } from '@/lib/store'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Separator } from '@/components/ui/separator'
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/tabs'
import { Checkbox } from '@/components/ui/checkbox'
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
import { toast } from 'sonner'
import {
  Search,
  Plus,
  Building2,
  MapPin,
  Phone,
  Mail,
  Globe,
  Calendar,
  User,
  FileText,
  CheckSquare,
  MessageSquare,
  Pencil,
  Trash2,
  Send,
  Clock,
  ArrowLeft,
  Briefcase,
  ChevronLeft,
  ChevronRight,
  StickyNote,
  Tag,
  X,
  Loader2,
  Upload,
  Download,
  Image as ImageIcon,
} from 'lucide-react'

// ─── Helpers ──────────────────────────────────────────────────────────────────

const formatCurrency = (v: number | null) =>
  new Intl.NumberFormat('ru-RU', { style: 'currency', currency: 'RUB', maximumFractionDigits: 0 }).format(v || 0)

function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('ru-RU', { day: 'numeric', month: 'short', year: 'numeric' })
}

function formatDateTime(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('ru-RU', { day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit' })
}

function relativeTime(dateStr: string): string {
  const now = Date.now()
  const then = new Date(dateStr).getTime()
  const diffMin = Math.floor((now - then) / 60000)
  if (diffMin < 1) return 'только что'
  if (diffMin < 60) return `${diffMin} мин. назад`
  const diffH = Math.floor(diffMin / 60)
  if (diffH < 24) return `${diffH} ч. назад`
  const diffD = Math.floor(diffH / 24)
  if (diffD < 7) return `${diffD} дн. назад`
  return formatDate(dateStr)
}

function formatFileSize(bytes: number): string {
  if (!bytes) return '—'
  if (bytes < 1024) return bytes + ' Б'
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' КБ'
  return (bytes / (1024 * 1024)).toFixed(1) + ' МБ'
}

const STATUS_BADGE: Record<string, string> = {
  'слабый интерес': 'bg-muted text-muted-foreground border-transparent',
  'надо залечивать': 'bg-amber-500/10 text-amber-600 border-amber-500/20',
  'сделал запрос': 'bg-sky-500/10 text-sky-600 border-sky-500/20',
  'сделал заказ': 'bg-emerald-500/10 text-emerald-600 border-emerald-500/20',
}

const PROPOSAL_BADGE: Record<string, string> = {
  'отправлено': 'bg-sky-500/10 text-sky-600 border-sky-500/20',
  'рассматривается': 'bg-amber-500/10 text-amber-600 border-amber-500/20',
  'принято': 'bg-emerald-500/10 text-emerald-600 border-emerald-500/20',
  'отклонено': 'bg-red-500/10 text-red-600 border-red-500/20',
}

const PRIORITY_LABELS: Record<string, string> = { low: 'Низкий', medium: 'Средний', high: 'Высокий' }
const PRIORITY_BADGE: Record<string, string> = {
  low: 'bg-muted text-muted-foreground',
  medium: 'bg-amber-500/10 text-amber-600',
  high: 'bg-red-500/10 text-red-600',
}

function getActivityIcon(type: string | null) {
  switch (type) {
    case 'звонок': return <Phone className="h-3.5 w-3.5" />
    case 'письмо': return <Mail className="h-3.5 w-3.5" />
    case 'whatsapp': return <MessageSquare className="h-3.5 w-3.5" />
    case 'встреча': return <User className="h-3.5 w-3.5" />
    case 'кп_отправлено': return <FileText className="h-3.5 w-3.5" />
    case 'заметка': return <StickyNote className="h-3.5 w-3.5" />
    case 'статус_изменен': return <CheckSquare className="h-3.5 w-3.5" />
    default: return <StickyNote className="h-3.5 w-3.5" />
  }
}

const ACTIVITY_ICON_BG: Record<string, string> = {
  'звонок': 'bg-emerald-500/10 text-emerald-600',
  'письмо': 'bg-sky-500/10 text-sky-600',
  'whatsapp': 'bg-green-500/10 text-green-600',
  'встреча': 'bg-violet-500/10 text-violet-600',
  'кп_отправлено': 'bg-amber-500/10 text-amber-600',
  'заметка': 'bg-muted text-muted-foreground',
  'статус_изменен': 'bg-rose-500/10 text-rose-600',
}

function getTodayStr(): string {
  const n = new Date()
  return `${n.getFullYear()}-${String(n.getMonth() + 1).padStart(2, '0')}-${String(n.getDate()).padStart(2, '0')}`
}

// ─── Component ───────────────────────────────────────────────────────────────

export function WorkspacePage() {
  const currentUser = useAuthStore((s) => s.currentUser)
  const openCompany = useNavigationStore((s) => s.openCompany)

  // ─── State ─────────────────────────────────────────────────────────────────
  const [companies, setCompanies] = useState<Company[]>([])
  const [searchQuery, setSearchQuery] = useState('')
  const [loading, setLoading] = useState(true)
  const [selectedId, setSelectedId] = useState<string | null>(null)

  // Selected company data
  const [company, setCompany] = useState<Company | null>(null)
  const [contacts, setContacts] = useState<CompanyContact[]>([])
  const [tasks, setTasks] = useState<Task[]>([])
  const [proposals, setProposals] = useState<Proposal[]>([])
  const [proposalItems, setProposalItems] = useState<Record<string, ProposalItem[]>>({})
  const [activities, setActivities] = useState<Activity[]>([])
  const [comments, setComments] = useState<Comment[]>([])
  const [companyDeals, setCompanyDeals] = useState<Deal[]>([])
  const [pipelineStages, setPipelineStages] = useState<PipelineStage[]>([])
  const [activeTab, setActiveTab] = useState('info')

  // Tags state
  const [allTags, setAllTags] = useState<{ id: string; name: string; color: string }[]>([])
  const [companyTags, setCompanyTags] = useState<string[]>([])
  const [addingTag, setAddingTag] = useState(false)

  // Task dialog
  const [taskDialogOpen, setTaskDialogOpen] = useState(false)
  const [taskForm, setTaskForm] = useState({ title: '', description: '', priority: 'medium', deadline: getTodayStr() })
  const [savingTask, setSavingTask] = useState(false)

  // Comment input
  const [commentText, setCommentText] = useState('')
  const [savingComment, setSavingComment] = useState(false)

  // File upload
  const [files, setFiles] = useState<{name: string; id: string; created_at: string; metadata: Record<string, unknown>}[]>([])
  const [uploadingFile, setUploadingFile] = useState(false)
  const fileInputRef = useRef<HTMLInputElement>(null)

  // Fetch trigger
  const [fetchTrigger, setFetchTrigger] = useState(0)
  const refresh = () => setFetchTrigger((n) => n + 1)

  // ─── Data Fetching ──────────────────────────────────────────────────────────

  useEffect(() => {
    let cancelled = false
    async function load() {
      try {
        const { data, error } = await supabase
          .from('companies')
          .select('*')
          .order('name')
        if (cancelled) return
        if (error) {
          toast.error('Ошибка загрузки компаний: ' + error.message)
        } else {
          setCompanies(data ?? [])
          // Auto-select first company
          if (data && data.length > 0 && !selectedId) {
            setSelectedId(data[0].id)
          }
        }
      } catch (err) {
        if (!cancelled) toast.error('Не удалось загрузить компании')
      }
      setLoading(false)
    }
    load()
    return () => { cancelled = true }
  }, [fetchTrigger, selectedId])

  // Fetch selected company details
  useEffect(() => {
    if (!selectedId) {
      setCompany(null)
      setContacts([])
      setTasks([])
      setProposals([])
      setActivities([])
      setComments([])
      setCompanyDeals([])
      setPipelineStages([])
      setFiles([])
      setCompanyTags([])
      setAddingTag(false)
      return
    }

    let cancelled = false
    async function loadDetails() {
      const results = await Promise.allSettled([
        supabase.from('companies').select('*').eq('id', selectedId).single(),
        supabase.from('company_contacts').select('*').eq('company_id', selectedId).order('is_primary', { ascending: false }),
        supabase.from('tasks').select('*').eq('company_id', selectedId).order('created_at', { ascending: false }),
        supabase.from('proposals').select('*').eq('company_id', selectedId).order('created_at', { ascending: false }),
        supabase.from('activities').select('*').eq('company_id', selectedId).order('created_at', { ascending: false }).limit(50),
        supabase.from('comments').select('*').eq('entity_id', selectedId).order('created_at', { ascending: false }).limit(100),
        supabase.from('pipeline_stages').select('*').order('position'),
        supabase.from('deals').select('*').eq('client_id', selectedId).order('created_at', { ascending: false }),
      ])

      if (cancelled) return
      setCompany(results[0].status === 'fulfilled' ? results[0].value : null)
      setContacts(results[1].status === 'fulfilled' ? (results[1].value?.data ?? []) : [])
      setTasks(results[2].status === 'fulfilled' ? (results[2].value?.data ?? []) : [])
      const propData = results[3].status === 'fulfilled' ? (results[3].value?.data ?? []) : []
      setProposals(propData)

      // Load proposal items for each proposal
      if (propData.length > 0) {
        const itemsMap: Record<string, ProposalItem[]> = {}
        const itemResults = await Promise.allSettled(
          propData.map((p: Proposal) =>
            supabase.from('proposal_items').select('*').eq('proposal_id', p.id)
          )
        )
        propData.forEach((p: Proposal, i: number) => {
          if (itemResults[i].status === 'fulfilled' && itemResults[i].value?.data) {
            itemsMap[p.id] = itemResults[i].value!.data
          }
        })
        setProposalItems(itemsMap)
      }

      setActivities(results[4].status === 'fulfilled' ? (results[4].value?.data ?? []) : [])
      setComments(results[5].status === 'fulfilled' ? (results[5].value?.data ?? []) : [])
      setPipelineStages(results[6].status === 'fulfilled' ? (results[6].value?.data ?? []) : [])
      setCompanyDeals(results[7].status === 'fulfilled' ? (results[7].value?.data ?? []) : [])

      // Load files
      const filesResult = await supabase.storage.from('crm-files').list(selectedId, { sortBy: { column: 'created_at', order: 'desc' } })
      if (!cancelled) setFiles(filesResult.data ?? [])

      // Load company tags
      try {
        const SETTINGS_TAGS_ID = '00000001-0000-0000-0000-000000000001'
        const { data: settingsData } = await supabase
          .from('activities')
          .select('content')
          .eq('id', SETTINGS_TAGS_ID)
          .eq('type', 'settings')
          .single()
        if (settingsData?.content && !cancelled) {
          try { setAllTags(JSON.parse(settingsData.content)) } catch { /* ignore */ }
        }
      } catch { /* ignore */ }

      // Load company tags
      try {
        const { data: tagRows } = await supabase
          .from('activities')
          .select('content')
          .eq('company_id', selectedId)
          .eq('type', 'company_tag')
        if (tagRows && !cancelled) {
          setCompanyTags(tagRows.map((r) => r.content))
        }
      } catch { /* ignore */ }
    }
    loadDetails()
    return () => { cancelled = true }
  }, [selectedId])

  // ─── Tag helpers ──────────────────────────────────────────────────────────

  async function addTagToCompany(tagName: string) {
    if (!selectedId) return
    await supabase.from('activities').insert({
      company_id: selectedId,
      type: 'company_tag',
      content: tagName,
      user_id: null,
    })
    setCompanyTags((prev) => [...prev, tagName])
    setAddingTag(false)
  }

  async function removeTagFromCompany(tagName: string) {
    if (!selectedId) return
    await supabase
      .from('activities')
      .delete()
      .eq('company_id', selectedId)
      .eq('type', 'company_tag')
      .eq('content', tagName)
    setCompanyTags((prev) => prev.filter((t) => t !== tagName))
  }

  // ─── Computed ───────────────────────────────────────────────────────────────

  const filteredCompanies = useMemo(() => {
    if (!searchQuery.trim()) return companies
    const q = searchQuery.toLowerCase()
    return companies.filter(
      (c) =>
        c.name?.toLowerCase().includes(q) ||
        c.inn?.toLowerCase().includes(q) ||
        c.city?.toLowerCase().includes(q) ||
        c.manager_name?.toLowerCase().includes(q)
    )
  }, [companies, searchQuery])

  const taskStats = useMemo(() => {
    const total = tasks.length
    const done = tasks.filter((t) => t.status === 'done').length
    const overdue = tasks.filter((t) => t.status !== 'done' && t.deadline && t.deadline < getTodayStr()).length
    return { total, done, overdue }
  }, [tasks])

  // ─── Actions ─────────────────────────────────────────────────────────────────

  const handleCreateTask = async () => {
    if (!selectedId || !taskForm.title.trim()) {
      toast.error('Укажите название задачи')
      return
    }
    if (!taskForm.deadline) {
      toast.error('Укажите срок выполнения')
      return
    }
    setSavingTask(true)
    try {
      const { error } = await supabase.from('tasks').insert({
        title: taskForm.title.trim(),
        description: taskForm.description.trim() || null,
        status: 'todo',
        priority: taskForm.priority,
        deadline: taskForm.deadline,
        company_id: selectedId,
        created_by: currentUser?.id,
      } as TaskInsert)
      if (error) throw error

      // Log activity
      await supabase.from('activities').insert({
        company_id: selectedId,
        user_id: currentUser?.id,
        type: 'заметка',
        content: `Создана задача «${taskForm.title.trim()}»`,
      } as ActivityInsert)

      toast.success('Задача создана')
      setTaskDialogOpen(false)
      setTaskForm({ title: '', description: '', priority: 'medium', deadline: getTodayStr() })
      refresh()
    } catch (err: any) {
      toast.error('Ошибка создания задачи: ' + (err?.message || ''))
    }
    setSavingTask(false)
  }

  const toggleTask = async (task: Task) => {
    const newStatus = task.status === 'done' ? 'todo' : 'done'
    const { error } = await supabase.from('tasks').update({ status: newStatus }).eq('id', task.id)
    if (error) {
      toast.error('Ошибка: ' + error.message)
    } else {
      toast.success(newStatus === 'done' ? 'Задача выполнена' : 'Задача возвращена в работу')
      refresh()
    }
  }

  const deleteTask = async (taskId: string) => {
    if (!window.confirm('Удалить задачу?')) return
    const { error } = await supabase.from('tasks').delete().eq('id', taskId)
    if (error) {
      toast.error('Ошибка: ' + error.message)
    } else {
      toast.success('Задача удалена')
      refresh()
    }
  }

  const handleAddComment = async () => {
    if (!selectedId || !commentText.trim()) return
    setSavingComment(true)
    try {
      const { error } = await supabase.from('comments').insert({
        text: commentText.trim(),
        user_id: currentUser?.id,
        entity_id: selectedId,
      } as CommentInsert)
      if (error) throw error
      setCommentText('')
      toast.success('Комментарий добавлен')
      refresh()
    } catch {
      toast.error('Ошибка добавления комментария')
    }
    setSavingComment(false)
  }

  const changeProposalStatus = async (proposal: Proposal, newStatus: string) => {
    const { error } = await supabase.from('proposals').update({ status: newStatus }).eq('id', proposal.id)
    if (!error) {
      toast.success(`Статус КП изменён на «${newStatus}»`)
      refresh()
    }
  }

  // ─── Deal Actions ─────────────────────────────────────────────────────

  const moveDeal = async (deal: Deal, newIndex: number) => {
    if (newIndex < 0 || newIndex >= pipelineStages.length) return
    const newStage = pipelineStages[newIndex]
    const { error } = await supabase
      .from('deals')
      .update({ stage_id: newStage.id })
      .eq('id', deal.id)
    if (!error) {
      toast.success(`Сделка «${deal.title}» перемещена в «${newStage.name}»`)
      await supabase.from('activities').insert({
        company_id: selectedId,
        content: `Перемещена сделка «${deal.title}» в ${newStage.name}`,
        type: 'заметка',
        user_id: currentUser?.id,
      } as ActivityInsert).catch(() => {})
      refresh()
    } else {
      toast.error('Ошибка: ' + error.message)
    }
  }

  const deleteDeal = async (deal: Deal) => {
    if (!window.confirm(`Удалить сделку «${deal.title}»?`)) return
    const { error } = await supabase
      .from('deals')
      .delete()
      .eq('id', deal.id)
    if (!error) {
      toast.success(`Сделка «${deal.title}» удалена`)
      await supabase.from('activities').insert({
        company_id: selectedId,
        content: `Удалена сделка «${deal.title}»`,
        type: 'заметка',
        user_id: currentUser?.id,
      } as ActivityInsert).catch(() => {})
      refresh()
    } else {
      toast.error('Ошибка: ' + error.message)
    }
  }

  // ─── File Handlers ───────────────────────────────────────────────────────

  const handleUploadFile = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file || !selectedId) return
    setUploadingFile(true)
    const { error } = await supabase.storage.from('crm-files').upload(`${selectedId}/${file.name}`, file)
    if (error) {
      toast.error('Ошибка загрузки: ' + error.message)
    } else {
      toast.success('Файл загружен')
      const { data } = await supabase.storage.from('crm-files').list(selectedId)
      if (data) setFiles(data)
    }
    setUploadingFile(false)
    if (fileInputRef.current) fileInputRef.current.value = ''
  }

  const handleDeleteFile = async (fileName: string) => {
    if (!selectedId || !window.confirm(`Удалить файл "${fileName}"?`)) return
    const { error } = await supabase.storage.from('crm-files').remove([`${selectedId}/${fileName}`])
    if (!error) {
      toast.success('Файл удалён')
      const { data } = await supabase.storage.from('crm-files').list(selectedId)
      if (data) setFiles(data)
    }
  }

  const getFileUrl = (fileName: string) => {
    return supabase.storage.from('crm-files').getPublicUrl(`${selectedId}/${fileName}`).data.publicUrl
  }

  // ─── Render ─────────────────────────────────────────────────────────────────

  if (loading) {
    return (
      <div className="flex gap-4 h-[calc(100vh-8rem)]">
        <div className="w-72 shrink-0 space-y-3">
          <Skeleton className="h-10 w-full" />
          {Array.from({ length: 8 }).map((_, i) => (
            <Skeleton key={i} className="h-14 w-full rounded-xl" />
          ))}
        </div>
        <div className="flex-1">
          <Skeleton className="h-10 w-full" />
          <Skeleton className="h-[600px] w-full mt-4 rounded-xl" />
        </div>
      </div>
    )
  }

  return (
    <div className="flex gap-4 h-[calc(100vh-8rem)]">
      {/* ── LEFT: Client List ─────────────────────────────────────────── */}
      <div className="w-72 shrink-0 flex flex-col bg-card/50 rounded-2xl border border-border/60 shadow-sm overflow-hidden">
        {/* Search */}
        <div className="p-3 border-b border-border/60">
          <div className="relative">
            <Search className="absolute left-2.5 top-1/2 -translate-y-1/2 h-3.5 w-3.5 text-muted-foreground pointer-events-none" />
            <Input
              placeholder="Поиск клиентов..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="h-9 pl-8 text-sm rounded-xl"
            />
          </div>
        </div>

        {/* Company List */}
        <ScrollArea className="flex-1">
          <div className="p-2 space-y-1">
            {filteredCompanies.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-12 gap-2">
                <Building2 className="h-8 w-8 text-muted-foreground" />
                <p className="text-xs text-muted-foreground">Нет клиентов</p>
              </div>
            ) : (
              filteredCompanies.map((c) => (
                <button
                  key={c.id}
                  onClick={() => setSelectedId(c.id)}
                  className={`w-full text-left px-3 py-2.5 rounded-xl transition-all duration-150 group ${
                    selectedId === c.id
                      ? 'bg-primary/10 border border-primary/20'
                      : 'hover:bg-muted/60 border border-transparent'
                  }`}
                >
                  <div className="flex items-center gap-2">
                    <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-primary/10 text-primary text-xs font-bold">
                      {(c.name || '?')[0]}
                    </div>
                    <div className="min-w-0 flex-1">
                      <p className={`text-sm font-medium truncate ${selectedId === c.id ? 'text-primary' : 'text-foreground'}`}>
                        {c.name}
                      </p>
                      <div className="flex items-center gap-1.5 mt-0.5">
                        {c.status && (
                          <span className={`inline-flex items-center rounded-md px-1.5 py-0 text-[10px] font-medium ${STATUS_BADGE[c.status] ?? 'bg-muted text-muted-foreground'}`}>
                            {c.status}
                          </span>
                        )}
                        {c.city && (
                          <span className="text-[10px] text-muted-foreground truncate">{c.city}</span>
                        )}
                      </div>
                    </div>
                    {selectedId === c.id && (
                      <ChevronRight className="h-4 w-4 text-primary shrink-0" />
                    )}
                  </div>
                </button>
              ))
            )}
          </div>
        </ScrollArea>

        {/* Count */}
        <div className="px-3 py-2 border-t border-border/60 text-[10px] text-muted-foreground">
          {filteredCompanies.length} из {companies.length} клиентов
        </div>
      </div>

      {/* ── RIGHT: Client Workspace ───────────────────────────────────── */}
      <div className="flex-1 min-w-0">
        {!selectedId || !company ? (
          <div className="flex flex-col items-center justify-center h-full gap-4">
            <div className="h-16 w-16 rounded-2xl bg-muted/50 flex items-center justify-center">
              <Briefcase className="h-8 w-8 text-muted-foreground" />
            </div>
            <div className="text-center">
              <p className="text-base font-medium text-foreground">Рабочая область</p>
              <p className="text-sm text-muted-foreground mt-1">Выберите клиента из списка слева</p>
            </div>
          </div>
        ) : (
          <div className="h-full flex flex-col">
            {/* Company Header */}
            <div className="bg-card rounded-2xl border border-border/60 shadow-sm p-4 mb-4">
              <div className="flex items-start justify-between gap-3">
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2">
                    <h2 className="text-lg font-bold text-foreground truncate">{company.name}</h2>
                    {company.status && (
                      <span className={`inline-flex items-center rounded-lg px-2 py-0.5 text-xs font-medium ${STATUS_BADGE[company.status] ?? 'bg-muted text-muted-foreground'}`}>
                        {company.status}
                      </span>
                    )}
                  </div>
                  <div className="flex flex-wrap items-center gap-3 mt-2 text-sm text-muted-foreground">
                    {company.inn && <span className="flex items-center gap-1"><span className="text-xs">ИНН: {company.inn}</span></span>}
                    {company.city && <span className="flex items-center gap-1"><MapPin className="h-3 w-3" />{company.city}</span>}
                    {company.contact_phone && <span className="flex items-center gap-1"><Phone className="h-3 w-3" />{company.contact_phone}</span>}
                    {company.contact_email && <span className="flex items-center gap-1"><Mail className="h-3 w-3" />{company.contact_email}</span>}
                    {company.website && <span className="flex items-center gap-1"><Globe className="h-3 w-3" />{company.website}</span>}
                  </div>
                  {(company.manager_id || company.manager_name) && (
                    <p className="text-xs text-muted-foreground mt-1">
                      Менеджер: {company.manager_name || '—'}
                    </p>
                  )}
                </div>
                <Button variant="outline" size="sm" className="gap-1.5 rounded-xl shrink-0" onClick={() => openCompany(company.id)}>
                  <ArrowLeft className="h-3.5 w-3.5" />
                  Карточка
                </Button>
              </div>
            </div>

            {/* Tabs */}
            <div className="flex-1 min-h-0">
              <Tabs value={activeTab} onValueChange={setActiveTab} className="h-full flex flex-col">
                <TabsList className="w-full bg-muted/60 rounded-xl p-1 shrink-0">
                  <TabsTrigger value="info" className="rounded-lg text-xs gap-1.5">
                    Информация
                  </TabsTrigger>
                  <TabsTrigger value="proposals" className="rounded-lg text-xs gap-1.5">
                    КП ({proposals.length})
                  </TabsTrigger>
                  <TabsTrigger value="deals" className="rounded-lg text-xs gap-1.5">
                    Сделки ({companyDeals.length})
                  </TabsTrigger>
                  <TabsTrigger value="tasks" className="rounded-lg text-xs gap-1.5">
                    Задачи ({taskStats.total})
                  </TabsTrigger>
                  <TabsTrigger value="history" className="rounded-lg text-xs gap-1.5">
                    История
                  </TabsTrigger>
                  <TabsTrigger value="comments" className="rounded-lg text-xs gap-1.5">
                    Комментарии
                  </TabsTrigger>
                  <TabsTrigger value="files" className="rounded-lg text-xs gap-1.5">
                    Файлы
                  </TabsTrigger>
                </TabsList>

                <div className="flex-1 min-h-0 overflow-y-auto mt-4">
                  {/* TAB: Info */}
                  <TabsContent value="info" className="mt-0">
                    <div className="space-y-4">
                      {/* Contacts */}
                      <Card className="rounded-xl border border-border/60 shadow-sm">
                        <CardHeader className="pb-2">
                          <CardTitle className="text-sm font-medium">Контакты ЛПР</CardTitle>
                        </CardHeader>
                        <CardContent>
                          {contacts.length === 0 ? (
                            <p className="text-sm text-muted-foreground py-2">Нет контактов</p>
                          ) : (
                            <div className="space-y-2">
                              {contacts.map((c) => (
                                <div key={c.id} className="flex items-center gap-3 py-2 border-b border-border/40 last:border-0 last:pb-0">
                                  <div className="h-8 w-8 rounded-lg bg-primary/10 flex items-center justify-center text-xs font-bold text-primary">
                                    {(c.name || '?')[0]}
                                  </div>
                                  <div className="min-w-0 flex-1">
                                    <p className="text-sm font-medium">{c.name} {c.is_primary && <Badge className="text-[10px] bg-amber-500/10 text-amber-600 border-transparent ml-1">Осн.</Badge>}</p>
                                    {c.position && <p className="text-xs text-muted-foreground">{c.position}</p>}
                                    <div className="flex items-center gap-3 mt-1">
                                      {c.phone && <a href={`tel:${c.phone}`} className="text-xs text-muted-foreground hover:text-primary">{c.phone}</a>}
                                      {c.email && <a href={`mailto:${c.email}`} className="text-xs text-muted-foreground hover:text-primary truncate max-w-[180px]">{c.email}</a>}
                                      {c.whatsapp && <a href={`https://wa.me/${c.whatsapp.replace(/\D/g, '')}`} className="text-xs text-green-600 hover:text-green-500">{c.whatsapp}</a>}
                                    </div>
                                  </div>
                                </div>
                              ))}
                            </div>
                          )}
                        </CardContent>
                      </Card>

                      {/* Notes */}
                      {company.notes && (
                        <Card className="rounded-xl border border-border/60 shadow-sm">
                          <CardHeader className="pb-2">
                            <CardTitle className="text-sm font-medium">Заметки</CardTitle>
                          </CardHeader>
                          <CardContent>
                            <p className="text-sm text-muted-foreground whitespace-pre-wrap">{company.notes}</p>
                          </CardContent>
                        </Card>
                      )}

                      {/* Tags */}
                      <Card className="rounded-xl border border-border/60 shadow-sm">
                        <CardHeader className="pb-2">
                          <CardTitle className="text-sm font-medium flex items-center gap-1.5">
                            <Tag className="h-3.5 w-3.5" />
                            Теги
                          </CardTitle>
                        </CardHeader>
                        <CardContent>
                          <div className="flex flex-wrap gap-1.5">
                            {companyTags.map((tag) => {
                              const tagInfo = allTags.find((t) => t.name === tag)
                              return (
                                <Badge
                                  key={tag}
                                  variant="outline"
                                  className="text-xs gap-1 pl-2 pr-1 py-0.5 cursor-pointer hover:opacity-80 transition-opacity"
                                  style={{
                                    backgroundColor: (tagInfo?.color || '#94a3b8') + '18',
                                    color: tagInfo?.color || '#94a3b8',
                                    borderColor: (tagInfo?.color || '#94a3b8') + '30',
                                  }}
                                >
                                  {tag}
                                  <button
                                    onClick={() => removeTagFromCompany(tag)}
                                    className="ml-0.5 h-3.5 w-3.5 inline-flex items-center justify-center rounded-full hover:bg-black/10"
                                  >
                                    <X className="h-2.5 w-2.5" />
                                  </button>
                                </Badge>
                              )
                            })}
                            {allTags
                              .filter((t) => !companyTags.includes(t.name))
                              .length > 0 && !addingTag && (
                              <button
                                onClick={() => setAddingTag(true)}
                                className="h-6 px-2 rounded-lg border border-dashed border-muted-foreground/40 text-xs text-muted-foreground hover:border-foreground/40 hover:text-foreground transition-colors"
                              >
                                <Plus className="h-3 w-3 mr-1" />
                                Добавить
                              </button>
                            )}
                            {addingTag && (
                              <div className="flex flex-wrap gap-1">
                                {allTags
                                  .filter((t) => !companyTags.includes(t.name))
                                  .map((t) => (
                                    <button
                                      key={t.id}
                                      onClick={() => addTagToCompany(t.name)}
                                      className="h-6 px-2 rounded-lg border border-dashed text-xs hover:bg-muted/50 transition-colors"
                                      style={{
                                        color: t.color,
                                        borderColor: t.color + '40',
                                      }}
                                    >
                                      {t.name}
                                    </button>
                                  ))}
                                <button
                                  onClick={() => setAddingTag(false)}
                                  className="h-6 px-2 rounded-lg text-xs text-muted-foreground hover:text-foreground transition-colors"
                                >
                                  Отмена
                                </button>
                              </div>
                            )}
                          </div>
                          {companyTags.length === 0 && !addingTag && allTags.length === 0 && (
                            <p className="text-sm text-muted-foreground py-1">Нет тегов. Добавьте теги в настройках.</p>
                          )}
                        </CardContent>
                      </Card>

                      {/* Next Contact */}
                      {company.next_contact_date && (
                        <Card className="rounded-xl border border-border/60 shadow-sm">
                          <CardContent className="pt-4">
                            <div className="flex items-center gap-2">
                              <Calendar className="h-4 w-4 text-muted-foreground" />
                              <span className="text-sm text-muted-foreground">
                                Следующий контакт: {formatDate(company.next_contact_date)}
                              </span>
                            </div>
                          </CardContent>
                        </Card>
                      )}
                    </div>
                  </TabsContent>

                  {/* TAB: Proposals (КП) */}
                  <TabsContent value="proposals" className="mt-0">
                    <div className="space-y-3">
                      {proposals.length === 0 ? (
                        <Card className="rounded-xl border border-border/60 shadow-sm p-6">
                          <p className="text-sm text-muted-foreground text-center">Нет коммерческих предложений</p>
                        </Card>
                      ) : (
                        proposals.map((p) => (
                          <Card key={p.id} className="rounded-xl border border-border/60 shadow-sm">
                            <CardContent className="p-4">
                              <div className="flex items-start justify-between gap-2">
                                <div className="min-w-0 flex-1">
                                  <div className="flex items-center gap-2">
                                    <p className="text-sm font-medium">{p.number ? `КП №${p.number}` : 'КП'}</p>
                                    <Select
                                      value={p.status || 'отправлено'}
                                      onValueChange={(v) => changeProposalStatus(p, v)}
                                    >
                                      <SelectTrigger className="h-7 w-32 text-xs">
                                        <SelectValue />
                                      </SelectTrigger>
                                      <SelectContent>
                                        {['отправлено', 'рассматривается', 'принято', 'отклонено'].map((s) => (
                                          <SelectItem key={s} value={s}>{s}</SelectItem>
                                        ))}
                                      </SelectContent>
                                    </Select>
                                  </div>
                                  <p className="text-base font-semibold text-foreground mt-1">{formatCurrency(p.total_amount || 0)}</p>
                                </div>
                              </div>
                              {/* Items */}
                              {proposalItems[p.id] && proposalItems[p.id].length > 0 && (
                                <div className="mt-3 border-t border-border/40 pt-3">
                                  {proposalItems[p.id].map((item) => (
                                    <div key={item.id} className="flex justify-between text-xs text-muted-foreground py-1">
                                      <span>{item.product_name} × {item.quantity || 0} {item.unit || 'шт'}</span>
                                      <span className="font-medium">{formatCurrency(item.price_per_unit || 0)}</span>
                                    </div>
                                  ))}
                                </div>
                              )}
                              {p.notes && <p className="text-xs text-muted-foreground mt-2">{p.notes}</p>}
                              <p className="text-[10px] text-muted-foreground/60 mt-2">{formatDate(p.created_at)}</p>
                            </CardContent>
                          </Card>
                        ))
                      )}
                    </div>
                  </TabsContent>

                  {/* TAB: Deals (Сделки) */}
                  <TabsContent value="deals" className="mt-0">
                    <div className="space-y-3">
                      {companyDeals.length === 0 ? (
                        <Card className="rounded-xl border border-border/60 shadow-sm p-6">
                          <div className="flex flex-col items-center gap-2">
                            <Briefcase className="h-8 w-8 text-muted-foreground" />
                            <p className="text-sm text-muted-foreground">Нет сделок</p>
                          </div>
                        </Card>
                      ) : (
                        companyDeals.map((deal) => {
                          const stage = pipelineStages.find((s) => s.id === deal.stage_id)
                          const stageIndex = pipelineStages.findIndex((s) => s.id === deal.stage_id)
                          const stageColor = stage?.color || '#94a3b8'
                          return (
                            <Card key={deal.id} className="rounded-xl border border-border/60 shadow-sm">
                              <CardContent className="p-4">
                                <div className="flex items-start justify-between gap-2">
                                  <div className="min-w-0 flex-1">
                                    <p className="text-sm font-medium">{deal.title}</p>
                                    <p className="text-base font-semibold text-foreground mt-1">{formatCurrency(deal.value)}</p>
                                  </div>
                                  <button
                                    onClick={() => deleteDeal(deal)}
                                    className="h-7 w-7 shrink-0 rounded-lg flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                                  >
                                    <Trash2 className="h-3.5 w-3.5" />
                                  </button>
                                </div>
                                <div className="flex items-center gap-2 mt-2">
                                  {stage && (
                                    <Badge
                                      className="text-[10px] px-1.5 py-0 border-transparent"
                                      style={{ backgroundColor: stageColor + '18', color: stageColor }}
                                    >
                                      {stage.name}
                                    </Badge>
                                  )}
                                  {deal.priority && (
                                    <Badge className={`text-[10px] px-1.5 py-0 ${PRIORITY_BADGE[deal.priority] || 'bg-muted text-muted-foreground'}`}>
                                      {PRIORITY_LABELS[deal.priority] || deal.priority}
                                    </Badge>
                                  )}
                                </div>
                                {/* Stage navigation */}
                                {pipelineStages.length > 1 && (
                                  <div className="flex items-center gap-2 mt-3 pt-3 border-t border-border/40">
                                    <button
                                      onClick={() => moveDeal(deal, stageIndex - 1)}
                                      disabled={stageIndex <= 0}
                                      className="h-7 w-7 shrink-0 rounded-lg flex items-center justify-center border border-border/60 text-muted-foreground hover:text-foreground hover:bg-muted/60 disabled:opacity-30 disabled:pointer-events-none transition-colors"
                                    >
                                      <ChevronLeft className="h-3.5 w-3.5" />
                                    </button>
                                    <div className="flex-1 flex items-center gap-1 overflow-x-auto">
                                      {pipelineStages.map((s, i) => (
                                        <button
                                          key={s.id}
                                          onClick={() => moveDeal(deal, i)}
                                          className={`h-1.5 rounded-full transition-all ${
                                            i === stageIndex
                                              ? 'w-4'
                                              : 'w-1.5 bg-border'
                                          }`}
                                          style={i === stageIndex ? { backgroundColor: s.color || '#94a3b8' } : undefined}
                                          title={s.name}
                                        />
                                      ))}
                                    </div>
                                    <button
                                      onClick={() => moveDeal(deal, stageIndex + 1)}
                                      disabled={stageIndex >= pipelineStages.length - 1}
                                      className="h-7 w-7 shrink-0 rounded-lg flex items-center justify-center border border-border/60 text-muted-foreground hover:text-foreground hover:bg-muted/60 disabled:opacity-30 disabled:pointer-events-none transition-colors"
                                    >
                                      <ChevronRight className="h-3.5 w-3.5" />
                                    </button>
                                  </div>
                                )}
                                <p className="text-[10px] text-muted-foreground/60 mt-2">{formatDate(deal.created_at)}</p>
                              </CardContent>
                            </Card>
                          )
                        })
                      )}
                    </div>
                  </TabsContent>

                  {/* TAB: Tasks */}
                  <TabsContent value="tasks" className="mt-0">
                    <div className="space-y-3">
                      {/* Stats */}
                      <div className="flex gap-3">
                        <Badge variant="secondary" className="text-xs">{taskStats.total} всего</Badge>
                        {taskStats.done > 0 && <Badge className="text-xs bg-emerald-500/10 text-emerald-600 border-transparent">{taskStats.done} выполнено</Badge>}
                        {taskStats.overdue > 0 && <Badge variant="destructive" className="text-xs">{taskStats.overdue} просрочено</Badge>}
                      </div>

                      <Button size="sm" onClick={() => setTaskDialogOpen(true)} className="gap-1.5 rounded-xl w-full">
                        <Plus className="h-4 w-4" />
                        Новая задача
                      </Button>

                      {tasks.length === 0 ? (
                        <Card className="rounded-xl border border-border/60 shadow-sm p-6">
                          <p className="text-sm text-muted-foreground text-center">Нет задач</p>
                        </Card>
                      ) : (
                        tasks.map((t) => {
                          const isDone = t.status === 'done'
                          const isOverdue = !isDone && t.deadline && t.deadline < getTodayStr()
                          return (
                            <Card key={t.id} className={`rounded-xl border shadow-sm ${isOverdue ? 'border-l-4 border-l-red-400' : 'border-border/60'}`}>
                              <CardContent className="p-3">
                                <div className="flex items-start gap-3">
                                  <Checkbox checked={isDone} onCheckedChange={() => toggleTask(t)} className="mt-0.5" />
                                  <div className="flex-1 min-w-0">
                                    <p className={`text-sm ${isDone ? 'line-through text-muted-foreground' : 'font-medium'}`}>{t.title}</p>
                                    {t.description && <p className="text-xs text-muted-foreground mt-0.5 line-clamp-1">{t.description}</p>}
                                    <div className="flex items-center gap-2 mt-1.5">
                                      <Badge className={`text-[10px] px-1.5 py-0 ${PRIORITY_BADGE[t.priority] || ''}`}>{PRIORITY_LABELS[t.priority] || t.priority}</Badge>
                                      {t.deadline && (
                                        <span className={`text-[10px] flex items-center gap-0.5 ${isOverdue ? 'text-red-500' : 'text-muted-foreground'}`}>
                                          <Clock className="h-3 w-3" />
                                          {formatDate(t.deadline)}
                                        </span>
                                      )}
                                    </div>
                                  </div>
                                  <button
                                    onClick={() => deleteTask(t.id)}
                                    className="h-7 w-7 shrink-0 rounded-lg flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                                  >
                                    <Trash2 className="h-3.5 w-3.5" />
                                  </button>
                                </div>
                              </CardContent>
                            </Card>
                          )
                        })
                      )}
                    </div>
                  </TabsContent>

                  {/* TAB: History */}
                  <TabsContent value="history" className="mt-0">
                    {activities.length === 0 ? (
                      <Card className="rounded-xl border border-border/60 shadow-sm p-6">
                        <p className="text-sm text-muted-foreground text-center">Нет активности</p>
                      </Card>
                    ) : (
                      <div className="space-y-1">
                        {activities.map((a) => (
                          <div key={a.id} className="flex items-start gap-3 p-2.5 rounded-xl hover:bg-muted/40 transition-colors">
                            <div className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-lg ${ACTIVITY_ICON_BG[a.type || 'заметка'] || 'bg-muted text-muted-foreground'}`}>
                              {getActivityIcon(a.type)}
                            </div>
                            <div className="min-w-0 flex-1">
                              <p className="text-sm">{a.content}</p>
                              <p className="text-[10px] text-muted-foreground mt-0.5">{relativeTime(a.created_at)}</p>
                            </div>
                          </div>
                        ))}
                      </div>
                    )}
                  </TabsContent>

                  {/* TAB: Files */}
                  <TabsContent value="files" className="mt-0">
                    <div className="space-y-3">
                      <input ref={fileInputRef} type="file" className="hidden" onChange={handleUploadFile} />
                      <Button size="sm" onClick={() => fileInputRef.current?.click()} disabled={uploadingFile} className="gap-1.5 rounded-xl w-full">
                        {uploadingFile ? <Loader2 className="h-4 w-4 animate-spin" /> : <Upload className="h-4 w-4" />}
                        {uploadingFile ? 'Загрузка...' : 'Загрузить файл'}
                      </Button>

                      {files.length === 0 ? (
                        <Card className="rounded-xl border border-border/60 shadow-sm p-6">
                          <p className="text-sm text-muted-foreground text-center">Нет файлов</p>
                        </Card>
                      ) : (
                        files.map((f) => {
                          const ext = f.name.split('.').pop()?.toLowerCase()
                          const isImage = ['jpg','jpeg','png','gif','webp','svg'].includes(ext || '')
                          return (
                            <div key={f.id} className="flex items-center gap-3 p-3 rounded-xl border border-border/60 hover:bg-muted/30 transition-colors">
                              <div className="h-9 w-9 rounded-lg bg-primary/10 flex items-center justify-center shrink-0">
                                {isImage ? <ImageIcon className="h-4 w-4 text-primary" /> : <FileText className="h-4 w-4 text-primary" />}
                              </div>
                              <div className="min-w-0 flex-1">
                                <p className="text-sm font-medium truncate">{f.name}</p>
                                <p className="text-[10px] text-muted-foreground">
                                  {formatFileSize(f.metadata?.size as number || 0)} · {new Date(f.created_at).toLocaleDateString('ru-RU')}
                                </p>
                              </div>
                              <a href={getFileUrl(f.name)} target="_blank" rel="noopener noreferrer" className="h-8 w-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-primary hover:bg-primary/10 transition-colors">
                                <Download className="h-4 w-4" />
                              </a>
                              <button onClick={() => handleDeleteFile(f.name)} className="h-8 w-8 rounded-lg flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors">
                                <Trash2 className="h-3.5 w-3.5" />
                              </button>
                            </div>
                          )
                        })
                      )}
                    </div>
                  </TabsContent>

                  {/* TAB: Comments */}
                  <TabsContent value="comments" className="mt-0">
                    <div className="space-y-3">
                      {/* Existing comments */}
                      {comments.map((c) => (
                        <div key={c.id} className="flex items-start gap-3 p-3 rounded-xl bg-muted/30">
                          <div className="h-8 w-8 rounded-lg bg-primary/10 flex items-center justify-center text-xs font-bold text-primary shrink-0">
                            {c.user_id ? 'У' : '?'}
                          </div>
                          <div className="flex-1 min-w-0">
                            <p className="text-sm">{c.text}</p>
                            <p className="text-[10px] text-muted-foreground mt-0.5">{formatDateTime(c.created_at)}</p>
                          </div>
                        </div>
                      ))}

                      {/* Add comment */}
                      <div className="flex gap-2">
                        <Textarea
                          placeholder="Напишите комментарий..."
                          value={commentText}
                          onChange={(e) => setCommentText(e.target.value)}
                          className="min-h-[80px] text-sm resize-none rounded-xl"
                          onKeyDown={(e) => {
                            if (e.key === 'Enter' && (e.metaKey || e.ctrlKey)) {
                              e.preventDefault()
                              handleAddComment()
                            }
                          }}
                        />
                        <Button
                          size="sm"
                          onClick={handleAddComment}
                          disabled={!commentText.trim() || savingComment}
                          className="shrink-0 self-end rounded-xl"
                        >
                          {savingComment ? <Loader2 className="h-4 w-4 animate-spin" /> : <Send className="h-4 w-4" />}
                        </Button>
                      </div>
                    </div>
                  </TabsContent>
                </div>
              </Tabs>
            </div>
          </div>
        )}
      </div>

      {/* ── Task Dialog ──────────────────────────────────────────────────── */}
      <Dialog open={taskDialogOpen} onOpenChange={(open) => { if (!open) setTaskForm({ title: '', description: '', priority: 'medium', deadline: getTodayStr() }) }}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Plus className="h-5 w-5" />
              Новая задача
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            <div className="space-y-2">
              <Label>Название *</Label>
              <Input
                placeholder="Связаться с клиентом..."
                value={taskForm.title}
                onChange={(e) => setTaskForm((f) => ({ ...f, title: e.target.value }))}
              />
            </div>
            <div className="space-y-2">
              <Label>Описание</Label>
              <Textarea
                placeholder="Подробности задачи..."
                value={taskForm.description}
                onChange={(e) => setTaskForm((f) => ({ ...f, description: e.target.value }))}
                rows={3}
                className="resize-none"
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Приоритет</Label>
                <Select value={taskForm.priority} onValueChange={(v) => setTaskForm((f) => ({ ...f, priority: v }))}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="low">Низкий</SelectItem>
                    <SelectItem value="medium">Средний</SelectItem>
                    <SelectItem value="high">Высокий</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Срок *</Label>
                <Input type="date" value={taskForm.deadline} onChange={(e) => setTaskForm((f) => ({ ...f, deadline: e.target.value }))} />
              </div>
            </div>
            <div className="flex justify-end gap-2 pt-2">
              <Button variant="outline" onClick={() => setTaskDialogOpen(false)}>Отмена</Button>
              <Button onClick={handleCreateTask} disabled={!taskForm.title.trim() || !taskForm.deadline || savingTask}>
                {savingTask ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : null}
                Создать
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
