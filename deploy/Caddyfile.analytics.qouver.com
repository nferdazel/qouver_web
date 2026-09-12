# Caddyfile for analytics.qouver.com: self-hosted Umami
#
# Umami runs as a podman container on the VPS, published on port 3000
# (see UMAMI_DEPLOY.md). DNS: analytics.qouver.com → VPS IP.

analytics.qouver.com {
    reverse_proxy 127.0.0.1:3000

    header {
        Strict-Transport-Security "max-age=31536000; includeSubDomains"
        X-Content-Type-Options "nosniff"
        Referrer-Policy "strict-origin-when-cross-origin"
    }

    encode zstd gzip
}
