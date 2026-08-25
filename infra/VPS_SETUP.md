# VPS SETUP — qouver.com (runbook untuk VPS yang SUDAH ADA)

> Status VPS (dikonfirmasi user 2026-08-18): **Caddy sudah terinstall & jalan**,
> semua site di **satu Caddyfile besar** (`/etc/caddy/Caddyfile`), **Postgres
> sudah jalan di podman** (dipakai majadu-api dll). Situs qouver.com statis
> (zero-JS) + Umami self-hosted di subdomain terpisah.
>
> Karena infra sudah ada, runbook ini **tidak** mengulang provisioning VPS.
> Yang perlu dilakukan: DNS → direktori → tambah site ke Caddyfile → deploy
> pertama → Umami (DB + container) → UptimeRobot.
>
> Komponen pendukung di repo:
> - `scripts/deploy.sh` — build + rsync + reload Caddy
> - `infra/Caddyfile.qouver.com` + `infra/Caddyfile.analytics.qouver.com`
>   — blok site yang harus digabung ke Caddyfile VPS
> - `infra/UMAMI_DEPLOY.md` — deploy container Umami
> - `infra/UPTIME_MONITORING.md` — uptime check (UptimeRobot)
>
> ⏱️ Total: ~15–20 menit pertama kali (sebagian nunggu DNS propagate).

---

## 0. Prasyarat

- Akses SSH ke VPS (`ssh root@qouver.com` atau user deploy dengan sudo).
- Domain `qouver.com` di Cloudflare (sudah ada per HANDOFF).
- Mesin lokal: repo ini.
- Caddy + Postgres (podman) sudah jalan — verifikasi cepat sebelum mulai:

```bash
ssh qouver.com "systemctl is-active caddy && podman ps --format '{{.Names}}'"
```

---

## 1. DNS (Cloudflare)

Di dashboard Cloudflare, zone `qouver.com` — tambah record:

| Type | Name | Value | Proxy |
|---|---|---|---|
| A | `@` | `<IP VPS>` | Proxied (oranye) |
| A | `www` | `<IP VPS>` | Proxied |
| A | `analytics` | `<IP VPS>` | Proxied (atau DNS only) |

> **SSL mode:** kalau apex proxied (oranye), pakai **Full (strict)** + origin
> cert dari Cloudflare — lihat §5.1. Kalau DNS-only, Caddy ambil cert
> Let's Encrypt sendiri.

## 2. Direktori situs

```bash
ssh qouver.com "sudo mkdir -p /srv/qouver/web && sudo chown -R \$(whoami): /srv/qouver"
```

> `chown` ke user SSH kamu supaya `rsync` dari `deploy.sh` bisa tulis tanpa
> sudo. Kalau login sebagai root, otomatis aman.

## 3. Tambah site ke Caddyfile (SATU file besar)

**Jangan replace** Caddyfile — **tambahkan dua blok** di bawah site yang
sudah ada. Cara terbaik: salin blok dari repo lalu gabung manual di VPS.

```bash
# Lihat dulu isi Caddyfile yang ada
ssh qouver.com "sudo cat /etc/caddy/Caddyfile"
```

Lalu tambahkan blok ini (sesuaikan indentasi dengan gaya file yang ada):

```caddy
qouver.com {
    root * /srv/qouver/web
    encode zstd gzip
    file_server

    header {
        Strict-Transport-Security "max-age=31536000; includeSubDomains"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "DENY"
        Referrer-Policy "strict-origin-when-cross-origin"
        Permissions-Policy "camera=(), microphone=(), geolocation=()"
        Content-Security-Policy "default-src 'self'; style-src 'self'; font-src 'self'; img-src 'self' data:; base-uri 'self'; frame-ancestors 'none'; form-action 'self'"
    }

    @static path /assets/* /fonts/* /fonts.css /styles.css /favicon.*
    header @static Cache-Control "public, max-age=31536000, immutable"
    header / Cache-Control "no-cache"

    handle_errors {
        @404 expression {http.error.status_code} == 404
        rewrite @404 /404.html
        file_server
    }
}

analytics.qouver.com {
    reverse_proxy 127.0.0.1:3000

    header {
        Strict-Transport-Security "max-age=31536000; includeSubDomains"
        X-Content-Type-Options "nosniff"
        Referrer-Policy "strict-origin-when-cross-origin"
    }

    encode zstd gzip
}
```

> Blok `analytics.qouver.com` bisa ditambahkan **sekarang juga** (reverse
> proxy ke port 3000 akan 502 selama Umami belum jalan — tidak apa-apa,
> `analytics` belum di-akses).

Validasi + reload:

```bash
ssh qouver.com "sudo caddy validate --config /etc/caddy/Caddyfile"
ssh qouver.com "sudo systemctl reload caddy"
```

> **Sinkronisasi repo ↔ VPS:** blok site hidup di repo
> (`infra/Caddyfile.*.qouver.com`) dan di Caddyfile VPS. Kalau diubah di
> repo, update juga di VPS — dan sebaliknya. Jangan sampai divergen.

