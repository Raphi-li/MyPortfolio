#!/bin/sh
# Converts an image to WebP, optionally cropped, max width.
# Usage: to-webp.sh <in> <out.webp> [maxwidth=2000] [quality=82] [crop "x y w h"]
set -eu
in=$1; out=$2; max=${3:-2000}; q=${4:-82}; crop=${5:-}
command -v cwebp >/dev/null || { echo "cwebp missing (brew install webp)" >&2; exit 4; }
src=$in
case $(printf '%s' "$in" | tr 'A-Z' 'a-z') in
  *.heic|*.heif|*.gif|*.bmp|*.psd)
    tmp=$(mktemp -d); src="$tmp/in.png"; sips -s format png "$in" --out "$src" >/dev/null ;;
esac
w=$(sips -g pixelWidth "$src" | awk '/pixelWidth/ { print $2 }')
[ -n "$crop" ] && w=$(echo "$crop" | awk '{ print $3 }')
resize=""
[ "$w" -gt "$max" ] && resize="-resize $max 0"
# shellcheck disable=SC2086
cwebp -quiet -q "$q" ${crop:+-crop $crop} $resize "$src" -o "$out"
sips -g pixelWidth -g pixelHeight "$out" | awk '/pixel/ { printf "%s ", $2 }'; du -k "$out" | awk '{ print $1 " KB" }'
