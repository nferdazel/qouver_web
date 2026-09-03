# STANDARDS — qouver_web (Enterprise-Grade Checklist)

> **Dibuat:** 2026-08-18 (sesi 2, lanjutan migrasi Jaspr)
> **Tujuan:** standar "enterprise grade" yang berlaku untuk proyek ini + hasil
> audit jujur kondisi sekarang. Standar diukur pragmatis untuk konteks:
> **situs statis personal-brand, infra self-hosted (VPS Rocky Linux + Caddy +
> podman), tim = 1 orang (user), framework Jaspr static mode.**
>
> Skala: ✅ pass · 🟡 partial · ❌ missing · ➖ tidak relevan

---

## 0. Verdict ringkas

| Area | Nilai | Catatan |
|---|---|---|
| Version control | ❌ | Belum `git init` — blocker terbesar (menunggu persetujuan) |
| CI/CD | ✅ | `.github/workflows/ci.yml` (format → analyze → test → build) |
| Code quality | ✅ | Analyzer bersih + format rapi + `.editorconfig`; CI menegakkan |
| Testing | ✅ | 12 test: smoke route, komponen, invariant data |
| Build & release | ✅ | Reproducible (`pubspec.lock`), 64K zero-JS, terverifikasi |
| Deployment & infra | 🟡 | `deploy/Caddyfile.qouver.com` (headers+cache+404) + `scripts/deploy.sh`; belum dijalankan/terverifikasi di VPS |
| Performance | ✅ | 64K, zero JS, font self-hosted + preload, og-image.webp — di atas rata-rata |
| Accessibility | ✅ | Skip-link + `id="main"` ditambahkan; semantik + focus + reduced-motion sudah |
| SEO & analytics | ✅ | SEO lengkap; Umami self-host terintegrasi (env-gated, VPS deploy pending) |
| Security | ✅ | Tidak ada secret; Caddyfile lengkap (HSTS/nosniff/CSP 'self' — font kini self-hosted); deps ter-pin |
| Observability | ✅ | Runbook UptimeRobot `infra/UPTIME_MONITORING.md` (setup 5 menit, belum didaftarkan akun) |
| Docs & maintenance | ✅ | README, HANDOFF, MIGRATION, STANDARDS; LICENSE + llms.txt + VERSION |
| CMS readiness | ✅ | `lib/data/projects.dart` = seam bersih, SSG→SSR kode sama |

**Verdict: BELUM enterprise grade.** Bloker tersisa: tidak ada version control
(user memilih menunda git init/commit). Semua P1 sudah ditutup; P2 menyusul.
CI pipeline siap di repo tapi aktif setelah repo di-push ke GitHub.

---

## 1. Version control (P0)

**Standar:** repo git aktif, commit bermakna, `.gitignore` benar, tidak ada
secret di history, branching convention, tag rilis.

| Kriteria | Status |
|---|---|
| `git init` + commit awal | ❌ belum ada repo sama sekali |
| `.gitignore` benar (build/, .dart_tool/, .DS_Store) | 🟡 ada, tapi belum ignore `.DS_Store` |
| `pubspec.lock` di-commit | ✅ (belum ada repo, tapi file ada & siap) |
| Tidak ada secret | ✅ tidak ada `.env`/key apa pun |
| Tag rilis / semver | ❌ belum (versi `0.0.1` di pubspec) |

**Aksi:** git init + commit awal (butuh persetujuan user), tambah `.DS_Store`
ke `.gitignore`, semver dipicu saat deploy.

## 2. CI/CD (P0)

**Standar:** pipeline otomatis menjalankan lint → format check → analyze →
test → build di setiap push/PR; deploy otomatis atau one-command dengan
approval.

| Kriteria | Status |
|---|---|
| Workflow CI (lint/analyze/test/build) | ❌ belum ada |
| Gate PR (status check) | ❌ belum ada (juga belum ada remote) |
| Deploy otomatis / semi-otomatis | 🟡 `scripts/build.sh` ada; belum `deploy.sh` + belum terhubung remote |

**Aksi:** tambah GitHub Actions (`ci.yml`): `dart format --output=none --set-exit-if-changed` →
`dart analyze` → `dart test` → `./scripts/build.sh`. Tambah `scripts/deploy.sh`
(rsync ke VPS + reload Caddy) yang dijalankan manual/semi-otomatis.

## 3. Code quality (P1)

**Standar:** analyzer 0 issue, `dart format` konsisten, lint rules aktif, tanpa
kode mati, konvensi penamaan jelas.

