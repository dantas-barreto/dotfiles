#!/bin/bash

# Verifica o layout atual
CURRENT_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')

# Alterna entre US e ABNT2
if [ "$CURRENT_LAYOUT" == "us" ]; then
    setxkbmap -layout br -variant abnt2
    notify-send "Teclado" "Layout alterado para ABNT2"
else
    setxkbmap -layout us
    notify-send "Teclado" "Layout alterado para US"
fi
