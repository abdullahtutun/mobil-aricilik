-- Şema v2: arılıklar, ana arılar, kovanlar ve kovanın arılık geçmişi.
--
-- Dört tabloda da v1'deki standart senkron alanları ve org_id var.
-- Birbirine bağlanan kayıtlar aynı işletmede olmalı: bağlar (id, org_id)
-- üzerinden bileşik yabancı anahtarla kurulur. Yabancı anahtar denetimi
-- RLS'e takılmaz; bu kısıt olmasa bir üye kendi kovanını id'sini bildiği
-- başka bir işletmenin arılığına ya da anasına bağlayabilirdi.

create extension if not exists postgis with schema extensions;

-- ---------------------------------------------------------------------------
-- Türler
-- ---------------------------------------------------------------------------

-- Arazi: kendi arazisi, kiralık, izinli.
create type public.apiary_land_tenure as enum ('owned', 'rented', 'permitted');

create type public.hive_type as enum ('langstroth', 'dadant', 'local', 'other');

-- Yaşam döngüsü. Güç (güçlü/orta/zayıf) burada tutulmaz, muayenelerden
-- yerelde hesaplanır.
create type public.hive_status as enum ('active', 'dead', 'merged', 'sold', 'lost');

-- Koloninin kaynağı: oğul, bölme, satın alma, paket arı.
create type public.hive_source as enum ('swarm', 'split', 'purchase', 'package');

-- Uluslararası işaret renkleri; istemcideki QueenMarkColor ile aynı.
create type public.queen_mark_color as enum ('white', 'yellow', 'red', 'green', 'blue');

-- Kendi üretimi, satın alınan yetiştirici, sertifikalı damızlık.
create type public.queen_source as enum ('own_rearing', 'purchased', 'certified_breeder');

create type public.queen_mating_status as enum ('virgin', 'mated');

-- ---------------------------------------------------------------------------
-- Tablolar
-- ---------------------------------------------------------------------------

create table public.apiaries (
  id uuid primary key,
  org_id uuid not null references public.organizations (id) on delete cascade,
  name text not null,
  -- WGS 84 noktası. GPS alınamadıysa boş.
  location extensions.geography(point, 4326),
  altitude_m integer,
  landowner_name text,
  landowner_phone text,
  land_tenure public.apiary_land_tenure,
  water_source text,
  -- Aracın bırakıldığı yerden arılığa uzaklık.
  vehicle_distance_m integer check (vehicle_distance_m >= 0),
  road_notes text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null,
  unique (id, org_id)
);

create table public.queens (
  id uuid primary key,
  org_id uuid not null references public.organizations (id) on delete cascade,
  -- Doğum ya da alım yılı; işaret rengi önerisi buradan çıkar.
  year smallint check (year between 2000 and 2100),
  -- Boş: işaretsiz.
  mark_color public.queen_mark_color,
  breed text,
  breed_line text,
  source public.queen_source,
  -- Boş: bilinmiyor.
  mating_status public.queen_mating_status,
  wing_clipped boolean not null default false,
  mother_queen_id uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null,
  unique (id, org_id),
  foreign key (mother_queen_id, org_id) references public.queens (id, org_id),
  check (mother_queen_id <> id)
);

create table public.hives (
  id uuid primary key,
  org_id uuid not null references public.organizations (id) on delete cascade,
  -- Arıcının verdiği numara ("101", "A-12"). Tekrar edebilir; offline iki
  -- cihazın aynı numarayı vermesini uygulama uyarır.
  number text not null,
  -- Önceden basılmış QR etiketin ya da NFC etiketin kodu. Uygulamanın
  -- ürettiği QR kovan id'sini taşıdığı için bu alana ihtiyaç duymaz.
  tag_code text,
  type public.hive_type not null,
  status public.hive_status not null default 'active',
  apiary_id uuid not null,
  queen_id uuid,
  box_count smallint not null default 1 check (box_count > 0),
  frame_count smallint check (frame_count >= 0),
  source public.hive_source,
  -- Kutunun rengi ya da üstündeki işaret.
  marking text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null,
  unique (id, org_id),
  foreign key (apiary_id, org_id) references public.apiaries (id, org_id),
  foreign key (queen_id, org_id) references public.queens (id, org_id)
);

