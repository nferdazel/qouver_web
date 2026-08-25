# MIGRATION — qouver_web: AngularDart → Jaspr

> **Dibuat:** 2026-08-18 (sesi migrasi)
> **Status:** ✅ **TEREKSEKUSI** — migrasi selesai & terverifikasi sesi yang sama.
> Dokumen ini adalah *source of truth* untuk keputusan arsitektur, pemetaan
> file, hasil eksekusi (§14), dan roadmap ke custom CMS.
> **Belum di-commit** (per instruksi user — folder bahkan belum `git init`).

---

## 1. Ringkasan eksekutif

qouver_web adalah situs statis 4 halaman (Home, Projects, About, Contact) yang
saat ini dibangun dengan **AngularDart (revival komunitas)** + `angulardart_prerender`
untuk menghasilkan HTML statis. Rencana: **migrasi penuh ke Jaspr** (framework web
Dart modern: SPA/SSR/SSG, partial hydration), sambil **mempertahankan 100% desain**
(styles.css, q-mark.svg, copy) dan membuka jalur ke **custom CMS** nanti.

**Mengapa layak:** situs ini kecil & statis, tapi stack AngularDart-nya rapuh
(versi fragile, prerender butuh headless Chrome, hack re-inject script). Jaspr
menghapus semua itu, menghasilkan HTML statis yang lebih murni (SEO-native,
tanpa JS berat), dan mendukung SSG **dan** SSR dengan kode komponen yang sama —
sehingga pilihan "CMS sebagai sumber build-time vs backend runtime" tidak
terkunci sampai CMS-nya ada.

**Estimasi effort:** port mekanis ~6 file komponen (shell + 2 komponen + 4 halaman),
swap pipeline build. Satu sesi fokus.

---

## 2. Kondisi sekarang & alasan migrasi

### 2.1 Stack saat ini (terverifikasi dari repo, 2026-08-15)

| Komponen | Detail |
|---|---|
| Framework | `angulardart` 9.4.1, `angulardart_router` 5.4.0, `angulardart_seo` 1.5.0 |
| Build | `build_runner` + `build_web_compilers` (dart2js `-O4`) |
| Prerender | `angulardart_prerender` 1.3.0 (headless Chrome, `render_delay_ms: 10000`) |
| Output | `build/web/` — HTML per route + `sitemap.xml` + `robots.txt`, lalu re-inject `<script>` via Python |
| Dart SDK | 3.13.0 |
| Deploy target | Caddy di VPS qouver.com (apex), atau static host apa pun |

### 2.2 Risiko & biaya tersembunyi (dari HANDOFF.md)

1. **Versi fragile.** Harus `angulardart >= 9.4.1` + `angulardart_router >= 5.4.0`;
   di bawah itu crash di runtime dart2js (2 bug diverifikasi: `DomHTMLStyleElement`
   cast + `web.Element` DI). Lock file "jangan pernah dihapus", tiap upgrade berisiko.
2. **Prerender lambat & butuh browser.** Headless Chrome + 10 dtk/route → ~40 dtk build.
3. **Hack re-inject script.** Tool prerender sengaja membuang `<script>`; `scripts/build.sh`
   mengembalikannya dengan Python. Fragile dan tidak jelas.
4. **SPA hydration 356K.** `main.dart.js` di-hydrate penuh padahal situs hampir tanpa interaksi.

### 2.3 Kenapa Jaspr (bukan framework lain, bukan tetap AngularDart)

- **Ekosistem Dart murni** — satu SDK, satu toolchain (`dart analyze`, `dart test`,
  `dart format`). Tidak ada Node/Python di pipeline.
- **Sinyal produksi terkuat di ekosistem Dart web:** April 2026 tim Flutter resmi
  membangun ulang **dart.dev, flutter.dev, docs.flutter.dev** dengan Jaspr
  (blog resmi Flutter: *"We rebuilt Flutter's websites with Dart and Jaspr"*).
