-- sync_pull: imleçten sonraki satırları sırayla ve sayfalı döner (teknik.md
-- §3, "Çekme").
--
-- İstemci tablo başına bir imleç (sync_state.last_pulled_seq) tutar, ilk
-- çekmede 0 gönderir. Yanıttaki next_seq'i sayfa yerel DB'ye yazılınca
-- saklar; has_more doğruysa aynı tabloyu next_seq ile yeniden çağırır.
--
-- Fonksiyon çağıranın yetkisiyle çalışır (security invoker): RLS yalnız
-- üyesi olunan işletmelerin satırlarını bırakır. Silinen satırlar da döner;
-- yumuşak silme bir güncellemedir ve satıra yeni bir server_seq verir.
--
-- Geriye bakma payı
--
-- server_seq trigger'da nextval ile verilir, satır ise işlem commit edilince
-- görünür. Numarayı önce alan işlem sonra commit edebilir: T1 100'ü, T2
-- 101'i alır; T2 commit eder ve istemci çeker. Yalnız 101 görünür. İmleç
-- 101'e geçerse, T1 commit edince 100 imlecin gerisinde kalır ve bir daha
-- hiç çekilmez.
--
-- Bu yüzden imleç son dağıtılan numaraya yaklaşmaz. Ufuk, son dağıtılan
-- numaranın lookback (1000) gerisidir; ufkun üstü taze bölgedir. Taze
-- satırlar yanıtta yine döner, yeni veri beklemeden iner. Ama next_seq ufku
-- geçmez, bu satırlar sonraki çağrıda yeniden gelir. İstemci satırları
-- idempotent upsert ettiği için tekrar zararsızdır. Ufkun altındaki bir
-- numarayı tutan işlemin, kendisinden sonra 1000 numara daha dağıtılmışken
-- hâlâ açık olmadığı varsayılır. Senkron yazmaları tek ifadelik RPC'lerdir
-- (sync_push paketi 100 satır) ve authenticated rolünün statement_timeout'u
-- 8 sn. 1000'lik pay, saniyede 125 yazmaya kadar 8 sn'yi karşılar. Yazma
-- hızı bunu aşarsa pay büyütülmeli.
--
-- İmleç yalnız döndürdüğü satırlara kadar ilerler, boş sayfada yerinde
-- kalır. Satır görmeden ufka atlasaydı, binden çok numara alan tek bir
-- işlem sürerken imleç onun numaralarını geçerdi.
--
-- İmleç taze bölgedeyse (since_seq >= ufuk) next_seq ilerleyemez. Bu
-- durumda sayfa dolu dönseydi istemci aynı sayfayı sonsuza dek isterdi.
-- Taze bölgede en çok 1000 numara olduğu için page_size yerine 1000 kullanılır:
-- bölgenin tamamı tek sayfada döner, has_more false olur.
--
-- Son dağıtılan numara satırlardan önce, ayrı bir sorguda okunur. Fonksiyon
-- VOLATILE olduğu için READ COMMITTED'da (PostgREST'in varsayılanı) satır
-- sorgusu daha yeni bir anlık görüntü alır. Ufkun altındaki işlemler o
-- numara okunurken bitmiş sayılır; satırları ancak sonraki anlık görüntüde
-- görünür.

-- Son dağıtılan server_seq; hiç dağıtılmadıysa 0. İstemcinin sync_seq'e
-- erişimi yok, bu yüzden güvenlik tanımlı.
create function private.last_server_seq()
returns bigint
language sql
security definer
set search_path = ''
as $$
  select case when s.is_called then s.last_value else 0 end
  from private.sync_seq s;
$$;

-- table_name: server_seq kolonu olan public tablolardan biri.
-- since_seq: imleç; server_seq'i bundan büyük satırlar döner.
-- page_size: sayfadaki en çok satır (1..1000). İmleç taze bölgedeyse
-- aşılabilir, en çok 1000 satır döner.
--
-- Dönen değer:
--   {"rows": [{"id": "...", ..., "server_seq": 1234}],
--    "next_seq": 1234,
--    "has_more": false}
--
-- rows server_seq sırasındadır, kolon adları sunucununkilerdir. Arılığın
-- konumu sync_push'taki gibi latitude + longitude olarak döner. next_seq bir
-- sonraki çağrının since_seq'idir ve son satırın server_seq'inden küçük
-- olabilir (geriye bakma payı). has_more false ise tablo şimdilik bitti.
create function public.sync_pull(
  table_name text,
  since_seq bigint,
  page_size integer
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  lookback constant bigint := 1000;
  max_page_size constant integer := 1000;
  last_seq bigint;
  horizon bigint;
  max_rows integer;
  row_expression text;
  page_rows jsonb;
  page_last_seq bigint;
  has_more boolean;
begin
  if sync_pull.table_name is null
     or sync_pull.since_seq is null
     or coalesce(sync_pull.page_size < 1, true) then
    raise exception 'table_name, since_seq ve en az 1 olan page_size verilmeli'
      using errcode = '22023';
  end if;
  if not exists (
    select
    from pg_catalog.pg_attribute a
    join pg_catalog.pg_class c on c.oid = a.attrelid
    where c.oid = pg_catalog.to_regclass(format('public.%I', sync_pull.table_name))
      and c.relkind in ('r', 'p')
      and a.attname = 'server_seq'
      and not a.attisdropped
  ) then
    raise exception 'Senkronla çekilemeyen tablo: %', sync_pull.table_name
      using errcode = '0A000';
  end if;

  last_seq := private.last_server_seq();
  horizon := last_seq - lookback;
  max_rows := case
    when sync_pull.since_seq >= horizon then lookback
    else least(sync_pull.page_size, max_page_size)
  end;

  row_expression := case sync_pull.table_name
    when 'apiaries' then
      $e$pg_catalog.to_jsonb(t) - 'location' || pg_catalog.jsonb_build_object(
        'latitude', extensions.st_y(t.location::extensions.geometry),
        'longitude', extensions.st_x(t.location::extensions.geometry))$e$
    else 'pg_catalog.to_jsonb(t)'
  end;

  -- Fazladan bir satır, sayfadan sonra satır kalıp kalmadığını gösterir.
  -- Son dağıtılan numaradan sonra commit edilen satırlar sonraki çağrıya
  -- kalır; taze bölge böylece 1000 numarayı aşmaz.
  execute format(
    $q$
    select
      coalesce(pg_catalog.jsonb_agg(p.row_data order by p.server_seq)
        filter (where p.n <= $3), '[]'),
      max(p.server_seq) filter (where p.n <= $3),
      count(*) > $3
    from (
      select
        t.server_seq,
        row_number() over (order by t.server_seq) as n,
        %2$s as row_data
      from public.%1$I as t
      where t.server_seq > $1 and t.server_seq <= $2
      order by t.server_seq
      limit $3 + 1
    ) as p
    $q$,
    sync_pull.table_name, row_expression
  )
  into page_rows, page_last_seq, has_more
  using sync_pull.since_seq, last_seq, max_rows;

  return pg_catalog.jsonb_build_object(
    'rows', page_rows,
    'next_seq', greatest(
      sync_pull.since_seq,
      least(coalesce(page_last_seq, sync_pull.since_seq), horizon)
    ),
    'has_more', has_more
  );
end;
$$;

revoke all on function private.last_server_seq() from public;
grant execute on function private.last_server_seq() to authenticated;

-- Supabase yeni fonksiyonları varsayılan olarak anon'a da açar.
revoke all on function public.sync_pull(text, bigint, integer) from public, anon;
grant execute on function public.sync_pull(text, bigint, integer) to authenticated;
