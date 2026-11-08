-- ============================================================================
-- MIGRATION 0006: SUBCATEGORIAS COMPLEMENTARES
-- Corrige lacuna da 0002 (apenas 5 subcategorias foram inseridas)
-- Adiciona as demais, com ON CONFLICT para evitar duplicatas
-- ============================================================================

-- Subcategorias: Saúde
insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Dentistas', 'dentistas', 'tooth', 1
from public.categories where slug = 'saude'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Médicos', 'medicos', 'stethoscope', 2
from public.categories where slug = 'saude'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Farmácias', 'farmacias', 'pill', 3
from public.categories where slug = 'saude'
on conflict (slug) do nothing;

-- Subcategorias: Serviços
insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Eletricistas', 'eletricistas', 'zap', 1
from public.categories where slug = 'servicos'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Encanadores', 'encanadores', 'droplet', 2
from public.categories where slug = 'servicos'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Assistência Técnica', 'assistencia-tecnica', 'wrench', 3
from public.categories where slug = 'servicos'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Pintores', 'pintores', 'paintbrush', 4
from public.categories where slug = 'servicos'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Pedreiros', 'pedreiros', 'hammer', 5
from public.categories where slug = 'servicos'
on conflict (slug) do nothing;

-- Subcategorias: Mercados
insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Supermercados', 'supermercados', 'shopping-basket', 1
from public.categories where slug = 'mercados'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Hortifrúti', 'hortifruti', 'apple', 2
from public.categories where slug = 'mercados'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Açougues', 'acougues', 'beef', 3
from public.categories where slug = 'mercados'
on conflict (slug) do nothing;

-- Subcategorias: Alimentação
insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Restaurantes', 'restaurantes', 'utensils', 1
from public.categories where slug = 'alimentacao'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Lanchonetes', 'lanchonetes', 'sandwich', 2
from public.categories where slug = 'alimentacao'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Pizzarias', 'pizzarias', 'pizza', 3
from public.categories where slug = 'alimentacao'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Padarias', 'padarias', 'croissant', 4
from public.categories where slug = 'alimentacao'
on conflict (slug) do nothing;

-- Subcategorias: Beleza
insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Salões de Beleza', 'saloes-de-beleza', 'scissors', 1
from public.categories where slug = 'beleza'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Barbearias', 'barbearias', 'scissors', 2
from public.categories where slug = 'beleza'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Manicures', 'manicures', 'hand', 3
from public.categories where slug = 'beleza'
on conflict (slug) do nothing;

-- Subcategorias: Automotivo
insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Oficinas', 'oficinas', 'wrench', 1
from public.categories where slug = 'automotivo'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Lava-Jatos', 'lava-jatos', 'droplets', 2
from public.categories where slug = 'automotivo'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Auto Peças', 'auto-pecas', 'cog', 3
from public.categories where slug = 'automotivo'
on conflict (slug) do nothing;

-- Subcategorias: Construção
insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Material de Construção', 'material-de-construcao', 'brick', 1
from public.categories where slug = 'construcao'
on conflict (slug) do nothing;

-- Subcategorias: Transporte
insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Mototáxi', 'mototaxi', 'bike', 1
from public.categories where slug = 'transporte'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Táxi', 'taxi', 'car', 2
from public.categories where slug = 'transporte'
on conflict (slug) do nothing;

-- Subcategorias: Educação
insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Escolas', 'escolas', 'school', 1
from public.categories where slug = 'educacao'
on conflict (slug) do nothing;

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Cursos', 'cursos', 'book-open', 2
from public.categories where slug = 'educacao'
on conflict (slug) do nothing;