- **SSG native, tanpa headless Chrome:** `jaspr build` me-render semua route di
  proses Dart → HTML statis + `sitemap.xml` otomatis (`--sitemap-domain`).
- **Partial hydration:** halaman statis murni; JS client hanya untuk komponen
  `@client` yang butuh interaksi. Untuk situs ini: nyaris **nol JS**.
- **SSG sekarang, SSR nanti, kode sama.** Ini kunci untuk roadmap custom CMS.
- Menghapus seluruh kelas risiko §2.2.

---

## 3. Kondisi Jaspr saat ini (terverifikasi 2026-08-18)

| Paket | Versi (Agustus 2026) | Catatan |
|---|---|---|
| `jaspr` | 0.23.x | Core framework |
| `jaspr_router` | 0.8.3 | Adaptasi go_router: `Router`, `Route`, `ShellRoute`, `Link`, `RouteState` |
| `jaspr_cli` | 0.23.x (dev dep) | `jaspr build`, `jaspr serve`, `jaspr create`, `jaspr migrate` |
| `jaspr_lints` | — | Lint + analyzer plugin, jalan via `dart analyze` |
| `jaspr_test` | — | Testing |
| `jaspr_content` | — | Plugin konten-driven (Markdown/blog/docs) — dipakai Flutter team |

**Kemampuan kunci yang dipakai migrasi ini:**
- **Static-Site Generation:** `jaspr build` → `index.html`, `about/index.html`, dst.
  Route dinamis didukung dengan `for (var post in posts) Route(path: '/posts/${post.id}')`.
- **Sitemap otomatis:** `jaspr build --sitemap-domain https://qouver.com` → `sitemap.xml`
  (+ `RouteSettings(changeFreq:, priority:)` per route).
- **SEO per halaman:** `Document.head(title:, meta: {...})` dari mana pun di tree
  komponen; default global via komponen `Document` di root.
- **Multi-page routing:** `Router` yang hanya di-render di server → tiap navigasi
  = real page load (cocok untuk situs tradisional seperti ini). Nav pakai `Link`
  (pengganti `<a>`). Ini artinya **tidak perlu JS client sama sekali** untuk navigasi.
- **Partial hydration:** komponen `@client` → chunk JS terpisah otomatis.

---

## 4. Pemetaan file per file

### 4.1 Dipakai ulang tanpa perubahan

| File | Alasan |
|---|---|
| `web/styles.css` | Plain CSS — seluruh design system. Utuh. |
| `web/assets/q-mark.svg` | Aset statis (monogram Q, favicon). Utuh. |
| `lib/data/projects.dart` | Pure Dart model + `const` list. **Nol perubahan.** Ini juga seam pertama ke CMS nanti. |

### 4.2 Ditulis ulang (mekanis)

| File lama | File baru | Catatan |
|---|---|---|
| `web/main.dart` (bootstrap Angular + injector) | `web/main.dart` (jaspr `runApp`) | Entrypoint sederhana |
| `lib/app_component.dart` (shell + RouteDefinition) | `lib/app.dart` | `App` → `ShellRoute` (header/nav/footer) + `Router` |
| `lib/components/q_mark.dart` | `lib/components/q_mark.dart` | `StatelessComponent`, param `size` |
| `lib/components/project_card.dart` | `lib/components/project_card.dart` | `StatelessComponent`, input `project` |
| `lib/pages/home_page.dart` | `lib/pages/home_page.dart` | + `Document.head()` |
| `lib/pages/projects_page.dart` | `lib/pages/projects_page.dart` | + `Document.head()` |
| `lib/pages/about_page.dart` | `lib/pages/about_page.dart` | + `Document.head()` |
| `lib/pages/contact_page.dart` | `lib/pages/contact_page.dart` | + `Document.head()` |
| `web/index.html` | `web/index.html` | Shell document: fonts, favicon, CSS; konten di-render jaspr |
| `pubspec.yaml` | `pubspec.yaml` | Ganti dependency (lihat §4.3) |

