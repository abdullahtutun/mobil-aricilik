# Arşiv: Supabase backend'i

Bu klasör 2026-11'e kadar kullanılan backend'dir (Postgres + RLS, Auth, Storage, Edge Function'lar, pg_cron). Backend PocketBase'e taşındı. Yeni sunucu kodu `server/` altında Go'dur, plan ve kararlar [docs/pocketbase-gecis.md](../../docs/pocketbase-gecis.md)'de.

- **Yeni migration yazılmaz.** Buradaki hiçbir dosya deploy edilmez. Şema değişikliği `server/migrations/` altında Go migration'ıdır.
- **P0.2 yedeği** kullanıcının Mac'inde: `~/Yedekler/mobil-arici/supabase-2026-11-09` (şema, veri, roller, Storage dosyaları, `manifest.txt`, `SHA256SUMS`). Yedek betiği `archive/backup_supabase.sh`; `supabase` CLI'si `archive/` içinden çalışır (bağlı proje `archive/supabase/.temp/project-ref`).
- **Neden duruyor:** Go testleri bu dosyaları kaynak olarak okur ve PocketBase karşılıklarıyla karşılaştırır: `server/internal/authz/policy_test.go` ve `server/internal/sync/push_rules_test.go` `migrations/*.sql`'i, `server/internal/authz/rls_test.go` `tests/database/*_rls.test.sql`'i. Sunucu kodundaki yorumlar da `supabase/...` yollarıyla buraya atıf yapar.
- Supabase projesi (`jcddnelaboueazhordfz`) P10.1'de donduruldu: `sync_push` her sürüme 426 döner, veri yerinde. Duraklatma P11.3'te.
