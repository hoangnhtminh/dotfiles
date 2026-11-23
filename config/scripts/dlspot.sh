#!/usr/bin/env bash
# Tải nhạc Spotify bằng spotdl. Dùng: dlspot <spotify_url_hoặc_tên> [thư_mục]
set -eu
URL="${1:-}"; OUT="${2:-$HOME/Music}"
[ -z "$URL" ] && { echo "Usage: dlspot <spotify_url_or_name> [output_dir]"; exit 1; }

mkdir -p "$OUT"; cd "$OUT"
spotdl download "$URL" \
    --output "{artist}/{album}/{track-number} - {title}.{output-ext}" \
    --format mp3 --bitrate 320k --threads 4
notify-send "✓ SpotDL" "Đã tải vào $OUT" -t 3000
