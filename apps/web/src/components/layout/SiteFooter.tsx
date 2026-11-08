import Link from "next/link";
import { MapPin } from "lucide-react";
import { Container } from "./Container";

const COLUMNS = [
  {
    title: "Navegar",
    links: [
      { href: "/", label: "Início" },
      { href: "/cidades", label: "Cidades" },
      { href: "/categorias", label: "Categorias" },
      { href: "/buscar", label: "Buscar" },
    ],
  },
  {
    title: "Para negócios",
    links: [
      { href: "/entrar", label: "Entrar" },
      { href: "/anunciar", label: "Anunciar negócio" },
      { href: "/painel", label: "Painel do anunciante" },
    ],
  },
  {
    title: "Legal",
    links: [
      { href: "/privacidade", label: "Privacidade" },
      { href: "/termos", label: "Termos de uso" },
      { href: "/lgpd", label: "LGPD" },
    ],
  },
];

export function SiteFooter() {
  return (
    <footer className="mt-auto border-t border-azul-100 bg-azul-50">
      <Container>
        <div className="grid gap-10 py-12 sm:grid-cols-2 lg:grid-cols-4">
          <div>
            <Link href="/" className="flex items-center gap-2 text-azul-600">
              <MapPin className="size-5" aria-hidden />
              <span className="font-bold text-azul-700">Conecta Cidades</span>
            </Link>
            <p className="mt-3 text-sm leading-6 text-azul-800/80">
              Diretório de serviços locais para conectar pessoas e negócios
              nas cidades atendidas.
            </p>
          </div>

          {COLUMNS.map((column) => (
            <nav key={column.title} aria-label={column.title}>
              <h3 className="text-sm font-semibold text-azul-900">
                {column.title}
              </h3>
              <ul className="mt-3 space-y-2">
                {column.links.map((link) => (
                  <li key={link.href + link.label}>
                    <Link
                      href={link.href}
                      className="text-sm text-azul-800/80 hover:text-azul-600"
                    >
                      {link.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </nav>
          ))}
        </div>

        <div className="border-t border-azul-100 py-6">
          <p className="text-xs leading-5 text-azul-800/70">
            Seus dados pessoais são tratados de acordo com a LGPD
            (Lei nº 13.709/2018). Utilizamos apenas as informações necessárias
            para exibir perfis de negócios e encaminhar contatos solicitados
            por você. Para dúvidas sobre privacidade, acesse nossa política ou
            entre em contato.
          </p>
          <p className="mt-2 text-xs text-azul-800/60">
            © 2026 Conecta Cidades. Todos os direitos
            reservados.
          </p>
        </div>
      </Container>
    </footer>
  );
}
