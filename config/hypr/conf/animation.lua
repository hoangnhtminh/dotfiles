-- Animation ngắn + không có vòng lặp liên tục (bản cũ có "borderangle loop"
-- khiến GPU vẽ lại màn hình mãi, vô hiệu hoá luôn misc.vfr).
local U = require("conf.util")

U.config({ animations = { enabled = true } })

local function curve(name, x1, y1, x2, y2)
    U.try("curve " .. name, hl.curve, name, { type = "bezier", points = { { x1, y1 }, { x2, y2 } } })
end
curve("easeOut",   0.0, 0.0, 0.2, 1.0)
curve("easeIn",    0.4, 0.0, 1.0, 1.0)
curve("easeInOut", 0.4, 0.0, 0.2, 1.0)
curve("linear",    0.0, 0.0, 1.0, 1.0)

local function anim(leaf, speed, bezier, style)
    U.try("animation " .. leaf, hl.animation, {
        leaf = leaf, enabled = true, speed = speed, bezier = bezier, style = style,
    })
end
anim("windowsIn",        3, "easeOut",   "popin 90%")
anim("windowsOut",       2, "easeIn",    "popin 90%")
anim("windowsMove",      3, "easeOut")
anim("border",           4, "linear")
anim("fade",             3, "easeOut")
anim("workspaces",       3, "easeInOut", "slide")
anim("specialWorkspace", 3, "easeInOut", "slidevert")
anim("layers",           2, "easeOut",   "fade")
