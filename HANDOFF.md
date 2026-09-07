# HANDOFF — qouver_web (situs utama qouver.com)

> **Arsitektur deploy saat ini (2026-09):** container `qouver-web` (:3002) via
> GH Actions → GHCR. Bagian-bagian yang menyebut rsync `/srv/qouver/web` di
> dokumen ini adalah riwayat arsitektur statis lama (tidak dipakai lagi).
>
> **Dibuat:** 2026-08-15 (sesi 1 — dari nol sampai siap deploy)
> **Diperbarui:** 2026-08-18 (sesi 2 — migrasi AngularDart → Jaspr, lihat §13)
> **Diperbarui:** 2026-09-03 (sesi 4 — konten: de-jargon + proof of work + katalog SDS, lihat §16)
> **Git:** aktif — repo `qouver_web` di GitHub (`nferdazel/qouver_web`), branch `main`
> **Tujuan dokumen:** resume penuh — apa yang dibangun, keputusan, versi yang
> fragile, cara build/deploy, dan apa yang belum — biar sesi berikutnya lanjut
> tanpa kehilangan konteks.

---

## 1. TL;DR — Status dalam 30 detik

- **Situs utama qouver.com SELESAI dibangun** di `qouver_web/` — **SEKARANG Jaspr** (static mode, 2026-08-18). AngularDart lama diarsipkan di `legacy/`.
- **Output sekarang:** `build/jaspr/` — **64K, zero JavaScript**, SEO (title/meta/canonical/OG/JSON-LD) di-render server-side. Build ~15 dtk tanpa headless Chrome.
- **4 halaman:** Home, Projects, About, Contact — bahasa **English**, positioning **umbrella produk**.
- **Portfolio (per 2026-09-03):** Skyward (live), Majadu Tools (live — Go backend/API, frontend community-maintained), SDS Management (live). **M-DEF archived** (mdef.qouver.com mati, superseded oleh rating Majadu); TAUG archived 2026-08-25 (di luar katalog).
- **Identitas baru:** logo monogram Q (SVG, sekaligus favicon), palet kertas/ink/bronze, IBM Plex Sans + Mono — Swiss editorial, bukan tema Majadu.
- **🔴 PENTING (versi fragile):** revival AngularDart harus **`angulardart >= 9.4.1` + `angulardart_router >= 5.4.0`** — versi yang di-scaffold CLI (9.3.6/5.3.3) **crash di runtime** di bawah dart2js (2 bug diverifikasi, detail di §3). `pubspec.lock` WAJIB di-commit.
- **Output siap deploy:** `build/web/` (356K) — static HTML prerender per route + sitemap.xml + robots.txt + SPA hydrate. Belum di-deploy.
- **Belum beres:** git init, Caddy site apex (error 525), email `hello@qouver.com` belum dibuat, `api.qouver.com/majadu/healthz` balas 502 (container?), konten bio/foto.

---

## 2. Keputusan sesi (dari user, 2026-08-15)

| Topik | Keputusan | Catatan |
|---|---|---|
| Scope | **Full site multi-page** | Home, Projects, About, Contact (siap dikembangin ke blog) |
| Bahasa | **English** | — |
| Positioning | **Umbrella produk** | Qouver = rumah untuk sistem & ide; proyek datang-pergi, Qouver tetap |
| Portfolio | Skyward, M-DEF, **Majadu (backend only)**, TAUG | Frontend badminton-match **bukan** buatan user → jangan di-feature |
| Domain | Semua di **apex `qouver.com`** | Bukan subdomain |
| Visual | **Identitas baru** (bukan tema Majadu), simple-professional-timeless, bukan AI-ish | Referensi: Swiss editorial / awwwards minimal |
| Logo | Desain impromptu, **SVG** | File logo asli user hilang |
| Font | **IBM Plex Sans** (+ Mono) | Preferensi user |

