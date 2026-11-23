-- Tiện ích dùng chung: bọc lệnh hl.* bằng pcall để 1 dòng lỗi không phá cả file.
local U = { errors = {} }

local function guarded(label, fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then U.errors[#U.errors + 1] = label .. ": " .. tostring(err) end
    return ok and err or nil
end

function U.config(tbl)  return guarded("hl.config",      hl.config, tbl)         end
function U.rule(tbl)    return guarded("window_rule",    hl.window_rule, tbl)    end
function U.layer(tbl)   return guarded("layer_rule",     hl.layer_rule, tbl)     end
function U.ws(tbl)      return guarded("workspace_rule", hl.workspace_rule, tbl) end
function U.gesture(tbl) return guarded("gesture",        hl.gesture, tbl)        end
function U.try(label, fn, ...) return guarded(label, fn, ...) end

return U
