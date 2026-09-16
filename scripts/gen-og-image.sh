#!/usr/bin/env bash
# Regenerates the Open Graph card from the live design tokens.
#
# Dev-only tool: it composes the card as HTML, rasterises it with headless
# Google Chrome, and encodes to webp. The normal release build
# (`scripts/build.sh`) never runs this and has no Chrome dependency.
#
# Sources of truth: web/assets/q-mark.svg (mark), web/fonts/*.woff2 (type),
# and the palette in web/styles.css. Text is duplicated here on purpose, since
# a raster card cannot read Dart constants; keep it in sync with lib/site.dart
# (siteName, siteTagline) when those change.
#
# Output: web/assets/og-image.webp (1200x630)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
if [ ! -x "$CHROME" ]; then
  echo "Chrome not found at: $CHROME" >&2
  echo "Set CHROME=/path/to/chrome to override." >&2
  exit 1
fi
if ! command -v cwebp >/dev/null 2>&1; then
  echo "cwebp not found. Install libwebp (brew install webp)." >&2
  exit 1
fi

W=1200
H=630
OUT="web/assets/og-image.webp"

# Palette (must match the tokens in web/styles.css).
PAPER="#EDEAE3"
INK="#141311"
INK_2="#4A4843"
ACCENT="#B23A1A"
RULE="#C9C4B8"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/fonts"
cp web/fonts/*.woff2 "$work/fonts/"

# Inline the mark so the card cannot drift from the brand SVG.
mark_inner="$(sed -e '1d' -e '$d' web/assets/q-mark.svg)"

cat > "$work/card.html" <<HTML
<!doctype html><html><head><meta charset="utf-8"><style>
@font-face{font-family:'Fraunces';src:url('fonts/fraunces-var.woff2') format('woff2');font-weight:100 900;font-display:block}
@font-face{font-family:'Archivo';src:url('fonts/archivo-var.woff2') format('woff2');font-weight:100 900;font-display:block}
*{margin:0;padding:0;box-sizing:border-box}
body{background:$PAPER}
.card{position:relative;width:${W}px;height:${H}px;background:$PAPER;color:$INK;
  display:flex;flex-direction:column;justify-content:center;
  padding:0 96px;overflow:hidden;font-family:'Archivo'}

/* Spec rule: the 2px rule with ticks used throughout the site. */
.rule{position:absolute;left:96px;right:96px;height:2px;background:$RULE}
.rule--top{top:72px}
.rule--bottom{bottom:72px}
.tick{position:absolute;width:2px;height:12px;background:$RULE}
.tick--tl{top:72px;left:96px}
.tick--tr{top:72px;right:96px}
.tick--bl{bottom:72px;left:96px}
.tick--br{bottom:72px;right:96px}

.label{position:absolute;top:104px;left:96px;font-family:'Archivo';
  font-weight:600;font-size:20px;letter-spacing:.18em;text-transform:uppercase;color:$INK_2}

.head{display:flex;align-items:center;gap:40px}
.mark{width:104px;height:104px;flex:none}
.name{font-family:'Fraunces';font-weight:600;font-size:140px;line-height:.92;
  letter-spacing:-.025em;color:$INK}
.tag{margin-top:28px;font-family:'Archivo';font-weight:400;font-size:42px;
  line-height:1.25;color:$INK_2}

.url{position:absolute;bottom:104px;left:96px;font-family:'Archivo';
  font-weight:600;font-size:22px;letter-spacing:.06em;color:$INK_2}
.dot{position:absolute;bottom:100px;right:96px;width:14px;height:14px;background:$ACCENT}
</style></head><body>
<div class="card">
  <div class="rule rule--top"></div>
  <div class="rule rule--bottom"></div>
  <div class="tick tick--tl"></div><div class="tick tick--tr"></div>
  <div class="tick tick--bl"></div><div class="tick tick--br"></div>
  <div class="label">Systems and ideas</div>
  <div class="head">
    <svg class="mark" viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">$mark_inner</svg>
    <div class="name">Qouver</div>
  </div>
  <div class="tag">A home for systems and ideas</div>
  <div class="url">qouver.com</div>
  <div class="dot"></div>
</div>
</body></html>
HTML

"$CHROME" --headless=new --disable-gpu --no-sandbox --hide-scrollbars \
  --force-device-scale-factor=1 --window-size="$W,$H" \
  --virtual-time-budget=8000 --screenshot="$work/card.png" \
  "file://$work/card.html" >/dev/null 2>&1

cwebp -quiet -q 88 -m 6 "$work/card.png" -o "$OUT"

printf 'wrote %s (%s, %sx%s)\n' "$OUT" "$(du -h "$OUT" | cut -f1)" "$W" "$H"
