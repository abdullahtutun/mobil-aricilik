-- Görev atanınca push bildirimi (ozellikler.md §8, teknik.md §6 "notify").
--
-- device_tokens: telefonların FCM token'ları. Senkronlanmaz (server_seq
-- yok). Kaydı Edge Function `device-token` service role ile yazar; kullanıcı
-- yalnız kendi token'larını okur. Bir token tek kullanıcıya aittir: aynı
-- telefona başka kullanıcı girerse token ona geçer.
--
-- tasks tetikleyicisi: bir göreve başkası atandığında (ekleme ya da
-- assigned_to değişimi) `notify` Edge Function'ı pg_net ile çağrılır.
-- Gövde, Supabase Database Webhook ile aynı biçimde ({type, table, record,
-- old_record}); Dashboard'dan kurulan bir webhook ile değiştirilebilir.
-- Adres ve paylaşılan gizli anahtar Vault'ta durur (repoda yok):
--   select vault.create_secret('https://<ref>.supabase.co/functions/v1/notify', 'notify_url');
--   select vault.create_secret('<gizli anahtar>', 'notify_secret');
-- İkisi de yoksa tetikleyici hiçbir şey yapmaz; görev yazması asla
-- bekletilmez ya da bozulmaz.

create table public.device_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  token text not null check (char_length(token) between 1 and 4096),
  platform text not null check (platform in ('android', 'ios')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index device_tokens_token_key on public.device_tokens (token);
create index device_tokens_user_id_idx on public.device_tokens (user_id);

alter table public.device_tokens enable row level security;

create policy "Kullanıcı kendi token'larını görür"
on public.device_tokens for select
to authenticated
using (user_id = (select auth.uid()));

-- ---------------------------------------------------------------------------
-- Görev atama tetikleyicisi
-- ---------------------------------------------------------------------------

create extension if not exists pg_net with schema extensions;

create function private.notify_task_assigned()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  webhook_url text;
  webhook_secret text;
begin
  if new.assigned_to is null
     or new.deleted_at is not null
     or new.completed_at is not null then
    return new;
  end if;
  if tg_op = 'UPDATE' and old.assigned_to is not distinct from new.assigned_to then
    return new;
  end if;
  -- Kendine atayan kendini bilgilendirmez.
  if new.assigned_to = (select auth.uid()) then
    return new;
  end if;

  select decrypted_secret into webhook_url
  from vault.decrypted_secrets where name = 'notify_url';
  select decrypted_secret into webhook_secret
  from vault.decrypted_secrets where name = 'notify_secret';
  if webhook_url is null or webhook_secret is null then
    return new;
  end if;

  perform net.http_post(
    url := webhook_url,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-webhook-secret', webhook_secret
    ),
    body := jsonb_build_object(
      'type', tg_op,
      'table', tg_table_name,
      'schema', tg_table_schema,
      'record', to_jsonb(new),
      'old_record', case when tg_op = 'UPDATE' then to_jsonb(old) end
    )
  );
  return new;
exception when others then
  -- Bildirim yardımcıdır; görev yazması bozulmasın.
  return new;
end;
$$;

revoke all on function private.notify_task_assigned() from public;

create trigger notify_task_assigned
after insert or update of assigned_to on public.tasks
for each row execute function private.notify_task_assigned();
