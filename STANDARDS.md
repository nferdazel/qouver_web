# STANDARDS. qouver_web

> **Diperbarui:** 2026-09-12 (revisi besar: kondisi nyata setelah revamp visual "Workshop Broadsheet").
> **Konteks standar:** situs statis personal-brand, zero client JS, infra self-hosted
> (VPS Rocky Linux + Caddy + podman), tim = 1 orang (user), framework Jaspr static mode.
> **Skala:** ✅ pass · 🟡 partial · ❌ missing · ➖ tidak relevan

---

## 0. Verdict ringkas

| Area | Nilai | Catatan |
|---|---|---|
| Version control | ✅ | Repo publik `nferdazel/qouver_web`, branch `main`. History pernah ditulis ulang untuk scrub IP VPS (lihat §10) |
| CI/CD | ✅ | `.github/workflows/build.yml`: test → build statis → push GHCR → deploy VPS. Actions di-pin ke commit SHA |
| Code quality | ✅ | `dart analyze` 0 issue, `dart format` ditegakkan CI, `.editorconfig` ada |
| Testing | ✅ | 15 test: smoke rute, komponen, invariant data |
| Build & release | ✅ | Reproducible (`pubspec.lock`), 328K total, zero `.js`, versi `1.0.0` |
| Deployment & infra | 🟡 | Caddyfile + headers + cache + 404 ada di repo; belum diverifikasi ulang di VPS |
| Performance | ✅ | Tanpa JS render-blocking, font self-hosted + preload, HTML dominan |
| Accessibility | ✅ | Skip-link, `:focus-visible`, kontras AA terukur, nav mobile 44px |
| SEO & analytics | ✅ | SEO lengkap, `llms.txt`, Umami env-gated dan kini diizinkan CSP |
| Security | 🟡 | Tidak ada secret di repo; origin IP masih publik via DNS, rotasi kredensial pending |
| Observability | 🟡 | Situs statis; monitoring manual/eksternal, belum ada runbook di repo |
| Docs & maintenance | ✅ | README, STANDARDS, LICENSE, `llms.txt`, VERSION (tracked). HANDOFF/MIGRATION lokal saja |
| CMS readiness | ✅ | `lib/data/projects.dart` seam bersih, SSG → SSR kode sama |

**Verdict: production-ready** untuk kelasnya (situs statis personal). Dua gap
operasional tersisa: tindak lanjut exposure IP VPS dan rotasi kredensial server.

---

## 1. Version control (P0)

| Kriteria | Status |
|---|---|
| Repo aktif + branch `main` | ✅ |
| `.gitignore` benar (`build/`, `.dart_tool/`, `.DS_Store`, dokumen internal) | ✅ |
| `pubspec.lock` di-track | ✅ |
| Tidak ada secret di tracked files | ✅ (diverifikasi, lihat §10) |
| Semver | ✅ `1.0.0` di `pubspec.yaml` dan `VERSION` |
| Tag rilis git | ❌ belum; rilis saat ini = image GHCR tag `main` + `sha` |

**Catatan:** history pernah memuat IP VPS. Sudah di-scrub dengan `git filter-repo`
(2026-09-12), force-push, dan diverifikasi 0 kemunculan. Detail follow-up di §10.

## 2. CI/CD (P0)

Pipeline: `.github/workflows/build.yml`, tiga job.

| Kriteria | Status |
|---|---|
| Gate test (format → analyze → test) | ✅ `dart format --set-exit-if-changed`, `dart analyze`, `dart test` |
| Build statis + publikasi image | ✅ `bash scripts/build.sh` → GHCR `ghcr.io/nferdazel/qouver_web` |
| Deploy ke VPS | ✅ otomatis via `appleboy/ssh-action`, restart quadlet `qouver-web` |
| Actions di-pin ke commit SHA | ✅ (SEC-3, 2026-09-12) |
| Least privilege | ✅ `permissions: contents: read`; `build-push` menambah `packages: write` |
| Approval gate deploy | ➖ dipilih tanpa gate (solo; push ke `main` = deploy). Opsi: GitHub Environment `production` |

## 3. Code quality (P1)

| Kriteria | Status |
|---|---|
| `dart analyze` bersih | ✅ 0 issue |
| `dart format` konsisten | ✅ ditegakkan di CI |
| `.editorconfig` | ✅ |
| `jaspr_lints` | ❌ belum (butuh SDK di atas 3.13, tertunda) |
| Kode mati | ✅ tidak ada (komponen tak terpakai sudah dihapus) |

## 4. Testing (P1)

15 test, semua hijau.

| Kriteria | Status |
|---|---|
| Smoke rute + judul + nav + katalog | ✅ `test/smoke_test.dart` (6) |
| Komponen (`ProjectCard`, `QMark`, `ProjectDetailPage` fallback) | ✅ `test/component_test.dart` (4) |
| Invariant data proyek | ✅ `test/projects_data_test.dart` (5) |
| Rute tak dikenal menampilkan 404 | ✅ |
| Test di CI | ✅ |

## 5. Build & release (P1)

| Kriteria | Status |
|---|---|
| Reproducible dari lock file | ✅ |
| Zero client JS | ✅ 0 file `.js` di output |
| Ukuran terukur | ✅ 328K total: 13 HTML 108K, font 100K, gambar 93K, CSS 24K |
| Versi di-stamp ke output | ✅ `VERSION` |
| Tag rilis | 🟡 belum |

## 6. Deployment & infra (P1)

