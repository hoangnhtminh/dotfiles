-- ============================================================
--  KEYBIND  (đã gỡ các phím trùng của bản cũ)
--  Super+L khóa màn hình + movefocus right  ->  khóa = Super+Ctrl+L
--  Super+J togglesplit + movefocus down      ->  togglesplit = Super+O
-- ============================================================
local P   = require("conf.programs")
local U   = require("conf.util")
local mod = "SUPER"

local function run(cmd) return hl.dsp.exec_cmd(cmd) end

-- Mọi bind đều qua pcall: 1 phím/dispatcher sai không làm mất các phím phía sau.
local function bind(keys, action, opts)
    if action == nil then return end
    local ok, err = pcall(hl.bind, keys, action, opts)
    if not ok then U.errors[#U.errors + 1] = "bind " .. keys .. ": " .. tostring(err) end
end

-- Dùng cho dispatcher có tham số dễ đổi giữa các bản: truyền vào 1 hàm tạo dispatcher.
local function make(fn)
    local ok, act = pcall(fn)
    if ok then return act end
    U.errors[#U.errors + 1] = "dispatcher: " .. tostring(act)
    return nil
end

-- ── Cửa sổ ───────────────────────────────────────────────────
bind(mod .. " + Q",         hl.dsp.window.close())
bind(mod .. " + SHIFT + Q", make(function() return hl.dsp.window.kill() end))   -- SIGKILL cửa sổ treo
bind(mod .. " + F", make(function() return hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }) end)
                    or make(function() return hl.dsp.window.fullscreen() end))
bind(mod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
bind(mod .. " + P",         hl.dsp.window.pseudo())
bind(mod .. " + O",         hl.dsp.layout("togglesplit"))

-- ── Chương trình ─────────────────────────────────────────────
bind(mod .. " + Return",         run(P.terminal))
bind(mod .. " + SHIFT + Return", run(P.terminal2))
bind(mod .. " + E",              run(P.filemanager))
bind(mod .. " + SHIFT + Y",      run(P.tui_files))
bind(mod .. " + B",              run(P.browser))
bind(mod .. " + T",              run(P.editor))
bind(mod .. " + Z",              run("zathura"))

-- ── Launcher / tiện ích ──────────────────────────────────────
bind(mod .. " + Space",         run(P.launcher))
bind(mod .. " + SHIFT + R",     run(P.runner))
bind(mod .. " + SHIFT + E",     run(P.emoji))
bind(mod .. " + V",             run(P.clipboard))
bind(mod .. " + C",             run(P.calc))
bind(mod .. " + SHIFT + C",     run(P.colorpick))
bind(mod .. " + W",             run(P.wallpaper))
bind(mod .. " + Escape",        run(P.powermenu))
bind(mod .. " + CTRL + L",      run(P.lock))
bind(mod .. " + Y",             run(P.sunset))              -- bảo vệ mắt
bind(mod .. " + N",             run("makoctl restore"))     -- xem lại thông báo gần nhất
bind(mod .. " + SHIFT + N",     run(P.dnd))                 -- bật/tắt Không làm phiền
bind(mod .. " + CTRL + N",      run("makoctl dismiss --all"))
bind(mod .. " + comma",         run("pkill -SIGUSR1 waybar"))  -- ẩn/hiện thanh bar
bind(mod .. " + SHIFT + B",     run(P.backup))

-- ── Chụp / quay màn hình ─────────────────────────────────────
bind(mod .. " + SHIFT + S", run(P.screenshot .. " area"))
bind("Print",               run(P.screenshot .. " full"))
bind("SHIFT + Print",       run(P.screenshot .. " area"))
bind(mod .. " + Print",     run(P.screenshot .. " window"))
bind(mod .. " + G",         run(P.record .. " full"))
bind(mod .. " + SHIFT + G", run(P.record .. " area"))

-- ── Reload cấu hình ──────────────────────────────────────────
bind(mod .. " + SHIFT + F5", function() hl.dispatch(hl.dsp.reload_config()) end)

-- ── Focus / di chuyển / đổi cỡ (vim + mũi tên) ──────────────
local dirs = {
    { "h", "left",  "left"  }, { "j", "down", "down" },
    { "k", "up",    "up"    }, { "l", "right", "right" },
}
for _, d in ipairs(dirs) do
    local vim, arrow, dir = d[1], d[2], d[3]
    for _, key in ipairs({ vim, arrow }) do
        bind(mod .. " + " .. key,             hl.dsp.focus({ direction = dir }))
        bind(mod .. " + SHIFT + " .. key,     hl.dsp.window.move({ direction = dir }))
    end
end

local step = 40
local resize = {
    { "h", "left",  -step, 0 }, { "l", "right", step, 0 },
    { "k", "up",    0, -step }, { "j", "down",  0, step },
}
for _, r in ipairs(resize) do
    for _, key in ipairs({ r[1], r[2] }) do
        bind(mod .. " + ALT + " .. key,
            make(function() return hl.dsp.window.resize({ x = r[3], y = r[4], relative = true }) end),
            { repeating = true })
    end
end

-- ── Workspace ────────────────────────────────────────────────
for i = 1, 10 do
    local key = i % 10   -- phím 0 -> workspace 10
    bind(mod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    bind(mod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end
bind(mod .. " + Tab",         hl.dsp.focus({ workspace = "e+1" }))
bind(mod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "e-1" }))
bind(mod .. " + mouse_down",  hl.dsp.focus({ workspace = "e+1" }))
bind(mod .. " + mouse_up",    hl.dsp.focus({ workspace = "e-1" }))

bind(mod .. " + S", make(function() return hl.dsp.workspace.toggle_special("scratch") end))
bind(mod .. " + M", make(function() return hl.dsp.workspace.toggle_special("music") end))

-- ── Chuột ────────────────────────────────────────────────────
bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── Âm lượng / sáng / media ──────────────────────────────────
local rep = { locked = true, repeating = true }
local lck = { locked = true }
bind("XF86AudioRaiseVolume",  run("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), rep)
bind("XF86AudioLowerVolume",  run("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),        rep)
bind("XF86AudioMute",         run("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       lck)
bind("XF86AudioMicMute",      run("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),     lck)
bind("XF86MonBrightnessUp",   run("brightnessctl set +10%"), rep)
bind("XF86MonBrightnessDown", run("brightnessctl set 10%-"), rep)
bind("XF86AudioPlay",         run("playerctl play-pause"),   lck)
bind("XF86AudioNext",         run("playerctl next"),         lck)
bind("XF86AudioPrev",         run("playerctl previous"),     lck)
