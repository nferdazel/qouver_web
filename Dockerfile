# qouver_web — podman image (seragam majadu-api: GHCR + quadlet)
# Fast Caddy static server for prerendered Jaspr output
# VPS: podman pull ghcr.io/nferdazel/qouver-web:main + systemctl --user restart qouver-web

FROM caddy:2.11-alpine

# Copy pre-built static Jaspr site output to /srv
COPY build/jaspr /srv

# Caddyfile untuk di DALAM container (listen :80, no TLS — TLS di host Caddy reverse_proxy)
COPY deploy/Caddyfile.qouver-web.docker /etc/caddy/Caddyfile

# Caddy expose 80 (host quadlet PublishPort=127.0.0.1:3002:80)
EXPOSE 80

