-- ============================================================================
-- CONECTA CIDADES — 0005_activate_mvp_cities.sql
-- Ativa as 3 cidades do lançamento
-- Códigos IBGE validados via API oficial (2026-11):
--   Nova Fátima - BA          2922730
--   Pé de Serra - BA          2924058
--   Riachão do Jacuípe - BA   2926301  ← CORRIGIDO (Doc 03 tinha 2925600)
-- Rodar APÓS 0004_seed_ibge_cities.sql
-- ============================================================================

update public.cities set active = true
where ibge_code in (
  '2922730',  -- Nova Fátima - BA
  '2924058',  -- Pé de Serra - BA
  '2926301'   -- Riachão do Jacuípe - BA
);

-- Verificação
select c.name, s.abbreviation as uf, c.slug, c.ibge_code, c.active
from public.cities c
join public.states s on s.id = c.state_id
where c.active = true
order by c.name;
