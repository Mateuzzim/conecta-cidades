import { cookies } from "next/headers"

const CITY_COOKIE = "cidade_atual"

export async function getCurrentCityCookie(): Promise<string | null> {
  const cookieStore = await cookies()
  return cookieStore.get(CITY_COOKIE)?.value ?? null
}

export async function setCurrentCityCookie(slug: string): Promise<void> {
  const cookieStore = await cookies()
  cookieStore.set(CITY_COOKIE, slug, {
    path: "/",
    maxAge: 60 * 60 * 24 * 365,
    sameSite: "lax",
    httpOnly: false,
  })
}
