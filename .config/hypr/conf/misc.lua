local U = require("conf.util")

U.config({
    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        force_default_wallpaper  = 0,
        vfr = true,          -- chỉ vẽ khi có thay đổi (tiết kiệm CPU/GPU/pin)
        vrr = 0,
        animate_manual_resizes       = false,
        animate_mouse_windowdragging = false,
        enable_swallow = true,
        swallow_regex  = "^(foot|kitty)$",
        focus_on_activate       = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms  = true,
        close_special_on_empty  = true,
    },
    cursor = {
        inactive_timeout  = 4,
        hide_on_key_press = true,
        hide_on_touch     = true,
    },
    debug = {
        disable_logs = true,
    },
    ecosystem = {
        no_update_news   = true,
        no_donation_nag  = true,
    },
})
