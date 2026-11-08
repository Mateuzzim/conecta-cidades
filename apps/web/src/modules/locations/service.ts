import { createClient } from "@/lib/supabase/server"
import type { CityWithState } from "./types"

type CityRow = {
  id: string
  name: string
  slug: string
  ibge_code: string
  active: boolean
  state: { abbreviation: string; name: string }[]
}

export async function getActiveCities(): Promise<CityWithState[]> {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from("cities")
    .select(`
      id, name, slug, ibge_code, active,
      state:states!inner(abbreviation, name)
    `)
    .eq("active", true)
    .order("name")

  if (error) throw error

  return (data ?? []).map((c: CityRow) => {
    const s = c.state[0]
    return {
      id: c.id,
      name: c.name,
      slug: c.slug,
      ibge_code: c.ibge_code,
      active: c.active,
      state_abbreviation: s.abbreviation,
      state_name: s.name,
    }
  })
}

export async function getCityBySlug(slug: string): Promise<CityWithState | null> {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from("cities")
    .select(`
      id, name, slug, ibge_code, active,
      state:states!inner(abbreviation, name)
    `)
    .eq("slug", slug)
    .eq("active", true)
    .maybeSingle()

  if (error) throw error
  if (!data) return null

  const c = data as CityRow
  const s = c.state[0]
  return {
    id: c.id,
    name: c.name,
    slug: c.slug,
    ibge_code: c.ibge_code,
    active: c.active,
    state_abbreviation: s.abbreviation,
    state_name: s.name,
  }
}

export async function getCityById(id: string): Promise<CityWithState | null> {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from("cities")
    .select(`
      id, name, slug, ibge_code, active,
      state:states!inner(abbreviation, name)
    `)
    .eq("id", id)
    .maybeSingle()

  if (error) throw error
  if (!data) return null

  const c = data as CityRow
  const s = c.state[0]
  return {
    id: c.id,
    name: c.name,
    slug: c.slug,
    ibge_code: c.ibge_code,
    active: c.active,
    state_abbreviation: s.abbreviation,
    state_name: s.name,
  }
}