-- Olay: kovan bu arılığa bu zamanda geldi. Arılıktan çıkışı, kovanın bir
-- sonraki kaydıdır. Satırları istemci yazar; hives.apiary_id değişince
-- sunucu geçmiş eklemez, böylece id'ler istemcinin UUIDv7'si kalır.
create table public.hive_location_history (
  id uuid primary key,
  org_id uuid not null references public.organizations (id) on delete cascade,
  hive_id uuid not null,
  apiary_id uuid not null,
  moved_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null,
  foreign key (hive_id, org_id) references public.hives (id, org_id),
  foreign key (apiary_id, org_id) references public.apiaries (id, org_id)
);

-- Etiket okutulunca tek kovan açılmalı. Silinen kovanın etiketi yeniden
-- kullanılabilir.
create unique index hives_org_id_tag_code_key
  on public.hives (org_id, tag_code)
  where deleted_at is null;

create index apiaries_org_id_idx on public.apiaries (org_id);
create index queens_org_id_idx on public.queens (org_id);
create index queens_mother_queen_id_idx on public.queens (mother_queen_id);
create index hives_org_id_idx on public.hives (org_id);
create index hives_apiary_id_idx on public.hives (apiary_id);
create index hives_queen_id_idx on public.hives (queen_id);
create index hive_location_history_org_id_idx on public.hive_location_history (org_id);
create index hive_location_history_hive_id_idx on public.hive_location_history (hive_id);
create index hive_location_history_apiary_id_idx on public.hive_location_history (apiary_id);

create index apiaries_server_seq_idx on public.apiaries (server_seq);
create index queens_server_seq_idx on public.queens (server_seq);
create index hives_server_seq_idx on public.hives (server_seq);
create index hive_location_history_server_seq_idx on public.hive_location_history (server_seq);

create trigger set_server_seq
before insert or update on public.apiaries
for each row execute function private.set_server_seq();

create trigger set_server_seq
before insert or update on public.queens
for each row execute function private.set_server_seq();

create trigger set_server_seq
before insert or update on public.hives
for each row execute function private.set_server_seq();

create trigger set_server_seq
before insert or update on public.hive_location_history
for each row execute function private.set_server_seq();

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------
-- Üyeler okur; owner, partner ve worker ekler ve günceller; viewer yalnız
-- okur. Silme politikası yok: silme deleted_at ile yapılan bir güncellemedir.

alter table public.apiaries enable row level security;
alter table public.queens enable row level security;
alter table public.hives enable row level security;
alter table public.hive_location_history enable row level security;

create policy "Üyeler arılıkları görür"
on public.apiaries for select
to authenticated
using (private.is_member(org_id));

create policy "Yazabilen üyeler arılık ekler"
on public.apiaries for insert
to authenticated
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Yazabilen üyeler arılıkları günceller"
on public.apiaries for update
to authenticated
using (private.has_role(org_id, '{owner,partner,worker}'))
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Üyeler ana arıları görür"
on public.queens for select
to authenticated
using (private.is_member(org_id));

create policy "Yazabilen üyeler ana arı ekler"
on public.queens for insert
to authenticated
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Yazabilen üyeler ana arıları günceller"
on public.queens for update
to authenticated
using (private.has_role(org_id, '{owner,partner,worker}'))
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Üyeler kovanları görür"
on public.hives for select
to authenticated
using (private.is_member(org_id));

create policy "Yazabilen üyeler kovan ekler"
on public.hives for insert
to authenticated
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Yazabilen üyeler kovanları günceller"
on public.hives for update
to authenticated
using (private.has_role(org_id, '{owner,partner,worker}'))
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Üyeler kovan geçmişini görür"
on public.hive_location_history for select
to authenticated
using (private.is_member(org_id));

create policy "Yazabilen üyeler kovan geçmişi ekler"
on public.hive_location_history for insert
to authenticated
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Yazabilen üyeler kovan geçmişini günceller"
on public.hive_location_history for update
to authenticated
using (private.has_role(org_id, '{owner,partner,worker}'))
with check (private.has_role(org_id, '{owner,partner,worker}'));
