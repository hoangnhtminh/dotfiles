#!/usr/bin/env bash
# ============================================================
# Ember Rice — Arch Linux + Hyprland 0.57+ (Lua)
# Full installer: packages, dotfiles, system tuning, Ly on tty2.
# Run as a regular user; sudo is requested only when required.
# ============================================================
set -Eeuo pipefail
trap 'echo -e "\033[0;31m[✗]\033[0m Lỗi ở dòng $LINENO: $BASH_COMMAND" >&2' ERR

REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
STAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$HOME/.dotfiles-backup/${STAMP}_$$"
DO_PKGS=1; DO_SYSTEM=1; LINK=0; WITH_LSP=0; WITH_GRAPHITE=0
FAILED=()

GREEN='\033[0;32m'; ORANGE='\033[0;33m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${ORANGE}[!]${NC} $*"; }
die()  { echo -e "${RED}[✗]${NC} $*" >&2; exit 1; }

for arg in "$@"; do
    case "$arg" in
        --no-packages) DO_PKGS=0 ;;
        --no-system)   DO_SYSTEM=0 ;;
        --link)        LINK=1 ;;
        --lsp)         WITH_LSP=1 ;;
        --graphite)    WITH_GRAPHITE=1 ;;
        -h|--help)
            cat <<'HELP'
Ember Rice installer
  ./install.sh                 Cài đầy đủ (mặc định)
  --no-packages                Không cài gói
  --no-system                  Không sửa /etc, sysctl, zram hoặc dịch vụ
  --link                       Symlink cấu hình thay vì sao chép
  --lsp                        Cài thêm language servers
  --graphite                   Cài GTK Graphite từ AUR
HELP
            exit 0 ;;
        *) die "Tuỳ chọn không hợp lệ: $arg" ;;
    esac
done

[[ $EUID -ne 0 ]] || die 'Không chạy bằng root; hãy chạy bằng tài khoản thường có sudo.'
[[ -f /etc/arch-release ]] || die 'Bộ cài này dành cho Arch Linux.'
command -v sudo >/dev/null || die 'Cần cài sudo trước.'
[[ -d "$REPO_DIR/.config/hypr" ]] || die 'Không tìm thấy .config/hypr trong repository.'
sudo -v

log '🍊 Ember Rice — bắt đầu cài đặt'

# Gói cần từ kho chính thức. Gói không có trong repo sẽ được thử qua AUR.
PKGS=(
    # Hyprland và đăng nhập
    hyprland ly hyprlock hypridle hyprpicker hyprpolkitagent
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xorg-xwayland xorg-xrandr
    # Giao diện
    waybar rofi rofi-emoji mako awww
    # Terminal / shell
    foot kitty zsh zsh-autosuggestions zsh-syntax-highlighting zsh-completions
    starship fastfetch bat eza zoxide fzf fd ripgrep btop
    # File / media
    thunar thunar-archive-plugin tumbler gvfs yazi ffmpegthumbnailer poppler imagemagick unarchiver
    zathura zathura-pdf-mupdf imv mpv playerctl
    # Wayland utilities
    grim slurp swappy jq wl-clipboard cliphist wf-recorder brightnessctl libnotify libqalculate gammastep
    # Audio
    pipewire pipewire-pulse pipewire-alsa wireplumber pavucontrol
    # Fonts / icons
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji papirus-icon-theme qt6ct
    # Vietnamese input
    fcitx5 fcitx5-unikey fcitx5-gtk fcitx5-qt fcitx5-configtool
    # Base tools
    neovim git curl base-devel unzip firefox zram-generator xdg-user-dirs
)
AUR_PKGS=(papirus-folders bibata-cursor-theme-bin)
LSP_PKGS=(clang lua-language-server pyright bash-language-server)
GRAPHITE_PKGS=(graphite-gtk-theme-git)
(( WITH_LSP )) && PKGS+=("${LSP_PKGS[@]}")
(( WITH_GRAPHITE )) && AUR_PKGS+=("${GRAPHITE_PKGS[@]}")

