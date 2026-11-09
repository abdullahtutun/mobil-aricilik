# Mobil Arıcı sunucusu

PocketBase v0.40.6, Go ile genişletilmiş kendi ikilimiz (`arici`). Plan ve kararlar: [../docs/pocketbase-gecis.md](../docs/pocketbase-gecis.md) (K-1…K-18).

Go sürümü PocketBase v0.40.6'nın `go.mod`'undaki `go 1.27` satırından gelir; Mac'te `go version` 1.27.x olmalı.

## Yapı

```text
main.go                 # pocketbase.New, migratecmd (Automigrate kapalı), bootstrap.Register
internal/config/        # ortam değişkenleri; eksikler açılışta adıyla loglanır
internal/bootstrap/     # açılış logu, BACKUPS_* → yedek ayarı, GET /api/app/info
migrations/             # Go şema migration'ları (K-3); şimdilik boş
ops/coolify.md          # Coolify panel ayarları (P1.3)
ops/backup.md           # gece yedeği, Mac'e indirme, geri yükleme (P1.4)
ops/pull_backup.sh      # en yeni yedeği Mac'e indirir
ops/restore_check.sh    # bir yedeği yerelde açıp dener
```

## Yerel çalıştırma

```sh
cd server
APP_ENV=dev go run . serve --http 127.0.0.1:8090
```

Veri `server/pb_data/`'ya yazılır (git'e girmez). `go run` PocketBase'i dev modunda açar: loglar ve SQL konsola düşer. İlk superuser:

```sh
go run . superuser upsert <e-posta> <parola>
```

Android emülatöründen adres `http://10.0.2.2:8090`, iOS simülatöründen `http://127.0.0.1:8090`.

Uçlar:

- `GET /api/health`: PocketBase'in sağlık denetimi, 200.
- `GET /api/app/info`: `{"env": "dev|prod", "version": "<git commit>"}`; oturumsuz, gizli değer içermez. Araçlar dev/prod ayrımını buradan yapar. `APP_ENV` yoksa ya da geçersizse `env` boş döner.

## Ortam değişkenleri

Adların tam listesi `internal/config/config.go`'daki `Known`'da ve dokümanın "Ortak bilgiler" bölümünde. Değerler yalnız Coolify'da (K-10). Eksik değişken sunucuyu durdurmaz; açılışta özelliğiyle birlikte adı loglanır, özellik kapalı kalır.

## Migration

Şema yalnız `migrations/` altındaki Go dosyalarıyla değişir; panelden değişiklik yapılmaz (K-3).

```sh
go run . migrate create <ad>   # migrations/<zaman>_<ad>.go açar
go run . migrate up            # bekleyenleri uygular (serve da açılışta uygular)
```

## Test

```sh
cd server
go test ./...
```

Testler `tests.NewTestApp` ile boş geçici bir veri klasöründe uygulamayı açar ve `tests.ApiScenario` ile uçları dener.

## Docker ile yerel deneme

Colima açık olmalı (`colima start`).

```sh
docker build --build-arg SOURCE_COMMIT=$(git rev-parse --short HEAD) -t arici-pb server
docker run --rm -p 8090:8090 -e APP_ENV=dev -e PB_ENCRYPTION_KEY=$(openssl rand -hex 16) -v arici-data:/pb/pb_data arici-pb
```

Kısa doğrulama:

```sh
docker run --rm -d -p 8090:8090 --name pbtest arici-pb && sleep 3 && curl -fsS localhost:8090/api/health; docker rm -f pbtest
```

İmaj: `golang:1.27.3-alpine3.24` içinde `CGO_ENABLED=0` derleme, çalışma imajı `alpine:3.24.4` + `ca-certificates` + `tzdata`; ikisi de etiket + digest ile sabit. İkili `/pb/arici`, kullanıcı `arici` (uid 10001), veri `/pb/pb_data` volume'ü, port 8090. `PB_ENCRYPTION_KEY` 32 karakter olmalı; değişirse panel ayarları çözülemez, bu yüzden her ortamda bir kez üretilip saklanır. İmaj boyutu ≈ 50 MB.

İmaj güncellerken etiket ve digest birlikte değişir: Docker Hub'da `library/golang` ve `library/alpine` etiketlerinin digest'i alınır, Dockerfile'daki `FROM` satırına yazılır.
