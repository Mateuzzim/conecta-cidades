export type Category = {
  id: string
  parent_id: string | null
  name: string
  slug: string
  icon: string | null
  position: number
  active: boolean
}
