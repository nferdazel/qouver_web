# qouver_web — podman image (seragam majadu-api: GHCR + quadlet)
# Build jaspr static (dart) → serve via Caddy (alpine)
# VPS: podman pull ghcr.io/nferdazel/qouver-web:main + systemctl --user restart qouver-web

# ---------- Stage 1: build ----------
FROM dart:3.13 AS build
WORKDIR /app

# Cache deps dulu
COPY pubspec.yaml pubspec.lock ./
RUN dart pub get

COPY . .

# Build static (mirip scripts/build.sh, tanpa shim — dart image sudah SDK murni)
# --sitemap-domain + exclude 404 → sitemap.xml bersih
RUN dart run jaspr_cli:jaspr build --sitemap-domain https://qouver.com --sitemap-exclude '404' -O4 \
 && cp web/robots.txt build/jaspr/robots.txt \
 && cp web/llms.txt build/jaspr/llms.txt \
 && cp VERSION build/jaspr/VERSION \
 && rm -rf build/jaspr/packages build/jaspr/.dart_tool build/jaspr/.build.manifest

# ---------- Stage 2: serve ----------
FROM caddy:2.11-alpine

# Copy static output ke /srv (seragam /srv/qouver/web di host, tapi di container /srv)
COPY --from=build /app/build/jaspr /srv

# Caddyfile untuk di DALAM container (listen :80, no TLS — TLS di host Caddy reverse_proxy)
COPY infra/Caddyfile.qouver-web.docker /etc/caddy/Caddyfile

# Caddy butuh expose 80 (host quadlet PublishPort=127.0.0.1:3002:80)
EXPOSE 80

# Caddy run sudah default di image caddy:alpine (caddy run --config /etc/caddy/Caddyfile)
