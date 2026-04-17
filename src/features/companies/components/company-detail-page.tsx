'use client'

import { useState, useEffect, useCallback, useRef } from 'react'
import { supabase } from '@/lib/supabase/client'
import type {
  Company,
  CompanyContact,
  CompanyContactInsert,
  Activity,
  ActivityInsert,
  Proposal,
  ProposalInsert,
  ProposalItem,
  ProposalItemInsert,
  Task,
  TaskInsert,
  Deal,
  PipelineStage,
  User as UserType,
  COMPANY_SOURCES,
  COMPANY_STATUSES,
  ACTIVITY_TYPES,
  PROPOSAL_STATUSES,
  LOST_REASONS,
} from '@/lib/supabase/database.types'
import {
  COMPANY_SOURCES as companySources,
  COMPANY_STATUSES as companyStatuses,
  ACTIVITY_TYPES as activityTypes,
  PROPOSAL_STATUSES as proposalStatuses,
  LOST_REASONS as lostReasons,
} from '@/lib/supabase/database.types'
import { useAuthStore, useNavigationStore } from '@/lib/store'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Textarea } from '@/components/ui/textarea'
import { Label } from '@/components/ui/label'
import { Badge } from '@/components/ui/badge'
import { Skeleton } from '@/components/ui/skeleton'
import { Checkbox } from '@/components/ui/checkbox'
import { Separator } from '@/components/ui/separator'
import { ScrollArea } from '@/components/ui/scroll-area'
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/tabs'
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
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
} from '@/components/ui/alert-dialog'
import {
  Select,
  SelectTrigger,
  SelectValue,
  SelectContent,
  SelectItem,
} from '@/components/ui/select'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { toast } from 'sonner'
import {
  ArrowLeft,
  Pencil,
  Trash2,
  Plus,
  Phone,
  Mail,
  MessageCircle,
  User,
  FileText,
  StickyNote,
  Star,
  Globe,
  MapPin,
  Calendar,
  AlertCircle,
  ChevronDown,
  ChevronUp,
  X,
  Building2,
  Send,
  CheckSquare,
  Briefcase,
  ChevronLeft,
  ChevronRight,
  Upload,
  Loader2,
  Image,
  File,
  Download,
} from 'lucide-react'

// ─── Helpers ──────────────────────────────────────────────────────────────────

const formatCurrency = (v: number | null) =>
  new Intl.NumberFormat('ru-RU', {
    style: 'currency',
    currency: 'RUB',
    maximumFractionDigits: 0,
  }).format(v || 0)

function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('ru-RU', {
    day: 'numeric',
    month: 'long',
    year: 'numeric',
  })
}

function formatDateTime(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('ru-RU', {
    day: 'numeric',
    month: 'short',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  })
}

function isOverdue(dateStr: string | null): boolean {
  if (!dateStr) return false
  const d = new Date(dateStr + 'T23:59:59')
  return d < new Date()
}

function formatDateShort(dateStr: string | null): string {
  if (!dateStr) return ''
  return new Date(dateStr).toLocaleDateString('ru-RU', {
    day: 'numeric',
    month: 'short',
  })
}

// ─── Status badge colors ─────────────────────────────────────────────────────

const STATUS_BADGE: Record<string, string> = {
  'слабый интерес': 'bg-muted text-muted-foreground border-transparent',
  'надо залечивать': 'bg-amber-500/10 text-amber-600 dark:text-amber-400 border-transparent',
  'сделал запрос': 'bg-sky-500/10 text-sky-600 dark:text-sky-400 border-transparent',
  'сделал заказ': 'bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 border-transparent',
}

// ─── Activity type icons ─────────────────────────────────────────────────────

function getActivityIcon(type: string | null) {
  switch (type) {
    case 'звонок': return <Phone className="h-4 w-4" />
    case 'письмо': return <Mail className="h-4 w-4" />
    case 'whatsapp': return <MessageCircle className="h-4 w-4" />
    case 'встреча': return <User className="h-4 w-4" />
    case 'кп_отправлено': return <FileText className="h-4 w-4" />
    case 'заметка': return <StickyNote className="h-4 w-4" />
    case 'статус_изменен': return <CheckSquare className="h-4 w-4" />
    default: return <StickyNote className="h-4 w-4" />
  }
}

const ACTIVITY_ICON_COLORS: Record<string, string> = {
  'звонок': 'bg-emerald-500/10 text-emerald-600 dark:text-emerald-400',
  'письмо': 'bg-sky-500/10 text-sky-600 dark:text-sky-400',
  'whatsapp': 'bg-green-500/10 text-green-600 dark:text-green-400',
  'встреча': 'bg-violet-500/10 text-violet-600 dark:text-violet-400',
  'кп_отправлено': 'bg-amber-500/10 text-amber-600 dark:text-amber-400',
  'заметка': 'bg-muted text-muted-foreground',
  'статус_изменен': 'bg-rose-500/10 text-rose-600 dark:text-rose-400',
}

// ─── Proposal status colors ──────────────────────────────────────────────────

const PROPOSAL_STATUS_BADGE: Record<string, string> = {
  'отправлено': 'bg-sky-500/10 text-sky-600 dark:text-sky-400 border-transparent',
  'рассматривается': 'bg-amber-500/10 text-amber-600 dark:text-amber-400 border-transparent',
  'принято': 'bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 border-transparent',
  'отклонено': 'bg-red-500/10 text-red-600 dark:text-red-400 border-transparent',
}

// ─── Proposal item form ──────────────────────────────────────────────────────

interface ProposalItemForm {
  product_name: string
  description: string
  quantity: number
  price_per_unit: number
}

// ─── File helpers ────────────────────────────────────────────────────────

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return bytes + ' Б'
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' КБ'
  return (bytes / (1024 * 1024)).toFixed(1) + ' МБ'
}

function getFileIcon(name: string) {
  const ext = name.split('.').pop()?.toLowerCase()
  if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg', 'bmp'].includes(ext ?? '')) return 'image'
  if (['pdf'].includes(ext ?? '')) return 'pdf'
  if (['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'].includes(ext ?? '')) return 'office'
  return 'file'
}

// ─── Proposal item form ──────────────────────────────────────────────────────

const EMPTY_PROPOSAL_ITEM: ProposalItemForm = {
  product_name: '',
  description: '',
  quantity: 1,
  price_per_unit: 0,
}

// ─── Component ────────────────────────────────────────────────────────────────

