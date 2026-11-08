# Conecta Cidades

Sua cidade. Seus serviços. Tudo conectado.

Diretório / marketplace de serviços locais para cidades brasileiras.

## Estrutura

```
conecta-cidades/
├── apps/web/          # Next.js (App Router)
├── supabase/          # Migrations e seeds
├── packages/shared/   # Types e validações compartilhados
├── docs/              # Documentos 01–10
└── tests/             # Unit (Vitest) e E2E (Playwright)
```

## Desenvolvimento

```bash
pnpm install
pnpm --filter web dev
```

Variáveis de ambiente: copie `.env.example` para `apps/web/.env.local` e preencha.

## Documentação

Ler `docs/` na ordem 01 → 10 antes de contribuir.
