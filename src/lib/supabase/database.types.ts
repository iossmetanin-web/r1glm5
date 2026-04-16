// Database types matching the actual Supabase schema
// Updated for transformer equipment CRM

export interface Database {
  public: {
    Tables: {
      // ── Companies (main client table) ───────────────────────────
      companies: {
        Row: {
          id: string; name: string; inn: string | null; city: string | null
          website: string | null; contact_phone: string | null; contact_email: string | null
          source: string | null; status: string | null; manager_id: string | null
          next_contact_date: string | null; lost_reason: string | null; notes: string | null
          created_at: string; updated_at: string
        }
        Insert: {
          id?: string; name: string; inn?: string | null; city?: string | null
          website?: string | null; contact_phone?: string | null; contact_email?: string | null
          source?: string | null; status?: string | null; manager_id?: string | null
          next_contact_date?: string | null; lost_reason?: string | null; notes?: string | null
          created_at?: string; updated_at?: string
        }
        Update: {
          id?: string; name?: string; inn?: string | null; city?: string | null
          website?: string | null; contact_phone?: string | null; contact_email?: string | null
          source?: string | null; status?: string | null; manager_id?: string | null
          next_contact_date?: string | null; lost_reason?: string | null; notes?: string | null
          created_at?: string; updated_at?: string
        }
      }

      // ── Company Contacts (LPR) ──────────────────────────────────
      company_contacts: {
        Row: {
          id: string; company_id: string; name: string; position: string | null
          phone: string | null; email: string | null; whatsapp: string | null
          notes: string | null; is_primary: boolean | null; created_at: string
        }
        Insert: {
          id?: string; company_id: string; name: string; position?: string | null
          phone?: string | null; email?: string | null; whatsapp?: string | null
          notes?: string | null; is_primary?: boolean | null; created_at?: string
        }
        Update: {
          id?: string; company_id?: string; name?: string; position?: string | null
          phone?: string | null; email?: string | null; whatsapp?: string | null
          notes?: string | null; is_primary?: boolean | null; created_at?: string
        }
      }

      // ── Proposals (КП) ─────────────────────────────────────────
      proposals: {
        Row: {
          id: string; company_id: string; manager_id: string | null
          number: string | null; status: string | null; total_amount: number | null
          valid_until: string | null; notes: string | null; created_at: string; updated_at: string
        }
        Insert: {
          id?: string; company_id: string; manager_id?: string | null
          number?: string | null; status?: string | null; total_amount?: number | null
          valid_until?: string | null; notes?: string | null; created_at?: string; updated_at?: string
        }
        Update: {
          id?: string; company_id?: string; manager_id?: string | null
          number?: string | null; status?: string | null; total_amount?: number | null
          valid_until?: string | null; notes?: string | null; created_at?: string; updated_at?: string
        }
      }

      // ── Proposal Items ─────────────────────────────────────────
      proposal_items: {
        Row: {
          id: string; proposal_id: string; product_name: string; description: string | null
          quantity: number | null; unit: string | null; price_per_unit: number | null
          total_price: number | null; created_at: string
        }
        Insert: {
          id?: string; proposal_id: string; product_name: string; description?: string | null
          quantity?: number | null; unit?: string | null; price_per_unit?: number | null
          total_price?: number | null; created_at?: string
        }
        Update: {
          id?: string; proposal_id?: string; product_name?: string; description?: string | null
          quantity?: number | null; unit?: string | null; price_per_unit?: number | null
          total_price?: number | null; created_at?: string
        }
      }

      // ── Users ──────────────────────────────────────────────────
      users: {
        Row: { id: string; name: string; email: string; role: string; created_at: string }
        Insert: { id?: string; name: string; email: string; role?: string; created_at?: string }
        Update: { id?: string; name?: string; email?: string; role?: string; created_at?: string }
      }

      // ── Activities (enhanced timeline) ──────────────────────────
      activities: {
        Row: {
          id: string; company_id: string | null; contact_id: string | null; user_id: string | null
          type: string | null; content: string; next_contact_date: string | null; created_at: string
        }
        Insert: {
          id?: string; company_id?: string | null; contact_id?: string | null; user_id?: string | null
          type?: string | null; content: string; next_contact_date?: string | null; created_at?: string
        }
        Update: {
          id?: string; company_id?: string | null; contact_id?: string | null; user_id?: string | null
          type?: string | null; content?: string; next_contact_date?: string | null; created_at?: string
        }
      }

      // ── Deals ──────────────────────────────────────────────────
      deals: {
        Row: {
          id: string; title: string; value: number; currency: string
          client_id: string | null; pipeline_id: string; stage_id: string
          owner_id: string; status: string; created_at: string
          probability: number | null; expected_close_date: string | null
          source: string | null; priority: string | null; lost_reason: string | null
        }
        Insert: {
          id?: string; title: string; value?: number; currency?: string
          client_id?: string | null; pipeline_id?: string; stage_id?: string
          owner_id?: string; status?: string; created_at?: string
          probability?: number | null; expected_close_date?: string | null
          source?: string | null; priority?: string | null; lost_reason?: string | null
        }
        Update: {
          id?: string; title?: string; value?: number; currency?: string
          client_id?: string | null; pipeline_id?: string; stage_id?: string
          owner_id?: string; status?: string; created_at?: string
          probability?: number | null; expected_close_date?: string | null
          source?: string | null; priority?: string | null; lost_reason?: string | null
        }
      }

      // ── Pipeline Stages ────────────────────────────────────────
      pipeline_stages: {
        Row: {
          id: string; pipeline_id: string; name: string; position: number
          probability: number; color: string; is_won: boolean; is_closed: boolean
        }
        Insert: {
          id?: string; pipeline_id?: string; name: string; position?: number
          probability?: number; color?: string; is_won?: boolean; is_closed?: boolean
        }
        Update: {
          id?: string; pipeline_id?: string; name?: string; position?: number
          probability?: number; color?: string; is_won?: boolean; is_closed?: boolean
        }
      }

      // ── Tasks (enhanced) ───────────────────────────────────────
      tasks: {
        Row: {
          id: string; title: string; description: string | null; status: string
          priority: string; deadline: string | null; project_id: string | null
          client_id: string | null; company_id: string | null; created_by: string | null
          created_at: string; is_recurring: boolean | null; recurrence_days: number | null
          last_recurrence: string | null; is_shared: boolean | null
        }
        Insert: {
          id?: string; title: string; description?: string | null; status?: string
          priority?: string; deadline?: string | null; project_id?: string | null
          client_id?: string | null; company_id?: string | null; created_by?: string | null
          created_at?: string; is_recurring?: boolean | null; recurrence_days?: number | null
          last_recurrence?: string | null; is_shared?: boolean | null
        }
        Update: {
          id?: string; title?: string; description?: string | null; status?: string
          priority?: string; deadline?: string | null; project_id?: string | null
          client_id?: string | null; company_id?: string | null; created_by?: string | null
          created_at?: string; is_recurring?: boolean | null; recurrence_days?: number | null
          last_recurrence?: string | null; is_shared?: boolean | null
        }
      }

      // ── Legacy tables (kept for compatibility) ─────────────────
      clients: {
        Row: {
          id: string; name: string; company: string | null; phone: string | null
          email: string | null; stage: string | null; created_at: string
        }
        Insert: {
          id?: string; name: string; company?: string | null; phone?: string | null
          email?: string | null; stage?: string | null; created_at?: string
        }
        Update: {
          id?: string; name?: string; company?: string | null; phone?: string | null
          email?: string | null; stage?: string | null; created_at?: string
        }
      }

      comments: {
        Row: {
          id: string; text: string; user_id: string | null
          created_at: string; entity_type: string | null; entity_id: string | null
        }
        Insert: {
          id?: string; text: string; user_id?: string | null
          created_at?: string; entity_type?: string | null; entity_id?: string | null
        }
        Update: {
          id?: string; text?: string; user_id?: string | null
          created_at?: string; entity_type?: string | null; entity_id?: string | null
        }
      }

      deal_comments: {
        Row: {
          id: string; deal_id: string; user_id: string | null
          comment: string; created_at: string
        }
        Insert: {
          id?: string; deal_id?: string; user_id?: string | null
          comment: string; created_at?: string
        }
        Update: {
          id?: string; deal_id?: string; user_id?: string | null
          comment?: string; created_at?: string
        }
      }

      reminders: {
        Row: {
          id: string; title: string; user_id: string | null
          created_at: string; deal_id: string | null; completed: boolean | null
        }
        Insert: {
          id?: string; title: string; user_id?: string | null
          created_at?: string; deal_id?: string | null; completed?: boolean | null
        }
        Update: {
          id?: string; title?: string; user_id?: string | null
          created_at?: string; deal_id?: string | null; completed?: boolean | null
        }
      }
    }
    Views: Record<string, never>
    Functions: Record<string, never>
    Enums: Record<string, never>
  }
}

