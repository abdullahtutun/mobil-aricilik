-- Görüş bildir mesajı e-postayla ekibe gelir.
--
-- `feedback` tablosuna satır eklenince `feedback-mail` Edge Function'ı
-- pg_net ile çağrılır; fonksiyon mesajı SMTP (Hostinger) üzerinden
-- FEEDBACK_TO_EMAIL adresine yollar. Gövde Supabase Database Webhook ile
-- aynı biçimde ({type, table, schema, record}).
-- Adres ve paylaşılan gizli anahtar Vault'ta durur (repoda yok):
--   select vault.create_secret('https://<ref>.supabase.co/functions/v1/feedback-mail', 'feedback_mail_url');
--   select vault.create_secret('<gizli anahtar>', 'feedback_mail_secret');
-- İkisi de yoksa tetikleyici hiçbir şey yapmaz. Mail yardımcıdır: çağrı
-- hatası görüş yazmasını asla bozmaz (pg_net isteği işlemden sonra yollar).

create extension if not exists pg_net with schema extensions;

create function private.notify_feedback_mail()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  webhook_url text;
  webhook_secret text;
begin
  select decrypted_secret into webhook_url
  from vault.decrypted_secrets where name = 'feedback_mail_url';
  select decrypted_secret into webhook_secret
  from vault.decrypted_secrets where name = 'feedback_mail_secret';
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
      'record', to_jsonb(new)
    )
  );
  return new;
exception when others then
  -- Mail yardımcıdır; görüş yazması bozulmasın.
  return new;
end;
$$;

revoke all on function private.notify_feedback_mail() from public;

create trigger notify_feedback_mail
after insert on public.feedback
for each row execute function private.notify_feedback_mail();
