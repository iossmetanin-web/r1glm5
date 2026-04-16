import { NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'

// Dashboard API — kept because it aggregates multiple tables with complex logic
export async function GET() {
  try {
    const supabase = await createClient()

    const { data: allDeals, error: dealsError } = await supabase
      .from('deals')
      .select('*, pipeline_stages(name, is_won, is_closed, color)')

    if (dealsError) {
      return NextResponse.json({ error: dealsError.message }, { status: 500 })
    }

    const { data: stages } = await supabase
      .from('pipeline_stages')
      .select('*')
      .order('position')

    const { data: recentActivities } = await supabase
      .from('activities')
      .select('*, users(name)')
      .order('created_at', { ascending: false })
      .limit(10)

    const { count: clientCount } = await supabase
      .from('clients')
      .select('*', { count: 'exact', head: true })

    const { count: taskCount } = await supabase
      .from('tasks')
      .select('*', { count: 'exact', head: true })

    if (!allDeals) {
      return NextResponse.json({
        metrics: {
          totalDeals: 0, openDeals: 0, wonDeals: 0, lostDeals: 0,
          totalRevenue: 0, pipelineValue: 0, conversionRate: 0,
          totalClients: clientCount || 0, totalTasks: taskCount || 0,
        },
        dealsByStage: [], recentDeals: [], recentActivities: [], stages: [],
      })
    }

    const totalDeals = allDeals.length
    const openDeals = allDeals.filter((d) => d.status === 'open')
    const wonDeals = allDeals.filter((d) => {
      const stage = d.pipeline_stages as { is_won?: boolean } | null
      return stage?.is_won
    })
    const lostDeals = allDeals.filter((d) => d.status === 'lost')

    const totalRevenue = wonDeals.reduce((sum, d) => sum + (d.value || 0), 0)
    const pipelineValue = openDeals.reduce((sum, d) => sum + (d.value || 0), 0)
    const conversionRate = totalDeals > 0 ? (wonDeals.length / totalDeals) * 100 : 0

    const dealsByStage = stages?.map((stage) => ({
      name: stage.name,
      color: stage.color,
      count: allDeals.filter((d) => d.stage_id === stage.id).length,
      value: allDeals.filter((d) => d.stage_id === stage.id).reduce((sum, d) => sum + (d.value || 0), 0) || 0,
    })) || []

    const recentDeals = [...allDeals]
      .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
      .slice(0, 5)

    return NextResponse.json({
      metrics: {
        totalDeals, openDeals: openDeals.length, wonDeals: wonDeals.length, lostDeals: lostDeals.length,
        totalRevenue, pipelineValue, conversionRate: Math.round(conversionRate * 10) / 10,
        totalClients: clientCount || 0, totalTasks: taskCount || 0,
      },
      dealsByStage, recentDeals, recentActivities, stages,
    })
  } catch (err) {
    return NextResponse.json(
      { error: err instanceof Error ? err.message : 'Unknown error' },
      { status: 500 },
    )
  }
}
