-- ============================================================================
-- CONECTA CIDADES — 0001_init.sql
-- Schema v1.0 (Docs 01–03) + correções Next 16 / stack real
-- Rodar no SQL Editor do Supabase (fresh database)
-- ============================================================================

-- Extensões
create extension if not exists pgcrypto;
create extension if not exists unaccent;
create extension if not exists pg_trgm;

-- ============================================================================
-- 1. PROFILES
-- ============================================================================
create table public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  full_name     text not null,
  phone         text,
  role          text not null default 'advertiser'
                check (role in ('advertiser','admin')),
  avatar_url    text,
  lgpd_accepted boolean not null default false,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- ============================================================================
-- 2. STATES
-- ============================================================================
create table public.states (
  id            uuid primary key default gen_random_uuid(),
  name          text not null,
  abbreviation  char(2) unique not null,
  ibge_code     varchar(2) unique not null
);

-- ============================================================================
-- 3. CITIES
-- ============================================================================
create table public.cities (
  id          uuid primary key default gen_random_uuid(),
  state_id    uuid not null references public.states(id),
  name        text not null,
  slug        text not null,
  ibge_code   varchar(7) unique not null,
  active      boolean default false,
  created_at  timestamptz default now(),
  unique (state_id, slug)
);

create index cities_slug_idx   on public.cities(slug);
create index cities_active_idx on public.cities(active);
create index cities_state_idx  on public.cities(state_id);

-- ============================================================================
-- 4. CATEGORIES
-- ============================================================================
create table public.categories (
  id          uuid primary key default gen_random_uuid(),
  parent_id   uuid references public.categories(id),
  name        text not null,
  slug        text unique not null,
  icon        text,
  position    int default 0,
  active      boolean default true,
  created_at  timestamptz default now()
);

create index categories_slug_idx   on public.categories(slug);
create index categories_parent_idx on public.categories(parent_id);

-- ============================================================================
-- 5. BUSINESSES
-- ============================================================================
create table public.businesses (
  id            uuid primary key default gen_random_uuid(),
  owner_id      uuid not null references public.profiles(id) on delete restrict,
  city_id       uuid not null references public.cities(id) on delete restrict,
  name          text not null,
  slug          text unique not null,
  description   text,
  phone         text,
  whatsapp      text,
  email         text,
  website       text,
  instagram     text,
  address       text,
  neighborhood  text,
  postal_code   varchar(8),
  latitude      numeric(10,7),
  longitude     numeric(10,7),
  status        text not null default 'pending'
                check (status in ('pending','approved','rejected','suspended')),
  is_verified   boolean default false,
  view_count    int default 0,
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

create index businesses_city_idx   on public.businesses(city_id);
create index businesses_status_idx on public.businesses(status);
create index businesses_slug_idx   on public.businesses(slug);
create index businesses_owner_idx  on public.businesses(owner_id);
create index businesses_city_status_idx
  on public.businesses(city_id, status);

create index businesses_name_trgm_idx
  on public.businesses using gin (unaccent(name) gin_trgm_ops);

create index businesses_description_trgm_idx
  on public.businesses using gin (unaccent(description) gin_trgm_ops);

-- ============================================================================
-- 6. BUSINESS_CATEGORIES
-- ============================================================================
create table public.business_categories (
  business_id  uuid references public.businesses(id) on delete cascade,
  category_id  uuid references public.categories(id) on delete restrict,
  is_primary   boolean default false,
  primary key (business_id, category_id)
);

create unique index business_primary_category_idx
  on public.business_categories(business_id)
  where is_primary = true;

create index business_categories_cat_idx
  on public.business_categories(category_id);

-- ============================================================================
-- 7. BUSINESS_PHOTOS
-- ============================================================================
create table public.business_photos (
  id            uuid primary key default gen_random_uuid(),
  business_id   uuid references public.businesses(id) on delete cascade,
  storage_path  text not null,
  position      int default 0,
  created_at    timestamptz default now()
);

create index business_photos_business_idx
  on public.business_photos(business_id);

-- ============================================================================
-- 8. BUSINESS_HOURS
-- ============================================================================
create table public.business_hours (
  id           uuid primary key default gen_random_uuid(),
  business_id  uuid references public.businesses(id) on delete cascade,
  weekday      int not null check (weekday between 0 and 6),
  open_time    time,
  close_time   time,
  closed       boolean default false,
  unique (business_id, weekday)
);

-- ============================================================================
-- 9. LEADS
-- ============================================================================
create table public.leads (
  id           uuid primary key default gen_random_uuid(),
  business_id  uuid references public.businesses(id) on delete cascade,
  type         text not null check (type in ('whatsapp_click','profile_view')),
  source       text,
  user_agent   text,
  created_at   timestamptz default now()
);

create index leads_business_type_idx
  on public.leads(business_id, type, created_at desc);

-- ============================================================================
-- 10. AUDIT_LOGS
-- ============================================================================
create table public.audit_logs (
  id          uuid primary key default gen_random_uuid(),
  actor_id    uuid references public.profiles(id),
  action      text not null,
  entity      text not null,
  entity_id   uuid,
  payload     jsonb default '{}',
  created_at  timestamptz default now()
);

create index audit_actor_idx  on public.audit_logs(actor_id);
create index audit_entity_idx on public.audit_logs(entity, entity_id);
create index audit_date_idx   on public.audit_logs(created_at desc);

-- ============================================================================
-- TRIGGERS
-- ============================================================================

-- A) updated_at automático
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

