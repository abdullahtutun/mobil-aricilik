-- server_seq: her insert/update'te global sync_seq'ten yeni değer alır.
begin;
create extension if not exists pgtap with schema extensions;
select plan(4);

insert into auth.users (id, email)
values ('11111111-1111-1111-1111-111111111111', 'owner@test.local');

-- İstemcinin gönderdiği server_seq yok sayılmalı.
insert into public.organizations (id, name, country_code, currency, created_by, server_seq)
values (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
  '11111111-1111-1111-1111-111111111111', -1
);

create temp table seq_after_insert as
select server_seq from public.organizations
where id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';

select cmp_ok(
  (select server_seq from seq_after_insert), '>', 0::bigint,
  'insert server_seq verir; istemcinin değeri yok sayılır'
);

select cmp_ok(
  (select server_seq from public.memberships
   where org_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  '>',
  (select server_seq from seq_after_insert),
  'trigger''ın eklediği owner üyeliği aynı global sıradan sonraki değeri alır'
);

update public.organizations
set name = 'Petek Arıcılık Ltd.', server_seq = 1
where id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';

select cmp_ok(
  (select server_seq from public.organizations
   where id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  '>',
  (select server_seq from public.memberships
   where org_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  'update server_seq''i ilerletir; istemcinin değeri yok sayılır'
);

select ok(
  not has_sequence_privilege('authenticated', 'private.sync_seq', 'usage'),
  'istemci sync_seq''e doğrudan erişemez'
);

select * from finish();
rollback;