### 4.3 Dependency `pubspec.yaml`

```yaml
environment:
  sdk: '>=3.10.0 <4.0.0'

dependencies:
  jaspr: ^0.23.0
  jaspr_router: ^0.8.0

dev_dependencies:
  jaspr_cli: ^0.23.0
  jaspr_lints: ^0.2.0
  jaspr_test: ^0.6.0
  test: ^1.25.0
  lints: ^6.0.0
```

**Dihapus:** `angulardart`, `angulardart_router`, `angulardart_seo`,
`build_runner`, `build_web_compilers`, `angulardart_test`, `angulardart_prerender`.

> SDK constraint naik ke `>=3.10.0` karena Jaspr memakai fitur Dart 3.10
> (dot shorthands, analyzer plugin). SDK lokal 3.13.0 — aman.

### 4.4 Dihapus / diarsipkan

| File | Nasib |
|---|---|
| `build.yaml` | Dihapus (tidak dipakai lagi; build_runner tidak ada) |
| `prerender.yaml` | Dihapus (diganti argumen `jaspr build`) |
| `scripts/build.sh` | Ditulis ulang: `jaspr build` + rakit output |
| `build/` (output lama AngularDart) | Diarsipkan → `legacy/build-angular/` |
| `pubspec.lock` lama | Diarsipkan (referensi versi fragile) |
| `lib/app_component.dart`, template file `.template.dart` | Diarsipkan → `legacy/` |

> **Rollback plan:** sebelum menimpa apa pun, seluruh file khusus AngularDart
> (pubspec, build.yaml, prerender.yaml, scripts, app_component, web/main.dart,
> build output) disalin ke `legacy/` di dalam repo. Karena belum ada git, ini
> satu-satunya jaring pengaman. Setelah `git init` + commit awal, `legacy/`
> boleh dihapus.

---

## 5. Pemetaan konsep AngularDart → Jaspr

| AngularDart | Jaspr | Contoh |
|---|---|---|
| `@Component(selector, template, directives, providers)` | `class X extends StatelessComponent` + `build(BuildContext)` | `class HomePage extends StatelessComponent` |
| Template string `{{ expr }}` | `Component.text()` / `.text()` | `h1([.text('Hello')])` |
| `*ngFor` | Dart collection-for | `[for (final p in projects) ProjectCard(project: p)]` |
| `*ngIf` / `ngIf else` | Dart collection-if / ternary | `[if (p.url != null) a(href: p.url, [...])]` |
| `[routerLink]`, `router-outlet`, `RouteDefinition` | `Link`, `Router(routes:)`, `Route(path:, builder:)`, `ShellRoute` | `Link(href: '/projects', [...] )` |
| `[class.x]` binding | `classes:` string | `div(classes: 'nav__link${active ? ' nav__link--active' : ''}')` |
| `[href]`, `[attr.*]`, event binding | `href:`, `attributes:`, `events:` | `a(href: url, target: '_blank')` |
| `@Input()` | constructor param | `ProjectCard({required this.project})` |
| `SeoService`/`TitleService` + prerender tool | `Document.head(title:, meta:)` (SSR ke HTML statis) | lihat §6 |
| `angulardart_prerender` + re-inject script | `jaspr build` (native, auto-inject client script) | lihat §7 |

**Aturan penting Jaspr yang dipakai:**
- Komponen tanpa `@client` = **server-only** (di-render saat build). Semua komponen
  situs ini server-only → output 100% HTML, tidak ada JS.
- Navigasi antar halaman: **multi-page routing** (real page load via `Link`).
  `Router.of(context).push()` TIDAK tersedia di mode ini (server-only router).
- Conditional/loop: pakai sintaks collection Dart biasa (`if`, `for`) — bukan helper.

