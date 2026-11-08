import Link from "next/link";
import { Container } from "@/components/layout/Container";
import { Button } from "@/components/ui/button";
import { getTopCategories } from "@/modules/categories/service";
import { CategoryGrid } from "@/components/category/CategoryGrid";
import { getCurrentCityCookie } from "@/lib/cookies";
import { getActiveCities } from "@/modules/locations/service";

export default async function Home() {
  const [categories, currentSlug, cities] = await Promise.all([
    getTopCategories(),
    getCurrentCityCookie(),
    getActiveCities(),
  ]);

  const citySlug = currentSlug ?? cities[0]?.slug ?? "nova-fatima";

  return (
    <>
      <section className="bg-gradient-to-b from-azul-50 to-white">
        <Container>
          <div className="flex flex-col items-start gap-6 py-16 md:py-24">
            <span className="inline-flex items-center gap-1.5 rounded-full bg-azul-100 px-3 py-1 text-xs font-medium text-azul-700">
              Nova Fátima · Pé de Serra · Riachão do Jacuípe
            </span>
            <h1 className="max-w-2xl text-4xl font-bold tracking-tight text-azul-900 md:text-5xl">
              Encontre serviços e negócios na sua cidade
            </h1>
            <p className="max-w-xl text-lg leading-7 text-azul-800/80">
              Busque por categoria, descubra estabelecimentos locais e fale
              direto com quem você precisa — sem complicação.
            </p>
            <div className="flex flex-wrap gap-3">
              <Button
                asChild
                size="lg"
                className="bg-azul-600 text-white hover:bg-azul-700"
              >
                <Link href="/categorias">
                  Explorar categorias
                </Link>
              </Button>
              <Button
                asChild
                size="lg"
                variant="outline"
                className="border-azul-300 text-azul-700 hover:bg-azul-50"
              >
                <Link href="/anunciar">Anunciar meu negócio</Link>
              </Button>
            </div>
          </div>
        </Container>
      </section>

      <section className="py-14 md:py-20">
        <Container>
          <div className="flex items-end justify-between gap-4">
            <div>
              <h2 className="text-2xl font-bold tracking-tight text-azul-900 md:text-3xl">
                Categorias
              </h2>
              <p className="mt-2 text-azul-800/80">
                Escolha uma área e encontre opções perto de você.
              </p>
            </div>
          </div>

          <CategoryGrid categories={categories} citySlug={citySlug} />
        </Container>
      </section>

      <section className="pb-16 md:pb-24">
        <Container>
          <div className="rounded-2xl bg-azul-600 px-6 py-10 text-white md:px-12 md:py-14">
            <div className="flex flex-col items-start gap-4 md:flex-row md:items-center md:justify-between">
              <div>
                <h2 className="text-2xl font-bold tracking-tight md:text-3xl">
                  Tem um negócio na cidade?
                </h2>
                <p className="mt-2 max-w-xl text-azul-100">
                  Cadastre seu estabelecimento e seja encontrado por quem
                  procura serviços na região.
                </p>
              </div>
              <Button
                asChild
                size="lg"
                className="shrink-0 bg-whatsapp-500 text-white hover:bg-whatsapp-600"
              >
                <Link href="/anunciar">Começar agora</Link>
              </Button>
            </div>
          </div>
        </Container>
      </section>
    </>
  );
}