export function CompanyDetailPage() {
  const companyId = useNavigationStore((s) => s.selectedCompanyId)
  const goBack = useNavigationStore((s) => s.goBack)
  const currentUser = useAuthStore((s) => s.currentUser)

  // ─── State ─────────────────────────────────────────────────────────────────

  const [company, setCompany] = useState<Company & { manager?: { id: string; name: string; email: string } | null } | null>(null)
  const [contacts, setContacts] = useState<CompanyContact[]>([])
  const [activities, setActivities] = useState<(Activity & { user?: { id: string; name: string } | null; contact?: { id: string; name: string; position: string | null } | null })[]>([])
  const [proposals, setProposals] = useState<(Proposal & { items?: ProposalItem[] })[]>([])
  const [tasks, setTasks] = useState<Task[]>([])
  const [companyDeals, setCompanyDeals] = useState<Deal[]>([])
  const [pipelineStages, setPipelineStages] = useState<PipelineStage[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [activeTab, setActiveTab] = useState('contacts')

  // Edit company dialog
  const [editCompanyOpen, setEditCompanyOpen] = useState(false)
  const [editForm, setEditForm] = useState({
    name: '', inn: '', city: '', website: '', contact_phone: '', contact_email: '',
    source: '', status: '', notes: '', lost_reason: '',
  })
  const [savingCompany, setSavingCompany] = useState(false)

  // Delete company
  const [deleteOpen, setDeleteOpen] = useState(false)
  const [deleting, setDeleting] = useState(false)

  // Contact dialog
  const [contactDialogOpen, setContactDialogOpen] = useState(false)
  const [editingContact, setEditingContact] = useState<CompanyContact | null>(null)
  const [contactForm, setContactForm] = useState({
    name: '', position: '', phone: '', email: '', whatsapp: '', notes: '', is_primary: false,
  })
  const [savingContact, setSavingContact] = useState(false)

  // Activity dialog
  const [activityDialogOpen, setActivityDialogOpen] = useState(false)
  const [activityForm, setActivityForm] = useState({
    type: 'заметка' as string,
    contact_id: '',
    content: '',
    next_contact_date: '',
  })
  const [savingActivity, setSavingActivity] = useState(false)

  // Quick note
  const [quickNote, setQuickNote] = useState('')
  const [savingQuickNote, setSavingQuickNote] = useState(false)

  // Proposal dialog
  const [proposalDialogOpen, setProposalDialogOpen] = useState(false)
  const [proposalForm, setProposalForm] = useState({
    number: '',
    status: 'отправлено',
    valid_until: '',
    notes: '',
    items: [{ ...EMPTY_PROPOSAL_ITEM }] as ProposalItemForm[],
  })
  const [savingProposal, setSavingProposal] = useState(false)

  // Expanded proposal
  const [expandedProposal, setExpandedProposal] = useState<string | null>(null)

  // Task dialog
  const [taskDialogOpen, setTaskDialogOpen] = useState(false)
  const [taskForm, setTaskForm] = useState({
    title: '',
    description: '',
    priority: 'medium' as string,
    deadline: '',
    deal_id: '',
    assigned_to: '',
  })
  const [savingTask, setSavingTask] = useState(false)
  const [taskUsers, setTaskUsers] = useState<UserType[]>([])

  // Files state
  const [files, setFiles] = useState<{ name: string; id: string; created_at: string; metadata: Record<string, unknown> }[]>([])
  const [uploading, setUploading] = useState(false)
  const fileInputRef = useRef<HTMLInputElement>(null)

  // ─── Data Fetching ────────────────────────────────────────────────────────

  const [fetchTrigger, setFetchTrigger] = useState(0)

  const fetchData = useCallback(async () => {
    if (!companyId) return

    let loadError: string | null = null
    let companyData: typeof company = null
    let contactsData: CompanyContact[] = []
    let activitiesData: typeof activities = []
    let proposalsData: typeof proposals = []
    let tasksData: Task[] = []

    // Company query — critical
    try {
      const res = await supabase.from('companies').select('*').eq('id', companyId).is('deleted_at', 'is', null).single()
      if (res.error) throw res.error
      companyData = res.data
    } catch (err: unknown) {
      loadError = err instanceof Error ? err.message : 'Не удалось загрузить данные компании'
    }

    // Contacts query — optional
    try {
      const res = await supabase.from('company_contacts').select('*').eq('company_id', companyId).order('is_primary', { ascending: false })
      if (!res.error) contactsData = res.data ?? []
    } catch { /* contacts optional */ }

    // Activities query — optional (no joins to avoid users table failures)
    try {
      const res = await supabase.from('activities').select('*').eq('company_id', companyId).order('created_at', { ascending: false }).limit(50)
      if (!res.error) activitiesData = res.data ?? []
    } catch { /* activities optional */ }

    // Proposals query — optional (items join is safe — direct FK)
    try {
      const res = await supabase.from('proposals').select('*, items:proposal_items(*)').eq('company_id', companyId).order('created_at', { ascending: false })
      if (!res.error) proposalsData = res.data ?? []
    } catch { /* proposals optional */ }

    // Tasks query — optional
    try {
      const res = await supabase.from('tasks').select('*').eq('company_id', companyId).order('created_at', { ascending: false })
      if (!res.error) tasksData = res.data ?? []
    } catch { /* tasks optional */ }

    // Deals + pipeline stages — optional
    let dealsData: Deal[] = []
    let stagesData: PipelineStage[] = []
    try {
      const [dealsRes, stagesRes] = await Promise.all([
        supabase.from('deals').select('*').eq('client_id', companyId).order('created_at', { ascending: false }),
        supabase.from('pipeline_stages').select('*').order('position'),
      ])
      if (!dealsRes.error) dealsData = dealsRes.data ?? []
      if (!stagesRes.error) stagesData = stagesRes.data ?? []
    } catch { /* deals optional */ }

    // Files query — optional (Supabase Storage)
    let filesData: typeof files = []
    try {
      const { data: storageFiles } = await supabase.storage.from('crm-files').list(companyId, { sortBy: { column: 'created_at', order: 'desc' } })
      if (storageFiles) filesData = storageFiles as typeof files
    } catch { /* files optional */ }

    setCompany(companyData)
    setContacts(contactsData)
    setActivities(activitiesData)
    setProposals(proposalsData)
    setTasks(tasksData)
    setCompanyDeals(dealsData)
    setPipelineStages(stagesData)
    setFiles(filesData)
    setError(loadError)
    setLoading(false)
  }, [companyId])

  useEffect(() => {
    let cancelled = false
    setLoading(true)
    fetchData().then(() => {
      if (cancelled) return
    })
    return () => { cancelled = true }
  }, [fetchTrigger, fetchData])

  const refresh = () => {
    setLoading(true)
    setFetchTrigger((n) => n + 1)
  }

  // ─── Company Edit ─────────────────────────────────────────────────────────

  const openEditCompany = () => {
    if (!company) return
    setEditForm({
      name: company.name ?? '',
      inn: company.inn ?? '',
      city: company.city ?? '',
      website: company.website ?? '',
      contact_phone: company.contact_phone ?? '',
      contact_email: company.contact_email ?? '',
      source: company.source ?? '',
      status: company.status ?? '',
      notes: company.notes ?? '',
      lost_reason: company.lost_reason ?? '',
    })
    setEditCompanyOpen(true)
  }

  const handleSaveCompany = async () => {
    if (!companyId || !editForm.name.trim()) return
    setSavingCompany(true)

    const oldStatus = company?.status
    const newStatus = editForm.status

    try {
      const { error: updateError } = await supabase
        .from('companies')
        .update({
          name: editForm.name.trim(),
          inn: editForm.inn.trim() || null,
          city: editForm.city.trim() || null,
          website: editForm.website.trim() || null,
          contact_phone: editForm.contact_phone.trim() || null,
          contact_email: editForm.contact_email.trim() || null,
          source: editForm.source || null,
          status: editForm.status || null,
          notes: editForm.notes.trim() || null,
          lost_reason: editForm.status === 'отказ' || editForm.status === 'не актуально' ? editForm.lost_reason : null,
        })
        .eq('id', companyId)

      if (!updateError && oldStatus !== newStatus && newStatus) {
        await supabase.from('activities').insert({
          company_id: companyId,
          user_id: currentUser?.id,
          type: 'статус_изменен',
          content: `Статус изменён на «${newStatus}»`,
        } as ActivityInsert)
      }

      setEditCompanyOpen(false)
      refresh()
    } catch { /* silent */ }
    setSavingCompany(false)
  }

  // ─── Company Delete ───────────────────────────────────────────────────────

  const handleDeleteCompany = async () => {
    if (!companyId) return
    setDeleting(true)
    try {
      // Soft-delete the company
      await supabase.from('companies').update({ deleted_at: new Date().toISOString() }).eq('id', companyId)

      // Cascade: hard-delete related child records
      await Promise.allSettled([
        supabase.from('company_contacts').delete().eq('company_id', companyId),
        supabase.from('activities').delete().eq('company_id', companyId),
        supabase.from('deals').delete().eq('client_id', companyId),
        supabase.from('tasks').delete().eq('company_id', companyId),
      ])

      // Clean up proposals + their items
      const { data: companyProposals } = await supabase.from('proposals').select('id').eq('company_id', companyId)
      if (companyProposals && companyProposals.length > 0) {
        const proposalIds = companyProposals.map((p) => p.id)
        await Promise.allSettled([
          supabase.from('proposal_items').delete().in('proposal_id', proposalIds),
          supabase.from('proposals').delete().eq('company_id', companyId),
        ])
      }

      toast.success('Компания и связанные данные удалены')
      setDeleteOpen(false)
      goBack()
    } catch {
      toast.error('Ошибка при удалении компании')
    }
    setDeleting(false)
  }

  // ─── Contacts CRUD ────────────────────────────────────────────────────────

  const openAddContact = () => {
    setEditingContact(null)
    setContactForm({ name: '', position: '', phone: '', email: '', whatsapp: '', notes: '', is_primary: false })
    setContactDialogOpen(true)
  }

  const openEditContact = (contact: CompanyContact) => {
    setEditingContact(contact)
    setContactForm({
      name: contact.name ?? '',
      position: contact.position ?? '',
      phone: contact.phone ?? '',
      email: contact.email ?? '',
      whatsapp: contact.whatsapp ?? '',
      notes: contact.notes ?? '',
      is_primary: contact.is_primary ?? false,
    })
    setContactDialogOpen(true)
  }

  const handleSaveContact = async () => {
    if (!companyId || !contactForm.name.trim()) return
    setSavingContact(true)
    try {
      if (editingContact) {
        const payload: Record<string, unknown> = {
          name: contactForm.name.trim(),
          position: contactForm.position.trim() || null,
          phone: contactForm.phone.trim() || null,
          email: contactForm.email.trim() || null,
          whatsapp: contactForm.whatsapp.trim() || null,
          notes: contactForm.notes.trim() || null,
          is_primary: contactForm.is_primary,
        }
        // If set as primary, unset others
        if (contactForm.is_primary) {
          await supabase.from('company_contacts').update({ is_primary: false }).eq('company_id', companyId).neq('id', editingContact.id)
        }
        await supabase.from('company_contacts').update(payload).eq('id', editingContact.id)
      } else {
        const insertData: CompanyContactInsert = {
          company_id: companyId,
          name: contactForm.name.trim(),
          position: contactForm.position.trim() || null,
          phone: contactForm.phone.trim() || null,
          email: contactForm.email.trim() || null,
          whatsapp: contactForm.whatsapp.trim() || null,
          notes: contactForm.notes.trim() || null,
          is_primary: contactForm.is_primary,
        }
        if (contactForm.is_primary) {
          await supabase.from('company_contacts').update({ is_primary: false }).eq('company_id', companyId)
        }
        await supabase.from('company_contacts').insert(insertData)
      }
      setContactDialogOpen(false)
      refresh()
    } catch { /* silent */ }
    setSavingContact(false)
  }

  const handleDeleteContact = async (contactId: string) => {
    if (!window.confirm('Удалить этот контакт?')) return
    try {
      await supabase.from('company_contacts').delete().eq('id', contactId)
      refresh()
    } catch { /* silent */ }
  }

  // ─── Activity CRUD ────────────────────────────────────────────────────────

  const openAddActivity = () => {
    setActivityForm({ type: 'заметка', contact_id: '', content: '', next_contact_date: '' })
    setActivityDialogOpen(true)
  }

  const handleSaveActivity = async () => {
    if (!companyId || !activityForm.content.trim()) return
    setSavingActivity(true)
    try {
      const insertData: ActivityInsert = {
        company_id: companyId,
        user_id: currentUser?.id,
        type: activityForm.type,
        content: activityForm.content.trim(),
        contact_id: activityForm.contact_id || null,
        next_contact_date: activityForm.next_contact_date || null,
      }
      await supabase.from('activities').insert(insertData)

      // Update next contact date on company
      if (activityForm.next_contact_date) {
        await supabase.from('companies').update({ next_contact_date: activityForm.next_contact_date }).eq('id', companyId)
      }

      setActivityDialogOpen(false)
      refresh()
    } catch { /* silent */ }
    setSavingActivity(false)
  }

  const handleQuickNote = async () => {
    if (!companyId || !quickNote.trim()) return
    setSavingQuickNote(true)
    try {
      await supabase.from('activities').insert({
        company_id: companyId,
        user_id: currentUser?.id,
        type: 'заметка',
        content: quickNote.trim(),
      } as ActivityInsert)
      setQuickNote('')
      refresh()
    } catch { /* silent */ }
    setSavingQuickNote(false)
  }

  // ─── Proposal CRUD ────────────────────────────────────────────────────────

  const openAddProposal = () => {
    setProposalForm({
      number: '',
      status: 'отправлено',
      valid_until: '',
      notes: '',
      items: [{ ...EMPTY_PROPOSAL_ITEM }],
    })
    setProposalDialogOpen(true)
  }

  const addProposalItem = () => {
    setProposalForm((f) => ({ ...f, items: [...f.items, { ...EMPTY_PROPOSAL_ITEM }] }))
  }

  const removeProposalItem = (index: number) => {
    setProposalForm((f) => ({ ...f, items: f.items.filter((_, i) => i !== index) }))
  }

  const updateProposalItem = (index: number, field: keyof ProposalItemForm, value: string | number) => {
    setProposalForm((f) => {
      const items = [...f.items]
      items[index] = { ...items[index], [field]: value }
      return { ...f, items }
    })
  }

  const proposalTotal = proposalForm.items.reduce(
    (sum, item) => sum + (item.quantity || 0) * (item.price_per_unit || 0),
    0
  )

  const handleSaveProposal = async () => {
    if (!companyId) return
    const hasItem = proposalForm.items.some((i) => i.product_name.trim())
    if (!hasItem) return
    setSavingProposal(true)
    try {
      const { data: proposal, error: proposalError } = await supabase
        .from('proposals')
        .insert({
          company_id: companyId,
          manager_id: currentUser?.id,
          number: proposalForm.number.trim() || null,
          status: proposalForm.status,
          total_amount: proposalTotal,
          valid_until: proposalForm.valid_until || null,
          notes: proposalForm.notes.trim() || null,
        } as ProposalInsert)
        .select()
        .single()

      if (!proposalError && proposal) {
        const validItems = proposalForm.items.filter((i) => i.product_name.trim())
        const itemsToInsert: ProposalItemInsert[] = validItems.map((item) => ({
          proposal_id: proposal.id,
          product_name: item.product_name.trim(),
          description: item.description.trim() || null,
          quantity: item.quantity || null,
          unit: 'шт',
          price_per_unit: item.price_per_unit || null,
          total_price: (item.quantity || 0) * (item.price_per_unit || 0),
        }))
        if (itemsToInsert.length > 0) {
          await supabase.from('proposal_items').insert(itemsToInsert)
        }

        // Create activity
        await supabase.from('activities').insert({
          company_id: companyId,
          user_id: currentUser?.id,
          type: 'кп_отправлено',
          content: `Отправлено КП ${proposalForm.number ? `№${proposalForm.number}` : ''} на сумму ${formatCurrency(proposalTotal)}`,
        } as ActivityInsert)
      }

      setProposalDialogOpen(false)
      refresh()
    } catch { /* silent */ }
    setSavingProposal(false)
  }

  // ─── Task CRUD ────────────────────────────────────────────────────────────

  const openAddTask = () => {
    setTaskForm({ title: '', description: '', priority: 'medium', deadline: '', deal_id: '', assigned_to: '' })
    setTaskDialogOpen(true)
    // Load users for assignment
    supabase.from('users').select('id, name').then((res) => {
      if (!res.error && res.data) setTaskUsers(res.data)
    }).catch(() => {})
  }

  const handleSaveTask = async () => {
    if (!companyId || !taskForm.title.trim()) return
    setSavingTask(true)
    try {
      await supabase.from('tasks').insert({
        title: taskForm.title.trim(),
        description: taskForm.description.trim() || null,
        status: 'todo',
        priority: taskForm.priority,
        deadline: taskForm.deadline || null,
        company_id: companyId,
        deal_id: taskForm.deal_id || null,
        assigned_to: taskForm.assigned_to || null,
        created_by: currentUser?.id,
      } as TaskInsert)
      setTaskDialogOpen(false)
      refresh()
    } catch { /* silent */ }
    setSavingTask(false)
  }

  const toggleTaskDone = async (task: Task) => {
    const newStatus = task.status === 'done' ? 'todo' : 'done'
    await supabase.from('tasks').update({ status: newStatus }).eq('id', task.id)
    refresh()
  }

  const handleDeleteTask = async (taskId: string) => {
    if (!window.confirm('Удалить эту задачу?')) return
    await supabase.from('tasks').delete().eq('id', taskId)
    refresh()
  }

  // ─── Deal Move / Delete ─────────────────────────────────────────────────

  const moveDeal = async (deal: Deal, newIndex: number) => {
    if (newIndex < 0 || newIndex >= pipelineStages.length) return
    const newStage = pipelineStages[newIndex]
    if (!newStage || deal.stage_id === newStage.id) return
    const { error } = await supabase.from('deals').update({ stage_id: newStage.id }).eq('id', deal.id)
    if (error) { toast.error('Ошибка: ' + error.message); return }
    toast.success(`Сделка «${deal.title}» → «${newStage.name}»`)
    await supabase.from('activities').insert({
      content: `Перемещена сделка «${deal.title}» в ${newStage.name}`,
      type: 'заметка',
      user_id: currentUser?.id ?? null,
      company_id: companyId ?? undefined,
    } as ActivityInsert)
    refresh()
  }

  const deleteDeal = async (deal: Deal) => {
    if (!window.confirm(`Удалить сделку «${deal.title}»?`)) return
    const { error } = await supabase.from('deals').delete().eq('id', deal.id)
    if (error) { toast.error('Ошибка: ' + error.message); return }
    toast.success(`Сделка «${deal.title}» удалена`)
    await supabase.from('activities').insert({
      content: `Удалена сделка «${deal.title}»`,
      type: 'заметка',
      user_id: currentUser?.id ?? null,
      company_id: companyId ?? undefined,
    } as ActivityInsert)
    refresh()
  }

  // ─── File Upload / Delete ─────────────────────────────────────────────────

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (!file || !companyId) return
    setUploading(true)
    try {
      const { error: uploadError } = await supabase.storage.from('crm-files').upload(`${companyId}/${file.name}`, file)
      if (uploadError) {
        toast.error('Ошибка загрузки: ' + uploadError.message)
      } else {
        toast.success('Файл загружен')
        refresh()
      }
    } catch (err: unknown) {
      toast.error('Ошибка загрузки: ' + (err instanceof Error ? err.message : 'Неизвестная ошибка'))
    }
    setUploading(false)
    // Reset input so the same file can be uploaded again
    if (fileInputRef.current) fileInputRef.current.value = ''
  }

  const handleFileDelete = async (fileName: string) => {
    if (!companyId) return
    if (!window.confirm(`Удалить файл «${fileName}»?`)) return
    try {
      const { error: deleteError } = await supabase.storage.from('crm-files').remove([`${companyId}/${fileName}`])
      if (deleteError) {
        toast.error('Ошибка удаления: ' + deleteError.message)
      } else {
        toast.success('Файл удалён')
        refresh()
      }
    } catch { /* silent */ }
  }

  const handleFileDownload = (fileName: string) => {
    if (!companyId) return
    const { data } = supabase.storage.from('crm-files').getPublicUrl(`${companyId}/${fileName}`)
    window.open(data.publicUrl, '_blank')
  }

  // ─── Loading State ────────────────────────────────────────────────────────

  if (loading) {
    return (
      <div className="space-y-6">
        <Skeleton className="h-8 w-32" />
        <Card className="rounded-2xl shadow-sm">
          <CardContent className="p-6 space-y-4">
            <Skeleton className="h-7 w-64" />
            <div className="flex gap-2">
              <Skeleton className="h-6 w-24 rounded-full" />
              <Skeleton className="h-6 w-20 rounded-full" />
              <Skeleton className="h-6 w-28 rounded-full" />
            </div>
            <Skeleton className="h-4 w-48" />
            <Skeleton className="h-4 w-64" />
          </CardContent>
        </Card>
        <Skeleton className="h-10 w-full rounded-xl" />
        <div className="space-y-3">
          {Array.from({ length: 3 }).map((_, i) => (
            <Card key={i} className="rounded-2xl shadow-sm">
              <CardContent className="p-4">
                <Skeleton className="h-5 w-40" />
                <Skeleton className="h-4 w-60 mt-2" />
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    )
  }

  // ─── Error State ──────────────────────────────────────────────────────────

  if (error || !company) {
    return (
      <div className="space-y-4">
        <Button variant="ghost" size="sm" onClick={goBack} className="gap-2">
          <ArrowLeft className="h-4 w-4" />
          Назад к списку
        </Button>
        <div className="flex flex-col items-center justify-center py-20 gap-3">
          <AlertCircle className="h-10 w-10 text-destructive" />
          <p className="text-sm text-muted-foreground">{error || 'Компания не найдена'}</p>
          <Button variant="outline" size="sm" onClick={refresh}>Повторить</Button>
        </div>
      </div>
    )
  }

  // ─── Render ───────────────────────────────────────────────────────────────

  const nextContactDate = company.next_contact_date
  const nextContactOverdue = isOverdue(nextContactDate)

  return (
    <div className="space-y-6">
      {/* ── Back Button ─────────────────────────────────────────────────────── */}
      <Button variant="ghost" size="sm" onClick={goBack} className="gap-2 -ml-2">
        <ArrowLeft className="h-4 w-4" />
        Назад к списку
      </Button>

      {/* ── Company Header Card ─────────────────────────────────────────────── */}
      <Card className="rounded-2xl shadow-sm hover:shadow-md transition-shadow duration-200">
        <CardHeader className="pb-4">
          <div className="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-4">
            <div className="flex-1 min-w-0 space-y-3">
              {/* Company Name */}
              <CardTitle className="text-xl sm:text-2xl font-bold tracking-tight flex items-center gap-2">
                <Building2 className="h-6 w-6 text-primary/70 shrink-0" />
                <span className="truncate">{company.name}</span>
              </CardTitle>

              {/* Badges */}
              <div className="flex flex-wrap items-center gap-2">
                {company.inn && (
                  <Badge variant="outline" className="text-xs font-mono">
                    ИНН: {company.inn}
                  </Badge>
                )}
                {company.city && (
                  <Badge variant="outline" className="text-xs gap-1">
                    <MapPin className="h-3 w-3" />
                    {company.city}
                  </Badge>
                )}
                {company.status && (
                  <Badge className={`text-xs ${STATUS_BADGE[company.status] ?? 'bg-muted text-muted-foreground border-transparent'}`}>
                    {company.status}
                  </Badge>
                )}
                {company.source && (
                  <Badge variant="secondary" className="text-xs">
                    {company.source}
                  </Badge>
                )}
              </div>

              {/* Manager */}
              {(company.manager || company.manager_name) && (
                <p className="text-sm text-muted-foreground flex items-center gap-1.5">
                  <User className="h-3.5 w-3.5" />
                  Ответственный: <span className="font-medium text-foreground">{company.manager?.name || company.manager_name}</span>
                </p>
              )}

              {/* Website */}
              {company.website && (
                <a
                  href={company.website.startsWith('http') ? company.website : `https://${company.website}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-sm text-primary hover:underline flex items-center gap-1.5 w-fit"
                >
                  <Globe className="h-3.5 w-3.5" />
                  {company.website}
                </a>
              )}

              {/* Contact Phone & Email */}
              <div className="flex flex-col sm:flex-row gap-2 sm:gap-4 text-sm text-muted-foreground">
                {company.contact_phone && (
                  <span className="flex items-center gap-1.5">
                    <Phone className="h-3.5 w-3.5" />
                    {company.contact_phone}
                  </span>
                )}
                {company.contact_email && (
                  <a href={`mailto:${company.contact_email}`} className="flex items-center gap-1.5 hover:text-primary transition-colors">
                    <Mail className="h-3.5 w-3.5" />
                    {company.contact_email}
                  </a>
                )}
              </div>

              {/* Next contact date */}
              {nextContactDate && (
                <div className={`flex items-center gap-1.5 text-sm ${nextContactOverdue ? 'text-red-500 dark:text-red-400 font-medium' : 'text-muted-foreground'}`}>
                  <Calendar className="h-3.5 w-3.5" />
                  Следующий контакт: {formatDate(nextContactDate)}
                  {nextContactOverdue && (
                    <Badge variant="destructive" className="text-[10px] ml-1">Просрочено</Badge>
                  )}
                </div>
              )}

              {/* Lost reason */}
              {(company.status === 'отказ' || company.status === 'не актуально') && (
                <div className="mt-2">
                  <Select
                    value={company.lost_reason || ''}
                    onValueChange={async (v) => {
                      await supabase.from('companies').update({ lost_reason: v || null }).eq('id', companyId)
                      refresh()
                    }}
                  >
                    <SelectTrigger className="w-full sm:w-64">
                      <SelectValue placeholder="Выберите причину отказа" />
                    </SelectTrigger>
                    <SelectContent>
                      {lostReasons.map((r) => (
                        <SelectItem key={r} value={r}>{r}</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              )}
            </div>

            {/* Action Buttons */}
            <div className="flex items-center gap-2 shrink-0">
              <Button variant="outline" size="sm" onClick={openEditCompany} className="gap-1.5 rounded-xl">
                <Pencil className="h-4 w-4" />
                <span className="hidden sm:inline">Редактировать</span>
              </Button>
              <Button variant="outline" size="sm" onClick={() => setDeleteOpen(true)} className="gap-1.5 rounded-xl text-destructive hover:text-destructive hover:bg-destructive/10 border-destructive/30">
                <Trash2 className="h-4 w-4" />
                <span className="hidden sm:inline">Удалить</span>
              </Button>
            </div>
          </div>
        </CardHeader>
      </Card>

      {/* ── Tabs ────────────────────────────────────────────────────────────── */}
      <Tabs value={activeTab} onValueChange={setActiveTab}>
        <TabsList className="w-full sm:w-auto bg-muted/60 rounded-xl p-1">
          <TabsTrigger value="contacts" className="rounded-lg text-xs sm:text-sm gap-1.5 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">
            Контакты ЛПР
            {contacts.length > 0 && (
              <Badge variant="secondary" className="text-[10px] h-4 min-w-[16px] px-1 ml-0.5">{contacts.length}</Badge>
            )}
          </TabsTrigger>
          <TabsTrigger value="history" className="rounded-lg text-xs sm:text-sm gap-1.5 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">
            История
            {activities.length > 0 && (
              <Badge variant="secondary" className="text-[10px] h-4 min-w-[16px] px-1 ml-0.5">{activities.length}</Badge>
            )}
          </TabsTrigger>
          <TabsTrigger value="proposals" className="rounded-lg text-xs sm:text-sm gap-1.5 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">
            КП
            {proposals.length > 0 && (
              <Badge variant="secondary" className="text-[10px] h-4 min-w-[16px] px-1 ml-0.5">{proposals.length}</Badge>
            )}
          </TabsTrigger>
          <TabsTrigger value="deals" className="rounded-lg text-xs sm:text-sm gap-1.5 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">
            <Briefcase className="h-3.5 w-3.5" />
            Сделки
            {companyDeals.length > 0 && (
              <Badge variant="secondary" className="text-[10px] h-4 min-w-[16px] px-1 ml-0.5">{companyDeals.length}</Badge>
            )}
          </TabsTrigger>
          <TabsTrigger value="tasks" className="rounded-lg text-xs sm:text-sm gap-1.5 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">
            Задачи
            {tasks.length > 0 && (
              <Badge variant="secondary" className="text-[10px] h-4 min-w-[16px] px-1 ml-0.5">{tasks.length}</Badge>
            )}
          </TabsTrigger>
          <TabsTrigger value="files" className="rounded-lg text-xs sm:text-sm gap-1.5 data-[state=active]:bg-primary data-[state=active]:text-primary-foreground">
            <Upload className="h-3.5 w-3.5" />
            Файлы
            {files.length > 0 && (
              <Badge variant="secondary" className="text-[10px] h-4 min-w-[16px] px-1 ml-0.5">{files.length}</Badge>
            )}
          </TabsTrigger>
        </TabsList>

        {/* ═══════════════════════════════════════════════════════════════════════
            TAB 1: Контакты ЛПР
        ═══════════════════════════════════════════════════════════════════════ */}
        <TabsContent value="contacts" className="mt-4">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-medium text-muted-foreground">
              {contacts.length}{' '}
              {contacts.length === 1 ? 'контакт' : contacts.length < 5 ? 'контакта' : 'контактов'}
            </h3>
            <Button size="sm" onClick={openAddContact} className="gap-1.5 rounded-xl">
              <Plus className="h-4 w-4" />
              Добавить контакт
            </Button>
          </div>

          {contacts.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-16 gap-3">
              <User className="h-8 w-8 text-muted-foreground" />
              <p className="text-sm text-muted-foreground">Нет добавленных контактов</p>
              <Button size="sm" variant="outline" onClick={openAddContact} className="gap-1.5 rounded-xl">
                <Plus className="h-4 w-4" />
                Добавить
              </Button>
            </div>
          ) : (
            <div className="space-y-3">
              {contacts.map((contact) => (
                <Card key={contact.id} className="rounded-2xl shadow-sm hover:shadow-md transition-shadow duration-200">
                  <CardContent className="p-4">
                    <div className="flex items-start justify-between gap-3">
                      <div className="flex-1 min-w-0 space-y-2">
                        {/* Name + primary star */}
                        <div className="flex items-center gap-2">
                          <p className="text-sm font-semibold truncate">{contact.name}</p>
                          {contact.is_primary && (
                            <Badge className="bg-amber-500/10 text-amber-600 dark:text-amber-400 border-transparent gap-1 text-[10px]">
                              <Star className="h-3 w-3 fill-current" />
                              Основной
                            </Badge>
                          )}
                        </div>

                        {/* Position */}
                        {contact.position && (
                          <p className="text-xs text-muted-foreground">{contact.position}</p>
                        )}

                        {/* Contact info row */}
                        <div className="flex flex-wrap items-center gap-2">
                          {contact.phone && (
                            <a href={`tel:${contact.phone}`} className="inline-flex items-center gap-1 text-xs text-muted-foreground hover:text-primary transition-colors px-2 py-1 rounded-lg hover:bg-primary/5">
                              <Phone className="h-3 w-3" />
                              {contact.phone}
                            </a>
                          )}
                          {contact.email && (
                            <a href={`mailto:${contact.email}`} className="inline-flex items-center gap-1 text-xs text-muted-foreground hover:text-primary transition-colors px-2 py-1 rounded-lg hover:bg-primary/5">
                              <Mail className="h-3 w-3" />
                              <span className="truncate max-w-[180px]">{contact.email}</span>
                            </a>
                          )}
                          {contact.whatsapp && (
                            <a
                              href={`https://wa.me/${contact.whatsapp.replace(/\D/g, '')}`}
                              target="_blank"
                              rel="noopener noreferrer"
                              className="inline-flex items-center gap-1 text-xs text-green-600 dark:text-green-400 hover:text-green-500 transition-colors px-2 py-1 rounded-lg hover:bg-green-500/5"
                            >
                              <MessageCircle className="h-3 w-3" />
                              <span className="truncate max-w-[160px]">{contact.whatsapp}</span>
                            </a>
                          )}
                        </div>

                        {/* Notes */}
                        {contact.notes && (
                          <p className="text-xs text-muted-foreground italic">{contact.notes}</p>
                        )}
                      </div>

                      {/* Actions */}
                      <div className="flex items-center gap-1 shrink-0">
                        <DropdownMenu>
                          <DropdownMenuTrigger asChild>
                            <button className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-primary/10 transition-colors">
                              <Pencil className="h-3.5 w-3.5" />
                            </button>
                          </DropdownMenuTrigger>
                          <DropdownMenuContent align="end">
                            <DropdownMenuItem onClick={() => openEditContact(contact)}>
                              <Pencil className="h-3.5 w-3.5 mr-2" />
                              Редактировать
                            </DropdownMenuItem>
                            <DropdownMenuItem
                              className="text-destructive focus:text-destructive"
                              onClick={() => handleDeleteContact(contact.id)}
                            >
                              <Trash2 className="h-3.5 w-3.5 mr-2" />
                              Удалить
                            </DropdownMenuItem>
                          </DropdownMenuContent>
                        </DropdownMenu>
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </TabsContent>

        {/* ═══════════════════════════════════════════════════════════════════════
            TAB 2: История (Activity Timeline)
        ═══════════════════════════════════════════════════════════════════════ */}
        <TabsContent value="history" className="mt-4">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-medium text-muted-foreground">
              {activities.length}{' '}
              {activities.length === 1 ? 'запись' : activities.length < 5 ? 'записи' : 'записей'}
            </h3>
            <Button size="sm" onClick={openAddActivity} className="gap-1.5 rounded-xl">
              <Plus className="h-4 w-4" />
              Добавить активность
            </Button>
          </div>

          {activities.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-16 gap-3">
              <StickyNote className="h-8 w-8 text-muted-foreground" />
              <p className="text-sm text-muted-foreground">История пуста</p>
              <Button size="sm" variant="outline" onClick={openAddActivity} className="gap-1.5 rounded-xl">
                <Plus className="h-4 w-4" />
                Добавить
              </Button>
            </div>
          ) : (
            <ScrollArea className="max-h-[calc(100vh-400px)]">
              <div className="relative pl-6">
                {/* Vertical line */}
                <div className="absolute left-[11px] top-2 bottom-2 w-px bg-border" />

                <div className="space-y-4">
                  {activities.map((activity) => {
                    const iconColor = ACTIVITY_ICON_COLORS[activity.type ?? 'заметка'] ?? 'bg-muted text-muted-foreground'
                    return (
                      <div key={activity.id} className="relative flex gap-3">
                        {/* Icon dot */}
                        <div className={`absolute -left-6 top-1 h-[22px] w-[22px] rounded-full flex items-center justify-center shrink-0 ${iconColor}`}>
                          {getActivityIcon(activity.type)}
                        </div>

                        {/* Content */}
                        <div className="flex-1 min-w-0">
                          <div className="bg-card border border-border/60 rounded-xl p-3 shadow-sm">
                            <div className="flex items-start justify-between gap-2">
                              <div className="flex-1 min-w-0">
                                <p className="text-sm text-foreground whitespace-pre-wrap break-words">{activity.content}</p>
                                <div className="flex flex-wrap items-center gap-x-3 gap-y-1 mt-2 text-[11px] text-muted-foreground">
                                  {activity.type && (
                                    <span className="capitalize">{activity.type.replace('_', ' ')}</span>
                                  )}
                                  {activity.contact && (
                                    <span>ЛПР: {activity.contact.name}</span>
                                  )}
                                  {activity.user && (
                                    <span>{activity.user.name}</span>
                                  )}
                                  <span>{formatDateTime(activity.created_at)}</span>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    )
                  })}
                </div>
              </div>
            </ScrollArea>
          )}

          {/* Quick Note Input */}
          <div className="mt-4 flex gap-2">
            <Input
              placeholder="Быстрая заметка..."
              value={quickNote}
              onChange={(e) => setQuickNote(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                  e.preventDefault()
                  handleQuickNote()
                }
              }}
              className="rounded-xl"
            />
            <Button
              size="sm"
              onClick={handleQuickNote}
              disabled={!quickNote.trim() || savingQuickNote}
              className="gap-1.5 rounded-xl shrink-0"
            >
              {savingQuickNote ? '...' : <Send className="h-4 w-4" />}
              <span className="hidden sm:inline">Добавить</span>
            </Button>
          </div>
        </TabsContent>

        {/* ═══════════════════════════════════════════════════════════════════════
            TAB 3: КП (Proposals)
        ═══════════════════════════════════════════════════════════════════════
        ═══════════════════════════════════════════════════════════════════════ */}
        <TabsContent value="proposals" className="mt-4">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-medium text-muted-foreground">
              {proposals.length}{' '}
              {proposals.length === 1 ? 'КП' : proposals.length < 5 ? 'КП' : 'КП'}
            </h3>
            <Button size="sm" onClick={openAddProposal} className="gap-1.5 rounded-xl">
              <Plus className="h-4 w-4" />
              Новое КП
            </Button>
          </div>

          {proposals.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-16 gap-3">
              <FileText className="h-8 w-8 text-muted-foreground" />
              <p className="text-sm text-muted-foreground">Нет коммерческих предложений</p>
              <Button size="sm" variant="outline" onClick={openAddProposal} className="gap-1.5 rounded-xl">
                <Plus className="h-4 w-4" />
                Создать КП
              </Button>
            </div>
          ) : (
            <div className="space-y-3">
              {proposals.map((proposal) => {
                const isExpanded = expandedProposal === proposal.id
                return (
                  <Card key={proposal.id} className="rounded-2xl shadow-sm hover:shadow-md transition-shadow duration-200">
                    <CardContent className="p-4">
                      <button
                        onClick={() => setExpandedProposal(isExpanded ? null : proposal.id)}
                        className="w-full text-left flex items-start justify-between gap-3"
                      >
                        <div className="flex-1 min-w-0 space-y-2">
                          <div className="flex flex-wrap items-center gap-2">
                            <p className="text-sm font-semibold">
                              {proposal.number ? `КП №${proposal.number}` : 'КП'}
                            </p>
                            {proposal.status && (
                              <Badge className={`text-[10px] ${PROPOSAL_STATUS_BADGE[proposal.status] ?? 'bg-muted text-muted-foreground border-transparent'}`}>
                                {proposal.status}
                              </Badge>
                            )}
                          </div>
                          <div className="flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-muted-foreground">
                            <span className="font-medium text-foreground">{formatCurrency(proposal.total_amount)}</span>
                            <span className="flex items-center gap-1">
                              <Calendar className="h-3 w-3" />
                              {formatDateShort(proposal.created_at)}
                            </span>
                            {proposal.valid_until && (
                              <span>
                                Действует до: {formatDateShort(proposal.valid_until)}
                                {isOverdue(proposal.valid_until) && (
                                  <span className="text-red-500 ml-1">(истекло)</span>
                                )}
                              </span>
                            )}
                          </div>
                        </div>
                        <div className="shrink-0 mt-1">
                          {isExpanded ? (
                            <ChevronUp className="h-4 w-4 text-muted-foreground" />
                          ) : (
                            <ChevronDown className="h-4 w-4 text-muted-foreground" />
                          )}
                        </div>
                      </button>

                      {/* Expanded Items */}
                      {isExpanded && proposal.items && proposal.items.length > 0 && (
                        <div className="mt-3 pt-3 border-t border-border/60">
                          <div className="rounded-lg border border-border/40 overflow-hidden">
                            <div className="bg-muted/40 px-3 py-2 grid grid-cols-[1fr_1fr_80px_100px_100px] gap-2 text-[11px] font-medium text-muted-foreground">
                              <span>Товар</span>
                              <span>Описание</span>
                              <span className="text-right">Кол-во</span>
                              <span className="text-right">Цена</span>
                              <span className="text-right">Сумма</span>
                            </div>
                            {proposal.items.map((item) => (
                              <div key={item.id} className="px-3 py-2 grid grid-cols-[1fr_1fr_80px_100px_100px] gap-2 text-xs border-t border-border/30 last:border-0">
                                <span className="font-medium truncate">{item.product_name}</span>
                                <span className="text-muted-foreground truncate">{item.description || '—'}</span>
                                <span className="text-right">{item.quantity ?? '—'} {item.unit ?? ''}</span>
                                <span className="text-right">{formatCurrency(item.price_per_unit ?? 0)}</span>
                                <span className="text-right font-medium">{formatCurrency(item.total_price ?? 0)}</span>
                              </div>
                            ))}
                          </div>
                          {proposal.notes && (
                            <p className="text-xs text-muted-foreground mt-2 italic">{proposal.notes}</p>
                          )}
                        </div>
                      )}
                    </CardContent>
                  </Card>
                )
              })}
            </div>
          )}
        </TabsContent>

        {/* ═══════════════════════════════════════════════════════════════════════
            TAB 4: Сделки
        ═══════════════════════════════════════════════════════════════════════ */}
        <TabsContent value="deals" className="mt-4">
          {companyDeals.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-12 text-muted-foreground">
              <Briefcase className="h-10 w-10 mb-3 opacity-40" />
              <p className="text-sm">Нет сделок у этого клиента</p>
              <p className="text-xs mt-1 opacity-60">Сделки можно создать на странице «Сделки»</p>
            </div>
          ) : (
            <div className="space-y-3">
              {companyDeals.map((deal) => {
                const stage = pipelineStages.find((s) => s.id === deal.stage_id)
                const stageIndex = pipelineStages.findIndex((s) => s.id === deal.stage_id)
                return (
                  <Card key={deal.id} className="rounded-xl border border-border/60 shadow-sm">
                    <CardContent className="p-4">
                      <div className="flex items-start justify-between gap-3">
                        <div className="flex-1 min-w-0">
                          <p className="text-sm font-medium">{deal.title}</p>
                          <p className="text-base font-semibold text-foreground mt-1">
                            {new Intl.NumberFormat('ru-RU', { style: 'currency', currency: 'RUB', maximumFractionDigits: 0 }).format(deal.value ?? 0)}
                          </p>
                        </div>
                        <div className="flex items-center gap-2 shrink-0">
                          {stage && (
                            <Badge className="text-[10px] px-2 py-0.5 rounded-full" style={{ backgroundColor: stage.color + '20', color: stage.color, borderColor: stage.color + '40' }}>
                              {stage.name}
                            </Badge>
                          )}
                          <button
                            onClick={() => deleteDeal(deal)}
                            className="h-7 w-7 rounded-lg flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                          >
                            <Trash2 className="h-3.5 w-3.5" />
                          </button>
                        </div>
                      </div>

                      {deal.priority && (
                        <Badge className={`text-[10px] px-1.5 py-0 mt-2 ${deal.priority === 'high' ? 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400' : deal.priority === 'medium' ? 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400' : 'bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400'}`}>
                          {deal.priority === 'high' ? 'Высокий' : deal.priority === 'medium' ? 'Средний' : 'Низкий'}
                        </Badge>
                      )}

                      {/* Stage navigation */}
                      {pipelineStages.length > 0 && (
                        <div className="flex items-center gap-2 mt-3">
                          <button
                            onClick={() => moveDeal(deal, stageIndex - 1)}
                            disabled={stageIndex <= 0}
                            className="h-6 w-6 rounded-md flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
                          >
                            <ChevronLeft className="h-3.5 w-3.5" />
                          </button>
                          <div className="flex items-center gap-1 flex-1">
                            {pipelineStages.map((s, i) => (
                              <button
                                key={s.id}
                                onClick={() => moveDeal(deal, i)}
                                className={`h-2 rounded-full transition-all duration-200 ${i === stageIndex ? 'flex-1 max-w-[40px]' : 'w-2'} hover:opacity-80`}
                                style={{ backgroundColor: i === stageIndex ? s.color : s.color + '40' }}
                                title={s.name}
                              />
                            ))}
                          </div>
                          <button
                            onClick={() => moveDeal(deal, stageIndex + 1)}
                            disabled={stageIndex >= pipelineStages.length - 1}
                            className="h-6 w-6 rounded-md flex items-center justify-center text-muted-foreground hover:text-foreground hover:bg-muted disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
                          >
                            <ChevronRight className="h-3.5 w-3.5" />
                          </button>
                        </div>
                      )}

                      <p className="text-[10px] text-muted-foreground/60 mt-2">
                        {new Date(deal.created_at).toLocaleDateString('ru-RU', { day: 'numeric', month: 'short', year: 'numeric' })}
                      </p>
                    </CardContent>
                  </Card>
                )
              })}
            </div>
          )}
        </TabsContent>

        {/* ═══════════════════════════════════════════════════════════════════════
            TAB 5: Задачи
        ═══════════════════════════════════════════════════════════════════════ */}
        <TabsContent value="tasks" className="mt-4">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-medium text-muted-foreground">
              {tasks.length}{' '}
              {tasks.length === 1 ? 'задача' : tasks.length < 5 ? 'задачи' : 'задач'}
            </h3>
            <Button size="sm" onClick={openAddTask} className="gap-1.5 rounded-xl">
              <Plus className="h-4 w-4" />
              Добавить задачу
            </Button>
          </div>

          {tasks.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-16 gap-3">
              <CheckSquare className="h-8 w-8 text-muted-foreground" />
              <p className="text-sm text-muted-foreground">Нет задач для этой компании</p>
              <Button size="sm" variant="outline" onClick={openAddTask} className="gap-1.5 rounded-xl">
                <Plus className="h-4 w-4" />
                Добавить
              </Button>
            </div>
          ) : (
            <div className="space-y-2">
              {tasks.map((task) => {
                const isDone = task.status === 'done'
                const overdue = isOverdue(task.deadline) && !isDone
                const priorityColors: Record<string, string> = {
                  low: 'bg-muted text-muted-foreground',
                  medium: 'bg-amber-500/10 text-amber-600 dark:text-amber-400',
                  high: 'bg-red-500/10 text-red-600 dark:text-red-400',
                }
                return (
                  <Card key={task.id} className="rounded-2xl shadow-sm hover:shadow-md transition-shadow duration-200">
                    <CardContent className="p-3 flex items-start gap-3">
                      <Checkbox
                        checked={isDone}
                        onCheckedChange={() => toggleTaskDone(task)}
                        className="h-5 w-5 rounded-[4px] mt-0.5 shrink-0"
                      />
                      <div className="flex-1 min-w-0">
                        <p className={`text-sm font-medium leading-snug ${isDone ? 'line-through text-muted-foreground' : ''}`}>
                          {task.title}
                        </p>
                        {task.description && (
                          <p className="text-xs text-muted-foreground mt-0.5 truncate">{task.description}</p>
                        )}
                        <div className="flex items-center gap-2 mt-1.5">
                          <Badge variant="outline" className={`text-[10px] border-transparent ${priorityColors[task.priority] ?? ''}`}>
                            {task.priority}
                          </Badge>
                          {task.deadline && (
                            <span className={`text-[11px] flex items-center gap-1 ${overdue ? 'text-red-500' : 'text-muted-foreground'}`}>
                              <Calendar className="h-3 w-3" />
                              {formatDateShort(task.deadline)}
                            </span>
                          )}
                          {task.deal_id && (() => {
                            const deal = companyDeals.find((d) => d.id === task.deal_id)
                            return deal ? (
                              <Badge variant="outline" className="text-[10px] border-amber-300 bg-amber-500/10 text-amber-600">{deal.title}</Badge>
                            ) : null
                          })()}
                          {task.assigned_to && taskUsers.length > 0 && (() => {
                            const user = taskUsers.find((u) => u.id === task.assigned_to)
                            return user ? (
                              <span className="text-[10px] text-muted-foreground">→ {user.name}</span>
                            ) : null
                          })()}
                        </div>
                      </div>
                      <button
                        onClick={() => handleDeleteTask(task.id)}
                        className="h-7 w-7 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors shrink-0"
                      >
                        <Trash2 className="h-3.5 w-3.5" />
                      </button>
                    </CardContent>
                  </Card>
                )
              })}
            </div>
          )}
        </TabsContent>

        {/* ═══════════════════════════════════════════════════════════════════════
            TAB 5: Файлы
        ═══════════════════════════════════════════════════════════════════════ */}
        <TabsContent value="files" className="mt-4">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-medium text-muted-foreground">
              {files.length}{' '}
              {files.length === 1 ? 'файл' : files.length < 5 ? 'файла' : 'файлов'}
            </h3>
            <div className="flex items-center gap-2">
              <input
                ref={fileInputRef}
                type="file"
                className="hidden"
                onChange={handleFileUpload}
              />
              <Button
                size="sm"
                onClick={() => fileInputRef.current?.click()}
                disabled={uploading}
                className="gap-1.5 rounded-xl"
              >
                {uploading ? <Loader2 className="h-4 w-4 animate-spin" /> : <Upload className="h-4 w-4" />}
                {uploading ? 'Загрузка...' : 'Загрузить файл'}
              </Button>
            </div>
          </div>

          {files.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-16 gap-3">
              <File className="h-8 w-8 text-muted-foreground" />
              <p className="text-sm text-muted-foreground">Нет загруженных файлов</p>
              <Button size="sm" variant="outline" onClick={() => fileInputRef.current?.click()} disabled={uploading} className="gap-1.5 rounded-xl">
                {uploading ? <Loader2 className="h-4 w-4 animate-spin" /> : <Upload className="h-4 w-4" />}
                Загрузить
              </Button>
            </div>
          ) : (
            <div className="space-y-3">
              {files.map((file) => {
                const iconType = getFileIcon(file.name)
                const FileIconComponent = iconType === 'image' ? Image : iconType === 'pdf' ? FileText : File
                const iconColorClass = iconType === 'image'
                  ? 'text-emerald-500'
                  : iconType === 'pdf'
                    ? 'text-red-500'
                    : iconType === 'office'
                      ? 'text-sky-500'
                      : 'text-muted-foreground'
                return (
                  <Card key={file.id} className="rounded-2xl shadow-sm hover:shadow-md transition-shadow duration-200">
                    <CardContent className="p-4">
                      <div className="flex items-center gap-3">
                        <div className={`h-10 w-10 rounded-lg flex items-center justify-center bg-muted/60 shrink-0 ${iconColorClass}`}>
                          <FileIconComponent className="h-5 w-5" />
                        </div>
                        <div className="flex-1 min-w-0">
                          <p className="text-sm font-medium truncate" title={file.name}>{file.name}</p>
                          <div className="flex items-center gap-2 mt-0.5">
                            {file.metadata?.size && typeof file.metadata.size === 'number' && (
                              <span className="text-xs text-muted-foreground">{formatFileSize(file.metadata.size)}</span>
                            )}
                            <span className="text-xs text-muted-foreground">
                              {formatDateTime(file.created_at)}
                            </span>
                          </div>
                        </div>
                        <div className="flex items-center gap-1 shrink-0">
                          <button
                            onClick={() => handleFileDownload(file.name)}
                            className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-primary hover:bg-primary/10 transition-colors"
                            title="Скачать"
                          >
                            <Download className="h-3.5 w-3.5" />
                          </button>
                          <button
                            onClick={() => handleFileDelete(file.name)}
                            className="h-8 w-8 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                            title="Удалить"
                          >
                            <Trash2 className="h-3.5 w-3.5" />
                          </button>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                )
              })}
            </div>
          )}
        </TabsContent>
      </Tabs>

      {/* DIALOG: Edit Company */}
      <Dialog open={editCompanyOpen} onOpenChange={(open) => {
        setEditCompanyOpen(open)
        if (!open) setEditForm({ name: '', inn: '', city: '', website: '', contact_phone: '', contact_email: '', source: '', status: '', notes: '', lost_reason: '' })
      }}>
        <DialogContent className="sm:max-w-lg max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Pencil className="h-5 w-5" />
              Редактировать компанию
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            <div className="space-y-2">
              <Label htmlFor="edit-name">Название компании <span className="text-destructive">*</span></Label>
              <Input id="edit-name" value={editForm.name} onChange={(e) => setEditForm((f) => ({ ...f, name: e.target.value }))} />
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="edit-inn">ИНН</Label>
                <Input id="edit-inn" value={editForm.inn} onChange={(e) => setEditForm((f) => ({ ...f, inn: e.target.value }))} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="edit-city">Город</Label>
                <Input id="edit-city" value={editForm.city} onChange={(e) => setEditForm((f) => ({ ...f, city: e.target.value }))} />
              </div>
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="edit-phone">Телефон</Label>
                <Input id="edit-phone" value={editForm.contact_phone} onChange={(e) => setEditForm((f) => ({ ...f, contact_phone: e.target.value }))} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="edit-email">Email</Label>
                <Input id="edit-email" type="email" value={editForm.contact_email} onChange={(e) => setEditForm((f) => ({ ...f, contact_email: e.target.value }))} />
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="edit-website">Веб-сайт</Label>
              <Input id="edit-website" value={editForm.website} onChange={(e) => setEditForm((f) => ({ ...f, website: e.target.value }))} placeholder="https://" />
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Источник</Label>
                <Select value={editForm.source} onValueChange={(v) => setEditForm((f) => ({ ...f, source: v }))}>
                  <SelectTrigger><SelectValue placeholder="Выберите источник" /></SelectTrigger>
                  <SelectContent>
                    {companySources.map((s) => (
                      <SelectItem key={s} value={s}>{s}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Статус</Label>
                <Select value={editForm.status} onValueChange={(v) => setEditForm((f) => ({ ...f, status: v }))}>
                  <SelectTrigger><SelectValue placeholder="Выберите статус" /></SelectTrigger>
                  <SelectContent>
                    {companyStatuses.map((s) => (
                      <SelectItem key={s} value={s}>{s}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="edit-notes">Заметки</Label>
              <Textarea id="edit-notes" value={editForm.notes} onChange={(e) => setEditForm((f) => ({ ...f, notes: e.target.value }))} rows={3} className="resize-none" />
            </div>
            {(editForm.status === 'отказ' || editForm.status === 'не актуально') && (
              <div className="space-y-2">
                <Label>Причина отказа</Label>
                <Select value={editForm.lost_reason} onValueChange={(v) => setEditForm((f) => ({ ...f, lost_reason: v }))}>
                  <SelectTrigger><SelectValue placeholder="Выберите причину" /></SelectTrigger>
                  <SelectContent>
                    {lostReasons.map((r) => (
                      <SelectItem key={r} value={r}>{r}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            )}
            <div className="flex justify-end gap-2 pt-2">
              <Button variant="outline" onClick={() => setEditCompanyOpen(false)}>Отмена</Button>
              <Button onClick={handleSaveCompany} disabled={!editForm.name.trim() || savingCompany} className="rounded-xl">
                {savingCompany ? 'Сохранение...' : 'Сохранить'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      {/* ═══════════════════════════════════════════════════════════════════════
          DIALOG: Delete Company
      ═══════════════════════════════════════════════════════════════════════ */}
      <AlertDialog open={deleteOpen} onOpenChange={setDeleteOpen}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Удалить компанию?</AlertDialogTitle>
            <AlertDialogDescription>
              Компания «{company.name}» и все связанные данные (контакты, история, КП, задачи) будут удалены навсегда. Это действие нельзя отменить.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel disabled={deleting}>Отмена</AlertDialogCancel>
            <AlertDialogAction
              onClick={handleDeleteCompany}
              disabled={deleting}
              className="bg-destructive text-destructive-foreground hover:bg-destructive/90"
            >
              {deleting ? 'Удаление...' : 'Удалить'}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      {/* ═══════════════════════════════════════════════════════════════════════
          DIALOG: Add/Edit Contact
      ═══════════════════════════════════════════════════════════════════════ */}
      <Dialog open={contactDialogOpen} onOpenChange={(open) => {
        setContactDialogOpen(open)
        if (!open) { setEditingContact(null); setContactForm({ name: '', position: '', phone: '', email: '', whatsapp: '', notes: '', is_primary: false }) }
      }}>
        <DialogContent className="sm:max-w-lg max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              {editingContact ? <><Pencil className="h-5 w-5" /> Редактировать контакт</> : <><Plus className="h-5 w-5" /> Новый контакт ЛПР</>}
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            <div className="space-y-2">
              <Label htmlFor="contact-fio">ФИО <span className="text-destructive">*</span></Label>
              <Input id="contact-fio" value={contactForm.name} onChange={(e) => setContactForm((f) => ({ ...f, name: e.target.value }))} placeholder="Иванов Иван Иванович" />
            </div>
            <div className="space-y-2">
              <Label htmlFor="contact-position">Должность</Label>
              <Input id="contact-position" value={contactForm.position} onChange={(e) => setContactForm((f) => ({ ...f, position: e.target.value }))} placeholder="Коммерческий директор" />
            </div>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="contact-phone">Телефон</Label>
                <Input id="contact-phone" value={contactForm.phone} onChange={(e) => setContactForm((f) => ({ ...f, phone: e.target.value }))} placeholder="+7 (999) 000-0000" />
              </div>
              <div className="space-y-2">
                <Label htmlFor="contact-email">Email</Label>
                <Input id="contact-email" type="email" value={contactForm.email} onChange={(e) => setContactForm((f) => ({ ...f, email: e.target.value }))} />
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="contact-whatsapp">WhatsApp</Label>
              <Input id="contact-whatsapp" value={contactForm.whatsapp} onChange={(e) => setContactForm((f) => ({ ...f, whatsapp: e.target.value }))} placeholder="+7 (999) 000-0000" />
            </div>
            <div className="space-y-2">
              <Label htmlFor="contact-notes">Заметки</Label>
              <Textarea id="contact-notes" value={contactForm.notes} onChange={(e) => setContactForm((f) => ({ ...f, notes: e.target.value }))} rows={2} className="resize-none" />
            </div>
            <div className="flex items-center gap-2">
              <Checkbox
                id="contact-primary"
                checked={contactForm.is_primary}
                onCheckedChange={(checked) => setContactForm((f) => ({ ...f, is_primary: !!checked }))}
              />
              <Label htmlFor="contact-primary" className="cursor-pointer">Основной ЛПР</Label>
            </div>
            <div className="flex justify-end gap-2 pt-2">
              <Button variant="outline" onClick={() => setContactDialogOpen(false)}>Отмена</Button>
              <Button onClick={handleSaveContact} disabled={!contactForm.name.trim() || savingContact} className="rounded-xl">
                {savingContact ? 'Сохранение...' : editingContact ? 'Обновить' : 'Добавить'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      {/* ═══════════════════════════════════════════════════════════════════════
          DIALOG: Add Activity
      ═══════════════════════════════════════════════════════════════════════ */}
      <Dialog open={activityDialogOpen} onOpenChange={(open) => {
        setActivityDialogOpen(open)
        if (!open) setActivityForm({ type: 'заметка', contact_id: '', content: '', next_contact_date: '' })
      }}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Plus className="h-5 w-5" />
              Добавить активность
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Тип</Label>
                <Select value={activityForm.type} onValueChange={(v) => setActivityForm((f) => ({ ...f, type: v }))}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    {activityTypes.map((t) => (
                      <SelectItem key={t} value={t}>{t.replace('_', ' ')}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Контакт ЛПР</Label>
                <Select value={activityForm.contact_id} onValueChange={(v) => setActivityForm((f) => ({ ...f, contact_id: v }))}>
                  <SelectTrigger><SelectValue placeholder="Выберите" /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="none">— Не выбран —</SelectItem>
                    {contacts.map((c) => (
                      <SelectItem key={c.id} value={c.id}>{c.name}{c.position ? ` (${c.position})` : ''}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="space-y-2">
              <Label htmlFor="activity-content">Содержание <span className="text-destructive">*</span></Label>
              <Textarea id="activity-content" value={activityForm.content} onChange={(e) => setActivityForm((f) => ({ ...f, content: e.target.value }))} rows={4} className="resize-none" />
            </div>
            <div className="space-y-2">
              <Label htmlFor="activity-next-date">Дата следующего контакта</Label>
              <Input id="activity-next-date" type="date" value={activityForm.next_contact_date} onChange={(e) => setActivityForm((f) => ({ ...f, next_contact_date: e.target.value }))} />
            </div>
            <div className="flex justify-end gap-2 pt-2">
              <Button variant="outline" onClick={() => setActivityDialogOpen(false)}>Отмена</Button>
              <Button onClick={handleSaveActivity} disabled={!activityForm.content.trim() || savingActivity} className="rounded-xl">
                {savingActivity ? 'Сохранение...' : 'Добавить'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      {/* ═══════════════════════════════════════════════════════════════════════
          DIALOG: Add Proposal
      ═══════════════════════════════════════════════════════════════════════ */}
      <Dialog open={proposalDialogOpen} onOpenChange={(open) => {
        setProposalDialogOpen(open)
        if (!open) setProposalForm({ number: '', status: 'отправлено', valid_until: '', notes: '', items: [{ ...EMPTY_PROPOSAL_ITEM }] })
      }}>
        <DialogContent className="sm:max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Plus className="h-5 w-5" />
              Новое коммерческое предложение
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              <div className="space-y-2">
                <Label htmlFor="proposal-number">Номер КП</Label>
                <Input id="proposal-number" value={proposalForm.number} onChange={(e) => setProposalForm((f) => ({ ...f, number: e.target.value }))} placeholder="КП-001" />
              </div>
              <div className="space-y-2">
                <Label>Статус</Label>
                <Select value={proposalForm.status} onValueChange={(v) => setProposalForm((f) => ({ ...f, status: v }))}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    {proposalStatuses.map((s) => (
                      <SelectItem key={s} value={s}>{s}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="proposal-valid">Срок действия</Label>
                <Input id="proposal-valid" type="date" value={proposalForm.valid_until} onChange={(e) => setProposalForm((f) => ({ ...f, valid_until: e.target.value }))} />
              </div>
            </div>

            <Separator />

            {/* Items */}
            <div>
              <div className="flex items-center justify-between mb-3">
                <Label className="text-sm font-medium">Позиции</Label>
                <Button type="button" size="sm" variant="outline" onClick={addProposalItem} className="gap-1 rounded-lg text-xs">
                  <Plus className="h-3 w-3" />
                  Добавить позицию
                </Button>
              </div>

              <div className="space-y-3">
                {proposalForm.items.map((item, idx) => (
                  <div key={idx} className="relative rounded-xl border border-border/60 p-3 bg-muted/20">
                    <button
                      type="button"
                      onClick={() => removeProposalItem(idx)}
                      className="absolute top-2 right-2 h-6 w-6 rounded-md inline-flex items-center justify-center text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors"
                      disabled={proposalForm.items.length <= 1}
                    >
                      <X className="h-3.5 w-3.5" />
                    </button>
                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 pr-6">
                      <div className="space-y-1">
                        <Label className="text-xs">Товар <span className="text-destructive">*</span></Label>
                        <Input
                          placeholder="Наименование"
                          value={item.product_name}
                          onChange={(e) => updateProposalItem(idx, 'product_name', e.target.value)}
                          className="h-9 text-sm"
                        />
                      </div>
                      <div className="space-y-1">
                        <Label className="text-xs">Описание</Label>
                        <Input
                          placeholder="Описание товара"
                          value={item.description}
                          onChange={(e) => updateProposalItem(idx, 'description', e.target.value)}
                          className="h-9 text-sm"
                        />
                      </div>
                    </div>
                    <div className="grid grid-cols-3 gap-3 mt-2">
                      <div className="space-y-1">
                        <Label className="text-xs">Кол-во</Label>
                        <Input
                          type="number"
                          min={1}
                          value={item.quantity || ''}
                          onChange={(e) => updateProposalItem(idx, 'quantity', Number(e.target.value) || 0)}
                          className="h-9 text-sm"
                        />
                      </div>
                      <div className="space-y-1">
                        <Label className="text-xs">Цена за ед. (₽)</Label>
                        <Input
                          type="number"
                          min={0}
                          step={100}
                          value={item.price_per_unit || ''}
                          onChange={(e) => updateProposalItem(idx, 'price_per_unit', Number(e.target.value) || 0)}
                          className="h-9 text-sm"
                        />
                      </div>
                      <div className="space-y-1">
                        <Label className="text-xs">Сумма (₽)</Label>
                        <div className="h-9 px-3 flex items-center text-sm font-medium bg-muted/50 rounded-md border border-border/40">
                          {formatCurrency((item.quantity || 0) * (item.price_per_unit || 0))}
                        </div>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Total */}
            <div className="flex items-center justify-between bg-muted/40 rounded-xl px-4 py-3">
              <span className="text-sm font-medium">Итого:</span>
              <span className="text-lg font-bold">{formatCurrency(proposalTotal)}</span>
            </div>

            <div className="space-y-2">
              <Label htmlFor="proposal-notes">Примечание</Label>
              <Textarea id="proposal-notes" value={proposalForm.notes} onChange={(e) => setProposalForm((f) => ({ ...f, notes: e.target.value }))} rows={2} className="resize-none" />
            </div>

            <div className="flex justify-end gap-2 pt-2">
              <Button variant="outline" onClick={() => setProposalDialogOpen(false)}>Отмена</Button>
              <Button onClick={handleSaveProposal} disabled={savingProposal || !proposalForm.items.some((i) => i.product_name.trim())} className="rounded-xl">
                {savingProposal ? 'Создание...' : 'Создать КП'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      {/* ═══════════════════════════════════════════════════════════════════════
          DIALOG: Add Task
      ═══════════════════════════════════════════════════════════════════════ */}
      <Dialog open={taskDialogOpen} onOpenChange={(open) => {
        setTaskDialogOpen(open)
        if (!open) setTaskForm({ title: '', description: '', priority: 'medium', deadline: '', deal_id: '', assigned_to: '' })
      }}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Plus className="h-5 w-5" />
              Новая задача
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-4 pt-2">
            <div className="space-y-2">
              <Label htmlFor="task-title">Название <span className="text-destructive">*</span></Label>
              <Input id="task-title" value={taskForm.title} onChange={(e) => setTaskForm((f) => ({ ...f, title: e.target.value }))} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="task-desc">Описание</Label>
              <Textarea id="task-desc" value={taskForm.description} onChange={(e) => setTaskForm((f) => ({ ...f, description: e.target.value }))} rows={3} className="resize-none" />
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
                <Label htmlFor="task-deadline">Срок</Label>
                <Input id="task-deadline" type="date" value={taskForm.deadline} onChange={(e) => setTaskForm((f) => ({ ...f, deadline: e.target.value }))} />
              </div>
            </div>
            <div className="space-y-2">
              <Label>Сделка</Label>
              <Select value={taskForm.deal_id} onValueChange={(v) => setTaskForm((f) => ({ ...f, deal_id: v }))}>
                <SelectTrigger><SelectValue placeholder="Выберите сделку (необязательно)" /></SelectTrigger>
                <SelectContent>
                  {companyDeals.map((d) => (
                    <SelectItem key={d.id} value={d.id}>{d.title}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Исполнитель</Label>
              <Select value={taskForm.assigned_to} onValueChange={(v) => setTaskForm((f) => ({ ...f, assigned_to: v }))}>
                <SelectTrigger><SelectValue placeholder="Выберите исполнителя (необязательно)" /></SelectTrigger>
                <SelectContent>
                  {taskUsers.map((u) => (
                    <SelectItem key={u.id} value={u.id}>{u.name}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="flex justify-end gap-2 pt-2">
              <Button variant="outline" onClick={() => setTaskDialogOpen(false)}>Отмена</Button>
              <Button onClick={handleSaveTask} disabled={!taskForm.title.trim() || savingTask} className="rounded-xl">
                {savingTask ? 'Создание...' : 'Создать задачу'}
              </Button>
            </div>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  )
}
