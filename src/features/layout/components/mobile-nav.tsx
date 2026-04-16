'use client'

import { useNavigationStore } from '@/lib/store'
import { NAV_SECTIONS } from '@/lib/section-colors'

export function MobileNav() {
  const currentView = useNavigationStore((s) => s.currentView)
  const navigate = useNavigationStore((s) => s.navigate)

  return (
    <nav className="fixed inset-x-0 bottom-0 z-50 md:hidden">
      {/* Safe area spacer */}
      <div className="pb-[env(safe-area-inset-bottom)]">
        <div className="border-t border-border/60 bg-card/95 backdrop-blur-lg">
          <div className="flex items-center justify-around px-1 py-1">
            {NAV_SECTIONS.map((section) => {
              const Icon = section.icon
              const isActive = currentView === section.view

              return (
                <button
                  key={section.view}
                  onClick={() => navigate(section.view)}
                  className="relative flex flex-1 flex-col items-center gap-0.5 py-2"
                >
                  {/* Active pill background */}
                  <div
                    className={`absolute inset-y-1 inset-x-1.5 rounded-xl transition-all duration-200 ease-in-out ${
                      isActive
                        ? `${section.tintClass} scale-100 opacity-100`
                        : 'scale-90 opacity-0'
                    }`}
                  />
                  {/* Content */}
                  <div className="relative flex flex-col items-center gap-0.5">
                    {/* Icon — colored circle when active, outline when inactive */}
                    <div
                      className={`flex h-7 w-7 items-center justify-center rounded-full transition-all duration-200 ease-in-out ${
                        isActive
                          ? `${section.bgClass} shadow-sm ${section.shadowClass}`
                          : ''
                      }`}
                    >
                      <Icon
                        className={`h-[14px] w-[14px] transition-all duration-200 ease-in-out ${
                          isActive
                            ? 'text-white scale-100'
                            : 'text-muted-foreground scale-95'
                        }`}
                      />
                    </div>
                    <span
                      className={`text-[10px] font-medium leading-none transition-all duration-200 ease-in-out ${
                        isActive
                          ? section.accentTextClass
                          : 'text-muted-foreground'
                      }`}
                    >
                      {section.label}
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