create trigger businesses_updated_at
  before update on public.businesses
  for each row execute function public.set_updated_at();

-- B) Criar profile automaticamente ao registrar usuário
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, full_name, lgpd_accepted)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'full_name', ''),
    coalesce((new.raw_user_meta_data->>'lgpd_accepted')::boolean, false)
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- C) Incrementar view_count ao registrar lead de profile_view
create or replace function public.increment_business_view()
returns trigger language plpgsql as $$
begin
  if new.type = 'profile_view' then
    update public.businesses
      set view_count = view_count + 1
      where id = new.business_id;
  end if;
  return new;
end;
$$;

create trigger leads_increment_view
  after insert on public.leads
  for each row execute function public.increment_business_view();

-- ============================================================================
-- RLS
-- ============================================================================
alter table public.profiles            enable row level security;
alter table public.states              enable row level security;
alter table public.cities              enable row level security;
alter table public.categories          enable row level security;
alter table public.businesses          enable row level security;
alter table public.business_categories enable row level security;
alter table public.business_photos     enable row level security;
alter table public.business_hours      enable row level security;
alter table public.leads               enable row level security;
alter table public.audit_logs          enable row level security;

create or replace function public.is_admin()
returns boolean language sql stable security definer as $$
  select exists (
    select 1 from public.profiles
    where id = auth.uid() and role = 'admin'
  );
$$;

-- PROFILES
create policy "profiles_select_own_or_admin"
  on public.profiles for select
  using (id = auth.uid() or public.is_admin());

create policy "profiles_update_own"
  on public.profiles for update
  using (id = auth.uid())
  with check (
    id = auth.uid()
    and role = (select p.role from public.profiles p where p.id = auth.uid())
  );

-- STATES / CITIES / CATEGORIES
create policy "states_read_all" on public.states
  for select using (true);

create policy "cities_read_active" on public.cities
  for select using (active = true or public.is_admin());

create policy "categories_read_active" on public.categories
  for select using (active = true or public.is_admin());

create policy "cities_admin_write" on public.cities
  for all using (public.is_admin());

create policy "categories_admin_write" on public.categories
  for all using (public.is_admin());

-- BUSINESSES
create policy "businesses_read_approved"
  on public.businesses for select
  using (status = 'approved' or owner_id = auth.uid() or public.is_admin());

