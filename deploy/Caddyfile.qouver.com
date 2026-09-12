# Caddyfile for qouver.com: host Caddy (VPS Rocky Linux) → reverse_proxy podman
#
# Podman (seragam majadu-api): container qouver-web di 127.0.0.1:3002 (Network=qouver)
# Host Caddy TLS + header + cache ada di sini; container Caddyfile.qouver-web.docker cuma file_server :80
# Append blok ini ke /etc/caddy/Caddyfile (jangan replace), lalu: sudo caddy reload --config /etc/caddy/Caddyfile
#
# Legacy rsync (root * /srv/qouver/web) ada di git history, tidak dipakai lagi.

qouver.com {
    reverse_proxy 127.0.0.1:3002

    # --- Security headers ---------------------------------------------------
    header {
        Strict-Transport-Security "max-age=31536000; includeSubDomains"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "DENY"
        Referrer-Policy "strict-origin-when-cross-origin"
        Permissions-Policy "camera=(), microphone=(), geolocation=()"
        # CSP: fonts are self-hosted (web/fonts/) and the site ships no JS by
        # default. analytics.qouver.com is allowed in script-src/connect-src so
        # the env-gated Umami snippet works when UMAMI_SCRIPT_URL is set; with
        # the snippet absent, the allowance is inert.
        Content-Security-Policy "default-src 'self'; script-src 'self' https://analytics.qouver.com; style-src 'self'; font-src 'self'; img-src 'self' data:; connect-src 'self' https://analytics.qouver.com; base-uri 'self'; frame-ancestors 'none'; form-action 'self'"
    }

    # --- Caching ------------------------------------------------------------
    # HTML: short cache (content changes on every build); assets: long cache.
    @static path /assets/* /fonts/* /fonts.css /styles.css /favicon.*
    header @static Cache-Control "public, max-age=31536000, immutable"
    header / Cache-Control "no-cache"

    # 404 ditangani di container (Caddyfile.qouver-web.docker handle_errors), host cukup proxy
}

www.qouver.com {
    redir https://qouver.com{uri} permanent
}
