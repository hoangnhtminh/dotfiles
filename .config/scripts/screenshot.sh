#!/usr/bin/env bash
# Chụp màn hình: grim + slurp (+ swappy để chú thích khi chọn vùng/cửa sổ)
# Dùng: screenshot.sh {full|area|window}
set -u

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/$(date +%Y%m%d_%H%M%S).png"

done_msg() { notify-send "📸 Screenshot" "$1" -i "$FILE" -t 3000; }

case "${1:-area}" in
    full)
        grim "$FILE" && wl-copy < "$FILE" && done_msg "Toàn màn hình"
        ;;
    window)
        geo=$(hyprctl activewindow -j | jq -r 'select(.size != null) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        [ -z "$geo" ] && exit 1
        grim -g "$geo" - | swappy -f - -o "$FILE" && [ -f "$FILE" ] && wl-copy < "$FILE" && done_msg "Cửa sổ"
        ;;
    area|*)
        region=$(slurp -d -c e8824a -b 1a151244 -s e8824a22) || exit 1
        [ -z "$region" ] && exit 1
        grim -g "$region" - | swappy -f - -o "$FILE" && [ -f "$FILE" ] && wl-copy < "$FILE" && done_msg "Vùng chọn"
        ;;
esac