## 4. Deploy pertama situs

Dari mesin lokal (root repo):

```bash
./scripts/deploy.sh --dry-run   # lihat apa yang akan di-sync (aman)
./scripts/deploy.sh             # build + rsync + reload Caddy
```

> `deploy.sh` default ke `root@qouver.com` + `/srv/qouver/web`. Kalau user
> SSH beda: `QOUVER_VPS_USER=<user> ./scripts/deploy.sh`.

Verifikasi:

```bash
curl -I https://qouver.com
# → HTTP/2 200, strict-transport-security, content-security-policy, dll

curl -s https://qouver.com/ | grep -o '<title>[^<]*</title>'
curl -s https://qouver.com/sitemap.xml | head -5
curl -s https://qouver.com/llms.txt | head -3
curl -sI https://qouver.com/assets/og-image.webp | grep -i cache-control
# → Cache-Control: public, max-age=31536000, immutable

# 404 kustom
curl -sI https://qouver.com/tidak-ada | grep -i 'HTTP\|location'
```

### 4.1 Kalau Cloudflare proxied (Full strict)

Caddy di belakang proxy Cloudflare butuh cert origin. Cara termudah:

```bash
# 1. Cloudflare → SSL/TLS → Origin Server → Create Certificate (15 tahun, RSA)
# 2. Simpan di VPS:
ssh qouver.com "sudo mkdir -p /etc/caddy/certs"
# salin isi fullchain + key ke /etc/caddy/certs/origin.pem dan origin.key
# 3. Tambah ke blok qouver.com di Caddyfile:
#    tls /etc/caddy/certs/origin.pem /etc/caddy/certs/origin.key
```

Alternatif: set SSL mode Flexible (tidak disarankan) atau DNS-only untuk
apex (Caddy ambil cert sendiri, tanpa proteksi Cloudflare).

## 5. Umami (analytics) — podman + Postgres existing

Postgres sudah jalan di podman — tinggal buat DB + container Umami. Ikuti
`infra/UMAMI_DEPLOY.md` langkah 1–3, dengan catatan:

- **DB:** buat database + user `umami` di Postgres yang **sudah ada**
  (`sudo -u postgres psql ...`), bukan instance baru.
- **Container:** `podman run -d --name umami -p 127.0.0.1:3000:3000 ...`
  (terikat localhost — hanya Caddy yang bisa akses). Untuk persist di
  reboot: `podman generate systemd` → unit service.
- **Caddy sudah terpasang** di langkah 3 — setelah Umami jalan, reload
  sekali lagi, lalu `curl https://analytics.qouver.com` harus 200 (login
  page).

Lalu buat website di Umami dan build situs dengan tracking:

```bash
UMAMI_SCRIPT_URL="https://analytics.qouver.com/script.js" \
UMAMI_WEBSITE_ID="<website-id>" \
./scripts/build.sh
./scripts/deploy.sh
```

> **Penting:** `UMAMI_SCRIPT_URL`/`UMAMI_WEBSITE_ID` di-*bake* ke HTML saat
> build — build yang dideploy **harus** pakai env var ini kalau mau
> analytics aktif. Default tanpa env = zero-JS. Simpan kedua nilai ini aman
> (password manager / `.env` git-ignored), jangan di-commit.

## 6. Uptime monitoring (UptimeRobot)

Ikuti `infra/UPTIME_MONITORING.md`: daftar monitor `https://qouver.com` dan
`https://analytics.qouver.com` (interval 5 menit, alert email). Gratis.

## 7. Email kontak (opsional, 2 menit)

`hello@qouver.com` belum ada — rekomendasi: **Cloudflare Email Routing**
(gratis, tanpa mail server). Setelah dibuat, pastikan alamat di
`lib/pages/contact_page.dart` sesuai.

---

## Checklist akhir

- [ ] DNS: apex, www, analytics → IP VPS (propagated: `dig +short qouver.com`)
- [ ] `/srv/qouver/web` ada & writable oleh user SSH
- [ ] Blok `qouver.com` + `analytics.qouver.com` masuk Caddyfile VPS
- [ ] `caddy validate` OK + reload sukses
- [ ] `curl -I https://qouver.com` → 200 + security headers lengkap
- [ ] Sitemap + robots + llms.txt + 404 kustom terverifikasi
- [ ] Umami: DB + container up (`curl -s http://127.0.0.1:3000` dari VPS)
- [ ] `https://analytics.qouver.com` → login page (200)
- [ ] Website Umami dibuat + `UMAMI_SCRIPT_URL`/`UMAMI_WEBSITE_ID` tersimpan
- [ ] UptimeRobot monitor aktif (qouver.com + analytics)
- [ ] `hello@qouver.com` (jika mau)

**Setelah semua hijau:** `git init` + commit + push (CI aktif) → tag
`v1.0.0` → status enterprise-grade penuh (lihat STANDARDS.md).
