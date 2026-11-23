#!/usr/bin/env bash
# Đặt theme GTK/icon/con trỏ qua gsettings, chỉ chạy khi giá trị khác (đỡ tốn
# 5 tiến trình mỗi lần đăng nhập như bản cũ). Theme đổi ở đây, KHÔNG đổi ở nơi khác.
set -u
command -v gsettings >/dev/null || exit 0

GTK_THEME="${GTK_THEME_NAME:-Adwaita-dark}"
S=org.gnome.desktop.interface

set_if() {  # set_if key value
    [ "$(gsettings get "$S" "$1" 2>/dev/null)" = "'$2'" ] || gsettings set "$S" "$1" "$2"
}
set_if gtk-theme    "$GTK_THEME"
set_if icon-theme   "Papirus-Dark"
set_if cursor-theme "Bibata-Modern-Ice"
set_if color-scheme "prefer-dark"
[ "$(gsettings get "$S" cursor-size)" = "24" ] || gsettings set "$S" cursor-size 24
