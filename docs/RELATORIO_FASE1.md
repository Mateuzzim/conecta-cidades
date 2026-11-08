# Relatório — Fase 1 (Fundação + Banco)

**Projeto:** Conecta Cidades
**Data:** 2026-11-08
**Branch:** main
**Commit atual:** c54f123

---

## Status geral

| Etapa | Status |
|---|---|
| 01 — GitHub + Supabase + Vercel | Concluído (Vercel ainda sem deploy confirmado) |
| 02 — Migrations Banco | Concluída (0001–0005 aplicadas) |
| 03 — Storage e Policies | Concluída (bucket + 4 policies aplicadas) |
| 04 — Testes RLS | Concluída (relatório em docs/testes_rls_resultado.txt) |
| 05 — Design Tokens e Layout | Concluída |
| 06 — Fonte Inter | Concluída |

---

## 01 — Infraestrutura

- Repositório GitHub: `https://github.com/Mateuzzim/conecta-cidades.git` (privado, branch `main`)
- Supabase: `jfrlhmliqwgydkalbyih` (`https://jfrlhmliqwgydkalbyih.supabase.co`)
- CLI Supabase 3.0.0 instalado e linkado ao projeto
- Vercel: projeto existente, mas sem deploy ativo (`DEPLOYMENT_NOT_FOUND`)

---

## 02 — Migrations (aplicadas em produção via `supabase db query --remote`)

| Migration | Conteúdo | Status |
|---|---|---|
| 0001_init.sql | Schema completo (profiles, states, cities, categories, businesses, leads, audit_logs, RLS, policies, índices GIN com `immutable_unaccent`) | Aplicada ✅ |
| 0002_seed_categories.sql | 12 categorias raiz + 5 subcategorias | Aplicada ✅ |
| 0003_seed_ibge_states.sql | 27 UFs | Aplicada ✅ |
| 0004_seed_ibge_cities.sql | 5.570 municípios do IBGE | Aplicada ✅ |
| 0005_activate_mvp_cities.sql | 3 cidades ativas (Nova Fátima, Pé de Serra, Riachão do Jacuípe) | Aplicada ✅ |

**Correção em 0001:** adicionada função `immutable_unaccent()` para índices GIN (o `unaccent()` puro não é IMMUTABLE).

---

## 03 — Storage

| Item | Resultado |
|---|---|
| Bucket `business-photos` | Criado, `public=true` |
| Limite de arquivo | 5 MB |
| MIME tipos | image/jpeg, image/png, image/webp |
| Policies | 4 (public_read, auth_insert, auth_update, auth_delete) |
| Upload manual | Testado via API: PUT 200, GET público 200, DELETE 200 (arquivo de teste removido) |

---

## 04 — Testes RLS

| Teste | Resultado |
|---|---|
| Anônimo lê negócio approved | ✅ 1 linha |
| Anônimo não lê negócio pending | ✅ `[]` |
| Anônimo não lê leads | ✅ `[]` |
| Anônimo não lê audit_logs | ✅ `[]` |
| Anônimo lê cidades ativas | ✅ 3 linhas |
| Dono A lê próprio pending | ✅ 1 linha |
| Dono B não lê pending de A | ✅ `[]` |
| Dados de teste removidos | ✅ businesses=0, profiles=0, leads=0 |

Relatório detalhado: `docs/testes_rls_resultado.txt`

---

## 05 — Design Tokens e Layout

| Item | Resultado |
|---|---|
| @theme em globals.css | Todos os tokens (azul, whatsapp, sucesso, atenção, erro, premium) |
| SiteHeader | Logo MapPin + nome, seletor cidade (placeholder), nav, Entrar, menu mobile |
| SiteFooter | 3 colunas (Navegar, Para negócios, Legal) + LGPD |
| Container | max-w-6xl, padding responsivo |
| (public)/layout.tsx | Header + main + footer |
| Home | Hero + 12 categorias + CTA |
| Cores no CSS | Confirmadas no build (azul-500, whatsapp-500, sucesso-500, etc.) |

Nota: ano do footer fixado em `2026` (Next.js 16 bloqueia `new Date()` em prerender).

---

## 06 — Fonte Inter

| Item | Resultado |
|---|---|
| Geist removida do layout | ✅ |
| Inter via `next/font/google` | ✅ (`--font-inter`, `display: swap`) |
| `html` com `className={inter.variable}` | ✅ |
| `body` com `font-sans ... bg-white text-slate-900 antialiased` | ✅ |
| `--font-sans` mapeado para `--font-inter` | ✅ |
| Build confirmado (@font-face Inter no CSS) | ✅ |

---

## 07 — Validação Seed (atual)

| Verificação | Esperado | Obtido | Status |
|---|---|---|---|
| Estados | 27 | 27 | ✅ |
| Cidades ativas | 3 (Nova Fátima, Pé de Serra, Riachão do Jacuípe) | 3 | ✅ |
| Categorias raiz | 12 | 12 | ✅ |
| Subcategorias | 18+ | 5 | ⚠️ (migration 0002 só insere 5) |
| search_businesses() sem erro | 0 linhas | 0 linhas | ✅ |
| Sem dados fake sobrando | 0 businesses/profiles | 0 / 0 | ✅ |

**Ressalva:** subcategorias estão em 5, não 18. A migration 0002 não contém mais. Reexecutá-la não altera. Se necessário, criar migration adicional com subcategorias faltantes.

---

## 08 — Estado do código local

Arquivos modificados (commit `c54f123`):
- `.gitignore` — ignora `supabase/.temp/`
- `apps/web/src/app/layout.tsx` — Inter, `lang="pt-BR"`
- `supabase/migrations/0001_init.sql` — `immutable_unaccent` + remoção Geist

Arquivos novos:
- `apps/web/src/components/layout/Container.tsx`
- `apps/web/src/components/layout/SiteHeader.tsx`
- `apps/web/src/components/layout/SiteFooter.tsx`
- `apps/web/src/app/(public)/layout.tsx`
- `apps/web/src/app/(public)/page.tsx`
- `docs/testes_rls_resultado.txt`

Excluído:
- `apps/web/src/app/page.tsx` (home antiga)

---

## Próximo passo

Instrução 08 (próxima): Etapa 3 do Doc 10 — Módulo LOCATIONS + CATEGORIES na interface (pages de cidades e categorias, seletor de cidade funcional, etc.).

---

**Verificações:** `pnpm tsc --noEmit` OK, `pnpm lint` OK, `pnpm build` OK. Servidor dev rodando em `http://localhost:3000`.
