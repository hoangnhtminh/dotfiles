#!/usr/bin/env bash
# Menu nguồn bằng rofi (thay wlogout: bớt 1 gói + 1 tiến trình layer-shell).
set -u

THEME=~/.config/rofi/powermenu.rasi
pkill -x rofi && exit 0

# Icon Nerd Font ghi bằng mã Unicode để không bị mất khi sao chép file
LOCK=$'\uf023'; SLEEP=$'\U000f0904'; REBOOT=$'\uf021'; OFF=$'\uf011'; OUT=$'\U000f0343'

confirm() {
    [ "$(printf 'Không\nCó\n' | rofi -dmenu -p "$1?" -theme "$THEME")" = "Có" ]
}

choice=$(printf '%s  Khóa\n%s  Ngủ\n%s  Khởi động lại\n%s  Tắt máy\n%s  Đăng xuất\n' \
         "$LOCK" "$SLEEP" "$REBOOT" "$OFF" "$OUT" | rofi -dmenu -p "⏻" -theme "$THEME")

case "$choice" in
    *Khóa)            pidof hyprlock >/dev/null || hyprlock ;;
    *Ngủ)             systemctl suspend ;;
    *"Khởi động lại") confirm "Khởi động lại" && systemctl reboot ;;
    *"Tắt máy")       confirm "Tắt máy"        && systemctl poweroff ;;
    *"Đăng xuất")     confirm "Đăng xuất"      && hyprctl dispatch 'hl.dsp.exit()' ;;
esac
