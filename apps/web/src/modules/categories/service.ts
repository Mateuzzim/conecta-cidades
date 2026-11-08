import { createClient } from "@/lib/supabase/server"
import type { Category } from "./types"

export async function getTopCategories(): Promise<Category[]> {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from("categories")
    .select("*")
    .is("parent_id", null)
    .eq("active", true)
    .order("position")

  if (error) throw error
  return data ?? []
}

export async function getCategoryBySlug(slug: string): Promise<Category | null> {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from("categories")
    .select("*")
    .eq("slug", slug)
    .eq("active", true)
    .maybeSingle()

  if (error) throw error
  return data
}

export async function getSubcategories(parentId: string): Promise<Category[]> {
  const supabase = await createClient()
  const { data, error } = await supabase
    .from("categories")
    .select("*")
    .eq("parent_id", parentId)
    .eq("active", true)
    .order("position")

  if (error) throw error
  return data ?? []
}
