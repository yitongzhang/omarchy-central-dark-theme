#!/usr/bin/env bash
# Render preview.png (1800x1012) from a theme's colors.toml.
# Usage: make-preview.sh <theme-dir> "<Display Name>"
set -euo pipefail

DIR="${1:?theme dir}"
NAME="${2:?display name}"
C="$DIR/colors.toml"
FONT="${PREVIEW_FONT:-JetBrainsMono-NF-Regular}"
FONT_BOLD="${PREVIEW_FONT_BOLD:-JetBrainsMono-NF-Bold}"

k() { sed -n "s/^$1 *= *\"\([^\"]*\)\".*/\1/p" "$C" | head -1; }

bg=$(k background); dbg=$(k dark_background); ddbg=$(k darker_background); lbg=$(k lighter_background)
fg=$(k foreground); dfg=$(k dark_foreground); bfg=$(k bright_foreground)
accent=$(k accent); sel=$(k selection)
red=$(k red); yellow=$(k yellow); green=$(k green); cyan=$(k cyan); blue=$(k blue); magenta=$(k magenta); orange=$(k orange)

W=1800; H=1012
# Card geometry
CX=140; CY=170; CW=1520; CH=680

args=(
  -size ${W}x${H} "xc:$ddbg"
  # subtle vignette wash so the card reads as raised
  \( -size ${W}x${H} "radial-gradient:$bg-$ddbg" \) -compose over -composite

  # window card
  -fill "$dbg" -stroke "$sel" -strokewidth 1
  -draw "roundrectangle $CX,$CY $((CX+CW)),$((CY+CH)) 14,14"

  # title bar
  -stroke none -fill "$lbg"
  -draw "roundrectangle $CX,$CY $((CX+CW)),$((CY+52)) 14,14"
  -fill "$dbg" -draw "rectangle $CX,$((CY+38)) $((CX+CW)),$((CY+52))"
  -fill "$red"    -draw "circle $((CX+28)),$((CY+26)) $((CX+28)),$((CY+33))"
  -fill "$yellow" -draw "circle $((CX+56)),$((CY+26)) $((CX+56)),$((CY+33))"
  -fill "$green"  -draw "circle $((CX+84)),$((CY+26)) $((CX+84)),$((CY+33))"
  -font "$FONT" -pointsize 20 -fill "$dfg"
  -draw "text $((CX+118)),$((CY+33)) '~/central'"
)

# terminal body
declare -a LINES=(
  "$green|\$ omarchy theme current||"
  "$fg|$NAME||"
  "$green|\$ omarchy-theme-mode status||"
  "$dfg|  mode    $(k mode)  (auto)||"
  "$dfg|  today   light 06:32 -> dark 19:54||"
  "$dfg|  source  sunrise/sunset, San Francisco||"
  "$green|\$ git log --oneline -3||"
  "$yellow|a91f0c2|$magenta|feat: mirror the neutral scale"
  "$yellow|7d3e415|$cyan|fix: hairline borders in light mode"
  "$yellow|1c8ba90|$blue|docs: how the pair stays in sync"
)
y=$((CY+108))
for entry in "${LINES[@]}"; do
  IFS='|' read -r c1 t1 c2 t2 <<<"$entry"
  args+=( -font "$FONT" -pointsize 26 -fill "$c1" -draw "text $((CX+40)),$y '$t1'" )
  if [[ -n $c2 && -n $t2 ]]; then
    off=$(( ${#t1} * 16 + 72 ))
    args+=( -fill "$c2" -draw "text $((CX+off)),$y '$t2'" )
  fi
  y=$((y+44))
done

# cursor block
args+=( -fill "$accent" -draw "rectangle $((CX+40)),$((y-24)) $((CX+56)),$((y+2))" )

# palette swatch row
sw=0
for col in "$red" "$orange" "$yellow" "$green" "$cyan" "$blue" "$magenta" "$accent" "$fg" "$dfg" "$sel" "$bg"; do
  [[ -n $col ]] || continue
  x=$((CX + sw*88))
  args+=( -fill "$col" -stroke "$sel" -strokewidth 1 -draw "roundrectangle $x,$((CY+CH+40)) $((x+72)),$((CY+CH+112)) 8,8" )
  sw=$((sw+1))
done

# theme name
args+=( -stroke none -font "$FONT_BOLD" -pointsize 40 -fill "$bfg" -draw "text $CX,$((CY-40)) '$NAME'" )

magick "${args[@]}" -depth 8 "$DIR/preview.png"
echo "wrote $DIR/preview.png"
