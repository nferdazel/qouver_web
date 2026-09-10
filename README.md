<div align="center">

# Qouver Web

**The official website for [qouver.com](https://qouver.com) — an umbrella home for systems and ideas.**

[![CI Pipeline](https://github.com/nferdazel/qouver_web/actions/workflows/ci.yml/badge.svg)](https://github.com/nferdazel/qouver_web/actions/workflows/ci.yml)
[![Built with Jaspr](https://img.shields.io/badge/Built%20with-Jaspr%20Static-A06428?style=flat&logo=dart)](https://jaspr.site)
[![Zero-JS](https://img.shields.io/badge/Runtime-Zero--JS%20Static-141413?style=flat)](https://qouver.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

---

## Overview

`qouver_web` is the static-first web presentation platform for **Qouver**. Built with [Jaspr](https://jaspr.site/) (Dart web framework) in **static pre-rendering mode**, all routes are generated as pure, self-contained HTML at build time — with **zero client-side JavaScript bundle overhead**.

SEO metadata (titles, meta descriptions, canonical URLs, OpenGraph cards, Twitter cards, and JSON-LD schemas) is pre-rendered directly into the static document structure server-side.

> 📄 **Complete Handoff & Status:** See [`HANDOFF.md`](HANDOFF.md)  
> 📄 **AngularDart → Jaspr Migration:** See [`MIGRATION.md`](MIGRATION.md)  
> 📄 **Quality Standards & Audit:** See [`STANDARDS.md`](STANDARDS.md)

---

## 🏛️ Site Architecture & Routes

| Route | Description |
| :--- | :--- |
| `/` | Hero section, 3-pillar approach strip, production systems catalogue, and operational manifesto |
| `/projects` | Complete systems catalogue (Skyward, Majadu Tools, SDS Management, M-DEF) |
| `/projects/:slug` | Technical case study reader (architecture decisions, trade-offs, takeaways) |
| `/journal` | Clean editorial index of technical essays, architecture post-mortems, and software notes |
| `/journal/:slug` | Full-page editorial article reader with code snippets and blockquotes |
| `/about` | Solo builder craft, engineering principles, production stack & Linux VPS infra |
| `/contact` | Direct maintainer email & GitHub organization links |

---

## 🛠️ Stack & Infrastructure

- **Framework:** `jaspr` 0.23.x + `jaspr_router` 0.8.x (static multi-page routing)
- **Rendering:** Pure static mode (`jaspr build` prerenders 13 routes server-side)
- **Typography:** Self-hosted `IBM Plex Sans` (UI & body) + `IBM Plex Mono` (metadata & code)
- **Design System:** Warm Alabaster paper (`#FAF9F5`), Obsidian Charcoal (`#141413`), Prospector Bronze accent (`#A06428`)
- **Deployment:** Containerized (`qouver-web` on Linux VPS behind Caddy TLS reverse proxy)
- **CI/CD:** GitHub Actions (format → analyze → test → static build → Docker layer cache → GHCR)

---

## 📁 Repository Structure

```text
web/                     # Static assets (styles.css, fonts.css, fonts/, robots.txt, llms.txt, q-mark.svg)
lib/
  main.server.dart       # Server entrypoint — static document & route configuration
  app.dart               # Shell component: header, nav, router, footer (+ skip-link, 404)
  seo.dart               # Per-page head helper (title, meta, OG, canonical, JSON-LD)
  components/            # UI components (q_mark, project_card)
  pages/                 # Page views (home, projects, journal, journal_detail, about, contact, 404)
  data/
    projects.dart        # Production systems & technical case studies data
    journal.dart         # Technical articles & essay data
test/                    # Server-render smoke & component invariant tests
scripts/build.sh         # Release build & static site generation script
deploy/                  # Caddyfile & Podman container specs
.github/workflows/       # GitHub Actions CI/CD workflows
```

---

## 🚀 Development & Build

### Development Server

Run the local dev server with hot reload:

```bash
dart pub get
dart run jaspr_cli:jaspr serve
```

### Static Production Build

Generate the static output directory:

```bash
./scripts/build.sh
# → Output generated to build/jaspr/ (HTML routes, sitemap.xml, robots.txt, styles.css)
```

The build script compiles all 13 routes in-process (zero headless browser dependency), generates `sitemap.xml`, copies static assets, and cleans dev artifacts.

### Testing & Analysis

```bash
# Run static analysis
dart analyze

# Run unit & component smoke tests
dart test
```

---

## 📊 Privacy-Friendly Analytics (Optional)

Analytics uses self-hosted [Umami](https://umami.is/). The site ships with **zero JavaScript by default**. Umami tracking is only injected if explicitly enabled during build:

```bash
UMAMI_SCRIPT_URL="https://analytics.qouver.com/script.js" \
UMAMI_WEBSITE_ID="<your-website-id>" \
./scripts/build.sh
```

---

## 🎨 Brand & Identity

- **Logo:** Optically balanced geometric Q-monogram — a ring holding a central Prospector Bronze focal dot (`accentDot: true`), its continuous arc tail tracing the prospector's sweep.
- **Color Palette:** Warm Alabaster (`#FAF9F5`), Obsidian Charcoal (`#141413`), Prospector Bronze (`#A06428`).
- **Typography:** `IBM Plex Sans` + `IBM Plex Mono` (self-hosted `.woff2`, zero external font network requests).

---

## 📜 License

- **Code:** MIT — see [`LICENSE`](LICENSE).
- **Content & Brand Assets:** All rights reserved (text, design, Qouver brand, q-mark logo).