// ── Type aliases ──────────────────────────────────────────────────────────────

// New CRM types
export type Company = Database['public']['Tables']['companies']['Row']
export type CompanyInsert = Database['public']['Tables']['companies']['Insert']
export type CompanyUpdate = Database['public']['Tables']['companies']['Update']
export type CompanyContact = Database['public']['Tables']['company_contacts']['Row']
export type CompanyContactInsert = Database['public']['Tables']['company_contacts']['Insert']
export type CompanyContactUpdate = Database['public']['Tables']['company_contacts']['Update']
export type Proposal = Database['public']['Tables']['proposals']['Row']
export type ProposalInsert = Database['public']['Tables']['proposals']['Insert']
export type ProposalUpdate = Database['public']['Tables']['proposals']['Update']
export type ProposalItem = Database['public']['Tables']['proposal_items']['Row']
export type ProposalItemInsert = Database['public']['Tables']['proposal_items']['Insert']
export type ProposalItemUpdate = Database['public']['Tables']['proposal_items']['Update']

// Legacy types
export type Deal = Database['public']['Tables']['deals']['Row']
export type DealInsert = Database['public']['Tables']['deals']['Insert']
export type DealUpdate = Database['public']['Tables']['deals']['Update']
export type PipelineStage = Database['public']['Tables']['pipeline_stages']['Row']
export type Task = Database['public']['Tables']['tasks']['Row']
export type TaskInsert = Database['public']['Tables']['tasks']['Insert']
export type TaskUpdate = Database['public']['Tables']['tasks']['Update']
export type Comment = Database['public']['Tables']['comments']['Row']
export type CommentInsert = Database['public']['Tables']['comments']['Insert']
export type Activity = Database['public']['Tables']['activities']['Row']
export type ActivityInsert = Database['public']['Tables']['activities']['Insert']
export type DealComment = Database['public']['Tables']['deal_comments']['Row']
export type DealCommentInsert = Database['public']['Tables']['deal_comments']['Insert']
export type User = Database['public']['Tables']['users']['Row']
export type Client = Database['public']['Tables']['clients']['Row']
export type ClientInsert = Database['public']['Tables']['clients']['Insert']
export type ClientUpdate = Database['public']['Tables']['clients']['Update']
export type Reminder = Database['public']['Tables']['reminders']['Row']

