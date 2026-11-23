-- Giao diện. Mặc định: PHẲNG, không blur/bóng/dim -> nhẹ GPU nhất.
-- Máy mạnh hơn? đổi FANCY = true để bật blur + bóng đổ.
local U = require("conf.util")
local C = require("conf.colors")

local FANCY = false

U.config({
    general = {
        gaps_in     = 3,
        gaps_out    = 6,
        border_size = 2,
        col = {
            active_border   = { colors = { C.rgba(C.orange, "ee"), C.rgba(C.orange2, "aa") }, angle = 45 },
            inactive_border = C.rgba(C.surf, "aa"),
        },
        resize_on_border        = true,
        extend_border_grab_area = 15,
        layout        = "dwindle",
        allow_tearing = false,
    },

    decoration = {
        rounding           = 4,
        active_opacity     = 1.0,
        inactive_opacity   = 1.0,
        fullscreen_opacity = 1.0,
        dim_inactive       = false,

        shadow = {
            enabled      = FANCY,
            range        = 16,
            render_power = 3,
            color        = C.rgba(C.bg_dark, "99"),
        },

        blur = {
            enabled = FANCY,
            size    = 4,
            passes  = 2,
            noise   = 0.015,
            new_optimizations = true,
            xray    = true,
        },
    },
})
