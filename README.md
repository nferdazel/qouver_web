<div align="center">

# Qouver Web

**The official website for [qouver.com](https://qouver.com), an umbrella home for systems and ideas.**

[![Build & Publish](https://github.com/nferdazel/qouver_web/actions/workflows/build.yml/badge.svg)](https://github.com/nferdazel/qouver_web/actions/workflows/build.yml)
[![Built with Jaspr](https://img.shields.io/badge/Built%20with-Jaspr%20Static-B23A1A?style=flat&logo=dart)](https://jaspr.site)
[![Zero-JS](https://img.shields.io/badge/Runtime-Zero--JS%20Static-141311?style=flat)](https://qouver.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

---

## Overview

`qouver_web` is the static-first presentation layer for **Qouver**. It is built with [Jaspr](https://jaspr.site/) (Dart web framework) in static pre-rendering mode, so every route is emitted as self-contained HTML at build time with no client-side JavaScript bundle.

SEO metadata ships in the same pass: titles, meta descriptions, canonical URLs, Open Graph cards, Twitter cards, and JSON-LD schemas are all pre-rendered into the static document.

The source tree is organized around four layers: `pages/` (route views), `components/` (reusable UI), `data/` (projects and journal content), and `seo.dart` (head/metadata helper). Content changes stay in `data/`, not in markup.

Quality standards and audit history live in [`STANDARDS.md`](STANDARDS.md).

---

## Site Architecture & Routes

| Route | Description |
| :--- | :--- |
| `/` | Hero, the three-pillar approach strip, production systems catalogue, and operational manifesto |
| `/projects` | Full systems catalogue (Skyward, Majadu Tools, SDS Management, M-DEF) |
| `/projects/:slug` | Technical case study reader: architecture decisions, trade-offs, takeaways |
| `/journal` | Editorial index of technical essays and architecture notes |
| `/journal/:slug` | Full-page article reader with code snippets and blockquotes |
| `/about` | Solo builder craft, engineering principles, production stack, Linux VPS infra |
| `/contact` | Direct maintainer email and GitHub links |

---

## Stack & Infrastructure

- **Framework:** `jaspr` 0.23.x with `jaspr_router` 0.8.x (static multi-page routing)
- **Rendering:** static mode; `jaspr build` pre-renders all 13 routes, plus `sitemap.xml`, `robots.txt`, and `llms.txt`
- **Typography:** self-hosted Fraunces (display) and Archivo (structure, body, labels) variable fonts, latin subset; no third-party font requests
- **Design system:** "Workshop Broadsheet": bone paper (`#EDEAE3`), ink (`#141311`), oxide accent (`#B23A1A`); square corners, hard rules, hover-only motion
- **Deployment:** containerized `qouver-web` (Podman) on a Linux VPS behind a Caddy TLS reverse proxy
- **CI/CD:** GitHub Actions runs format, analyze, and test, builds the static site, pushes an image to GHCR, then deploys to the VPS

---

## Repository Structure

```text
web/                     # Static assets (styles.css, fonts.css, fonts/, robots.txt, llms.txt, q-mark.svg, assets/icons)
lib/
  main.server.dart       # Server entrypoint: static document and route configuration
  app.dart               # Shell component: header, nav, router, footer, skip-link, 404
  seo.dart               # Per-page head helper (title, meta, OG, canonical)
  site.dart              # Site-wide identity and contact constants
  routes.dart            # Route paths (single source of truth for internal links)
  components/            # UI components (q_mark, project_card, project_status_badge)
  pages/                 # Page views (home, projects, journal, journal_detail, about, contact, 404)
  data/
    projects.dart        # Production systems and technical case study data
    journal.dart         # Technical articles and essay data
test/                    # 23 tests: route smoke, components, data invariants, route paths
scripts/build.sh         # Release build and static site generation
scripts/gen-icons.sh     # Rasterises the app icons from q-mark.svg (dev-only, needs Chrome)
deploy/                  # Caddyfile and Podman container specs
.github/workflows/       # GitHub Actions CI/CD
```

---

## Development & Build

### Development server

```bash
dart pub get
dart run jaspr_cli:jaspr serve
```

### Static production build

```bash
./scripts/build.sh
# Output: build/jaspr/ (HTML routes, sitemap.xml, robots.txt, styles.css)
```

The build compiles all 13 routes in-process with no headless-browser dependency, generates the sitemap, copies static assets, and cleans dev artifacts.

### Testing and analysis

```bash
dart analyze   # static analysis
dart test      # unit and component smoke tests
```

### Regenerating the app icons

`web/assets/icons/*.png` are rasterised from `web/assets/q-mark.svg`, so the tab icon, the install prompt, and the logo in the header always show the same mark:

```bash
./scripts/gen-icons.sh
```

This is a dev-only tool. It drives headless Google Chrome (override the binary with `CHROME=/path/to/chrome`), writes `icon-192.png`, `icon-512.png`, `apple-touch-icon.png`, and `maskable-512.png`, and is never invoked by `scripts/build.sh`, which has no browser dependency.

---

## Privacy-Friendly Analytics (Optional)

Analytics uses self-hosted [Umami](https://umami.is/). The site ships with zero JavaScript by default, and tracking is injected only when explicitly enabled at build time:

```bash
UMAMI_SCRIPT_URL="https://analytics.qouver.com/script.js" \
UMAMI_WEBSITE_ID="<your-website-id>" \
./scripts/build.sh
```

The `Content-Security-Policy` shipped in `deploy/` already allows `analytics.qouver.com` in `script-src` and `connect-src`, so enabling the snippet needs no CSP edit; when analytics is not enabled the allowance is inert. Note that the host edge in `deploy/Caddyfile.qouver.com` and the container edge in `deploy/Caddyfile.qouver-web.docker` both set the security headers. They must stay identical, because a browser enforces the intersection of duplicate headers, so the stricter copy wins silently. Prefer dropping one set: the host edge is the natural owner, since it already terminates TLS and sets caching.

---

## Brand & Identity

- **Logo:** geometric Q-monogram, a ring holding a single oxide focal dot (`accentDot: true`), with an arc tail tracing the prospector's sweep.
- **Palette:** bone paper (`#EDEAE3`), ink (`#141311`), oxide accent (`#B23A1A`).
- **Typography:** Fraunces for display, Archivo for structure and body, self-hosted as variable `.woff2` (latin subset).
- **Design language:** "Workshop Broadsheet", an industrial spec sheet with an editorial voice: hard 2px rules, square corners, oversized index numerals, and full-bleed ink sections.
- **Icon set:** every surface (browser tab, bookmark, install prompt, home screen) renders the same mark. `web/assets/q-mark.svg` is the source of truth; the raster icons in `web/assets/icons/` are generated from it, not drawn separately, so they cannot drift out of sync.

---

## License

- **Code:** MIT. See [`LICENSE`](LICENSE).
- **Content and brand assets:** all rights reserved (text, design, Qouver brand, q-mark logo).
