-- Görüş bildir ve gizlilik dostu kullanım analitiği (teknik.md §11
-- "İzleme", §13 "Görüş bildir").
--
-- feedback: Daha fazla > "Görüş bildir" mesajı. Senkronlanmaz: telefon
-- yalnız ekler (çevrimdışıysa yerel kuyrukta bekler), uygulama geri okumaz.
-- Ekip mesajları panelden (service role) okur; bu yüzden okuma politikası
-- yok. Kimlik istemcide üretilir; aynı mesajın ikinci gönderimi 23505 alır
-- ve istemci bunu "gönderildi" sayar (okuma politikası olmadığı için
-- `on conflict do nothing` RLS hatası verir).
-- Ekran görüntüsü `feedback` bucket'ında `<org_id>/<id>.jpg` yolunda.
--
-- analytics_events: kullanım olayları (muayene süresi, okutma sonucu,
-- senkron gecikmesi). Kullanıcı ya da işletme kimliği yok; yalnız bu
-- kurulumun rastgele kimliği ve sayısal ya da kısa enum değerleri. Kullanıcı
-- Ayarlar'dan kapatabilir; kapalıyken telefon olay yazmaz ve göndermez.
--
-- sync_push yalnız Drift şema sürümü 10'u kabul eder (yerelde iki kuyruk
-- tablosu eklendi; senkronlanan tablolar değişmedi).

create type public.feedback_kind as enum (
  'bug', 'suggestion', 'missing_feature', 'thanks'
);

create table public.feedback (
  id uuid primary key,
  org_id uuid not null references public.organizations (id) on delete cascade,
  kind public.feedback_kind not null,
  message text not null check (char_length(btrim(message)) between 1 and 4000),
  -- Ekran görüntüsünün bucket'taki yolu; yalnız `<org_id>/<id>.jpg`.
  screenshot_path text,
  -- "Cihaz ve sürüm bilgisini ekle" seçiliyse uygulama sürümü, işletim
  -- sistemi, model ve dil.
  device_info jsonb check (
    device_info is null
    or (jsonb_typeof(device_info) = 'object' and octet_length(device_info::text) <= 2048)
  ),
  -- Mesajın telefonda yazıldığı an; gönderim sonra olabilir.
  created_at timestamptz not null default now(),
  received_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  check (
    screenshot_path is null
    or screenshot_path = org_id::text || '/' || id::text || '.jpg'
  )
);

create index feedback_org_id_idx on public.feedback (org_id);
create index feedback_created_by_idx on public.feedback (created_by);

alter table public.feedback enable row level security;

-- Salt görüntüleyen üye de görüş bildirebilir.
create policy "Üyeler işletmeleri adına görüş bildirir"
on public.feedback for insert
to authenticated
with check (
  private.is_member(org_id)
  and created_by = (select auth.uid())
);

create table public.analytics_events (
  id uuid primary key,
  -- Bu kurulumun rastgele kimliği; analitik kapatılıp açılınca yenilenir.
  install_id uuid not null,
  name text not null check (name ~ '^[a-z][a-z_]{0,39}$'),
  props jsonb not null default '{}'::jsonb check (
    jsonb_typeof(props) = 'object' and octet_length(props::text) <= 1024
  ),
  occurred_at timestamptz not null,
  app_version text check (char_length(app_version) <= 32),
  platform text check (platform in ('android', 'ios', 'other')),
  received_at timestamptz not null default now()
);

create index analytics_events_name_occurred_at_idx
  on public.analytics_events (name, occurred_at);

alter table public.analytics_events enable row level security;

-- Satırda kimlik yok; oturumlu her kullanıcı ekleyebilir, kimse okuyamaz.
create policy "Oturumlu kullanıcılar kullanım olayı ekler"
on public.analytics_events for insert
to authenticated
with check ((select auth.uid()) is not null);

-- ---------------------------------------------------------------------------
-- Storage: feedback bucket'ı
-- ---------------------------------------------------------------------------
-- Özel bucket; uygulama yalnız yükler. Dosya bir kez yazılır: okuma,
-- güncelleme ve silme politikası yok; aynı yola ikinci yükleme reddedilir
-- (istemci bunu "zaten yüklendi" sayar).

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('feedback', 'feedback', false, 5242880, array['image/jpeg']);

-- Nesne yolunun işletmesi; yol `uuid/uuid.jpg` biçiminde değilse boş
-- (politika reddeder).
create function private.feedback_object_org_id(object_name text)
returns uuid
language sql
immutable
set search_path = ''
as $$
  select case
    when object_name ~ '^[0-9a-f-]{36}/[0-9a-f-]{36}\.jpg$'
      then split_part(object_name, '/', 1)::uuid
  end;
$$;

grant execute on function private.feedback_object_org_id(text) to authenticated;

create policy "Üyeler görüş için ekran görüntüsü yükler"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'feedback'
  and private.is_member(private.feedback_object_org_id(name))
);

-- ---------------------------------------------------------------------------
-- sync_push: şema sürümü 10
-- ---------------------------------------------------------------------------
-- Belge: 20261023164500_sync_push.sql. Tek fark desteklenen şema sürümleri.
create or replace function public.sync_push(
  changes jsonb,
  client_time timestamptz,
  schema_version integer
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  supported_versions constant integer[] := array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  -- İstemci saati sunucudan bundan fazla saparsa uyarı döner.
  max_clock_skew constant interval := interval '5 minutes';
  skew_seconds bigint;
  change jsonb;
  outcome jsonb;
  results jsonb := '[]'::jsonb;
begin
  if not coalesce(sync_push.schema_version = any (supported_versions), false) then
    raise exception 'Desteklenmeyen şema sürümü: %', sync_push.schema_version
      using errcode = 'PT426',
            detail = format('Desteklenen sürümler: %s', array_to_string(supported_versions, ', ')),
            hint = 'Uygulamayı güncelleyin';
  end if;
  if jsonb_typeof(sync_push.changes) is distinct from 'array' then
    raise exception 'changes bir dizi olmalı' using errcode = '22023';
  end if;
  if sync_push.client_time is null then
    raise exception 'client_time boş olamaz' using errcode = '22023';
  end if;

  for i in 0 .. jsonb_array_length(sync_push.changes) - 1 loop
    change := sync_push.changes -> i;
    begin
      outcome := jsonb_build_object(
        'id', change -> 'id',
        'status', 'ok',
        'applied', private.sync_push_change(
          change ->> 'table', change ->> 'operation', change -> 'payload'
        )
      );
    exception when others then
      -- Geçici hata: bütün paket geri alınır, istemci yeniden dener.
      if left(sqlstate, 2) in ('08', '40', '53', '57', '58') or sqlstate = '55P03' then
        raise;
      end if;
      outcome := jsonb_build_object(
        'id', change -> 'id',
        'status', 'rejected',
        'reason', case sqlstate
          when '42501' then 'forbidden'
          when '23505' then 'conflict'
          when '23503' then 'missing_reference'
          when '0A000' then 'unsupported'
          else 'invalid'
        end,
        'message', sqlerrm
      );
    end;
    results := results || jsonb_build_array(outcome);
  end loop;

  skew_seconds := round(extract(epoch from sync_push.client_time - now()));
  return jsonb_build_object(
    'results', results,
    'server_time', now(),
    'warning', case
      when abs(skew_seconds) > extract(epoch from max_clock_skew) then
        jsonb_build_object('code', 'clock_skew', 'skew_seconds', skew_seconds)
    end
  );
end;
$$;
