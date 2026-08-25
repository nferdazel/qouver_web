# Umami self-host — runbook VPS (podman + Postgres)

> Umami = privacy-friendly analytics (open source). Self-hosted di VPS yang
> sudah menjalankan podman + Postgres (infra yang sama dengan majadu-api).
> Dipilih user 2026-08-18. Implikasi: situs menyisipkan **satu script JS
> ~2KB** (`/script.js`) — tradeoff terhadap zero-JS murni, diterima user.

## 1. Deploy container (sekali, di VPS)

```bash
# Pull image
podman pull ghcr.io/umami-software/umami:latest

# Database: buat database + user khusus di Postgres yang sudah ada
sudo -u postgres psql <<'SQL'
CREATE USER umami WITH PASSWORD 'GANTI_PASSWORD';
CREATE DATABASE umami OWNER umami;
SQL

# Container (systemd unit via `podman generate systemd` untuk persist)
podman run -d --name umami \
  -p 127.0.0.1:3000:3000 \
  -e DATABASE_URL="postgresql://umami:GANTI_PASSWORD@localhost:5432/umami" \
  -e APP_SECRET="$(openssl rand -base64 32)" \
  --restart unless-stopped \
  ghcr.io/umami-software/umami:latest

# Verifikasi
curl -s http://127.0.0.1:3000/api/telemetry/rum-event -o /dev/null -w '%{http_code}\n'
```

> Umami butuh Postgres 12+ (user sudah punya). Untuk produksi, ekspor
> `DATABASE_URL`/`APP_SECRET` dari file env (`--env-file`) — jangan di history.

## 2. Caddy subdomain

- Pasang `infra/Caddyfile.analytics.qouver.com` sebagai site terpisah
  (atau gabung ke Caddyfile utama). DNS `analytics.qouver.com` → IP VPS
  (Cloudflare proxy boleh; pastikan SSL mode sesuai).
- Reload: `sudo caddy reload --config /etc/caddy/Caddyfile`

## 3. Buat website di Umami

- Buka `https://analytics.qouver.com`, login admin (user dibuat saat
  container pertama jalan), lalu **Settings → Websites → Add website**
  (domain: `qouver.com`).
- Salin **Website ID** dari halaman tersebut.

## 4. Build situs dengan tracking

Website ID + URL script di-inject saat build via env var:

```bash
UMAMI_SCRIPT_URL="https://analytics.qouver.com/script.js" \
UMAMI_WEBSITE_ID="<website-id>" \
./scripts/build.sh
```

- Tanpa env var → situs tetap **zero-JS** (script tidak ikut ter-render).
- Verifikasi: `grep -o 'script.js' build/jaspr/index.html`
- Selanjutnya rilis biasa: build + deploy (`scripts/deploy.sh`). Umami
  dideploy sekali; situs cukup di-build ulang dengan env yang sama.

## 5. Referensi

- https://umami.is/docs — install & API
- Image: `ghcr.io/umami-software/umami`
