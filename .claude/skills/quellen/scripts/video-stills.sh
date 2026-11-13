#!/bin/sh
# Extracts evenly spaced stills from a video.  Usage: video-stills.sh <video> <outdir> [count]
# Needs ffmpeg/ffprobe; without them it falls back to one Quick Look thumbnail.
set -eu
f=$1; out=$2; n=${3:-6}
mkdir -p "$out"
if command -v ffmpeg >/dev/null && command -v ffprobe >/dev/null; then
  dur=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$f")
  i=1
  while [ "$i" -le "$n" ]; do
    t=$(awk -v d="$dur" -v i="$i" -v n="$n" 'BEGIN { printf "%.2f", d * (i - 0.5) / n }')
    ffmpeg -v error -y -ss "$t" -i "$f" -frames:v 1 -vf "scale='min(2000,iw)':-2" "$out/still-$i.png"
    i=$((i + 1))
  done
else
  echo "ffmpeg not installed (brew install ffmpeg) - using one Quick Look thumbnail" >&2
  qlmanage -t -s 1600 -o "$out" "$f" >/dev/null 2>&1
fi
ls -1 "$out"
