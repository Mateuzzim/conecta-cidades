-- ============================================================================
-- CONECTA CIDADES — 0002_seed_categories.sql
-- 12 macros + subcategorias iniciais (Doc 03 seção 9)
-- Rodar APÓS 0001_init.sql
-- ============================================================================

insert into public.categories (name, slug, icon, position) values
  ('Alimentação',        'alimentacao',        'utensils',         1),
  ('Mercados',           'mercados',           'shopping-cart',    2),
  ('Saúde',              'saude',              'heart-pulse',      3),
  ('Beleza e Estética',  'beleza',             'scissors',         4),
  ('Automotivo',         'automotivo',         'car',              5),
  ('Construção',         'construcao',         'hammer',           6),
  ('Serviços',           'servicos',           'wrench',           7),
  ('Educação',           'educacao',           'graduation-cap',   8),
  ('Lojas e Comércio',   'lojas',              'store',            9),
  ('Serviços Públicos',  'servicos-publicos',  'building-2',      10),
  ('Transporte',         'transporte',         'truck',           11),
  ('Outros',             'outros',             'more-horizontal', 12);

-- Subcategorias — Saúde
insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Dentistas', 'dentistas', 'tooth', 1
from public.categories where slug = 'saude';

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Médicos', 'medicos', 'stethoscope', 2
from public.categories where slug = 'saude';

-- Subcategorias — Serviços
insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Eletricistas', 'eletricistas', 'zap', 1
from public.categories where slug = 'servicos';

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Encanadores', 'encanadores', 'droplet', 2
from public.categories where slug = 'servicos';

insert into public.categories (parent_id, name, slug, icon, position)
select id, 'Assistência Técnica', 'assistencia-tecnica', 'wrench', 3
from public.categories where slug = 'servicos';
