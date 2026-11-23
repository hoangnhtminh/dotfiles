#!/usr/bin/env bash
# Chế độ bảo vệ mắt (gammastep). Dùng: sunset-toggle.sh {toggle|status|start|stop}
set -u

TEMP=4500
is_on() { pgrep -x gammastep >/dev/null; }
refresh_bar() { pkill -RTMIN+8 waybar 2>/dev/null || true; }

start() { gammastep -O "$TEMP" >/dev/null 2>&1 & disown; refresh_bar; }
stop()  { pkill -x gammastep; refresh_bar; }

case "${1:-status}" in
    toggle)
        if is_on; then stop; notify-send "🌙 Eye care" "Tắt" -t 1500
        else start; notify-send "🌙 Eye care" "Bật (${TEMP}K)" -t 1500; fi ;;
    start)  start ;;
    stop)   stop ;;
    status)
        if is_on; then echo '{"text":"󰛩","tooltip":"Eye care: BẬT","class":"active"}'
        else echo '{"text":"󰛨","tooltip":"Eye care: tắt","class":""}'; fi ;;
esac
