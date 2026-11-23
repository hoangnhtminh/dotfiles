-- Chạy 1 lần khi Hyprland khởi động. Không dùng uwsm -> không cần "uwsm finalize".
local S = "~/.config/scripts/"

hl.on("hyprland.start", function()
    -- Môi trường cho dbus/systemd --user (portal, polkit, ...)
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")

    -- Polkit (hộp thoại nhập mật khẩu admin)
    hl.exec_cmd("systemctl --user start hyprpolkitagent || /usr/lib/hyprpolkitagent/hyprpolkitagent")

    -- Giao diện
    hl.exec_cmd("mako")
    hl.exec_cmd("waybar")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd(S .. "wallpaper.sh restore")
    hl.exec_cmd(S .. "gtk-init.sh")

    -- Tiện ích nền
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --type text  --watch cliphist -max-items 200 store")
    hl.exec_cmd("wl-paste --type image --watch cliphist -max-items 50 store")

    -- Đặt XWayland làm primary (Steam/Java/Wine hay cần)
    hl.exec_cmd("command -v xrandr >/dev/null && xrandr --output XWAYLAND0 --primary")
end)