// ── Extended types with relations ─────────────────────────────────────────────

export type CompanyWithManager = Company & {
  manager?: Pick<User, 'id' | 'name' | 'email'> | null
}

export type CompanyWithRelations = Company & {
  manager?: Pick<User, 'id' | 'name' | 'email'> | null
  contacts?: CompanyContact[]
  _activity_count?: number
  _proposal_count?: number
}

export type ActivityWithUser = Activity & {
  user?: Pick<User, 'id' | 'name' | 'email'> | null
  contact?: Pick<CompanyContact, 'id' | 'name' | 'position'> | null
}

export type ProposalWithItems = Proposal & {
  items?: ProposalItem[]
  company?: Pick<Company, 'id' | 'name' | 'inn'> | null
}

export type TaskWithRelations = Task & {
  company?: Pick<Company, 'id' | 'name'> | null
  created_by_user?: Pick<User, 'id' | 'name'> | null
}

export type DealWithStage = Deal & {
  pipeline_stages: Pick<PipelineStage, 'id' | 'name' | 'color' | 'position' | 'is_won' | 'is_closed'> | null
}

export type DealWithRelations = Deal & {
  pipeline_stages?: Pick<PipelineStage, 'id' | 'name' | 'color' | 'position' | 'is_won' | 'is_closed'> | null
  owner?: Pick<User, 'id' | 'name' | 'email'> | null
  client?: Pick<Client, 'id' | 'name' | 'company'> | null
}

export type DealCommentWithUser = DealComment & {
  user?: Pick<User, 'id' | 'name' | 'email'> | null
}

// ── Constants ─────────────────────────────────────────────────────────────────

export const COMPANY_SOURCES = [
  'входящая заявка',
  'реклама',
  'холодный обзвон',
  'личный контакт',
] as const

export const COMPANY_STATUSES = [
  'слабый интерес',
  'надо залечивать',
  'сделал запрос',
  'сделал заказ',
] as const

export const ACTIVITY_TYPES = [
  'звонок',
  'письмо',
  'whatsapp',
  'встреча',
  'кп_отправлено',
  'заметка',
  'статус_изменен',
] as const

export const PROPOSAL_STATUSES = [
  'отправлено',
  'рассматривается',
  'принято',
  'отклонено',
] as const

export const LOST_REASONS = [
  'дорого',
  'не актуально',
  'работают с другим поставщиком',
  'нет бюджета',
  'нет потребности',
  'не дозвонились',
  'другое',
] as const
