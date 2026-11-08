"use client"

import { useRouter } from "next/navigation"
import { useState, useTransition } from "react"
import { MapPin, ChevronDown, Check } from "lucide-react"
import type { CityWithState } from "@/modules/locations/types"
import { setCityCookieClient } from "@/lib/cookies-client"

type Props = {
  cities: CityWithState[]
  currentSlug: string | null
}

export function CitySelector({ cities, currentSlug }: Props) {
  const router = useRouter()
  const [open, setOpen] = useState(false)
  const [isPending, startTransition] = useTransition()

  const current = cities.find((c) => c.slug === currentSlug) ?? cities[0]

  function handleSelect(city: CityWithState) {
    setCityCookieClient(city.slug)
    setOpen(false)
    startTransition(() => {
      router.push(`/${city.slug}`)
    })
  }

  return (
    <div className="relative">
      <button
        type="button"
        onClick={() => setOpen(!open)}
        className="flex items-center gap-1.5 px-3 py-2 rounded-md text-sm font-medium text-slate-700 hover:bg-slate-100 transition-colors"
        disabled={isPending}
      >
        <MapPin className="w-4 h-4 text-azul-500" />
        <span>{current?.name ?? "Escolha a cidade"}</span>
        <ChevronDown className="w-3.5 h-3.5 text-slate-500" />
      </button>

      {open && (
        <>
          <div
            className="fixed inset-0 z-40"
            onClick={() => setOpen(false)}
          />
          <div className="absolute left-0 mt-1 w-64 bg-white border border-slate-200 rounded-lg shadow-lg z-50 max-h-80 overflow-y-auto">
            {cities.map((city) => (
              <button
                key={city.id}
                type="button"
                onClick={() => handleSelect(city)}
                className="w-full flex items-center justify-between px-3 py-2 text-sm text-left hover:bg-slate-50"
              >
                <span>
                  {city.name} - {city.state_abbreviation}
                </span>
                {city.slug === currentSlug && (
                  <Check className="w-4 h-4 text-azul-500" />
                )}
              </button>
            ))}
          </div>
        </>
      )}
    </div>
  )
}
