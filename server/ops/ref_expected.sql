-- Supabase side of `arici seed verify-ref` (P8.1): prints the --expect JSON.
-- Read-only. Run on the Supabase project (SQL editor, or psql on the P0.2
-- backup loaded into a local Postgres); ref_expected.json is its output of
-- 2026-11-12 (jcddnelaboueazhordfz). Samples: a GLOBAL drug, a soft-deleted
-- TR drug and the Bayvarol strip the demo treatment uses.
select json_build_object(
  'ref_drugs', json_build_object(
    'count', (select count(*) from public.ref_drugs),
    'samples', (
      select json_agg(row_to_json(d) order by d.id)
      from (
        select id, country_code, name_tr, name_en, active_ingredient,
          dose_unit, withdrawal_days, license_no, deleted_at
        from public.ref_drugs
        where id in ('01900000-0000-7000-8000-000000000001',
                     '01900000-0000-7000-8000-000000000102',
                     '01900000-0000-7000-8000-000000000201')
      ) d)),
  'ref_support_periods', json_build_object(
    'count', (select count(*) from public.ref_support_periods),
    'samples', (
      select coalesce(json_agg(row_to_json(p) order by p.id), '[]'::json)
      from (
        select id, name, application_starts_on, application_ends_on,
          description, source_url, deleted_at
        from public.ref_support_periods
        order by id
        limit 3
      ) p))
) as expect;
