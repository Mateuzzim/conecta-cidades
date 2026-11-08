import Link from "next/link"
import { CategoryIcon } from "./CategoryIcon"
import type { Category } from "@/modules/categories/types"

type Props = {
  categories: Category[]
  citySlug: string
}

export function CategoryGrid({ categories, citySlug }: Props) {
  const resolvedSlug = citySlug ?? "nova-fatima"

  return (
    <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
      {categories.map((cat) => (
        <Link
          key={cat.id}
          href={`/${resolvedSlug}/${cat.slug}`}
          className="flex flex-col items-center text-center gap-2 p-4 bg-white border border-slate-200 rounded-lg hover:border-azul-300 hover:bg-azul-50 transition-colors"
        >
          <CategoryIcon name={cat.icon ?? ""} className="w-6 h-6 text-azul-500" />
          <span className="text-sm font-medium text-slate-900">
            {cat.name}
          </span>
        </Link>
      ))}
    </div>
  )
}
