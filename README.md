<div align="center">

# Qouver Web

**The official website for [qouver.com](https://qouver.com), an umbrella home for systems and ideas.**

[![Build & Publish](https://github.com/nferdazel/qouver_web/actions/workflows/build.yml/badge.svg)](https://github.com/nferdazel/qouver_web/actions/workflows/build.yml)
[![Built with Jaspr](https://img.shields.io/badge/Built%20with-Jaspr%20Static-A06428?style=flat&logo=dart)](https://jaspr.site)
[![Zero-JS](https://img.shields.io/badge/Runtime-Zero--JS%20Static-141413?style=flat)](https://qouver.com)
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
- **Typography:** self-hosted IBM Plex Sans (UI and body) and IBM Plex Mono (metadata and code), zero external font requests
- **Design system:** Warm Alabaster paper (`#FAF9F5`), Obsidian Charcoal (`#141413`), Prospector Bronze accent (`#A06428`)
- **Deployment:** containerized `qouver-web` (Podman) on a Linux VPS behind a Caddy TLS reverse proxy
- **CI/CD:** GitHub Actions runs format, analyze, and test, builds the static site, pushes an image to GHCR, then deploys to the VPS

---

## Repository Structure

```text
web/                     # Static assets (styles.css, fonts.css, fonts/, robots.txt, llms.txt, q-mark.svg)
lib/
  main.server.dart       # Server entrypoint: static document and route configuration
  app.dart               # Shell component: header, nav, router, footer, skip-link, 404
  seo.dart               # Per-page head helper (title, meta, OG, canonical, JSON-LD)
  components/            # UI components (q_mark, project_card)
  pages/                 # Page views (home, projects, journal, journal_detail, about, contact, 404)
  data/
    projects.dart        # Production systems and technical case study data
    journal.dart         # Technical articles and essay data
test/                    # Server-render smoke and component invariant tests
scripts/build.sh         # Release build and static site generation
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

---

## Privacy-Friendly Analytics (Optional)

Analytics uses self-hosted [Umami](https://umami.is/). The site ships with zero JavaScript by default, and tracking is injected only when explicitly enabled at build time:

```bash
UMAMI_SCRIPT_URL="https://analytics.qouver.com/script.js" \
UMAMI_WEBSITE_ID="<your-website-id>" \
./scripts/build.sh
```

If analytics is enabled, the Caddy `Content-Security-Policy` must allow the analytics origin in `script-src` and `connect-src`.

---

## Brand & Identity

- **Logo:** optically balanced geometric Q-monogram, a ring holding a central Prospector Bronze focal dot (`accentDot: true`), with an arc tail tracing the prospector's sweep.
- **Palette:** Warm Alabaster (`#FAF9F5`), Obsidian Charcoal (`#141413`), Prospector Bronze (`#A06428`).
- **Typography:** IBM Plex Sans and IBM Plex Mono, self-hosted as `.woff2`.

---

## License

- **Code:** MIT. See [`LICENSE`](LICENSE).
- **Content and brand assets:** all rights reserved (text, design, Qouver brand, q-mark logo).
