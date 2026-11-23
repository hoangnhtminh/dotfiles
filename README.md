# 🍊 Ember Rice — Hyprland dotfiles (Arch, máy yếu)

Bản viết lại của `Dotfiles-hyprland`: **giữ nguyên bố cục và phong cách cam ấm**, cập nhật cho
**Hyprland 0.57+ (cấu hình Lua)** và tối ưu cho máy cấu hình thấp.

> ⚠️ Từ Hyprland **0.57** file `hyprland.conf` không còn được đọc. Cấu hình mới là `~/.config/hypr/hyprland.lua`.
> `hypridle.conf` và `hyprlock.conf` vẫn dùng cú pháp cũ (không phải Lua).

## Cài đặt một lệnh (Arch Linux)

Sau khi cài Arch Linux, tạo tài khoản người dùng có quyền `sudo`, có Internet và quyền `sudo`, chạy trực tiếp một dòng sau (tự cài `curl` và `git` nếu còn thiếu):

```bash
sudo pacman -S --needed --noconfirm curl git && bash <(curl -fsSL https://raw.githubusercontent.com/hoangnhtminh/dotfiles/main/bootstrap.sh)
```

Lệnh trên tải `bootstrap.sh`, clone repository vào `~/.local/share/ember-rice`, sau đó chạy `install.sh`. Bộ cài sẽ:

1. Cập nhật hệ thống bằng `pacman -Syu`.
2. Cài các gói chính thức; cài `yay` để xử lý các gói AUR còn lại.
3. Kiểm tra Hyprland **0.57 trở lên** trước khi triển khai cấu hình Lua.
4. Sao lưu cấu hình hiện có vào `~/.dotfiles-backup/` rồi cài Ember Rice.
5. Thiết lập zram, sysctl và Ly trên `tty2`.
6. Tắt `getty@tty2` và display manager khác đang bật để Ly có thể quản lý màn hình đăng nhập.

**Đăng nhập:** khởi động lại máy, Ly sẽ xuất hiện ở TTY2. Chọn phiên Hyprland nếu danh sách phiên được hiển thị. Không chạy bộ cài bằng `root`; script tự gọi `sudo` khi cần.

> Lưu ý: đường dẫn một lệnh ở trên chỉ hoạt động sau khi bạn tải toàn bộ repository này lên GitHub công khai, đúng tài khoản `hoangnhtminh`, tên repository `dotfiles`, nhánh `main`. Nếu repository đang private hoặc tên/nhánh khác, cần sửa URL trong lệnh và `bootstrap.sh` cho khớp.

### Cài từ bản ZIP hoặc repository đã clone

```bash
cd Dotfiles-hyprland
chmod +x install.sh bootstrap.sh
./install.sh
```

Tuỳ chọn: `--no-packages` · `--no-system` · `--link` · `--lsp` · `--graphite`. Mặc định là cài đầy đủ, gồm Ly. `--no-packages` yêu cầu Hyprland 0.57+ và các ứng dụng đã có sẵn. `--no-system` không chỉnh zram/sysctl và không bật Ly.

## Cấu trúc (giữ thứ tự cũ)

```
.config/
├── hypr/
│   ├── hyprland.lua        # điểm vào: nạp các module bên dưới theo thứ tự
│   ├── hypridle.conf       # (mới) tối màn hình 2.5' → khóa 5' → tắt màn hình 5.5' → ngủ 15'
│   ├── hyprlock.conf       # (mới) màn hình khóa nền đặc, không blur
│   └── conf/               # monitors, environment, input, appearance, animation,
│                           # layout, misc, windowrule, workspaces, keybinding, autostart,
│                           # + programs (chương trình mặc định), colors, util
├── colors/                 # theme.css (waybar) · color.rasi (rofi) — cùng bảng màu "Ember"
├── waybar/  rofi/  mako/   # thanh bar · launcher · thông báo
├── foot/  kitty/           # terminal (foot là chính)
├── nvim/  yazi/  zathura/  bat/  fastfetch/  starship.toml  gtk-3.0/  gtk-4.0/
└── scripts/                # wallpaper, screenshot, record, sunset-toggle, dnd, powermenu,
                            # clipboard, calc, dpms, gtk-init, backup, dlmusic, dlspot
.zshrc  .zprofile  install.sh
```

## Phím tắt

| Phím | Chức năng | Phím | Chức năng |
|---|---|---|---|
| `Super+Return` | Terminal (foot) | `Super+Space` | Launcher |
| `Super+Shift+Return` | Kitty | `Super+Shift+R` | Chạy lệnh |
| `Super+E` / `Super+Shift+Y` | Thunar / Yazi | `Super+V` | Lịch sử clipboard |
| `Super+B` / `Super+T` / `Super+Z` | Firefox / nvim / zathura | `Super+C` | Máy tính (qalc) |
| `Super+Q` | Đóng cửa sổ | `Super+Shift+E` | Emoji |
| `Super+Shift+Q` | Kill cửa sổ treo | `Super+Shift+C` | Chọn màu |
| `Super+F` / `Super+Shift+F` | Toàn màn hình / nổi | `Super+W` | Chọn hình nền |
| `Super+O` | Đổi hướng chia (togglesplit) | `Super+Escape` | Menu nguồn |
| `Super+P` | Pseudotile | `Super+Ctrl+L` | **Khóa màn hình** |
| `Super+h/j/k/l` hoặc mũi tên | Đổi focus | `Super+Y` | Bảo vệ mắt |
| `Super+Shift+h/j/k/l` | Dời cửa sổ | `Super+N` | Xem lại thông báo |
| `Super+Alt+h/j/k/l` | Đổi cỡ cửa sổ | `Super+Shift+N` | Không làm phiền |
| `Super+1…0` / `+Shift` | Tới / chuyển cửa sổ sang workspace | `Super+Ctrl+N` | Xoá hết thông báo |
| `Super+Tab`, cuộn chuột | Workspace kế/trước | `Super+,` | Ẩn/hiện waybar |
| `Super+S` / `Super+M` | Scratchpad / Spotify | `Super+Shift+F5` | Reload config |
| `Super+Shift+S` | Chụp vùng (có swappy) | `Print` / `Shift+Print` / `Super+Print` | Toàn màn hình / vùng / cửa sổ |
| `Super+G` / `Super+Shift+G` | Quay màn hình / quay vùng | `Super+Shift+B` | Sao lưu config |