create policy "businesses_insert_own"
  on public.businesses for insert
  with check (owner_id = auth.uid());

create policy "businesses_update_own"
  on public.businesses for update
  using (owner_id = auth.uid() or public.is_admin());

-- BUSINESS_CATEGORIES / PHOTOS / HOURS
create policy "bc_read_public" on public.business_categories
  for select using (
    exists (
      select 1 from public.businesses b
      where b.id = business_id
        and (b.status = 'approved' or b.owner_id = auth.uid() or public.is_admin())
    )
  );

create policy "bc_write_own" on public.business_categories
  for all using (
    exists (
      select 1 from public.businesses b
      where b.id = business_id and b.owner_id = auth.uid()
    )
  );

create policy "photos_read_public" on public.business_photos
  for select using (
    exists (
      select 1 from public.businesses b
      where b.id = business_id
        and (b.status = 'approved' or b.owner_id = auth.uid() or public.is_admin())
    )
  );

create policy "photos_write_own" on public.business_photos
  for all using (
    exists (
      select 1 from public.businesses b
      where b.id = business_id and b.owner_id = auth.uid()
    )
  );

create policy "hours_read_public" on public.business_hours
  for select using (
    exists (
      select 1 from public.businesses b
      where b.id = business_id
        and (b.status = 'approved' or b.owner_id = auth.uid() or public.is_admin())
    )
  );

create policy "hours_write_own" on public.business_hours
  for all using (
    exists (
      select 1 from public.businesses b
      where b.id = business_id and b.owner_id = auth.uid()
    )
  );

-- LEADS
create policy "leads_insert_public"
  on public.leads for insert
  with check (true);

create policy "leads_read_own_or_admin"
  on public.leads for select
  using (
    public.is_admin()
    or exists (
      select 1 from public.businesses b
      where b.id = business_id and b.owner_id = auth.uid()
    )
  );

-- AUDIT_LOGS
create policy "audit_read_admin"
  on public.audit_logs for select
  using (public.is_admin());

create policy "audit_insert_admin"
  on public.audit_logs for insert
  with check (public.is_admin());

-- ============================================================================
-- BUSCA PRINCIPAL (RPC)
-- ============================================================================
create or replace function public.search_businesses(
  p_city_slug      text,
  p_category_slug  text default null,
  p_query          text default null,
  p_limit          int  default 20,
  p_offset         int  default 0
)
returns table (
  id            uuid,
  name          text,
  slug          text,
  description   text,
  whatsapp      text,
  phone         text,
  neighborhood  text,
  city_name     text,
  city_slug     text,
  is_verified   boolean,
  primary_photo text,
  total_count   bigint
)
language sql stable as $$
with base as (
  select
    b.*,
    c.name as city_name,
    c.slug as city_slug,
    (
      select bp.storage_path
      from public.business_photos bp
      where bp.business_id = b.id
      order by bp.position asc
      limit 1
    ) as primary_photo
  from public.businesses b
  join public.cities c on c.id = b.city_id
  where b.status = 'approved'
    and c.slug = p_city_slug
    and (
      p_category_slug is null
      or exists (
        select 1
        from public.business_categories bc
        join public.categories cat on cat.id = bc.category_id
        where bc.business_id = b.id and cat.slug = p_category_slug
      )
    )
    and (
      p_query is null
      or p_query = ''
      or unaccent(b.name) ilike '%' || unaccent(p_query) || '%'
      or unaccent(b.description) ilike '%' || unaccent(p_query) || '%'
    )
)
select
  id, name, slug, description, whatsapp, phone, neighborhood,
  city_name, city_slug, is_verified, primary_photo,
  count(*) over () as total_count
from base
order by
  is_verified desc,
  similarity(unaccent(name), unaccent(coalesce(p_query, ''))) desc,
  name asc
limit p_limit offset p_offset;
$$;
