'use client'

import {
  LayoutDashboard,
  Kanban,
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
}

const mobileNavItems: MobileNavItem[] = [
  { view: 'dashboard', label: 'Панель', icon: LayoutDashboard },
  { view: 'deals', label: 'Сделки', icon: Kanban },
  { view: 'contacts', label: 'Контакты', icon: Users },
  { view: 'tasks', label: 'Задачи', icon: CheckSquare },
  { view: 'settings', label: 'Настройки', icon: Settings },
]

export function MobileNav() {
  const currentView = useNavigationStore((s) => s.currentView)
  const navigate = useNavigationStore((s) => s.navigate)

  return (
    <nav className="fixed inset-x-0 bottom-0 z-50 border-t border-border bg-background/95 backdrop-blur-md md:hidden">
      <div className="flex items-center justify-around px-1 pb-[env(safe-area-inset-bottom)]">
        {mobileNavItems.map((item) => {
          const Icon = item.icon
          const isActive = currentView === item.view

          return (
            <button
              key={item.view}
              onClick={() => navigate(item.view)}
              className={`flex flex-1 flex-col items-center gap-0.5 py-2 pt-2.5 transition-colors ${
                isActive
                  ? 'text-primary'
                  : 'text-muted-foreground hover:text-foreground'
              }`}
            >
              <Icon className="h-5 w-5" />
              <span className="text-[10px] font-medium leading-none">
                {item.label}
              </span>
              {isActive && (
                <span className="absolute top-0 h-0.5 w-6 rounded-full bg-primary" />
              )}
            </button>
          )
        })}
      </div>
    </nav>
  )
}
