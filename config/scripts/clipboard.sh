#!/usr/bin/env bash
# Lịch sử clipboard (cliphist + rofi). Super+V
pkill -x rofi && exit 0
sel=$(cliphist list | rofi -dmenu -p "󰅍 Clipboard" -theme ~/.config/rofi/clipboard.rasi) || exit 0
[ -n "$sel" ] && printf '%s' "$sel" | cliphist decode | wl-copy
