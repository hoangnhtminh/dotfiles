#!/usr/bin/env bash
# Máy tính nhanh bằng libqalculate (không cần plugin rofi-calc từ AUR). Super+C
# Gõ biểu thức, Enter -> kết quả được copy vào clipboard.
pkill -x rofi && exit 0
expr=$(rofi -dmenu -p "=" -theme ~/.config/rofi/calc.rasi < /dev/null) || exit 0
[ -z "$expr" ] && exit 0
res=$(qalc -t "$expr" 2>&1)
printf '%s' "$res" | wl-copy
notify-send "🧮 $expr" "$res" -t 4000
