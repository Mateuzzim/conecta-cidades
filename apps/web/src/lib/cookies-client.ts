"use client"

export function setCityCookieClient(slug: string) {
  document.cookie = `cidade_atual=${slug}; path=/; max-age=${60 * 60 * 24 * 365}; samesite=lax`
}
