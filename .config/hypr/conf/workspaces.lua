-- 5 workspace cố định (khớp waybar); 6-10 xuất hiện khi dùng tới.
local U = require("conf.util")

for i = 1, 5 do
    U.ws({ workspace = tostring(i), persistent = true, default = (i == 1) or nil })
end

-- Scratchpad (Super+S) và music (Super+M)
U.ws({ workspace = "special:scratch", on_created_empty = "foot --app-id=scratch" })
U.ws({ workspace = "special:music",   on_created_empty = "spotify" })

-- "Smart gaps": chỉ có 1 cửa sổ thì bỏ gap/viền/bo góc -> rộng hơn, ít vẽ hơn
U.ws({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
U.ws({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
U.rule({ name = "no-gaps-wtv1", match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
U.rule({ name = "no-gaps-f1",   match = { float = false, workspace = "f[1]"   }, border_size = 0, rounding = 0 })
