-- ============================================================
--  HYPRLAND 0.57+  —  cấu hình Lua (hyprlang .conf đã bị bỏ)
--  Thứ tự nạp giữ nguyên như bản cũ: monitors → environment →
--  input → appearance → animation → layout → misc → windowrule →
--  workspaces → keybinding → autostart
--  Mỗi module nằm trong ./conf/*.lua. Lỗi ở 1 module KHÔNG làm
--  hỏng cả cấu hình: nó được gom lại và báo bằng notify-send.
-- ============================================================

local home = os.getenv("HOME")
local base = (os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")) .. "/hypr/"
package.path = base .. "?.lua;" .. base .. "?/init.lua;" .. package.path

local U = require("conf.util")

for _, name in ipairs({
    "monitors", "environment", "input", "appearance", "animation",
    "layout", "misc", "windowrule", "workspaces", "keybinding", "autostart",
}) do
    local ok, err = pcall(require, "conf." .. name)
    if not ok then U.errors[#U.errors + 1] = name .. ": " .. tostring(err) end
end

-- Báo lỗi (nếu có) sau khi mako đã chạy
if #U.errors > 0 then
    local msg = table.concat(U.errors, "\n")
    hl.on("hyprland.start", function()
        local f = io.open(home .. "/.cache/hypr-config-errors.log", "w")
        if f then f:write(msg, "\n"); f:close() end
        local quoted = "'" .. (msg:gsub("'", "'\\''")) .. "'"
        hl.exec_cmd("sleep 3 && notify-send -u critical 'Hyprland: lỗi cấu hình' " .. quoted)
    end)
end