---

## 6. Strategi SEO

**Sebelum (AngularDart):** `SeoService.setPageSeo()` per halaman → di-capture headless
Chrome saat prerender → tool membuang `<script>` → build.sh re-inject.

**Sesudah (Jaspr):** tiap halaman mengembalikan

```dart
return fragment([
  Document.head(
    title: 'Projects — Qouver',
    meta: {'description': 'The systems under the Qouver umbrella: ...'},
  ),
  div(classes: 'page-head container', [...konten...]),
]);
```

- Title + meta description **langsung ada di HTML statis** hasil `jaspr build`.
- Default global (lang, viewport, meta dasar, favicon, font) di `web/index.html` + komponen `Document` di root.
- Sitemap: `jaspr build --sitemap-domain https://qouver.com` → `sitemap.xml` otomatis.
- Robots.txt: file statis `web/robots.txt` (tidak di-generate otomatis).
- **Enhancement (sesi ini, user mengizinkan):** `og:title`, `og:description`,
  `og:image` (perlu file OG image — generate SVG/PNG sederhana), `twitter:card`,
  canonical per halaman, JSON-LD `Organization`/`WebSite` di root.

---

## 7. Pipeline build — sebelum vs sesudah

### Sebelum (`scripts/build.sh`, ~40 dtk, butuh Chrome)

1. `dart run build_runner build --release` → dart2js `-O4` → `main.dart.js`
2. Rakit `build/web/` (index.html, styles.css, q-mark.svg, main.dart.js)
3. `angulardart_prerender` (headless Chrome, 10 dtk/route) → HTML per route + sitemap + robots
4. Python re-inject `<script defer src="main.dart.js">`

### Sesudah (baru)

```bash
dart pub get
dart run jaspr_cli:jaspr build --sitemap-domain https://qouver.com
# → build/jaspr/ (atau output config): index.html, projects/index.html,
#   about/index.html, contact/index.html, sitemap.xml, + client script auto-inject
cp web/robots.txt build/...
```

- Render di proses Dart — **tanpa browser, jauh lebih cepat**.
- Client bootstrap di-inject otomatis oleh CLI (hanya untuk komponen `@client`).
- Sitemap otomatis; robots statis.

### `scripts/build.sh` baru

1. `dart run jaspr_cli:jaspr build --sitemap-domain https://qouver.com`
2. Salin aset statis (`styles.css`, `q-mark.svg`, `robots.txt`) ke output
3. Verifikasi struktur output (4 route + sitemap + robots)

---

## 8. Jalur menuju custom CMS (roadmap)

CMS belum ada. Migrasi ke Jaspr **tidak mengunci pilihan**; dua jalur sama-sama
didukung dengan kode komponen yang identik:

| | Jalur A — CMS build-time (SSG) | Jalur B — CMS runtime (SSR) |
|---|---|---|
| Cara kerja | CMS tulis konten (JSON/Markdown/DB) → saat `jaspr build`, fetch & generate route statis: `for (var post in posts) Route(path: '/posts/${post.id}', ...)` | `jaspr serve` di VPS; halaman di-render per request dari API CMS |
| Deploy | Static host / Caddy biasa | Caddy reverse-proxy ke proses Dart |
| Cocok untuk | Blog, katalog, halaman marketing — konten jarang berubah | Konten realtime, preview/draft, per-user |
| Stack CMS | Bebas (Go cocok dengan infra existing: `majadu-api`) | Bebas; atau fullstack Dart (`jaspr_serverpod`) |

**Seam pertama yang sudah siap:** `lib/data/projects.dart` (const list) → ganti
jadi fetch dari CMS. Bentuk datanya (`Project`) sudah stabil dan akan dipertahankan
sebagai kontrak API.

**Rekomendasi:** mulai Jalur A (SSG + CMS Go/JSON). Jika nanti butuh draft/realtime,
pindah Jalur B tanpa menulis ulang komponen.

