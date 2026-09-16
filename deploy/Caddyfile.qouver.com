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
    # The host is the single owner of these headers. The container does not set
    # any: two headers with the same name are enforced as an intersection, not
    # merged, so a stale copy silently overrides the correct one. That is
    # exactly what happened when this file was updated but the running host
    # config was not, and the old CSP kept blocking analytics while the
    # container's policy was already correct.
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
    # `no-cache` everywhere, deliberately. It does not mean "do not cache": the
    # browser keeps the file but revalidates before use, and Caddy answers with
    # a bodyless 304 when the ETag still matches, so an unchanged asset costs
    # one conditional request and zero bytes.
    #
    # The previous policy marked /assets/*, /fonts/*, /styles.css and
    # /favicon.* as `immutable` for a year. That is only safe when the filename
    # changes with the content, and ours do not (styles.css is always
    # styles.css, and its contents change on every deploy). An immutable
    # stylesheet with a stable name means a returning visitor never sees the
    # new design until the cache expires, which is exactly what happened: a
    # normal Firefox tab kept the old site while incognito showed the current
    # one.
    #
    # If hashed filenames are ever introduced, the hashed paths can go back to
    # `immutable` and only the unhashed entry points should stay `no-cache`.
    header Cache-Control "no-cache"

    # 404 ditangani di container (Caddyfile.qouver-web.docker handle_errors), host cukup proxy
}

www.qouver.com {
    redir https://qouver.com{uri} permanent
}