**Sumber konten:** dokumen *"Qouver — Identity, Philosophy, and Lore"* yang di-paste user
(origin story Quousever→Qouver, Systems Prospector, filosofi "Find value. Build
systems. Share knowledge.", motto "Turning overlooked ideas into useful systems.").

---

## 3. Stack & versi — 🔴 BACA INI DULU

### Versi yang ter-resolve (sudah terbukti jalan)

| Package | Versi | Kenapa |
|---|---|---|
| `angulardart` | **9.4.1** | Wajib >= 9.4.1 (fix bug style injection) |
| `angulardart_router` | **5.4.0** | Wajib >= 5.4.0 (fix bug `web.Element` DI) |
| `angulardart_seo` | 1.5.0 | Gelombang fix yang sama |
| `angulardart_compiler` | 5.6.1 | Transitif (via angulardart) |
| `angulardart_ast` | 3.4.0 | Transitif |
| `angulardart_prerender` | 1.3.0 | Tool prerender (dev dep) |
| Dart SDK | 3.13.0 | Standalone; Flutter 3.47.0 juga ada |
| `package:web` | 1.1.1 | Transitif |

### Dua bug revival yang ditemukan & diverifikasi sesi ini

1. **`TypeError: _BrowserElement is not a subtype of DomHTMLStyleElement`**
   - Lokasi: `ComponentStyles._appendStyles()` — setiap `@Component` bikin `<style>` element
     (walau kosong) dan cast-nya gagal di dart2js → **app tidak pernah boot**.
   - Terjadi di angulardart 9.3.6 (yang di-scaffold CLI `ngdart new --seo`).
   - **Fix:** bump ke 9.4.x. Terverifikasi: scaffold mentah pun crash — bukan salah kode kita.

2. **`No provider found for JSObject`** (boot lebih jauh, error berikutnya)
   - Lokasi: `RouterLink` constructor inject `web.Element` (package:web) via DI,
     tapi compiler memperlakukannya sebagai token injectable dan tidak ada provider-nya.
   - Terjadi di angulardart_router 5.3.3. **Fix:** bump ke 5.4.0.

> **Pelajaran:** `dart pub get` TIDAK meng-upgrade package dalam constraint lama
> (lock file menahan). Kalau suatu saat `pub get`/`pub upgrade` menjatuhkan versi
> ke bawah 9.4.1/5.4.0, situs crash di browser. **Jangan pernah hapus `pubspec.lock`**
> dari git (scaffold default me-ignore — sudah diperbaiki di `.gitignore`).
> Kalau mau update package, tes build + browser dulu (lihat §8).

### Risiko lain yang perlu diingat

- Revival ini sangat muda & aktif (rilis harian). CI mereka hanya test `analyze` +
  unit test CLI/SEO — **tidak ada test browser untuk core `angular`**, jadi bug
  runtime bisa lolos ke release. Jangan asumsi "versi terbaru = jalan".
- `angulardart_prerender` **sengaja menghapus `<script>`** dari HTML hasil capture
  (ditujukan buat crawler). `scripts/build.sh` sudah menangani (re-inject) — lihat §6.

---

## 4. Struktur proyek

```
qouver_web/
├── web/                       # entrypoint
│   ├── main.dart              # bootstrap: injector (router + seo) → runApp(AppComponent)
│   ├── index.html             # fonts Google (IBM Plex), favicon q-mark.svg, theme-color
│   ├── styles.css             # SELURUH design system (tokens, komponen, responsive)
│   └── assets/q-mark.svg      # logo monogram Q (juga favicon)
├── lib/
│   ├── app_component.dart     # shell: header (brand+nav), <router-outlet>, footer
│   ├── components/
│   │   ├── q_mark.dart        # QMarkComponent — SVG inline, input size, currentColor
│   │   └── project_card.dart  # ProjectCardComponent — card link/static, input Project
│   ├── pages/
│   │   ├── home_page.dart     # hero + strip filosofi + index proyek + manifesto
│   │   ├── projects_page.dart # katalog penuh (project-row + focus list + link)
│   │   ├── about_page.dart    # origin story, prospector, is/is-not, visi
│   │   └── contact_page.dart  # email + GitHub rows
│   └── data/projects.dart     # Model Project + const list (single source of truth)
├── scripts/build.sh           # build release + assemble + prerender + re-inject script
├── prerender.yaml             # routes + base_url (https://qouver.com)
├── build.yaml                 # dart2js -O4, entrypoint web/main.dart
├── pubspec.yaml / pubspec.lock # ⚠️ lock WAJIB di-commit
└── README.md                  # ringkasan (HANDOFF ini = versi detail)
```

**Pola penting (kesalahan yang sudah diperbaiki):**
- Import file template `.template.dart` dari `lib/` WAJIB pakai **package URI**
  (`package:qouver_web/...`), bukan relative — `web/main.dart` relative ke `web/`
  tidak akan ketemu file di `lib/`.
- Setiap komponen yang pakai `routerLink`/`routerDirectives` wajib
  `import 'package:angulardart_router/angulardart_router.dart'` — kalau tidak,
  compiler error membingungkan: `Invalid constant value` (bukan "undefined name").
- `@Input()` field nullable (`Project?`) bikin codegen akses tanpa null-check →
  error di build. Pakai non-nullable + default (lihat `ProjectCardComponent`).

---

## 5. Identitas & design system

| Token | Nilai | Pemakaian |
|---|---|---|
| `--paper` | `#F4F1E9` | Background hangat |
| `--paper-2` | `#ECE7DB` | Surface hover |
| `--ink` | `#1C1913` | Teks utama |
| `--ink-2` | `#57503F` | Teks sekunder |
| `--bronze` | `#A07030` | Aksen (prospector gold, muted) |
| `--bronze-2` | `#7A5422` | Aksen teks di light (AA) |
| `--night` | `#16130D` | Section/footer gelap |
| `--bone` | `#EAE3D2` | Teks di gelap |
| `--line` | `#D8D0BD` | Hairlines |

- **Font:** IBM Plex Sans (headline/body) + IBM Plex Mono (label, index, meta) — Google Fonts.
- **Logo:** monogram Q — ring menahan **satu titik** di dalam bowl ("the find,
  brought home"; ekor tetap melacak sapuan prospector yang mengarah ke sana).
  Titik bronze `#A07030` di konteks berwarna (tile icon, og-image); standalone
  SVG tetap monokrom (`currentColor` → adaptif light/dark). File:
  `web/assets/q-mark.svg` (standalone) + `web/assets/q-mark-solid.svg`
  (ink-on-paper) + `web/assets/icons/` (apple-touch 180, PWA 192/512,
  maskable 512) + `web/site.webmanifest`.
- **Layout language:** mono label uppercase (`01 / INDEX`), hairlines, grid kartu
  border-1px, section gelap (strip filosofi, manifesto) untuk ritme kontras,
  whitespace lebar. Hero punya watermark Q mark besar.
- Semua token & komponen di `web/styles.css` (satu file, sistem).

---

## 6. Build & prerender pipeline

`./scripts/build.sh` (sudah terverifikasi end-to-end):

1. `dart run build_runner build --release` → dart2js -O4 → `main.dart.js`
2. Susun `build/web/`: `index.html`, `styles.css`, `assets/q-mark.svg`, `main.dart.js`
3. `dart run angulardart_prerender:prerender` — baca `prerender.yaml`
   (routes `/`, `/projects`, `/about`, `/contact`; `base_url: https://qouver.com`)
   → render tiap route di headless Chrome → `build/web/<route>/index.html` +
   `sitemap.xml` + `robots.txt` (SEO title per halaman sudah dinamis via SeoService)
4. **Re-inject** `<script defer src="main.dart.js">` ke tiap HTML hasil prerender
   (tool-nya sengaja buang script) → halaman ter-render static UNTUK crawler,
   DAN hydrate sebagai SPA untuk user.

**Catatan:** `render_delay_ms: 10000` di prerender.yaml → tiap route ~10 dtk (total ~40s).
Kalau mau build lebih cepat, turunkan ke ~3000 (konten tidak bergantung font).

---

## 7. Deployment (belum dilakukan)

Target: Caddy di VPS qouver.com (pola sama seperti `Caddyfile.api.qouver.com`).

```caddy
qouver.com {
    root * /srv/qouver/web
    try_files {path} /index.html
    file_server
}
```

- **DNS:** apex `qouver.com` sudah lewat Cloudflare (proxy). Sekarang balas **525**
  (handshake gagal — tidak ada origin di belakangnya). Setelah Caddy site dibuat,
  TLS otomatis (atau Cloudflare Full strict + origin cert).
- **Email kontak:** `hello@qouver.com` **belum dibuat** — rekomendasi: Cloudflare
  Email Routing (gratis, user sudah di Cloudflare, tanpa mail server, 2 menit).
  Kalau email ganti, update di: `lib/pages/contact_page.dart` + footer
  (`lib/app_component.dart`) + `web/index.html` meta + `prerender.yaml` tidak perlu.
- **GitHub:** footer link `github.com/qouver` (org, sepi) + `github.com/nferdazel`
  (personal, aktif). Tidak ada sosmed lain.

---

## 8. Verifikasi (rekam jejak sesi ini)

| Item | Hasil |
|---|---|
| `dart analyze` | ✅ No issues |
| `build_runner build --release` | ✅ Success |
| Prerender | ✅ 4/4 route, 0 failed, sitemap + robots |
| Render browser (headless Chrome) | ✅ 0 console error; hero, 4 cards, strip, manifesto, footer semua tampil |
| SEO per route | ✅ Title dinamis: `/projects`→"Projects — Qouver", dst.; canonical `https://qouver.com/...` |
| Dev serve (`dart run build_runner serve`) | ✅ 200, app ter-render |
| URL produk | ✅ `mdef.qouver.com` 200, `skyward.qouver.com` 200, `api.qouver.com/majadu` ❌ healthz 502 |
| Output | `build/web/` 356K |

---

## 9. Known issues & gotchas

1. **`api.qouver.com/majadu/healthz` → 502** (curl 2026-08-15). `/healthz` tanpa prefix → 404 (normal, infra-only). Kemungkinan container majadu-api mati/restart — cek sebelum klaim "Majadu Tools" punya API live.
2. **Apex `qouver.com` → 525** — belum ada origin (direncanakan: Caddy site, §7).
3. **Versi fragile** — §3. Jangan downgrade; jangan hapus lock.
4. **Prerender tool menghapus script** — jangan jalankan `angulardart_prerender` manual tanpa re-inject (pakai `scripts/build.sh`).
5. **Fonts via Google Fonts** — butuh internet saat render; di lingkungan offline, font jatuh ke fallback. Tidak memblokir konten.
6. **TAUG** — cuma lore, tanpa repo/link. Card-nya "In exploration" tanpa URL (bukan bug — desain).
7. **Logo file asli user hilang** — yang dipakai sekarang monogram buatan sesi ini (`web/assets/q-mark.svg`). Kalau user menemukan file asli, tinggal ganti.
8. **Konten majadu** — deskripsi "backend by Qouver, frontend community-maintained" sesuai instruksi user; jangan ubah framing ini.

---

## 10. Yang BELUM dikerjakan (prioritas)

| # | Item | Catatan |
|---|---|---|
| 1 | **Git init + commit awal** | Folder belum repo. Butuh persetujuan user. `.gitignore` sudah siap (build/, .dart_tool/; lock di-commit) |
| 2 | **Deploy: Caddy site apex qouver.com** | Fix 525. Snippet di §7. Copy `build/web/` ke VPS |
| 3 | **Bikin `hello@qouver.com`** | Cloudflare Email Routing (gratis). Update kontak jika berubah |
| 4 | **Cek container majadu-api (502)** | Sebelum/bersamaan deploy, pastikan API sehat |
| 5 | **Konten: bio & detail About** | User belum kasih bio personal; draft sekarang pakai lore doc |
| 6 | **Konten: deskripsi produk per-user** | Deskripsi saat ini disusun dari README repo + lore; user boleh refine |
| 7 | **Favicon & OG image** | Favicon sudah q-mark.svg; OG image belum ada (opsional untuk sharing) |
| 8 | **Blog/SEO growth** | Rencana jangka panjang — bukan sekarang |

---

## 11. Cara lanjut (checklist resume)

```bash
# 1. Konteks cepat
cd /Users/sachiel/Projects/qouver_web
cat README.md          # ringkasan
cat HANDOFF.md         # dokumen ini

# 2. Dev (hot reload)
dart run build_runner serve     # → http://localhost:8080

# 3. Ubah konten
#    - data proyek:  lib/data/projects.dart
#    - copy halaman: lib/pages/*.dart
#    - design:       web/styles.css
#    - kontak:       lib/pages/contact_page.dart + lib/app_component.dart (footer)

# 4. Build static (deployable)
./scripts/build.sh              # → build/web/

# 5. Validasi cepat (sebelum deploy)
#    (buat server + headless chrome — lihat riwayat sesi; intinya: 0 console error)
dart analyze

# 6. Deploy ke VPS
#    rsync/scp build/web/ → /srv/qouver/web + buat Caddy site (§7)
```

**Kalau update dependency:** `dart pub upgrade`, lalu WAJIB tes: `./scripts/build.sh`
+ render browser. Kalau crash (lihat §3), pin balik ke versi yang terbukti.

---

## 12. Kontak & konteks pribadi

- Project personal user (`sachiel`). Domain qouver.com di Cloudflare; VPS Rocky Linux
  (`[REDACTED_VPS_IP]`) dengan Caddy + podman + Postgres — infra yang sama dipakai
  Majadu (`api.qouver.com`, `mjd-api.qouver.com`).
- Proyek lain di workspace: `majadu-api` (Go), `badminton-match` (React PWA),
  `mdef` & `skyward` (Flutter). qouver_web adalah **wajah publik** dari umbrella ini.
- GitHub personal: `nferdazel` (aktif). Org: `qouver` (belum terisi).
- Bahasa kerja user: Indonesia. Konten situs: English.

---

## 13. SESI 2 (2026-08-18) — Migrasi AngularDart → Jaspr

> Dokumen pendamping: `MIGRATION.md` (analisis + hasil eksekusi detail).

### 13.1 Ringkasan

Seluruh situs di-migrasi dari AngularDart (revival) ke **Jaspr 0.23.4 static
mode**. Desain (styles.css, q-mark.svg, palet, copy) dipertahankan 100%; copy
hanya berubah di satu tempat (footer: "Built with Jaspr"). Semua artefak
AngularDart diarsipkan di `legacy/` (rollback plan).

### 13.2 Apa yang berubah

| Sebelum (AngularDart) | Sesudah (Jaspr) |
|---|---|
| `angulardart` + `angulardart_router` + `angulardart_seo` + build_runner + prerender headless Chrome | `jaspr` + `jaspr_router` (multi-page routing), `jaspr build` (render in-process) |
| `build/web/` 356K, SPA hydrate `main.dart.js` | `build/jaspr/` **64K, zero JS** |
| `prerender.yaml` + hack re-inject script (Python) | `jaspr build --sitemap-domain` (sitemap otomatis) + `robots.txt` statis |
| Versi fragile (lock file sakral) | Versi normal; lock tetap di-commit |

### 13.3 Struktur baru

```
web/                     # styles.css, robots.txt, assets/ (q-mark.svg, og-image.png)
lib/
  main.server.dart       # entrypoint server (Document + head global + App)
  app.dart               # shell: header, nav, Router (4 route), footer
  seo.dart               # helper pageHead(): title/meta/canonical/OG/twitter
  components/            # q_mark, project_card
  pages/                 # home, projects, about, contact
  data/projects.dart     # TIDAK BERUBAH — seam pertama ke CMS nanti
test/smoke_test.dart     # 4 smoke test (route, title SEO, nav active, katalog)
scripts/build.sh         # deteksi SDK + jaspr build + sitemap + cleanup output
```

### 13.4 🔴 Gotchas baru (baca sebelum lanjut)

1. **`which dart` harus SDK asli.** jaspr_cli memverifikasi `which dart` ada di
   dalam Dart/Flutter SDK. Mesin ini `dart` = shim Flutter (Homebrew cask) →
   `jaspr build` gagal. `scripts/build.sh` sudah handle (resolve
   `<flutter>/bin/cache/dart-sdk/bin/dart`). Kalau menjalankan
   `dart run jaspr_cli:jaspr ...` manual, pakai SDK asli di PATH.
2. **Tidak ada `main.client.dart` (sengaja).** Situs zero-JS. Kalau nanti
   tambah komponen interaktif (`@client`), perlu tambah `lib/main.client.dart`
   DAN verifikasi compile client-nya (quirk build target `web` — lihat
   MIGRATION.md §14.2). Server meng-inject `<script src="main.client.dart.js">`
   hanya jika `main.client.dart` ada.
3. **`jaspr serve` (dev) menampilkan warning** "Could not find a respective
   '.client.dart' file..." — EKSPEKTASI (situs memang tanpa client). Bukan bug.
4. **`jaspr_lints` belum dipakai** — butuh SDK dengan `_macros` (belum ada di
   Dart 3.13.0 lokal). `lints` standar cukup.
5. **Scaffold `jaspr create` saat ini rusak** (konstrain `build_web_compilers
   ^4.8.10` vs `jaspr_builder` bentrok resolver) — jangan jadikan acuan; pakai
   struktur di §13.3 / MIGRATION.md.

### 13.5 Enhancement sesi ini

- OG image `web/assets/og-image.png` (1200×630) — di-generate via Chrome
  headless screenshot.
- Per halaman: canonical + OpenGraph + twitter:card; JSON-LD Organization +
  WebSite di home; robots.txt dengan referensi sitemap.

### 13.6 Verifikasi sesi 2

| Item | Hasil |
|---|---|
| `dart analyze` | ✅ No issues |
| `dart test` | ✅ 4/4 |
| `./scripts/build.sh` | ✅ 64K, 4 route, sitemap, robots, ~15 dtk |
| Headless Chrome (4 route) | ✅ 0 console error, title/h1 benar |
| `jaspr serve` | ✅ 200 `/`, `/projects` |

### 13.7 Yang masih terbuka (dari sesi 1, tidak berubah)

Git init + commit awal, deploy Caddy apex (525), email hello@qouver.com,
container majadu-api (502), bio/foto About, deploy baru `build/jaspr/`.

---

## 14. SESI 2 (lanjutan, 2026-08-18) — Enterprise-grade hardening

Setelah migrasi, sesi lanjutan menetapkan standar (STANDARDS.md) dan menutup
gap P0/P1. **Verdict saat itu: BELUM enterprise grade** (bloker: git + CI).
Yang sudah ditutup:

| Gap | Solusi |
|---|---|
| CI | `.github/workflows/ci.yml` — format check → analyze → test → build; upload artifact `build/jaspr/` |
| 404 | `lib/pages/not_found_page.dart` + route `/404.html` (di-exclude dari sitemap via `--sitemap-exclude '404'`) |
| A11y | skip-link + `id="main"` (+ CSS `.skip-link`) |
| Security headers & cache | `deploy/Caddyfile.qouver.com` — HSTS, nosniff, frame-ancestors, CSP, cache policy aset, `handle_errors` 404 |
| Deploy | `scripts/deploy.sh` (rsync → `/srv/qouver/web` + `caddy reload`; `--dry-run` aman; env `QOUVER_VPS_HOST/USER/WEB_DIR`) |
| Testing | 12 test: smoke route + komponen (ProjectCard, QMark) + invariant data proyek |
| Konvensi | `.editorconfig`; `.gitignore` + `.DS_Store`; `prerender.yaml` sisa AngularDart dihapus |

**Belum beres (butuh keputusan user):**
1. **git init + commit awal** (P0) — `legacy/` backup sudah dihapus user; git
   sekarang satu-satunya jaring pengaman.
2. **Analytics** (P1) — pilihan: tanpa / Umami self-hosted (cocok VPS) /
   Plausible / GoatCounter. Implikasi: menambah script JS (melanggar zero-JS)
   atau pola tanpa JS.
3. **P2:** font preload, og-image.webp, uptime monitoring, LICENSE, llms.txt,
   semver/tag rilis.
4. **Caddyfile & deploy belum dijalankan** terhadap VPS (perlu akses SSH +
   persetujuan).

**Verifikasi sesi ini:** analyze 0 issue · format konsisten · `dart test`
12/12 pass · build 4 route + 404 + sitemap bersih · render Chrome OK.

---

## 15. SESI 3 (2026-08-18) — Eksekusi P2 (optimasi + ops + lisensi)

Menutup semua gap P2 dari STANDARDS.md. **Verdict STANDARDS sekarang: semua
P1 ✅; P2 selesai semua (satu 🟡 semver/tag menunggu git init).** Sisa bloker
"enterprise grade" tetap: git init + commit (P0, keputusan user) + verifikasi
Caddyfile/deploy di VPS.

### 15.1 Font self-hosted (preload + zero request eksternal)

**Masalah:** font diambil dari Google Fonts (`fonts.googleapis.com` +
`fonts.gstatic.com`) — request eksternal ketiga-party, plus preconnect.
**Solusi:** unduh subset **latin** woff2 (via UA Chrome, biar dapat URL woff2)
dari fonts.gstatic.com dan self-host:

```
web/fonts/ibm-plex-sans-var.woff2   40K  (variable font, weight 400–700)
web/fonts/ibm-plex-mono-400.woff2   10K
web/fonts/ibm-plex-mono-500.woff2   10K
web/fonts.css                       @font-face lokal (display=swap)
```

Perubahan:
- `web/fonts.css` — @font-face lokal; IBM Plex Sans dideklarasi sebagai
  **variable font** (`font-weight: 400 700`), Mono per-weight.
- `lib/main.server.dart` — head: preconnect Google Fonts **dihapus**, diganti
  `link rel=preload` untuk sans-var + mono-400 (font yang pasti dipakai), lalu
  `fonts.css` + `styles.css`. **Sumber kebenaran head adalah `main.server.dart`
  (bukan `web/index.html`) — gotcha lama yang baru terlihat di sesi ini.**
- `web/index.html` — sinkron (preload + fonts.css), meski file ini tidak
  dipakai di mode static (hanya template client).
- `deploy/Caddyfile.qouver.com` — CSP kini `'self'` penuh
  (`style-src 'self'; font-src 'self'`), whitelist Google Fonts **dihapus**;
  `@static` cache path ditambah `/fonts/*` + `/fonts.css` (long cache,
  immutable).

**Verifikasi:** output HTML 0 referensi `fonts.googleapis`/`fonts.gstatic`;
`fonts.css` + woff2 serve 200 dari output statis; total site 228K (font 60K
termasuk).

### 15.2 og-image.webp

- PNG 53K → **WebP 20K** (hemat 62%), via Chrome headless screenshot
  `--screenshot-format=webp` dari `/tmp/og.html` yang sama (desain identik).
- `lib/seo.dart`: `ogImageUrl` → `.../assets/og-image.webp`.
- `og-image.png` **dipertahankan** di `web/assets/` sebagai fallback (beberapa
  crawler lama masih prefer PNG — gampang di-balik satu baris kalau ada yang
  komplain).

### 15.3 Uptime monitoring — UptimeRobot

- Pilihan (Gravity Index): **UptimeRobot** — free tier 50 monitor, interval
  5 menit, alert email, cek SSL expiry; managed (nol beban di VPS).
  Alternatif Healthchecks.io lebih cocok untuk cron/job, bukan endpoint HTTP
  publik.
- Runbook lengkap: `infra/UPTIME_MONITORING.md` — langkah setup, monitor yang
  didaftarkan (`https://qouver.com`, `www`, `https://analytics.qouver.com`),
  respons insiden, dan snippet API untuk otomasi pembuatan monitor.
- **Belum didaftarkan akun** — butuh email user (5 menit, dashboard).

### 15.4 LICENSE

Keputusan user (2026-08-18): **MIT untuk kode + konten all-rights-reserved.**
- `LICENSE` — teks MIT standar + catatan bahwa konten situs (teks, desain,
  brand Qouver: q-mark, og-image) tetap All Rights Reserved.
- README mendapat seksi License yang sama ringkasnya.

### 15.5 llms.txt

- `web/llms.txt` — deskripsi situs + daftar halaman kunci + highlight teknis
  (zero-JS, SSG, SEO server-side), format `llms.txt` (tren discovery AI 2026).
- `scripts/build.sh` menyalinnya ke output (`build/jaspr/llms.txt`).

### 15.6 semver / VERSION

- `VERSION` = `1.0.0` di root; `scripts/build.sh` menyalinnya ke
  `build/jaspr/VERSION` (versi terdeploy selalu terlihat di server).
- **Tag rilis menunggu git init** — belum ada repo, jadi belum ada tag.
  Setelah git: tag `v1.0.0` + changelog (lihat STANDARDS.md §1).

### 15.7 File baru sesi ini

```
LICENSE                          MIT (kode) + konten all-rights-reserved
VERSION                          1.0.0 (di-stamp ke build)
web/fonts.css                    @font-face lokal
web/fonts/                       ibm-plex-{sans-var,mono-400,mono-500}.woff2
web/llms.txt                     deskripsi situs untuk AI crawler
infra/UPTIME_MONITORING.md       runbook UptimeRobot
```

File diubah: `lib/main.server.dart` (head fonts), `lib/seo.dart`
(og:image webp), `scripts/build.sh` (copy llms.txt + VERSION),
`deploy/Caddyfile.qouver.com` (CSP 'self' + cache fonts), `web/index.html`,
`README.md`, `STANDARDS.md`.

### 15.8 Verifikasi sesi 3

| Item | Hasil |
|---|---|
| `dart format` | ✅ 15 file, 0 changed |
| `dart analyze` | ✅ No issues |
| `dart test` | ✅ 12/12 |
| `./scripts/build.sh` (clean, tanpa cache build_runner) | ✅ 228K total: 4 route + 404 + sitemap + robots + llms.txt + VERSION + fonts + assets (og png+webp) |
| Output HTML | ✅ 0 referensi Google Fonts; preload 2 woff2; `og:image` → webp; fonts.css 200 |
| Headless Chrome (localhost) | ✅ fonts.css + woff2 200 |

### 15.9 Sisa & next steps (urutan rekomendasi)

1. **git init + commit awal** (P0) — sekarang satu-satunya bloker enterprise
   grade. Setelah push: CI aktif + tag `v1.0.0` (semver kelar).
2. **VPS deploy** — jalankan `scripts/deploy.sh` (rsync `build/jaspr/` →
   `/srv/qouver/web`), pasang `deploy/Caddyfile.qouver.com`, verifikasi header
   via `curl -I`, daftarkan UptimeRobot, deploy Umami (`infra/UMAMI_DEPLOY.md`).
3. **Opsional lanjutan (P2 berikutnya):** Lighthouse CI + budget performance,
   `og-image.avif`, halaman `blog/` atau `writing/`, favicon apple-touch-icon.

### 15.10 Runbook VPS setup lengkap (baru sesi ini)

Sebelumnya komponen deploy tersebar (`deploy.sh`, 2 Caddyfile, runbook Umami
+ UptimeRobot) tapi **belum ada alur dari nol**. Sekarang ada
`infra/VPS_SETUP.md` — runbook end-to-end: SSH + user → firewall → install
Caddy → DNS Cloudflare → `/srv/qouver/web` → gabung 2 site di satu Caddyfile
→ deploy pertama + verifikasi (header, sitemap, llms.txt, cache, 404) →
opsi Cloudflare Full strict (origin cert) → Umami → UptimeRobot → email
kontak, ditutup checklist 12 poin. README §Deployment kini menunjuk ke
runbook ini.

### 15.11 VPS_SETUP.md disesuaikan ke kondisi VPS nyata

Kondisi VPS (dikonfirmasi user): **Caddy sudah jalan (satu Caddyfile besar
di /etc/caddy/Caddyfile), Postgres sudah jalan di podman**. `infra/VPS_SETUP.md`
di-rewrite dari "setup dari nol" → **runbook existing-VPS**: skip provisioning,
fokus ke DNS → `/srv/qouver/web` → tambah 2 blok site ke Caddyfile existing
(validate + reload, JANGAN replace) → deploy pertama + verifikasi → Umami di
podman existing (DB di Postgres yang ada, container bind 127.0.0.1:3000) →
UptimeRobot → email. Checklist 11 poin. Catatan penting: blok site hidup di
repo DAN di Caddyfile VPS — jaga sinkron (jangan divergen).

---

## 16. SESI 4 (2026-09-03) — Konten: de-jargon + proof of work + katalog SDS

> Analisis konten (diminta user): positioning kuat ("home for systems and
> ideas"), gap = identitas manusia (bio/foto), proof of work tipis, dan jargon
> tech terkonsentrasi di deskripsi proyek. Sesi ini menutup jargon + proof.

### 16.1 Katalog proyek (`lib/data/projects.dart`) — diverifikasi ulang dari fakta

Fakta diverifikasi 2026-09-03 dari `~/Projects/*` (README repo + `SERVER_STATE.md`)
dan endpoint live. **Data lama basi** (verifikasi 2026-08-15):

| Proyek | Sebelum | Sesudah (fakta) |
|---|---|---|
| Skyward | stack `Flutter · Supabase / Postgres` | `Flutter · Go · Postgres` — `skyward-api` (Go) live di VPS (SERVER_STATE §4); skyward.qouver.com 200 |
| Majadu Tools | deskripsi "REST + optimistic concurrency + OpenAPI" | value-first: scheduling, live scoring, tournament, rating lintas season (fitur produksi nyata); framing backend-by-Qouver / community-frontend **dipertahankan** |
| M-DEF | status `Live`, url mdef.qouver.com | **`Archived`**, url dihapus — mdef.qouver.com **000 (mati)**; narasi: rating engine-nya dilanjutkan di Majadu |
| SDS Management | tidak ada | **baru (03, Live)** — sds.qouver.com 200; client (Bayer) sengaja TIDAK disebut di situs |

### 16.2 Copy & docs

- 3 deskripsi proyek ditulis ulang value-first (≤1 jargon/kalimat; stack label
  menampung detail teknis).
- `/projects` lead: "some live, some in the ground" → "some live and in
  production, some archived"; fallback link proyek archived = "Archived — no
  public link" (bukan "No public link yet").
- `README.md`: TAUG dihapus dari katalog; baris `/projects` diperbarui (4 proyek).
- **Repo `nferdazel` (terpisah):** link `github.com/nferdazel/mdef` (404) dihapus
  dari profile README — commit terpisah di repo itu.

### 16.3 Test & verifikasi

- `test/projects_data_test.dart`: indexes 01–04 (4 proyek).
- `test/smoke_test.dart`: + assert `SDS Management` di /projects.
- Verifikasi: `dart analyze` 0 issue · `dart test` 12/12 · `./scripts/build.sh` OK.

### 16.4 Masih terbuka

- Bio/foto About ("Photo coming soon") — user belum kasih konten.
- `seather` (CI/CD lab, open source) belum masuk katalog — keputusan user.
- Deploy `build/jaspr/` ke VPS belum dijalankan sesi ini (butuh SSH).
