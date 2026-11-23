#!/usr/bin/env bash
# Sao lưu cấu hình hiện tại ra ~/backup/dotfiles/backup_<ngày>.tar.gz
set -u

DEST_DIR="$HOME/backup/dotfiles"
DATE=$(date +%Y%m%d_%H%M%S)
STAGE=$(mktemp -d)
mkdir -p "$DEST_DIR"

ITEMS=(
    ".config/hypr" ".config/waybar" ".config/rofi" ".config/mako" ".config/foot"
    ".config/kitty" ".config/colors" ".config/fastfetch" ".config/starship.toml"
    ".config/scripts" ".config/nvim" ".config/yazi" ".config/zathura" ".config/bat"
    ".zshrc" ".zprofile"
)

for item in "${ITEMS[@]}"; do
    if [ -e "$HOME/$item" ]; then
        mkdir -p "$STAGE/$(dirname "$item")"
        cp -a "$HOME/$item" "$STAGE/$(dirname "$item")/"
        echo "✓ $item"
    else
        echo "✗ không có: $item"
    fi
done

OUT="$DEST_DIR/backup_$DATE.tar.gz"
tar -czf "$OUT" -C "$STAGE" .
rm -rf "$STAGE"
echo "✓ $OUT ($(du -sh "$OUT" | cut -f1))"
command -v notify-send >/dev/null && notify-send "💾 Backup" "Đã lưu $OUT" -t 3000
