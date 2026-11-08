# 00 — Correções de Stack (oficiais)

Data: 2026-11-08
Status: Aprovado — prevalece sobre Docs 02, 04 e 10 em caso de conflito.

## Origem

Descobertas na **Etapa 0** (scaffold real do projeto). Aplicadas ao repositório
e registradas aqui porque os Docs 01–10 foram entregues por chat (não estão
versionados como arquivos).

---

## 1. Doc 02 — Seção 2 (stack definitiva)

| Camada | Tecnologia | Versão real |
|---|---|---|
| Framework web | Next.js (App Router) | **16+** |
| Linguagem | TypeScript | 5+ |
| Estilo | Tailwind CSS | **4+ (CSS-first, sem tailwind.config.ts)** |
| Componentes | shadcn/ui (New York, Slate, Radix) | latest |
| Formulários | React Hook Form + Zod | latest |
| Banco | PostgreSQL (Supabase) | 15+ |
| Auth | Supabase Auth + @supabase/ssr | latest |
| Hospedagem | Vercel | — |

### Nota sobre Next.js 16

- `middleware.ts` foi **renomeado para `proxy.ts`** (mesma API, novo nome).
  Referência: `node_modules/next/dist/docs/01-app/01-getting-started/16-proxy.md`
- Tailwind v4 usa **`@theme` em `globals.css`** (não usa `tailwind.config.ts`)
- **Inter** deve ser configurada manualmente (create-next-app usa Geist)
- `cookies()` é **assíncrono**: `await cookies()`

---

## 2. Doc 04 — Seção 13 (design tokens)

Os tokens de cor vão em `apps/web/src/app/globals.css` via `@theme`, **não** em
`tailwind.config.ts`. O conteúdo das cores (azul, whatsapp, sucesso, atenção,
erro, premium) é o mesmo do Doc 04 §13 — só muda o destino.

```css
@theme {
  --color-azul-500: #0EA5E9;
  --color-whatsapp-700: #17A34A;
  /* ... demais tokens do Doc 04 §13 */
}
```

---

## 3. Doc 10 — Etapa 4

Onde o texto disser `middleware.ts`, ler **`proxy.ts`**. Mesma lógica, nome novo.
A proteção de `/painel` e `/admin` acontece em `apps/web/src/proxy.ts`.

---

## 4. Doc 03 — Códigos IBGE (CORREÇÃO DE DADO)

O Doc 03 §9.3 tinha um código **incorreto**. Validado na API IBGE em 2026-11-08:

| Cidade | Código correto | Código no Doc 03 |
|---|---|---|
| Nova Fátima - BA | `2922730` | `2922730` ✓ |
| Pé de Serra - BA | `2924058` | `2924058` ✓ |
| Riachão do Jacuípe - BA | **`2926301`** | `2925600` ✗ |

A migration `0005_activate_mvp_cities.sql` usa o código corrigido.

---

## 5. Base IBGE

- Municípios importados da **API oficial** (`servicodados.ibge.gov.br`)
- Total: **5.571** municípios (a API retorna 5.571; o Doc citava 5.570)
- Arquivo gerado: `supabase/migrations/0004_seed_ibge_cities.sql`
- JSON bruto de referência: `supabase/seed/municipios_ibge.json`
