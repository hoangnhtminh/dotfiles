-- Chương trình mặc định. Đổi ở đây, keybinding tự cập nhật.
-- Foot là terminal chính (khởi động nhanh, ít RAM); kitty để dành khi cần ảnh/ligature.
local S = "~/.config/scripts/"

-- Bấm lần nữa để đóng rofi
local function rofi(mode, theme)
    return "pkill -x rofi || rofi -show " .. mode .. " -theme ~/.config/rofi/" .. theme .. ".rasi"
end

return {
    terminal    = "foot",
    terminal2   = "kitty",
    filemanager = "thunar",
    browser     = "firefox",
    editor      = "foot -e nvim",
    tui_files   = "foot -e yazi",

    launcher  = rofi("drun",  "launcher"),
    runner    = rofi("run",   "runner"),
    emoji     = rofi("emoji", "emoji"),
    clipboard = S .. "clipboard.sh",
    calc      = S .. "calc.sh",
    powermenu = S .. "powermenu.sh",

    wallpaper  = S .. "wallpaper.sh pick",
    screenshot = S .. "screenshot.sh",
    record     = S .. "record.sh",
    sunset     = S .. "sunset-toggle.sh toggle",
    dnd        = S .. "dnd.sh toggle",
    backup     = S .. "backup.sh",
    colorpick  = "hyprpicker -a",
    lock       = "pidof hyprlock || hyprlock",
    S          = S,
}