| Kriteria | Status |
|---|---|
| `dart analyze` bersih | ✅ 0 issue |
| `dart format` konsisten | ✅ baru di-format sesi ini; CI akan menegakkan |
| Lint `lints/recommended` | ✅ aktif |
| `jaspr_lints` (plugin analyzer) | ❌ di-skip — butuh SDK >3.13 (macros). Ditunggu sampai SDK naik |
| `.editorconfig` | ❌ belum ada |
| Kode mati / TODO | ✅ tidak ada (verifikasi sesi) |

**Aksi:** `.editorconfig`, jaga format via CI.

## 4. Testing (P1)

**Standar:** smoke test tiap route + test unit komponen kunci; coverage untuk
jalur yang mudah rusak (data proyek, SEO head, nav state).

| Kriteria | Status |
|---|---|
| Server-render smoke (route/title/nav/katalog) | ✅ 4 test lulus |
| Unit test komponen (`ProjectCard`, `QMark`) | ❌ belum ada |
| Test data (`projects.dart` invariant: index unik, URL valid) | ❌ belum ada |
| Test di CI | ❌ (ikut CI P0) |

**Aksi:** tambah test `ProjectCard` (link vs static), `QMark` (attribute),
invariant data proyek (index unik, url http(s) kalau ada, status konsisten).

## 5. Build & release (✅)

**Standar:** build reproducible dari lock file, output terverifikasi, rilis
versi, rollback jelas.

- ✅ `pubspec.lock` ter-pin; build idempotent (`scripts/build.sh`)
- ✅ Output 64K zero-JS; 4 route + sitemap + robots; verifikasi headless Chrome
- ✅ Build cepat (~15 dtk), tanpa headless Chrome
- 🟡 Belum ada tag/semver; rilis = copy `build/jaspr/` ke server
- ➖ Rollback: sebelum ada git, backup = folder `legacy/` (sudah dihapus user);
  **setelah git, rollback = checkout commit lama + rebuild** (ini alasan git = P0)

## 6. Deployment & infra (P1)

**Standar:** deploy satu perintah/idempotent, TLS, security headers, cache
policy, halaman 404, backup.

| Kriteria | Status |
|---|---|
| Snippet Caddy (TLS, SPA fallback) | ✅ ada di README |
| Security headers (HSTS, X-Content-Type-Options, Referrer-Policy, CSP) | ❌ belum |
| Cache policy aset statis (immutable hash / long cache) | ❌ belum |
| Halaman 404 kustom | ❌ belum |
| `scripts/deploy.sh` (rsync + reload) | ❌ belum |
| Backup konfigurasi | 🟡 Caddyfile di VPS; belum di-repo |

**Aksi:** `web/404.html` + rute 404 di router (fallback statis), snippet
Caddy lengkap (headers + cache) di README/HANDOFF, `scripts/deploy.sh`
(dry-run aman, tidak dijalankan tanpa izin), versi Caddyfile disimpan di repo
(`deploy/Caddyfile.qouver.com`).

## 7. Performance (✅)

- ✅ SSG murni, zero JS, 64K total, tanpa render-blocking JS
- ✅ Font **self-hosted** (lokal, tanpa request ke Google) + `preload` woff2 + `display=swap`
- ✅ OG image `.webp` (20K, hemat 62% dari PNG 53K); PNG dipertahankan sebagai fallback
- 🟡 Belum ada Lighthouse CI / budget performance (P2 lanjutan opsional)
- **Aksi P2 selesai:** font self-host + preload, `og-image.webp`.

## 8. Accessibility (P1)

**Standar:** HTML semantik, skip-link, kontras AA, keyboard navigable, aria
yang tepat, `:focus-visible`.

| Kriteria | Status |
|---|---|
| HTML semantik (header/nav/main/footer/section/article/h1-h4) | ✅ |
| `:focus-visible` global | ✅ (styles.css) |
| `aria-hidden` pada dekorasi (q-mark) | ✅ |
| Alt/aria label link ikon | ✅ (`aria-label` brand link) |
| Skip-link "Skip to content" | ❌ belum ada |
| Kontras (paper/ink/bronze-2 AA) | 🟡 bronze-2 dipilih AA untuk teks; belum diaudit penuh |
| `prefers-reduced-motion` | ✅ (styles.css) |

**Aksi:** tambah skip-link di `app.dart`, `id="main"`/`role=main` pada
`<main>`, sasar Lighthouse a11y 100.

## 9. SEO & analytics (P1)

- ✅ sitemap.xml otomatis, robots.txt, canonical, OG, twitter card, JSON-LD
- ✅ Title + meta description per halaman (SSR)
- ❌ **Analytics belum ada** — keputusan user: tanpa / Umami self-hosted
  (cocok dengan VPS existing) / Plausible / GoatCounter. Zero-JS vs data.
