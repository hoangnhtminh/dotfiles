#!/usr/bin/env bash
# Tải nhạc từ YouTube/… bằng yt-dlp. Dùng: dlmusic <url> [thư_mục]
set -eu
URL="${1:-}"; OUT="${2:-$HOME/Music}"
[ -z "$URL" ] && { echo "Usage: dlmusic <url> [output_dir]"; exit 1; }

yt-dlp -x --audio-format mp3 --audio-quality 0 \
    --embed-thumbnail --embed-metadata \
    --concurrent-fragments 4 \
    -o "$OUT/%(playlist_title|Singles)s/%(playlist_index|)s%(playlist_index& - |)s%(title)s.%(ext)s" \
    "$URL"
notify-send "✓ Download" "Đã tải vào $OUT" -t 3000
