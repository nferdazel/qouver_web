# qouver_web

The main website for **qouver.com** — the umbrella home for systems and ideas.

Built with [Jaspr](https://jaspr.site/) (Dart web framework) in **static mode**:
all routes are prerendered to pure static HTML at build time — no client-side
JavaScript at all. SEO (title, meta, canonical, OpenGraph, JSON-LD) is baked
into the static HTML server-side.

> 📄 **Handoff lengkap (status, keputusan, versi fragile, build/deploy, known
> issues):** baca [`HANDOFF.md`](HANDOFF.md).
> 📄 **Analisis + keputusan migrasi AngularDart → Jaspr:** baca [`MIGRATION.md`](MIGRATION.md).
> 📄 **Standar enterprise-grade + hasil audit:** baca [`STANDARDS.md`](STANDARDS.md).

## Pages

| Route             | Content                                                                   |
|-------------------|---------------------------------------------------------------------------|
| `/`               | Hero, philosophy strip, project index, recent writing, manifesto          |
| `/projects`       | Full catalogue + case studies (Skyward, Majadu Tools, SDS, M-DEF)         |
| `/journal`        | Technical essays, architecture post-mortems, and software craft notes     |
| `/journal/:slug`  | Full-page editorial article reader with code snippets and quotes          |
| `/about`          | Solo builder craft, engineering principles, production stack & infra      |
| `/contact`        | Email + GitHub links                                                      |

## Stack

- **Framework:** `jaspr` 0.23.x + `jaspr_router` 0.8.x (multi-page routing)
- **Rendering:** static mode — `jaspr build` prerenders every route server-side
- **Design:** IBM Plex Sans + IBM Plex Mono (self-hosted woff2, preloaded), Swiss Alabaster palette (`#F6F4EE`, `#131210`, `#A06428`)
- **Build:** `jaspr_cli` + `jaspr_builder` (build_runner) + dart2js
- **Deploy target:** static container (`qouver-web` on VPS behind Caddy proxy)

## Structure

```
web/                     # static assets (styles.css, fonts.css, fonts/, robots.txt, llms.txt, assets/)
lib/
  main.server.dart       # server entrypoint — renders the full document + routes
  app.dart               # shell: header, nav, router, footer (+ skip-link, 404)
  seo.dart               # per-page head helper (title, meta, OG, canonical, twitter)
  components/            # q_mark, project_card
  pages/                 # home, projects, journal, journal_detail, about, contact, not_found
  data/
    projects.dart        # project catalogue & case study data
    journal.dart         # technical essays & article catalogue
test/                    # server-render smoke + component + data invariant tests
test/smoke_test.dart     # all 13 static routes, SEO titles, nav state
scripts/build.sh         # release + static generation
deploy/Caddyfile.qouver.com  # production Caddy config (TLS, headers, cache, 404)
.github/workflows/ci.yml # CI: format → analyze → test → build
```

> No `main.client.dart`: the site is 100% static (zero `@client` components),
> so there is intentionally no client bundle. Adding interactivity later means
> re-adding a client entrypoint — see `MIGRATION.md` §13.

## Develop

```bash
dart pub get
dart run jaspr_cli:jaspr serve     # dev server with hot reload
```

> **Note:** `jaspr build`/`serve` verify that `which dart` points into a real
> Dart SDK. `scripts/build.sh` resolves the real SDK (`flutter/bin/cache/dart-sdk/bin/dart`) automatically.

## Build (static output)

```bash
./scripts/build.sh
# → build/jaspr/  (deployable: index.html, /projects/, /journal/, /about/, /contact/,
#                  sitemap.xml, robots.txt, styles.css, assets/)
```

The build renders all 13 routes in-process (no headless browser), generates
`sitemap.xml` from the route list, copies `robots.txt`/`llms.txt`/`VERSION`
into the output, and strips dev residue (`packages/`, `.dart_tool/`).

Fonts are self-hosted (`web/fonts/*.woff2`, latin subset, IBM Plex) — no
request to Google Fonts at runtime; preloaded in `<head>` for fast first paint.

## Uptime monitoring

Runbook: `infra/UPTIME_MONITORING.md` — UptimeRobot free tier (monitor
`https://qouver.com` + `https://analytics.qouver.com`, email alerts, SSL
expiry checks).

## Test

```bash
dart test
```

## Analytics

Umami (self-hosted, privacy-friendly) — di-inject saat build lewat env var,
**default tetap zero-JS**:

```bash
UMAMI_SCRIPT_URL="https://analytics.qouver.com/script.js" \
UMAMI_WEBSITE_ID="<id>" ./scripts/build.sh
```

## CI

GitHub Actions (`.github/workflows/ci.yml`) runs format check, `dart analyze`,
`dart test`, and `./scripts/build.sh` on every push/PR, and uploads
`build/jaspr/` as an artifact.

## Deployment

> **Arsitektur saat ini (2026-09):** qouver.com dilayani **container `qouver-web`**
> (Caddy proxy host → `127.0.0.1:3002`). Deploy otomatis via GitHub Actions
> (`.github/workflows/build.yml`) → GHCR → `podman pull` + restart unit quadlet
> (`deploy/qouver-web.container`). Konfig host ada di `deploy/Caddyfile.qouver.com`.

## Versioning

`VERSION` (semver, saat ini `1.0.0`) di-stamp ke output build (`build/jaspr/VERSION`).

## License

- **Kode:** MIT — lihat `LICENSE`.
- **Konten situs** (teks, desain, brand Qouver termasuk q-mark & og-image):
  All Rights Reserved.

## Identity

- **Logo:** Optically balanced geometric Q-monogram — a ring holding a central bronze focal dot (`accentDot: true`), its continuous arc tail tracing the prospector's sweep.
- **Palette:** Swiss Alabaster paper `#F6F4EE`, Obsidian Ink `#131210`, Prospector Bronze `#A06428`.
- **Type:** IBM Plex Sans (UI & body) + IBM Plex Mono (labels & code).
