#!/usr/bin/env bash
# One-command bootstrap for Ember Rice. Run as the target user, never as root.
set -Eeuo pipefail
REPO='https://github.com/hoangnhtminh/dotfiles.git'
DEST="$HOME/.local/share/ember-rice"

if [[ $EUID -eq 0 ]]; then
  echo 'Không chạy bootstrap bằng root. Hãy chạy bằng tài khoản thường có sudo.' >&2
  exit 1
fi
command -v git >/dev/null || { echo 'Cần git. Cài bằng: sudo pacman -S git' >&2; exit 1; }

mkdir -p "$(dirname "$DEST")"
if [[ -d "$DEST/.git" ]]; then
  git -C "$DEST" pull --ff-only
elif [[ -e "$DEST" ]]; then
  mv "$DEST" "${DEST}.backup.$(date +%Y%m%d_%H%M%S)"
  git clone --depth=1 "$REPO" "$DEST"
else
  git clone --depth=1 "$REPO" "$DEST"
fi
exec "$DEST/install.sh" "$@"
