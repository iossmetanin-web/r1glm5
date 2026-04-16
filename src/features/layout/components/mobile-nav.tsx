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
    <nav className="fixed inset-x-0 bottom-0 z-50 md:hidden">
      {/* Safe area spacer */}
      <div className="pb-[env(safe-area-inset-bottom)]">
        {/* Border top with subtle gradient */}
        <div className="border-t border-border/80 bg-card/95 backdrop-blur-lg">
          <div className="flex items-center justify-around px-2 py-1">
            {mobileNavItems.map((item) => {
              const Icon = item.icon
              const isActive = currentView === item.view

              return (
                <button
                  key={item.view}
                  onClick={() => navigate(item.view)}
                  className="relative flex flex-1 flex-col items-center gap-0.5 py-2"
                >
                  {/* Active pill background */}
                  <div
                    className={`absolute inset-y-1 inset-x-1 rounded-xl transition-all duration-200 ease-in-out ${
                      isActive
                        ? 'bg-primary/10 scale-100 opacity-100'
                        : 'scale-95 opacity-0'
                    }`}
                  />
                  {/* Content */}
                  <div className="relative flex flex-col items-center gap-0.5">
                    <Icon
                      className={`h-5 w-5 transition-all duration-200 ease-in-out ${
                        isActive
                          ? 'text-primary scale-110'
                          : 'text-muted-foreground'
                      }`}
                    />
                    <span
                      className={`text-[10px] font-medium leading-none transition-all duration-200 ease-in-out ${
                        isActive
                          ? 'text-primary'
                          : 'text-muted-foreground'
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
