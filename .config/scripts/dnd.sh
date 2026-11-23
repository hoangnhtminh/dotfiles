#!/usr/bin/env bash
# Không làm phiền cho mako. Dùng: dnd.sh {toggle|status}
set -u

is_on() { makoctl mode 2>/dev/null | grep -qx 'do-not-disturb'; }

case "${1:-status}" in
    toggle)
        makoctl mode -t do-not-disturb >/dev/null
        pkill -RTMIN+9 waybar 2>/dev/null || true ;;
    status)
        if is_on; then echo '{"text":"󰂛","tooltip":"Không làm phiền: BẬT","class":"active"}'
        else echo '{"text":"󰂚","tooltip":"Thông báo: bình thường","class":""}'; fi ;;
esac
