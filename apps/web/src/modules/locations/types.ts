export type City = {
  id: string
  name: string
  slug: string
  state_abbreviation: string
  ibge_code: string
  active: boolean
}

export type CityWithState = City & {
  state_name: string
}
