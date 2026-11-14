#!/bin/bash
# Lock the screen with i3lock over a pixelated screenshot (X11 / i3).

icon="$HOME/.config/i3/lock.png"

# Keep the image in RAM when possible.
img=$(mktemp "${XDG_RUNTIME_DIR:-/tmp}/lock-XXXXXXXXXX.png")
trap 'rm -f "$img"' EXIT

# Add the lock image on top, if there is one.
overlay=()
[[ -f $icon ]] && overlay=("$icon" -gravity center -composite)

# ImageMagick 7 calls it "magick" and warns about the old "convert" name.
convert=convert
command -v magick >/dev/null && convert=magick

# Capture, pixelate and compose in a single pass. The screenshot travels through
# the pipe uncompressed and the PNG is written with the cheapest compression,
# since it only lives until the screen is unlocked.
import -silent -window root miff:- |
  "$convert" miff:- -scale 10% -sample 1000% "${overlay[@]}" \
    -define png:compression-level=1 -define png:compression-filter=0 "$img"

# run i3lock with custom background
i3lock -i "$img"
