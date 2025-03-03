#!/bin/bash

$icon="$HOME/.config/i3/lock.png"

img=$(mktemp /tmp/XXXXXXXXXX.png)

import -window root $img

# pixelate screenshot
convert $img -scale 10% -scale %1000 $img
# alternatively, blur the screenshot (slow)
#convert $img -blur 2,5 $img

# add the lock image
convert $img $icon -gravity center -composite $img

# run i3lock with custom background
i3lock -i $img

# remove temp file
rm $img
