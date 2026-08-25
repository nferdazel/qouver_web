#!/usr/bin/env bash
# Build script for qouver_web (Jaspr).
#
# Produces build/jaspr/ — a fully static, self-contained site:
#   - prerendered static HTML for every route (SEO: title + meta per page)
#   - sitemap.xml (auto-generated from the route list)
#   - static assets (styles.css, q-mark.svg, robots.txt)
#   - client JS only for @client components (this site: none)
#
# Usage: ./scripts/build.sh
set -euo pipefail
cd "$(dirname "$0")/.."

# --- Find a real Dart SDK executable -------------------------------------
# jaspr_cli verifies that `which dart` points inside a Dart/Flutter SDK. The
# Homebrew `dart` is often just a Flutter shim (bin/dart -> flutter/bin/dart),
# which fails that check. Resolve the real SDK binary and put it on PATH.
find_dart() {
  local d
  if d="$(command -v dart 2>/dev/null)"; then
    # /path/to/<sdk>/bin/dart  →  <sdk>/version must exist
    local maybe_sdk
    maybe_sdk="$(dirname "$(dirname "$d")")"
    if [ -f "$maybe_sdk/version" ] && [ "$(basename "$(dirname "$d")")" = "bin" ]; then
      echo "$d"
      return
    fi
    # Maybe it's a Flutter shim: <flutter>/bin/dart → <flutter>/bin/cache/dart-sdk/bin/dart
    local flutter_dart
    flutter_dart="$(dirname "$d")/cache/dart-sdk/bin/dart"
    if [ -f "$(dirname "$(dirname "$flutter_dart")")/version" ]; then
      echo "$flutter_dart"
      return
    fi
  fi
  # Fallback: search common Flutter install locations.
  for f in "$HOME"/development/flutter/bin/cache/dart-sdk/bin/dart \
           "$HOME"/flutter/bin/cache/dart-sdk/bin/dart \
           /opt/homebrew/Caskroom/flutter/*/flutter/bin/cache/dart-sdk/bin/dart \
           /usr/local/Caskroom/flutter/*/flutter/bin/cache/dart-sdk/bin/dart; do
    if [ -x "$f" ]; then
      echo "$f"
      return
    fi
  done
  echo ""
}

DART="$(find_dart)"
if [ -z "$DART" ]; then
  echo "✗ Could not find a Dart SDK executable. Install the standalone Dart SDK or Flutter." >&2
  exit 1
fi
echo "→ Using Dart SDK at: $DART"
export PATH="$(dirname "$DART"):$PATH"

# --- Build ------------------------------------------------------------------
echo "→ Building static site (jaspr build)..."
dart run jaspr_cli:jaspr build --sitemap-domain https://qouver.com --sitemap-exclude '404' -O4

echo "→ Copying static assets..."
cp web/robots.txt build/jaspr/robots.txt
cp web/llms.txt build/jaspr/llms.txt

# Stamp the deployed version (see VERSION + git tags after repo init).
cp VERSION build/jaspr/VERSION

# build_runner leaves dev residue in the output — strip it.
echo "→ Cleaning build residue..."
rm -rf build/jaspr/packages build/jaspr/.dart_tool build/jaspr/.build.manifest

echo "→ Done. Deployable site in build/jaspr/"
du -sh build/jaspr
find build/jaspr -type f | sort
