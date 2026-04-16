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
  color: string   // Tailwind bg class for active icon circle
  tint: string    // Tailwind bg class for active pill
  text: string    // Tailwind text class for active label
}

const mobileNavItems: MobileNavItem[] = [
  { view: 'dashboard', label: 'Панель', icon: LayoutDashboard, color: 'bg-blue-500', tint: 'bg-blue-50', text: 'text-blue-600' },
  { view: 'deals', label: 'Сделки', icon: Kanban, color: 'bg-amber-500', tint: 'bg-amber-50', text: 'text-amber-600' },
  { view: 'contacts', label: 'Контакты', icon: Users, color: 'bg-emerald-500', tint: 'bg-emerald-50', text: 'text-emerald-600' },
  { view: 'tasks', label: 'Задачи', icon: CheckSquare, color: 'bg-violet-500', tint: 'bg-violet-50', text: 'text-violet-600' },
  { view: 'settings', label: 'Настройки', icon: Settings, color: 'bg-gray-500', tint: 'bg-gray-50', text: 'text-gray-600' },
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
                    className={`absolute inset-y-1 inset-x-1.5 rounded-xl transition-all duration-200 ease-in-out ${
                      isActive
                        ? `${item.tint} scale-100 opacity-100`
                        : 'scale-90 opacity-0'
                    }`}
                  />
                  {/* Content */}
                  <div className="relative flex flex-col items-center gap-0.5">
                    {/* Colored circle when active */}
                    <div className={`flex h-7 w-7 items-center justify-center rounded-full transition-all duration-200 ease-in-out ${
                      isActive ? `${item.color} shadow-sm` : ''
                    }`}>
                      <Icon
                        className={`h-3.5 w-3.5 transition-all duration-200 ease-in-out ${
                          isActive
                            ? 'text-white'
                            : 'text-muted-foreground'
                        }`}
                      />
                    </div>
                    <span
                      className={`text-[10px] font-medium leading-none transition-all duration-200 ease-in-out ${
                        isActive
                          ? item.text
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
