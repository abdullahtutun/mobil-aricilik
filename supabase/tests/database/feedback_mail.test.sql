-- feedback-mail tetikleyicisi: Vault'ta adres ve anahtar yokken görüş yine
-- yazılır ve istek kuyruğa girmez; ikisi varken eklenen görüş için tek
-- pg_net isteği kuyruğa girer, istek gizli anahtarı ve satırı taşır.
begin;
create extension if not exists pgtap with schema extensions;
select plan(5);

insert into auth.users (id, email) values
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local');

insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '33333333-3333-3333-3333-333333333333');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker');

select has_trigger('public', 'feedback', 'notify_feedback_mail', 'feedback tablosunda mail tetikleyicisi var');

create temp table queued_before as select count(*) as n from net.http_request_queue;
grant select on queued_before to authenticated;

set local role authenticated;
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.feedback (id, org_id, kind, message)
    values ('f0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'bug', 'Vault boşken')$$,
  'Vault boşken görüş yazılır'
);

reset role;

select is(
  (select count(*) from net.http_request_queue),
  (select n from queued_before),
  'Vault boşken istek kuyruğa girmez'
);

select vault.create_secret('https://example.test/functions/v1/feedback-mail', 'feedback_mail_url');
select vault.create_secret('test-gizli', 'feedback_mail_secret');

set local role authenticated;
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.feedback (id, org_id, kind, message)
    values ('f0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'suggestion', 'Vault doluyken')$$,
  'Vault doluyken görüş yazılır'
);

reset role;

select results_eq(
  $$select url, headers ->> 'x-webhook-secret', convert_from(body, 'UTF8')::jsonb #>> '{record,message}'
    from net.http_request_queue
    order by id desc limit 1$$,
  $$values ('https://example.test/functions/v1/feedback-mail'::text, 'test-gizli'::text, 'Vault doluyken'::text)$$,
  'istek adresi, gizli anahtarı ve görüşü taşır'
);

select * from finish();
rollback;
