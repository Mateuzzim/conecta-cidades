import { getActiveCities } from "@/modules/locations/service"
import { getCurrentCityCookie } from "@/lib/cookies"
import { CitySelector } from "./CitySelector"
import Link from "next/link"

export async function SiteHeader() {
  const [cities, currentSlug] = await Promise.all([
    getActiveCities(),
    getCurrentCityCookie(),
  ])

  return (
    <header className="sticky top-0 z-40 bg-white border-b border-slate-200">
      <div className="mx-auto max-w-6xl px-4 md:px-6 lg:px-8 h-16 flex items-center justify-between">
        <Link href="/" className="flex items-center gap-2">
          <div className="w-8 h-8 bg-azul-500 rounded-lg flex items-center justify-center">
            <span className="text-white font-bold">C</span>
          </div>
          <span className="font-bold text-slate-900 hidden sm:inline">
            Conecta Cidades
          </span>
        </Link>

        <CitySelector cities={cities} currentSlug={currentSlug} />

        <Link
          href="/login"
          className="px-3 py-2 text-sm font-medium text-slate-700 hover:bg-slate-100 rounded-md"
        >
          Entrar
        </Link>
      </div>
    </header>
  )
}
