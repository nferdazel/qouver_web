#!/usr/bin/env bash
# Deploy qouver_web to the VPS.
#
# 1. Builds the static site locally (scripts/build.sh).
# 2. rsync build/jaspr/ → /srv/qouver/web on the VPS (qouver.com).
# 3. Reloads Caddy so the new site + headers take effect.
#
# Usage:
#   ./scripts/deploy.sh            # build + deploy
#   ./scripts/deploy.sh --dry-run  # build + show what would be synced (no changes)
#
# Requires:
#   - SSH access to the VPS (ssh qouver.com or host defined below)
#   - Caddyfile installed at /etc/caddy/Caddyfile on the VPS (see infra/)
set -euo pipefail
cd "$(dirname "$0")/.."

VPS_HOST="${QOUVER_VPS_HOST:-qouver.com}"
VPS_USER="${QOUVER_VPS_USER:-root}"
VPS_WEB_DIR="${QOUVER_VPS_WEB_DIR:-/srv/qouver/web}"
SSH_TARGET="$VPS_USER@$VPS_HOST"

DRY_RUN=0
[ "${1:-}" = "--dry-run" ] && DRY_RUN=1

echo "→ Building static site..."
./scripts/build.sh

echo "→ Syncing build/jaspr/ to $SSH_TARGET:$VPS_WEB_DIR"
if [ "$DRY_RUN" = "1" ]; then
  rsync -avz --dry-run --delete build/jaspr/ "$SSH_TARGET:$VPS_WEB_DIR"
  echo "→ Dry run — nothing changed."
  exit 0
fi

rsync -avz --delete build/jaspr/ "$SSH_TARGET:$VPS_WEB_DIR"

echo "→ Reloading Caddy..."
ssh "$SSH_TARGET" "sudo caddy reload --config /etc/caddy/Caddyfile"

echo "→ Done. https://qouver.com"
