'use client'

import {
  LayoutDashboard,
  FileText,
  Users,
  CheckSquare,
  Settings,
} from 'lucide-react'
import { useNavigationStore } from '@/lib/store'
import type { AppView } from '@/lib/store'
import type { LucideIcon } from 'lucide-react'

interface MobileNavItem {
  view: AppView
  label: string
  icon: LucideIcon
  color: string   // Tailwind bg class for active icon circle
  tint: string    // Tailwind bg class for active pill
  text: string    // Tailwind text class for active label
  iconColor: string // Tailwind text class for always-visible icon color
}

const mobileNavItems: MobileNavItem[] = [
  { view: 'dashboard', label: 'Панель', icon: LayoutDashboard, color: 'bg-blue-500', tint: 'bg-blue-50', text: 'text-blue-600', iconColor: 'text-blue-500' },
  { view: 'proposals', label: 'КП', icon: FileText, color: 'bg-amber-500', tint: 'bg-amber-50', text: 'text-amber-600', iconColor: 'text-amber-500' },
  { view: 'companies', label: 'Клиенты', icon: Users, color: 'bg-emerald-500', tint: 'bg-emerald-50', text: 'text-emerald-600', iconColor: 'text-emerald-500' },
  { view: 'tasks', label: 'Задачи', icon: CheckSquare, color: 'bg-violet-500', tint: 'bg-violet-50', text: 'text-violet-600', iconColor: 'text-violet-500' },
  { view: 'settings', label: 'Настройки', icon: Settings, color: 'bg-gray-500', tint: 'bg-gray-50', text: 'text-gray-600', iconColor: 'text-gray-400' },
]

export function MobileNav() {
  const currentView = useNavigationStore((s) => s.currentView)
  const navigate = useNavigationStore((s) => s.navigate)

  return (
    <nav className="fixed inset-x-0 bottom-0 z-50 md:hidden">
      {/* Safe area spacer */}
      <div className="pb-[env(safe-area-inset-bottom)]">
        {/* Border top with subtle gradient */}
        <div className="border-t border-border/80 bg-card">
          <div className="flex items-center justify-around px-1 py-1.5">
            {mobileNavItems.map((item) => {
              const Icon = item.icon
              const isActive = currentView === item.view

              return (
                <button
                  key={item.view}
                  onClick={() => navigate(item.view)}
                  className="relative flex flex-1 flex-col items-center gap-1 min-h-[44px] justify-center py-2 px-1"
                >
                  {/* Active pill background */}
                  <div
                    className={`absolute inset-y-1 inset-x-1.5 rounded-xl transition-opacity duration-200 ease-in-out ${
                      isActive
                        ? `${item.tint} opacity-100`
                        : 'opacity-0'
                    }`}
                  />
                  {/* Content */}
                  <div className="relative flex flex-col items-center gap-0.5">
                    {/* Icon — same size always, colored */}
                    <div className={`flex h-9 w-9 items-center justify-center rounded-full transition-colors duration-200 ease-in-out ${
                      isActive ? `${item.color} shadow-sm` : ''
                    }`}>
                      <Icon
                        className={`h-6 w-6 transition-colors duration-200 ease-in-out ${
                          isActive ? 'text-white' : item.iconColor
                        }`}
                      />
                    </div>
                    <span
                      className={`text-[11px] font-medium leading-none transition-colors duration-200 ease-in-out ${
                        isActive ? item.text : 'text-muted-foreground'
                      }`}
                    >
                      {item.label}
                    </span>
                  </div>
                </button>
              )
            })}
          </div>
        </div>
      </div>
    </nav>
  )
}