- 🟡 `llms.txt` (opsional, tren 2026) — P2
- **Aksi:** pilih analytics (P1, butuh keputusan), sisanya sudah standar.

## 10. Security (P1)

**Standar:** tidak ada secret, dependency ter-pin & ter-update, security
headers, CSP, HTTPS-only.

- ✅ Tidak ada secret; HTTPS via Caddy; dependency ter-pin
- ✅ `dart pub outdated`: tidak ada direct dep tertinggal
- ✅ Security headers + CSP ada di `deploy/Caddyfile.qouver.com`
  (HSTS, nosniff, X-Frame-Options, Referrer-Policy, Permissions-Policy, CSP `'self'`)
- ✅ CSP kini `'self'` penuh — font self-hosted, tidak perlu whitelist Google
- **Aksi:** verifikasi header di VPS saat deploy (curl -I). Upgrade policy:
  `dart pub upgrade` → test + build + browser (pola lama tetap valid).

## 11. Observability (P2)

- ✅ Runbook **UptimeRobot** siap: `infra/UPTIME_MONITORING.md` — free tier,
  monitor `https://qouver.com` + `https://analytics.qouver.com`, alert email,
  cek SSL expiry. Setup ~5 menit via dashboard (belum didaftarkan akun).
- ➖ Log/error: situs statis tanpa runtime → minimal. Analytics (Umami)
  menutup sebagian visibility.
- **Aksi:** daftar UptimeRobot + tambah monitor sesuai runbook (butuh akun user).

## 12. Docs & maintenance (✅)

- ✅ README (stack, build, deploy), HANDOFF (resume operasional), MIGRATION
  (keputusan + hasil), STANDARDS (ini)
- ✅ Semua gotcha tercatat (SDK PATH, main.client.dart, jaspr_lints, serve
  warning)
- ✅ **LICENSE**: MIT untuk kode + catatan konten all-rights-reserved (keputusan user 2026-08-18)
- ✅ **llms.txt** di `web/llms.txt` (dijadikan ke build output)
- ✅ **VERSION** `1.0.0` + di-stamp ke output build; semver/tag menunggu git init

## 13. CMS readiness (✅)

- ✅ `lib/data/projects.dart` = seam bersih; SSG→SSR kode sama; kontrak
  `Project` stabil
- ✅ Roadmap A (build-time) vs B (runtime) terdokumentasi di MIGRATION.md §8
- ➖ Konten CMS: belum ada CMS (sesuai rencana user)

---

## Gap list & prioritas

| Prio | Gap | Aksi | Status |
|---|---|---|---|
| P0 | Tidak ada git | `git init` + commit awal (perlu persetujuan) | 🔜 usul ke user |
| P0 | Tidak ada CI | `.github/workflows/ci.yml` (format→analyze→test→build) | ✅ |
| P1 | Tidak ada 404 | `NotFoundPage` + route `/404.html` (exclude dari sitemap) | ✅ |
| P1 | A11y skip-link | skip-link + `id="main"` | ✅ |
| P1 | Security headers & cache | `deploy/Caddyfile.qouver.com` (HSTS/nosniff/CSP/cache/404) | ✅ (belum terverifikasi di VPS) |
| P1 | Deploy script | `scripts/deploy.sh` (rsync + reload Caddy, `--dry-run`) | ✅ (belum dijalankan) |
| P1 | Test coverage | 12 test: komponen + invariant data + smoke | ✅ |
| P1 | Analytics | Umami self-host (env-gated script, runbook `infra/UMAMI_DEPLOY.md`); VPS deploy pending | ✅ |
| P1 | `.editorconfig` | file konvensi editor | ✅ |
| P2 | Font self-host + preload | `web/fonts/` + `fonts.css` + preload di head | ✅ |
| P2 | og-image.webp | 20K webp (PNG dipertahankan) | ✅ |
| P2 | Uptime monitoring | runbook UptimeRobot `infra/UPTIME_MONITORING.md` | ✅ (daftar akun = user) |
| P2 | LICENSE | MIT (kode) + konten all-rights-reserved | ✅ |
| P2 | llms.txt | `web/llms.txt` → build output | ✅ |
| P2 | semver/tag | `VERSION` 1.0.0 di-stamp; tag menunggu git init | 🟡 |

> **Definisi selesai "enterprise grade":** semua P0 + P1 hijau + verifikasi
> akhir (analyze, format, test, build, render browser). P2 boleh menyusul.
