// Auto-generated Supabase database types
// These match the existing Supabase schema

export interface Database {
  public: {
    Tables: {
      deals: {
        Row: {
          id: string
          title: string
          value: number
          currency: string
          client_id: string | null
          pipeline_id: string
          stage_id: string
          owner_id: string
          status: string
          created_at: string
          probability: number | null
          expected_close_date: string | null
          source: string | null
          priority: string | null
          lost_reason: string | null
        }
        Insert: {
          id?: string
          title: string
          value?: number
          currency?: string
          client_id?: string | null
          pipeline_id?: string
          stage_id?: string
          owner_id?: string
          status?: string
          created_at?: string
          probability?: number | null
          expected_close_date?: string | null
          source?: string | null
          priority?: string | null
          lost_reason?: string | null
        }
        Update: {
          id?: string
          title?: string
          value?: number
          currency?: string
          client_id?: string | null
          pipeline_id?: string
          stage_id?: string
          owner_id?: string
          status?: string
          created_at?: string
          probability?: number | null
          expected_close_date?: string | null
          source?: string | null
          priority?: string | null
          lost_reason?: string | null
        }
      }
      pipeline_stages: {
        Row: {
          id: string
          pipeline_id: string
          name: string
          position: number
          probability: number
          color: string
          is_won: boolean
          is_closed: boolean
        }
        Insert: {
          id?: string
          pipeline_id?: string
          name: string
          position?: number
          probability?: number
          color?: string
          is_won?: boolean
          is_closed?: boolean
        }
        Update: {
          id?: string
          pipeline_id?: string
          name?: string
          position?: number
          probability?: number
          color?: string
          is_won?: boolean
          is_closed?: boolean
        }
      }
      tasks: {
        Row: {
          id: string
          title: string
          description: string | null
          status: string
          priority: string
          deadline: string | null
          deal_id: string | null
          client_id: string | null
          created_by: string | null
          created_at: string
        }
        Insert: {
          id?: string
          title: string
          description?: string | null
          status?: string
          priority?: string
          deadline?: string | null
          deal_id?: string | null
          client_id?: string | null
          created_by?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          title?: string
          description?: string | null
          status?: string
          priority?: string
          deadline?: string | null
          deal_id?: string | null
          client_id?: string | null
          created_by?: string | null
          created_at?: string
        }
      }
      comments: {
        Row: {
          id: string
          text: string
          user_id: string | null
          created_at: string
          entity_type: string | null
          entity_id: string | null
        }
        Insert: {
          id?: string
          text: string
          user_id?: string | null
          created_at?: string
          entity_type?: string | null
          entity_id?: string | null
        }
        Update: {
          id?: string
          text?: string
          user_id?: string | null
          created_at?: string
          entity_type?: string | null
          entity_id?: string | null
        }
      }
      activities: {
        Row: {
          id: string
          action: string
          user_id: string | null
          created_at: string
          entity_type: string | null
          entity_id: string | null
        }
        Insert: {
          id?: string
          action: string
          user_id?: string | null
          created_at?: string
          entity_type?: string | null
          entity_id?: string | null
        }
        Update: {
          id?: string
          action?: string
          user_id?: string | null
          created_at?: string
          entity_type?: string | null
          entity_id?: string | null
        }
      }
      deal_comments: {
        Row: {
          id: string
          deal_id: string
          user_id: string | null
          comment: string
          created_at: string
        }
        Insert: {
          id?: string
          deal_id?: string
          user_id?: string | null
          comment: string
          created_at?: string
        }
        Update: {
          id?: string
          deal_id?: string
          user_id?: string | null
          comment?: string
          created_at?: string
        }
      }
      users: {
        Row: {
          id: string
          name: string
          email: string
          role: string
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          email: string
          role?: string
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          email?: string
          role?: string
          created_at?: string
        }
      }
      clients: {
        Row: {
          id: string
          name: string
          company: string | null
          phone: string | null
          email: string | null
          stage: string | null
          created_at: string
        }
        Insert: {
          id?: string
          name: string
          company?: string | null
          phone?: string | null
          email?: string | null
          stage?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          name?: string
          company?: string | null
          phone?: string | null
          email?: string | null
          stage?: string | null
          created_at?: string
        }
      }
      reminders: {
        Row: {
          id: string
          title: string
          user_id: string | null
          created_at: string
          deal_id: string | null
          completed: boolean | null
        }
        Insert: {
          id?: string
          title: string
          user_id?: string | null
          created_at?: string
          deal_id?: string | null
          completed?: boolean | null
        }
        Update: {
          id?: string
          title?: string
          user_id?: string | null
          created_at?: string
          deal_id?: string | null
          completed?: boolean | null
        }
      }
    }
    Views: Record<string, never>
    Functions: Record<string, never>
    Enums: {
      deal_status: 'open' | 'won' | 'lost'
      task_status: 'todo' | 'in_progress' | 'done'
      task_priority: 'low' | 'medium' | 'high'
      deal_priority: 'low' | 'medium' | 'high'
      user_role: 'admin' | 'user'
    }
  }
}

// Convenience type aliases
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

// Extended types with relations (for joined queries)
export type DealWithStage = Deal & {
  pipeline_stages: Pick<PipelineStage, 'id' | 'name' | 'color' | 'position' | 'is_won' | 'is_closed'> | null
}

export type DealWithRelations = Deal & {
  pipeline_stages?: Pick<PipelineStage, 'id' | 'name' | 'color' | 'position' | 'is_won' | 'is_closed'> | null
  owner?: Pick<User, 'id' | 'name' | 'email'> | null
  client?: Pick<Client, 'id' | 'name' | 'company'> | null
}

export type TaskWithRelations = Task & {
  client?: Pick<Client, 'id' | 'name' | 'company'> | null
  created_by_user?: Pick<User, 'id' | 'name'> | null
}

export type DealCommentWithUser = DealComment & {
  user?: Pick<User, 'id' | 'name' | 'email'> | null
}

export type ActivityWithUser = Activity & {
  user?: Pick<User, 'id' | 'name' | 'email'> | null
}

// Dashboard metrics type
export interface DashboardMetrics {
  totalDeals: number
  openDeals: number
  wonDeals: number
  lostDeals: number
  totalRevenue: number
  pipelineValue: number
  conversionRate: number
  totalClients: number
  totalTasks: number
}

export interface DealByStage {
  name: string
  color: string
  count: number
  value: number
}