| Kriteria | Status |
|---|---|
| Konfigurasi Caddy di repo | ✅ `deploy/Caddyfile.qouver.com`, `deploy/Caddyfile.qouver-web.docker`, `deploy/Caddyfile.analytics.qouver.com` |
| Security headers (HSTS, nosniff, X-Frame-Options, Referrer-Policy, Permissions-Policy, CSP) | ✅ |
| Cache policy (HTML `no-cache`, aset `immutable`) | ✅ |
| Halaman 404 kustom | ✅ `handle_errors` → `/404.html` |
| Unit podman | ✅ `deploy/qouver-web.container` |
| Verifikasi header di VPS | 🟡 belum dilakukan dari sesi ini (`curl -I` saat deploy) |
| Skrip deploy terpisah | ➖ tidak ada; deploy lewat CI |

## 7. Performance (P1)

- ✅ SSG murni, tanpa render-blocking JS; HTML 108K untuk 13 halaman.
- ✅ Font self-hosted (Fraunces 66K + Archivo 34K, variable latin), preload Fraunces saja.
- ✅ Gambar `webp`; total aset gambar 93K.
- 🟡 Belum ada Lighthouse CI atau performance budget.

## 8. Accessibility (P1)

| Kriteria | Status |
|---|---|
| HTML semantik + `id="main"` | ✅ |
| Skip-link "Skip to content" | ✅ |
| `:focus-visible` global | ✅ |
| `aria-hidden` pada dekorasi (Q mark) | ✅ |
| Kontras AA terukur | ✅ ink 15.45, ink-2 7.60, ink-3 5.55, accent 4.98 (paper); on-dark 10.67, on-dark-2 5.40, signal 4.72 large (ink) |
| Nav mobile + tap target 44px | ✅ (header bertumpuk di bawah 640px) |
| `prefers-reduced-motion` | ✅ |
| Klik-through browser (keyboard + 360px) | 🟡 belum dilakukan |

## 9. SEO & analytics (P1)

- ✅ `sitemap.xml` otomatis, `robots.txt`, canonical, OpenGraph, Twitter card, JSON-LD.
- ✅ Title + meta description per halaman, dirender server-side.
- ✅ `llms.txt` ikut ke output build.
- ✅ Umami self-hosted, env-gated (`UMAMI_SCRIPT_URL`). Saat aktif, CSP mengizinkan `analytics.qouver.com` di `script-src` dan `connect-src`.

## 10. Security (P1)

- ✅ Tidak ada secret di tracked files maupun di history (diverifikasi).
- ✅ Dependency ter-pin (`pubspec.lock`).
- ✅ Security headers + CSP di Caddyfile.
- ✅ Actions CI di-pin ke SHA.
- ⚠️ **Exposure IP VPS.** IP pernah ada di history dan sudah di-scrub, tetapi origin masih dapat ditemukan lewat DNS (`dig qouver.com`). Scrub history bersifat kosmetik sampai origin disembunyikan (Cloudflare proxy) atau IP diganti. GitHub masih dapat menyajikan blob lama lewat API sampai di-GC oleh Support.
- ⚠️ **Kredensial server.** Ada kredensial plaintext di dokumen server di luar repo (`~/Projects/SERVER_STATE.md`) dan salinannya ikut backup. Rotasi (sudo, token Telegram, password Kuma) belum dilakukan.
- 🟡 Email author git publik (`fredinix@proton.me`). Putuskan apakah dipertahankan atau pindah ke email noreply.

## 11. Observability (P2)

- ➖ Situs statis tanpa runtime; log/error minimal.
- 🟡 Belum ada runbook monitoring di repo. Monitoring (uptime, SSL expiry) masih manual/eksternal dan belum terdokumentasi di sini.
- ✅ Analytics Umami (saat diaktifkan) menutup sebagian visibility trafik.

## 12. Docs & maintenance (✅)

- ✅ Tracked di repo: `README.md`, `STANDARDS.md`, `LICENSE`, `web/llms.txt`, `VERSION`, `deploy/`, `scripts/build.sh`.
- ➖ `HANDOFF.md` dan `MIGRATION.md` **lokal saja** (gitignored), tidak ada di repo publik. Dokumen ini tidak lagi merujuk keduanya sebagai sumber publik.
- ✅ Gotcha teknis tercatat di README (PATH SDK, build statis, catatan `jaspr serve`).

## 13. CMS readiness (✅)

- ✅ `lib/data/projects.dart` dan `lib/data/journal.dart` adalah seam bersih; kontrak data stabil; SSG → SSR memakai kode yang sama.
- ➖ Belum ada CMS (sesuai rencana).

---

## Gap list & prioritas

| Prio | Gap | Aksi | Status |
|---|---|---|---|
| P0 | Exposur IP VPS | Kirim permintaan GC ke GitHub Support; aktifkan Cloudflare proxy atau ganti IP | 🔜 butuh aksi user |
| P0 | Kredensial plaintext server | Rotasi sudo/Telegram/Kuma; simpan di password manager | 🔜 butuh aksi user |
| P1 | Verifikasi header di VPS | `curl -I https://qouver.com` setelah deploy | 🟡 |
| P1 | Klik-through browser | Cek keyboard, fokus, dan 360px di browser | 🟡 |
| P1 | Rute journal/404 belum diuji penuh | Sudah ditambah di smoke test | ✅ |
| P2 | Tag rilis git | Tag semver saat rilis bermakna | ❌ |
| P2 | Lighthouse CI / budget performa | Opsional | ❌ |
| P2 | Runbook monitoring | Dokumentasikan monitor uptime + SSL | ❌ |
| P2 | Email author git | Putuskan noreply atau tidak | 🟡 |

> **Definisi selesai "enterprise grade":** semua P0 + P1 hijau, plus verifikasi
> akhir (analyze, format, test, build, render browser). P2 boleh menyusul.
