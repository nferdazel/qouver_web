#!/usr/bin/env bash
# Regenerates the raster app icons from the brand SVG.
#
# Dev-only tool: it rasterises with headless Google Chrome. The normal release
# build (`scripts/build.sh`) never runs this and has no Chrome dependency.
#
# Source of truth for the mark: web/assets/q-mark.svg
# Output: web/assets/icons/{icon-192,icon-512,apple-touch-icon,maskable-512}.png
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
if [ ! -x "$CHROME" ]; then
  echo "Chrome not found at: $CHROME" >&2
  echo "Set CHROME=/path/to/chrome to override." >&2
  exit 1
fi

SRC="web/assets/q-mark.svg"
OUT="web/assets/icons"
PLATE="#EDEAE3"

# The mark's ink bounds inside the 64-unit viewBox are roughly x/y 7.25..56.25,
# centred on (31.75, 30.5). A 50-unit square viewBox centred there gives a tight,
# centred crop, so a slot of `mark` px makes the visible mark that exact size.
TIGHT_VIEWBOX="6.75 5.5 50 50"

# name:size:mark-fraction (maskable keeps the mark inside the safe zone)
SPECS=(
  "icon-192.png:192:0.66"
  "icon-512.png:512:0.66"
  "apple-touch-icon.png:180:0.66"
  "maskable-512.png:512:0.52"
)

inner="$(sed -e '1d' -e '$d' "$SRC")"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$OUT"
for spec in "${SPECS[@]}"; do
  name="${spec%%:*}"; rest="${spec#*:}"
  size="${rest%%:*}"; frac="${rest#*:}"
  mark="$(python3 -c "print(int($size*$frac))")"

  page="$tmp/$name.html"
  cat > "$page" <<HTML
<!doctype html><html><head><meta charset="utf-8"><style>
html,body{margin:0;padding:0;background:$PLATE}
.stage{width:${size}px;height:${size}px;background:$PLATE;display:flex;align-items:center;justify-content:center;overflow:hidden}
</style></head><body>
<div class="stage">
<svg xmlns="http://www.w3.org/2000/svg" viewBox="$TIGHT_VIEWBOX" width="$mark" height="$mark" fill="none">$inner</svg>
</div></body></html>
HTML

  "$CHROME" --headless=new --disable-gpu --no-sandbox --hide-scrollbars \
    --force-device-scale-factor=1 --window-size="$size,$size" \
    --screenshot="$OUT/$name" "file://$page" >/dev/null 2>&1

  printf '%-24s %sx%s\n' "$OUT/$name" "$size" "$size"
done

echo "Done. Icons regenerated from $SRC (plate $PLATE)."
