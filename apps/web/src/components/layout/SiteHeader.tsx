"use client";

import { useState } from "react";
import Link from "next/link";
import { MapPin, Menu, X, ChevronDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Container } from "./Container";

const NAV_LINKS = [
  { href: "/", label: "Início" },
  { href: "/cidades", label: "Cidades" },
  { href: "/categorias", label: "Categorias" },
];

export function SiteHeader() {
  const [mobileOpen, setMobileOpen] = useState(false);

  return (
    <header className="sticky top-0 z-40 border-b border-azul-100 bg-white/95 backdrop-blur">
      <Container>
        <div className="flex h-16 items-center justify-between gap-4">
          <Link href="/" className="flex items-center gap-2 text-azul-600">
            <MapPin className="size-6" aria-hidden />
            <span className="text-lg font-bold tracking-tight text-azul-700">
              Conecta Cidades
            </span>
          </Link>

          <div className="hidden items-center gap-3 md:flex">
            <button
              type="button"
              className="flex items-center gap-1.5 rounded-lg border border-azul-200 bg-azul-50 px-3 py-2 text-sm text-azul-800 hover:bg-azul-100"
            >
              <MapPin className="size-4 text-azul-500" aria-hidden />
              Selecionar cidade
              <ChevronDown className="size-3.5 text-azul-500" aria-hidden />
            </button>

            <nav aria-label="Principal">
              <ul className="flex items-center gap-4">
                {NAV_LINKS.map((link) => (
                  <li key={link.href}>
                    <Link
                      href={link.href}
                      className="text-sm font-medium text-azul-800 hover:text-azul-600"
                    >
                      {link.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </nav>

            <Button asChild className="bg-azul-600 text-white hover:bg-azul-700">
              <Link href="/entrar">Entrar</Link>
            </Button>
          </div>

          <button
            type="button"
            className="rounded-lg p-2 text-azul-700 hover:bg-azul-50 md:hidden"
            aria-label={mobileOpen ? "Fechar menu" : "Abrir menu"}
            aria-expanded={mobileOpen}
            onClick={() => setMobileOpen((open) => !open)}
          >
            {mobileOpen ? (
              <X className="size-6" aria-hidden />
            ) : (
              <Menu className="size-6" aria-hidden />
            )}
          </button>
        </div>

        {mobileOpen && (
          <div className="border-t border-azul-100 py-4 md:hidden">
            <nav aria-label="Mobile">
              <ul className="flex flex-col gap-3">
                {NAV_LINKS.map((link) => (
                  <li key={link.href}>
                    <Link
                      href={link.href}
                      className="block rounded-lg px-2 py-2 text-sm font-medium text-azul-800 hover:bg-azul-50"
                      onClick={() => setMobileOpen(false)}
                    >
                      {link.label}
                    </Link>
                  </li>
                ))}
                <li>
                  <Link
                    href="/entrar"
                    className="block rounded-lg bg-azul-600 px-2 py-2 text-center text-sm font-medium text-white hover:bg-azul-700"
                    onClick={() => setMobileOpen(false)}
                  >
                    Entrar
                  </Link>
                </li>
              </ul>
            </nav>
          </div>
        )}
      </Container>
    </header>
  );
}
