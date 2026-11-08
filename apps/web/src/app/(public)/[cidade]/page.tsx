import { notFound } from "next/navigation"
import { Container } from "@/components/layout/Container"
import { getCityBySlug } from "@/modules/locations/service"
import { getTopCategories } from "@/modules/categories/service"
import { CategoryGrid } from "@/components/category/CategoryGrid"

type Params = { cidade: string }

export default async function CidadePage({
  params,
}: {
  params: Promise<Params>
}) {
  const { cidade } = await params
  const city = await getCityBySlug(cidade)
  const categories = await getTopCategories()

  if (!city) notFound()

  return (
    <Container>
      <div className="py-12">
        <h1 className="text-3xl md:text-4xl font-bold text-slate-900">
          Serviços e empresas em {city.name} - {city.state_abbreviation}
        </h1>
        <p className="text-slate-600 mt-2">
          Encontre o que precisa com contato direto pelo WhatsApp.
        </p>
        <div className="py-8">
          <h2 className="text-2xl font-semibold text-slate-900 mb-6">
            Categorias
          </h2>
          <CategoryGrid categories={categories} citySlug={city.slug} />
        </div>
      </div>
    </Container>
  )
}

export const dynamic = "force-dynamic"
