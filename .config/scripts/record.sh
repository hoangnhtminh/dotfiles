#!/usr/bin/env bash
# Quay màn hình bằng wf-recorder. Gọi lần nữa để dừng.
# Dùng: record.sh {full|area}
set -u

PID_FILE="${XDG_RUNTIME_DIR:-/tmp}/wl-record.pid"
DIR="$HOME/Videos/Recordings"
mkdir -p "$DIR"
FILE="$DIR/$(date +%Y%m%d_%H%M%S).mp4"

running() { [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; }

if running; then
    kill -INT "$(cat "$PID_FILE")"      # SIGINT để wf-recorder ghi xong file
    rm -f "$PID_FILE"
    notify-send "⏹ Recording" "Đã lưu vào $DIR" -t 3000
    exit 0
fi

case "${1:-full}" in
    area)
        region=$(slurp) || exit 0
        [ -z "$region" ] && exit 0
        wf-recorder -g "$region" -f "$FILE" &
        ;;
    *)
        wf-recorder -f "$FILE" &
        ;;
esac
echo $! > "$PID_FILE"
notify-send "⏺ Recording" "Đang quay… (bấm lại phím để dừng)" -t 2000
