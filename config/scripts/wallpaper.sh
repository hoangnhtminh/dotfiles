#!/usr/bin/env bash
# Hình nền bằng awww (trước đây là swww — đã đổi tên, gói `swww` không còn).
# Dùng: wallpaper.sh {pick|restore|random|next}
set -u

WALL_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="$HOME/.cache/current_wallpaper"
# Chuyển cảnh nhẹ cho máy yếu: fade, 30 fps, 0.4s. Máy mạnh: "grow", 60, 0.8
TRANSITION="fade"; FPS=30; DURATION=0.4

mkdir -p "$WALL_DIR" "$(dirname "$CACHE_FILE")"

list_walls() { find "$WALL_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort; }

wait_daemon() {
    local i
    for i in $(seq 1 30); do
        awww query >/dev/null 2>&1 && return 0
        sleep 0.1
    done
    return 1
}

apply() {
    local wall="$1"
    [ -f "$wall" ] || return 1
    wait_daemon || { notify-send "Wallpaper" "awww-daemon chưa chạy" -u critical; return 1; }
    awww img "$wall" --transition-type "$TRANSITION" --transition-fps "$FPS" --transition-duration "$DURATION"
    printf '%s\n' "$wall" > "$CACHE_FILE"
}

case "${1:-}" in
    pick)
        pkill -x rofi && exit 0
        sel=$(list_walls | while IFS= read -r f; do printf '%s\0icon\x1f%s\n' "$f" "$f"; done \
              | rofi -dmenu -show-icons -p "󰸉 Wallpaper" -theme ~/.config/rofi/launcher.rasi)
        [ -n "$sel" ] && apply "$sel"
        ;;
    restore)
        wall=$(cat "$CACHE_FILE" 2>/dev/null)
        [ -f "${wall:-}" ] || wall=$(list_walls | head -n1)
        [ -n "${wall:-}" ] && apply "$wall"
        ;;
    random)
        wall=$(list_walls | shuf -n1)
        [ -n "$wall" ] && apply "$wall"
        ;;
    next)
        mapfile -t walls < <(list_walls)
        total=${#walls[@]}; [ "$total" -eq 0 ] && exit 1
        current=$(cat "$CACHE_FILE" 2>/dev/null); idx=0
        for i in "${!walls[@]}"; do
            [ "${walls[$i]}" = "$current" ] && idx=$(( (i + 1) % total ))
        done
        apply "${walls[$idx]}"
        ;;
    *)
        echo "Usage: $0 {pick|restore|random|next}" >&2; exit 1 ;;
esac
