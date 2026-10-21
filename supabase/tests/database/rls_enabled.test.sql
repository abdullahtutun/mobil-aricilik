-- public şemasında RLS'siz tablo olamaz.
begin;
create extension if not exists pgtap with schema extensions;
select plan(1);

select is_empty(
  $$select c.relname
    from pg_class c
    where c.relnamespace = 'public'::regnamespace
      and c.relkind in ('r', 'p')
      and not c.relrowsecurity$$,
  'public şemasındaki her tabloda RLS açık'
);

select * from finish();
rollback;