Chuột: `Super + kéo trái` di chuyển, `Super + kéo phải` đổi cỡ. Cử chỉ touchpad 3 ngón: trái/phải đổi workspace, lên = toàn màn hình, xuống = đóng.

## Đã tối ưu cho máy yếu

- **Phẳng theo mặc định**: tắt blur, bóng đổ, dim; animation ngắn; bỏ animation `borderangle` chạy vòng lặp (nó khiến GPU vẽ lại liên tục, vô hiệu `vfr`). Máy mạnh hơn: đặt `FANCY = true` trong `conf/appearance.lua`.
- `vfr = true`, `vrr = 0`, scale số nguyên, smart gaps (1 cửa sổ → không gap/viền).
- Thay thế bằng bản nhẹ hơn: **mako** (thay swaync), **rofi power menu** (thay wlogout), **starship** (thay oh-my-posh), **fzf-lua + mini.files** (thay telescope + neo-tree), **foot** làm terminal chính.
- Bỏ: cava (không dùng), noice/notify/dashboard/bufferline/indent-blankline trong nvim, treesitter plugin (dùng bản tích hợp sẵn của Neovim), zinit (plugin zsh lấy từ pacman, không `git clone` lúc mở shell).
- Waybar tối giản (workspace, tên cửa sổ, đồng hồ, tray, âm lượng, bảo vệ mắt, DND, nguồn); sunset/DND cập nhật bằng **tín hiệu**, không polling mỗi 5 giây.
- Hệ thống: **zram** (`ram/2`, zstd) với `vm.swappiness=100` (bản cũ đặt 10 → zram gần như không được dùng), `page-cluster=0`.
- Thông báo, ảnh nền, polkit đều khởi động từ `autostart.lua`; `gtk-init.sh` chỉ ghi gsettings khi giá trị khác.

## Khác với bản cũ

| Cũ | Mới | Lý do |
|---|---|---|
| `hyprland.conf` + `conf/*.conf` | `hyprland.lua` + `conf/*.lua` | 0.57 bỏ hyprlang |
| `swww` | `awww` | dự án đã đổi tên thành awww |
| `rofi-wayland` | `rofi` | rofi 2.0 đã tích hợp Wayland |
| `uwsm finalize` | (bỏ) | không dùng uwsm nên lệnh này vô nghĩa |
| `polkit-gnome` | `hyprpolkitagent` | agent chính thức của Hyprland |
| `Super+L` khóa + focus phải | khóa = `Super+Ctrl+L` | trùng phím |
| `Super+J` togglesplit + focus xuống | togglesplit = `Super+O` | trùng phím |
| `alias grep=rg`, `find=fd` | (bỏ) | đổi cờ lệnh, làm hỏng lệnh quen thuộc; dùng thẳng `rg`/`fd` |
| `.zshrc` ghi vào `~/.zprofile` mỗi lần mở shell | `.zprofile` 1 khối duy nhất | file cũ bị lặp 273 lần |
| `GTK_IM_MODULE=fcitx` | (bỏ) | trên Wayland có thể gây lỗi gõ tiếng Việt ở app GTK |
| `rofi-calc` (AUR) | `calc.sh` + `qalc` | bỏ phụ thuộc plugin ngoài |
| Catppuccin lẫn lộn (nvim/bat/fzf) | một bảng màu Ember (gruvbox-dark cho nvim/bat) | đồng nhất |
| 3 launcher script thừa, `kitty/config` trùng, `Monitors`, `errors*.txt`, `cacl.rasi` | đã xoá | rác |

Giữ lại ảnh/preview trong thư mục `assets/` của repo cũ nếu muốn (không nằm trong gói này).

## Xử lý sự cố

- Có thông báo đỏ khi vào Hyprland → `hyprctl configerrors` hoặc `cat ~/.cache/hypr-config-errors.log`. Mỗi module Lua được nạp riêng, nên một lỗi chỉ làm mất phần của module/dòng đó.
- Waybar trống/lỗi style → chạy `waybar` trong terminal để xem log.
- Không gõ được tiếng Việt → mở `fcitx5-configtool`, thêm bộ gõ **Unikey**.
- Ảnh nền không đổi → `awww query`; nếu daemon chưa chạy: `awww-daemon &` rồi `Super+W`.
- Sau lần đầu mở `nvim` (cần mạng), commit `~/.config/nvim/lazy-lock.json` để khoá phiên bản plugin.

## Lưu ý

Bộ này được viết dựa trên wiki chính thức của Hyprland (0.57), Arch Wiki và tài liệu của từng công cụ,
**nhưng chưa được chạy thử trên phần cứng thật**. Tên gói/tuỳ chọn có thể thay đổi; `install.sh` sẽ cảnh báo thay vì dừng khi thiếu gói.
