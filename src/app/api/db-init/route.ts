import { NextResponse } from 'next/server'
import { getSupabaseAdminClient } from '@/lib/supabase/client'
import fs from 'fs'
import path from 'path'

/**
 * GET /api/db-init — Returns the SQL migration file content.
 * Also checks if the database is already set up.
 */
export async function GET() {
  try {
    const admin = getSupabaseAdminClient()

    // Check if companies table already exists
    const { error } = await admin.from('companies').select('id').limit(1)

    const isSetup = !error || !error.message.includes('Could not find')

    // Read the SQL file
    const sqlPath = path.join(process.cwd(), 'scripts', 'import-data.sql')
    let sql = ''
    if (fs.existsSync(sqlPath)) {
      sql = fs.readFileSync(sqlPath, 'utf-8')
    }

    return NextResponse.json({
      isSetup,
      sqlPreview: sql.substring(0, 500) + '...',
      sqlLength: sql.length,
      message: isSetup
        ? 'База данных уже настроена'
        : 'Необходимо выполнить SQL в Supabase SQL Editor',
    })
  } catch (err) {
    return NextResponse.json(
      { error: err instanceof Error ? err.message : 'Unknown error' },
      { status: 500 },
    )
  }
}
