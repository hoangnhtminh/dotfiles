#!/usr/bin/env bash
# Bật/tắt màn hình qua Hyprland Lua dispatcher (dùng cho hypridle).
case "${1:-}" in
    on)  hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'  ;;
    off) hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })' ;;
    *)   echo "Usage: $0 {on|off}" >&2; exit 1 ;;
esac
