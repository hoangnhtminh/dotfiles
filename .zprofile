# ~/.zprofile — chỉ 1 khối duy nhất (bản cũ bị lặp 273 lần).
# Tự khởi động Hyprland khi đăng nhập ở tty1. Nếu dùng Ly (chạy ở tty2) thì khối này không kích hoạt.
if [[ -z ${WAYLAND_DISPLAY:-} && -z ${DISPLAY:-} && ${XDG_VTNR:-0} -eq 1 ]]; then
    if command -v start-hyprland >/dev/null 2>&1; then
        exec start-hyprland
    else
        exec Hyprland
    fi
fi
