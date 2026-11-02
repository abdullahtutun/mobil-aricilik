-- Kovan karantinası (ozellikler.md "İhbarı mecburi hastalıklar"): teşhis
-- yardımcısında ihbarı mecburi bir hastalık şüphesiyle kovan karantinaya
-- alınır; kovan kartında "Karantinada" görünür, oradan kaldırılır.
--
-- hives.quarantined: kovan karantinada mı. quarantined_at: ne zamandan
-- beri (yalnız karantinadayken dolu). quarantine_disease: şüphelenilen
-- hastalığın teşhis kural tablosundaki kimliği (uygulamayla gelen
-- `assets/diagnosis/rules.json`); kimlik bilinmiyorsa uygulama adı
-- göstermez. Karantina durumu kovanın aktifliğini ve kovan sayısını
-- değiştirmez. Kolonlar kovan satırıyla senkronlanır; kovan durum kaydı
-- olduğu için son yazan kazanır.
--
-- Kolonları bilmeyen eski uygulamanın (sürüm ≤ 21) kovan yazmasında
-- `quarantined` boş gelir; o zaman üç kolon sunucudaki değerde kalır
-- (lot yayımındaki karar). Yeni uygulama karantinayı kaldırırken
-- `quarantined = false` gönderir.
--
-- sync_push Drift şema sürümü 22'yi kabul eder.

alter table public.hives add column quarantined boolean not null default false;
alter table public.hives add column quarantined_at timestamptz;
alter table public.hives add column quarantine_disease text
  check (char_length(btrim(quarantine_disease)) between 1 and 100);
alter table public.hives add constraint hives_quarantine_consistent check (
  quarantined = (quarantined_at is not null)
  and (quarantined or quarantine_disease is null)
);

-- Eski uygulamanın yazmasında karantina kolonları korunur.
--
-- sync_push upsert'ü önce eklemeyi dener: BEFORE INSERT çakışmadan önce
-- çalışır ve çakışmadaki güncelleme bu satırın değerlerini yazar. Bu
-- yüzden eklemede satır zaten varsa değerler mevcut satırdan alınır;
-- yoksa karantina yoktur.
create function private.keep_hive_quarantine()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  prior record;
begin
  if new.quarantined is not null then
    return new;
  end if;
  if tg_op = 'INSERT' then
    select h.quarantined, h.quarantined_at, h.quarantine_disease
    into prior
    from public.hives h
    where h.id = new.id;
    if not found then
      new.quarantined := false;
      new.quarantined_at := null;
      new.quarantine_disease := null;
      return new;
    end if;
    new.quarantined := prior.quarantined;
    new.quarantined_at := prior.quarantined_at;
    new.quarantine_disease := prior.quarantine_disease;
  else
    new.quarantined := old.quarantined;
    new.quarantined_at := old.quarantined_at;
    new.quarantine_disease := old.quarantine_disease;
  end if;
  return new;
end;
$$;

create trigger keep_hive_quarantine
before insert or update on public.hives
for each row execute function private.keep_hive_quarantine();

-- ---------------------------------------------------------------------------
-- sync_push: şema sürümü 22
-- ---------------------------------------------------------------------------
-- Belge: 20261023164500_sync_push.sql. Tek fark desteklenen şema sürümleri.
-- Karantina kolonları kovan yazmasına kendiliğinden katılır.
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
  supported_versions constant integer[] := array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22];
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
