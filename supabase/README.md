# Supabase

## Ordem de execução (SQL Editor)

1. `migrations/0001_init.sql` — tabelas + triggers + RLS + `search_businesses()`
2. `migrations/0002_seed_categories.sql` — 12 macros + subcategorias
3. `migrations/0003_seed_ibge_states.sql` — 27 UFs
4. `migrations/0004_seed_ibge_cities.sql` — 5.571 municípios
5. `migrations/0005_activate_mvp_cities.sql` — ativa as 3 cidades do MVP

## Bucket de fotos (painel Supabase → Storage)

1. Criar bucket público `business-photos`
2. Rodar as policies de `storage.objects` (Doc 03 §10):

```sql
create policy "business_photos_public_read"
  on storage.objects for select
  using (bucket_id = 'business-photos');

create policy "business_photos_auth_insert"
  on storage.objects for insert
  with check (
    bucket_id = 'business-photos'
    and auth.role() = 'authenticated'
  );

create policy "business_photos_auth_update"
  on storage.objects for update
  using (
    bucket_id = 'business-photos'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "business_photos_auth_delete"
  on storage.objects for delete
  using (
    bucket_id = 'business-photos'
    and auth.uid()::text = (storage.foldername(name))[1]
  );
```

Path: `business-photos/{owner_id}/{business_id}/{uuid}.webp`

## Testes manuais de RLS (após migrations)

```sql
-- Anônimo lê só approved (deve ver 0 de pending)
select count(*) from public.businesses where status = 'pending';

-- Anônimo insere lead (deve funcionar)
insert into public.leads (business_id, type, source)
values ('00000000-0000-0000-0000-000000000000', 'whatsapp_click', 'test');
-- (FK vai falhar se business_id não existir — ok; testar com id real)

-- Anônimo NÃO lê leads (deve falhar)
select * from public.leads limit 1;
```

## Regra

**NUNCA** alterar migration já aplicada em produção. Criar nova migration.
