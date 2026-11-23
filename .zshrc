# ~/.zshrc — gọn, khởi động nhanh. (Bản cũ tự ghi vào ~/.zprofile mỗi lần mở zsh -> đã bỏ.)
[[ $- != *i* ]] && return

# ── Lịch sử ──────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history share_history hist_ignore_all_dups hist_reduce_blanks hist_ignore_space
setopt interactive_comments auto_cd
bindkey -e

# ── Biến môi trường ──────────────────────────────────────────
export EDITOR=nvim VISUAL=nvim
export BAT_THEME="gruvbox-dark"
typeset -U path                       # PATH không bị lặp
path=("$HOME/.local/bin" "$HOME/competitive" $path)

# ── Completion (cache, chỉ dựng lại sau 24h) ─────────────────
fpath=(/usr/share/zsh/site-functions $fpath)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# ── fzf (màu theo bảng Ember) ────────────────────────────────
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded \
--color=bg:#1a1512,bg+:#3a2c22,fg:#e8d5c4,fg+:#e8d5c4,hl:#e8824a,hl+:#e8824a \
--color=info:#b89880,prompt:#e8824a,pointer:#e8824a,marker:#e8c24a,spinner:#e8824a,header:#7a5c45,border:#7a5c45"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --color=always {}'"
[[ -r /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -r /usr/share/fzf/completion.zsh   ]] && source /usr/share/fzf/completion.zsh

# ── Công cụ ──────────────────────────────────────────────────
command -v zoxide   >/dev/null && eval "$(zoxide init zsh)"
command -v starship >/dev/null && eval "$(starship init zsh)"

# ── Alias ────────────────────────────────────────────────────
alias cat='bat --paging=never'
alias ls='eza --icons'
alias ll='eza -lh --icons'
alias la='eza -lah --icons'
alias lt='eza --tree --level=2 --icons'
alias vim='nvim'
alias top='btop'
alias update='sudo pacman -Syu'
alias gs='git status' ga='git add' gc='git commit' gp='git push' gl='git pull'
alias dlspot='~/.config/scripts/dlspot.sh'
alias dlmusic='~/.config/scripts/dlmusic.sh'
# (đã bỏ alias grep='rg' và find='fd': khác cờ lệnh, làm hỏng lệnh quen thuộc. Dùng thẳng rg / fd.)

# Gỡ gói mồ côi (không lỗi khi không còn gói nào)
cleanup() {
    local orphans; orphans=$(pacman -Qtdq)
    [[ -z $orphans ]] && { echo "Không có gói mồ côi."; return; }
    sudo pacman -Rns $orphans
}

# ── Plugin từ pacman (không cần zinit/git clone). syntax-highlighting PHẢI nạp cuối ──
[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
    && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
    && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
