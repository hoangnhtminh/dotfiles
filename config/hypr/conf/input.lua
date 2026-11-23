local U = require("conf.util")

U.config({
    input = {
        kb_layout    = "us",
        kb_options   = "altwin:super_win",
        numlock_by_default = true,
        repeat_rate  = 35,
        repeat_delay = 250,

        follow_mouse = 1,
        float_switch_override_focus = 2,
        sensitivity  = 0,
        accel_profile = "flat",

        touchpad = {
            natural_scroll       = true,
            disable_while_typing = true,
            scroll_factor        = 0.8,
            tap_to_click         = true,
            drag_lock            = true,
            middle_button_emulation = false,
        },
    },
})

-- Cử chỉ 3 ngón (như bản cũ): trái/phải đổi workspace, lên = toàn màn hình, xuống = đóng
U.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
U.gesture({ fingers = 3, direction = "up",         action = "fullscreen" })
U.gesture({ fingers = 3, direction = "down",       action = "close" })