---

## 9. Rencana enhancement (sesi ini)

1. **SEO/OG:** og:title/description/image, twitter:card, canonical per halaman,
   JSON-LD Organization. *(belum ada di versi AngularDart — HANDOFF item #7)*
2. **robots.txt** statis.
3. **Meta description** disempurnakan per halaman.
4. **Copy polish ringan** di halaman About (bio) & meta — tanpa mengubah identitas/keputusan
   sesi sebelumnya (bahasa English, positioning umbrella, framing Majadu backend-only).
5. **Nav active state** yang benar per halaman (di versi Angular pakai JS; di Jaspr
   di-render server-side via `ShellRoute` state).
6. Struktur output & dokumentasi (README/HANDOFF update).

---

## 10. Risiko & mitigasi

| Risiko | Mitigasi |
|---|---|
| API Jaspr berubah antar versi (0.x) | Pin versi di pubspec; verifikasi `dart analyze` + build tiap fase; catat versi terverifikasi di HANDOFF |
| Output HTML berbeda dari ekspektasi Caddy (`/projects/` dll) | Fase verifikasi: bandingkan struktur `build/` dengan output lama |
| Copy/desain berubah tak sengaja | styles.css & q-mark.svg dipakai ulang tanpa edit; copy di-port verbatim dulu, enhancement terpisah & tercatat |
| Tidak bisa rollback (belum ada git) | Backup `legacy/` sebelum menimpa; instruksi rollback §11 |
| Docsite `docs.jaspr.site` kadang cert/akses bermasalah | Fallback: source di GitHub repo `schultek/jaspr`, `docs.page/schultek/jaspr~727/...`, pub.dev |

---

## 11. Rollback plan

Seluruh artefak AngularDart disalin ke `legacy/`:

```
legacy/
  pubspec.yaml + pubspec.lock        # versi fragile yang terbukti jalan
  build.yaml, prerender.yaml
  scripts/build.sh
  web/main.dart (Angular bootstrap)
  lib/app_component.dart
  lib/**/*.template.dart             # hasil codegen (kalau ada)
  build-angular/                     # output build/web lama (356K)
```

Untuk kembali: `cp legacy/*` balik, `dart pub get`, `./legacy/scripts/build.sh`.
Setelah repo di-`git init` + commit, `legacy/` bisa dihapus.

---

## 12. Rencana fase + checklist verifikasi

| Fase | Isi | Verifikasi keluar fase |
|---|---|---|
| 1 | Backup legacy + swap pubspec + `dart pub get` | `dart pub get` bersih; `dart analyze` tidak error karena import lama |
| 2 | Port `data/projects.dart` (nol), `q_mark`, `project_card` | analyze bersih; build sementara |
| 3 | Port 4 halaman + `Document.head()` per halaman | analyze bersih; copy == versi lama |
| 4 | Shell (`App` + `ShellRoute` + header/nav/footer) + `web/main.dart` + router | `jaspr build` sukses; 4 route ter-generate |
| 5 | Pipeline: `scripts/build.sh` baru, sitemap, robots, verifikasi output vs lama | Struktur build setara/lebih baik; sitemap berisi 4 URL |
| 6 | Enhancement: OG/JSON-LD/canonical, meta polish, copy ringan | analyze + build + cek HTML punya head lengkap |
| 7 | Audit akhir: bandingkan rendering (headless Chrome), update README/HANDOFF | 0 console error; konten lengkap; docs update |

**Loop kerja (sesuai instruksi user):** jalankan fase → audit/analisis/review →
fix → update tasklist → fase berikutnya.

---

## 13. Catatan teknis yang harus diverifikasi saat implementasi

- `RouteState` punya field untuk path/uri? (dipakai `ShellRoute` untuk nav active).
  Cek source di pub-cache setelah `pub get`.
- API `Document.head()`: apakah mendukung child components (untuk link canonical /
  og:property yang bukan name-meta)? Kalau tidak, fallback: taruh OG di
  `web/index.html` global + tag khusus lewat `attributes`/raw head.
- Struktur output `jaspr build`: path route & penamaan file (perlu cek setelah
  build pertama).
- Mode static: apakah `web/index.html` tetap dipakai sebagai shell document
  (fonts/favicon/CSS link) — ya, dan konten di-render ke dalamnya.

---

## 14. Hasil eksekusi (terverifikasi 2026-08-18)

### 14.1 Status akhir

| Item | Hasil |
|---|---|
| `dart analyze` | ✅ No issues |
| `dart test` (smoke) | ✅ 4/4 — semua route, title SEO per route, nav active, katalog proyek |
| `scripts/build.sh` | ✅ 4 route + sitemap + robots + assets, ~15 dtk (dulu ~40 dtk + headless Chrome) |
| Render headless Chrome | ✅ Semua route, 0 console error |
| `jaspr serve` (dev) | ✅ 200 untuk `/` dan `/projects` |
| Output | **64K** (dulu 356K) — **zero JavaScript** |

### 14.2 Keputusan yang menyimpang dari rencana awal

1. **`lib/main.client.dart` TIDAK dibuat.** Situs 100% statis tanpa komponen
   `@client`, jadi client bundle tidak diperlukan. Memiliki `main.client.dart`
   justru membuat server meng-inject `<script src="main.client.dart.js">` ke
   HTML padahal file-nya tidak pernah ter-compile (quirk build target `web` di
   build_daemon — generated entrypoint masuk target `$default`, bukan `web`)
   → 404 di browser. Menghapusnya = situs murni tanpa JS. **Jika nanti butuh
   interaktivitas:** tambahkan kembali `lib/main.client.dart` dan verifikasi
   compile client-nya (kemungkinan butuh `build.yaml`/versi paket yang pas).
2. **Perlu deteksi SDK di `scripts/build.sh`.** `which dart` di mesin ini
   menunjuk ke shim Flutter (`/opt/homebrew/bin/dart`) yang gagal diverifikasi
   jaspr_cli sebagai SDK. `build.sh` me-resolve SDK asli
   (`<flutter>/bin/cache/dart-sdk/bin/dart`) dan menaruhnya di `PATH`.
3. **`jaspr_lints` di-skip** — versinya butuh SDK dengan `_macros` yang belum
   ada di Dart 3.13.0 lokal. `lints` standar tetap dipakai.

### 14.3 Versi terverifikasi (lock file, 2026-08-18)

| Paket | Versi |
|---|---|
| `jaspr` | 0.23.4 |
| `jaspr_router` | 0.8.3 |
| `jaspr_cli` | 0.23.4 |
| `jaspr_builder` | 0.23.4 |
| `jaspr_test` | 0.23.4 |
| `build_web_compilers` | 4.8.9 |
| Dart SDK | 3.13.0 (via Flutter 3.44.2 cache) |

### 14.4 Enhancement yang dikerjakan (user mengizinkan)

- **OG image** `web/assets/og-image.png` (1200×630, palet paper/ink/bronze,
  monogram Q) — di-generate via headless Chrome screenshot, bukan PIL.
- **Per-halaman head:** canonical, og:type/site_name/title/description/url/image,
  twitter:card/title/description/image (helper `lib/seo.dart`).
- **JSON-LD** di home: `Organization` + `WebSite` (schema.org).
- **robots.txt** statis dengan referensi sitemap.
- Copy situs dipertahankan verbatim (keputusan identitas sesi sebelumnya).
  Satu-satunya perubahan copy: footer "Built with AngularDart" → "Built with Jaspr".

### 14.5 Rollback

Seluruh artefak AngularDart ada di `legacy/` (§11). Belum ada git — setelah
`git init` + commit awal, `legacy/` boleh dihapus.