install_yay() {
    command -v yay >/dev/null && return 0
    log 'Cài yay-bin để xử lý các gói AUR...'
    local tmp
    tmp=$(mktemp -d)
    if ! git clone --depth=1 https://aur.archlinux.org/yay-bin.git "$tmp/yay-bin"; then
        rm -rf "$tmp"; die 'Không tải được yay-bin từ AUR.'
    fi
    (cd "$tmp/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$tmp"
    command -v yay >/dev/null || die 'Cài yay thất bại.'
}

install_packages() {
    log 'Đồng bộ và cập nhật Arch Linux (pacman -Syu)...'
    sudo pacman -Syu --noconfirm

    local repo=() aur=("${AUR_PKGS[@]}") p
    for p in "${PKGS[@]}"; do
        if pacman -Si "$p" >/dev/null 2>&1; then repo+=("$p"); else aur+=("$p"); fi
    done
    log "Cài ${#repo[@]} gói từ repository chính thức..."
    sudo pacman -S --needed --noconfirm "${repo[@]}"

    if ((${#aur[@]})); then
        install_yay
        log "Cài ${#aur[@]} gói AUR..."
        for p in "${aur[@]}"; do
            if yay -S --needed --noconfirm "$p"; then
                log "Đã cài: $p"
            else
                warn "Không cài được gói AUR: $p"
                FAILED+=("$p")
            fi
        done
    fi
}

backup_and_place() {
    local src="$1" dst="$2"
    if [[ -L "$dst" ]] && [[ "$(readlink -f "$dst" 2>/dev/null || true)" == "$(readlink -f "$src")" ]]; then return 0; fi
    if (( ! LINK )) && [[ ! -L "$dst" ]] && [[ -e "$dst" ]] && diff -rq "$src" "$dst" >/dev/null 2>&1; then return 0; fi
    if [[ -e "$dst" || -L "$dst" ]]; then
        local rel="${dst#"$HOME"/}"
        mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
        mv "$dst" "$BACKUP_DIR/$rel"
        warn "Đã sao lưu cấu hình cũ: ~/$rel"
    fi
    mkdir -p "$(dirname "$dst")"
    if (( LINK )); then ln -s "$src" "$dst"; else cp -a "$src" "$dst"; fi
}

check_hyprland() {
    local bin ver major minor patch
    bin=$(command -v Hyprland || command -v hyprland || true)
    [[ -n "$bin" ]] || die 'Không tìm thấy Hyprland sau bước cài gói.'
    ver=$("$bin" --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1 || true)
    [[ -n "$ver" ]] || die 'Không đọc được phiên bản Hyprland.'
    IFS=. read -r major minor patch <<< "$ver"
    patch=${patch:-0}
    if (( major == 0 && minor < 57 )); then
        die "Hyprland $ver chưa hỗ trợ cấu hình Lua yêu cầu của Ember Rice. Cần >= 0.57. Hãy cập nhật Arch rồi chạy lại."
    fi
    log "Hyprland $ver — đạt yêu cầu cấu hình Lua."
}

install_dotfiles() {
    log 'Cài cấu hình Ember Rice vào ~/.config ...'
    mkdir -p "$HOME/.config"
    local item name f
    for item in "$REPO_DIR"/.config/*; do
        [[ -e "$item" ]] || continue
        name=$(basename "$item")
        case "$name" in
            gtk-3.0|gtk-4.0)
                mkdir -p "$HOME/.config/$name"
                for f in "$item"/*; do [[ -e "$f" ]] && backup_and_place "$f" "$HOME/.config/$name/$(basename "$f")"; done
                ;;
            *) backup_and_place "$item" "$HOME/.config/$name" ;;
        esac
    done
    for f in .zshrc .zprofile; do
        [[ -f "$REPO_DIR/$f" ]] && backup_and_place "$REPO_DIR/$f" "$HOME/$f"
    done
    chmod +x "$HOME/.config/scripts"/*.sh 2>/dev/null || true
    mkdir -p "$HOME/Pictures/Wallpapers" "$HOME/Pictures/Screenshots" "$HOME/Videos/Recordings"
    command -v xdg-user-dirs-update >/dev/null && xdg-user-dirs-update || true
    log 'Đã triển khai cấu hình.'
}

backup_etc_file() {
    local f="$1"
    if sudo test -e "$f"; then sudo cp -a "$f" "${f}.ember-backup-${STAMP}"; fi
}

configure_ly() {
    log 'Cấu hình Ly trên TTY2...'
    # Ly hiện dùng service template ly@ttyX.service trên Arch.
    if ! systemctl list-unit-files 'ly@.service' --no-legend 2>/dev/null | grep -q 'ly@'; then
        warn 'Không tìm thấy ly@.service; đã cài gói ly nhưng chưa thể bật dịch vụ. Kiểm tra pacman -Ql ly.'
        return 0
    fi
    sudo systemctl disable --now getty@tty2.service >/dev/null 2>&1 || true
    # Tắt display manager khác nếu đã bật để tránh tranh quyền màn hình đăng nhập.
    local dm
    for dm in display-manager.service sddm.service gdm.service lightdm.service lxdm.service greetd.service emptty.service; do
        if systemctl is-enabled "$dm" >/dev/null 2>&1; then
            sudo systemctl disable --now "$dm" >/dev/null 2>&1 || warn "Không thể tắt dịch vụ đăng nhập cũ: $dm"
        fi
    done
    sudo systemctl enable ly@tty2.service
    log 'Đã bật ly@tty2.service; màn hình đăng nhập sẽ xuất hiện sau khi khởi động lại.'
}

tune_system() {
    log 'Tinh chỉnh hệ thống nhẹ cho desktop...'
    backup_etc_file /etc/systemd/zram-generator.conf
    sudo install -d /etc/systemd
    sudo tee /etc/systemd/zram-generator.conf >/dev/null <<'ZRAM'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
ZRAM

    backup_etc_file /etc/sysctl.d/99-ember.conf
    sudo tee /etc/sysctl.d/99-ember.conf >/dev/null <<'SYSCTL'
vm.swappiness = 100
vm.page-cluster = 0
vm.vfs_cache_pressure = 50
SYSCTL
    sudo systemctl daemon-reload
    sudo sysctl --system >/dev/null
    sudo systemctl start systemd-zram-setup@zram0.service >/dev/null 2>&1 || warn 'zram sẽ được khởi tạo khi khởi động lại.'

    # Không tự bật dịch vụ CPU/pin trên máy bàn.
    if getent group video >/dev/null; then sudo gpasswd -a "$USER" video >/dev/null || true; fi
    if command -v papirus-folders >/dev/null; then
        papirus-folders -C orange --theme Papirus-Dark || warn 'Không đổi được màu thư mục Papirus.'
    fi
    if [[ "$(basename "${SHELL:-bash}")" != zsh ]] && command -v zsh >/dev/null; then
        chsh -s "$(command -v zsh)" || warn 'Không đổi được shell mặc định; chạy: chsh -s /usr/bin/zsh'
    fi
    if (( WITH_GRAPHITE )) && [[ -d /usr/share/themes/Graphite-orange-Dark ]]; then
        sed -i 's/^gtk-theme-name=.*/gtk-theme-name=Graphite-orange-Dark/' "$HOME/.config/gtk-3.0/settings.ini" 2>/dev/null || true
    fi
    configure_ly
}

if (( DO_PKGS )); then install_packages; fi
# Luôn kiểm tra trước khi ghi cấu hình Lua; --no-packages đòi hỏi Hyprland có sẵn.
check_hyprland
install_dotfiles
if (( DO_SYSTEM )); then tune_system; fi

echo
log '🍊 Ember Rice đã được cài đặt.'
[[ -d "$BACKUP_DIR" ]] && warn "Cấu hình cũ được lưu tại: $BACKUP_DIR"
if ((${#FAILED[@]})); then
    warn "Các gói AUR chưa cài được: ${FAILED[*]}"
    warn "Có thể thử lại: yay -S ${FAILED[*]}"
fi
cat <<'NEXT'

Bước tiếp theo:
  1. Khởi động lại máy: sudo reboot
  2. Ly xuất hiện trên TTY2; đăng nhập tài khoản của bạn.
  3. Chọn phiên Hyprland nếu Ly hiển thị danh sách session.
  4. Thêm ảnh vào ~/Pictures/Wallpapers và nhấn Super+W.
  5. Mở nvim lần đầu để lazy.nvim tải plugin (cần Internet).

Nếu cấu hình có lỗi: hyprctl configerrors
Nếu Ly không xuất hiện: systemctl status ly@tty2.service
NEXT
