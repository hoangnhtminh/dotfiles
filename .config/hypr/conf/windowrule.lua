-- Luật cửa sổ (cú pháp Lua: match = {...} + hiệu ứng). Luật chạy từ trên xuống.
local U = require("conf.util")

local function any(...) return "^(" .. table.concat({ ... }, "|") .. ")$" end

-- Từ file mẫu chính thức của Hyprland
U.rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })
U.rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- Cửa sổ nổi
U.rule({ name = "float-apps", float = true, match = { class = any(
    "pavucontrol", "nm-connection-editor", "blueman-manager",
    "org.gnome.Calculator", "qalculate-gtk", "eog", "imv", "feh", "mpv",
    "xdg-desktop-portal-gtk", "rofi", "scratch", "org.fcitx.fcitx5-config-qt") } })
U.rule({ name = "float-dialogs", float = true, match = { title = "^(Open File|Save File|Open Folder|Save As).*$" } })

-- Kích thước + giữa màn hình
U.rule({ name = "size-pavucontrol", match = { class = any("pavucontrol") },
         size = "800 500", center = true })
U.rule({ name = "size-calc", match = { class = any("org.gnome.Calculator", "qalculate-gtk") },
         size = "380 280", center = true })
U.rule({ name = "size-dialogs", match = { title = "^(Open File|Save File|Open Folder|Save As).*$" },
         size = "1000 650", center = true })
U.rule({ name = "size-scratch", match = { class = any("scratch") },
         size = "900 520", center = true })

-- Picture-in-Picture: nổi, ghim, góc dưới phải
U.rule({ name = "pip", match = { title = "^(Picture-in-Picture)$" },
         float = true, pin = true, size = "480 270", move = "monitor_w-500 monitor_h-290" })

-- Chống tắt màn hình
U.rule({ name = "idle-fullscreen", match = { class = ".*" }, idle_inhibit = "fullscreen" })
U.rule({ name = "idle-video",      match = { class = any("mpv", "vlc") }, idle_inhibit = "focus" })

-- Giữ focus cho popup
U.rule({ name = "stay-focused", match = { class = any("rofi") }, stay_focused = true })

-- Hơi trong suốt cho file manager (rẻ vì không có blur)
U.rule({ name = "opacity-thunar", match = { class = any("thunar") }, opacity = "0.95 0.90" })

-- Steam
U.rule({ name = "steam-friends", float = true, match = { class = "^(steam)$", title = "^(Friends List)$" } })

-- Layer: bỏ animation cho thanh chọn vùng (slurp) và rofi cho bấm là hiện ngay
U.layer({ name = "no-anim-overlays", match = { namespace = "^(selection|rofi)$" }, no_anim = true })
