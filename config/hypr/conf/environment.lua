-- Biến môi trường
local function env(k, v) hl.env(k, v) end

-- Wayland
env("XDG_SESSION_TYPE",    "wayland")
env("XDG_SESSION_DESKTOP", "Hyprland")
env("XDG_CURRENT_DESKTOP", "Hyprland")
env("GDK_BACKEND",         "wayland,x11,*")
env("QT_QPA_PLATFORM",     "wayland;xcb")
env("SDL_VIDEODRIVER",     "wayland,x11")
env("CLUTTER_BACKEND",     "wayland")
env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
env("_JAVA_AWT_WM_NONREPARENTING",  "1")

-- Qt
env("QT_AUTO_SCREEN_SCALE_FACTOR",         "1")
env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
env("QT_QPA_PLATFORMTHEME",                "qt6ct")

-- Con trỏ
env("XCURSOR_THEME",    "Bibata-Modern-Ice")
env("XCURSOR_SIZE",     "24")
env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
env("HYPRCURSOR_SIZE",  "24")

-- Bộ gõ fcitx5 (Unikey). GTK_IM_MODULE cố ý KHÔNG đặt: trên Wayland GTK
-- dùng text-input-v3 trực tiếp; đặt nó thường làm gõ tiếng Việt bị lỗi.
env("QT_IM_MODULE",  "fcitx")
env("XMODIFIERS",    "@im=fcitx")
env("SDL_IM_MODULE", "fcitx")
