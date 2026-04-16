import type { LucideIcon } from 'lucide-react'
import {
  LayoutDashboard,
  Kanban,
  Users,
  CheckSquare,
  Settings,
} from 'lucide-react'
import type { AppView } from '@/lib/store'

/**
 * Telegram-style section color system.
 * Each section has a fixed color identity used across
 * sidebar, mobile nav, page headers, cards, and buttons.
 */

export interface SectionConfig {
  view: AppView
  label: string
  icon: LucideIcon
  /** Main section color — hex */
  color: string
  /** Tailwind bg class for the colored circle bg */
  bgClass: string
  /** Tailwind text class for the icon inside the circle */
  textClass: string
  /** Tailwind bg class for light tinted backgrounds (active states) */
  tintClass: string
  /** Tailwind text class for colored text accents */
  accentTextClass: string
  /** Tailwind border class for subtle colored borders */
  borderClass: string
  /** Tailwind ring/shadow class for glows */
  shadowClass: string
}

export const SECTION_COLORS: Record<AppView, SectionConfig> = {
  dashboard: {
    view: 'dashboard',
    label: 'Панель',
    icon: LayoutDashboard,
    color: '#3B82F6',
    bgClass: 'bg-blue-500',
    textClass: 'text-blue-500',
    tintClass: 'bg-blue-50',
    accentTextClass: 'text-blue-600',
    borderClass: 'border-blue-200',
    shadowClass: 'shadow-blue-500/20',
  },
  deals: {
    view: 'deals',
    label: 'Сделки',
    icon: Kanban,
    color: '#F59E0B',
    bgClass: 'bg-amber-500',
    textClass: 'text-amber-500',
    tintClass: 'bg-amber-50',
    accentTextClass: 'text-amber-600',
    borderClass: 'border-amber-200',
    shadowClass: 'shadow-amber-500/20',
  },
  contacts: {
    view: 'contacts',
    label: 'Контакты',
    icon: Users,
    color: '#10B981',
    bgClass: 'bg-emerald-500',
    textClass: 'text-emerald-500',
    tintClass: 'bg-emerald-50',
    accentTextClass: 'text-emerald-600',
    borderClass: 'border-emerald-200',
    shadowClass: 'shadow-emerald-500/20',
  },
  tasks: {
    view: 'tasks',
    label: 'Задачи',
    icon: CheckSquare,
    color: '#8B5CF6',
    bgClass: 'bg-violet-500',
    textClass: 'text-violet-500',
    tintClass: 'bg-violet-50',
    accentTextClass: 'text-violet-600',
    borderClass: 'border-violet-200',
    shadowClass: 'shadow-violet-500/20',
  },
  'deal-detail': {
    view: 'deal-detail',
    label: 'Детали сделки',
    icon: Kanban,
    color: '#F59E0B',
    bgClass: 'bg-amber-500',
    textClass: 'text-amber-500',
    tintClass: 'bg-amber-50',
    accentTextClass: 'text-amber-600',
    borderClass: 'border-amber-200',
    shadowClass: 'shadow-amber-500/20',
  },
  settings: {
    view: 'settings',
    label: 'Настройки',
    icon: Settings,
    color: '#6B7280',
    bgClass: 'bg-gray-500',
    textClass: 'text-gray-500',
    tintClass: 'bg-gray-50',
    accentTextClass: 'text-gray-600',
    borderClass: 'border-gray-200',
    shadowClass: 'shadow-gray-500/20',
  },
}

/** Ordered nav items for sidebar and mobile nav */
export const NAV_SECTIONS: SectionConfig[] = [
  SECTION_COLORS.dashboard,
  SECTION_COLORS.deals,
  SECTION_COLORS.contacts,
  SECTION_COLORS.tasks,
  SECTION_COLORS.settings,
]

/** Get color config for the current view */
export function getSectionConfig(view: AppView): SectionConfig {
  return SECTION_COLORS[view] ?? SECTION_COLORS.dashboard
}
