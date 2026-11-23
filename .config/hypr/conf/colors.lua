-- Bảng màu "Ember" (cam ấm). Nguồn duy nhất cho phía Hyprland.
-- Các file khác dùng cùng giá trị: colors/theme.css (waybar), colors/color.rasi (rofi).
local C = {
    bg      = "1a1512", bg_dark = "0f0c0a", surf  = "241c17", float = "2e2218", hover = "3a2c22",
    fg      = "e8d5c4", fg_sub  = "b89880", fg_dim = "7a5c45",
    orange  = "e8824a", orange2 = "c4683a", orange3 = "9e4e26",
    yellow  = "e8c24a", red     = "e85a4a", green  = "8ac44a",
    blue    = "4a98e8", purple  = "9a4ae8", cyan   = "4ae8c2",
}

-- rgba("e8824a", "aa") -> "rgba(e8824aaa)"
function C.rgba(hex, alpha) return "rgba(" .. hex .. (alpha or "ff") .. ")" end

return C
