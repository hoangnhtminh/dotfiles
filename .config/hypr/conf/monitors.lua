-- Màn hình. Scale số nguyên (1/2) nhẹ GPU hơn scale lẻ (wiki: Performance).
-- Xem tên màn hình:  hyprctl monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Ví dụ cố định độ phân giải/tần số quét:
-- hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })
