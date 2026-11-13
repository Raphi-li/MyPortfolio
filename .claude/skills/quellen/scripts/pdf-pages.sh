#!/bin/sh
# Renders PDF pages to PNG.  Usage: pdf-pages.sh <file.pdf> <outdir> [first] [last] [dpi]
set -eu
f=$1; out=$2; first=${3:-1}; last=${4:-$first}; dpi=${5:-150}
command -v pdftoppm >/dev/null || { echo "pdftoppm missing (brew install poppler)" >&2; exit 4; }
mkdir -p "$out"
pdftoppm -r "$dpi" -png -f "$first" -l "$last" "$f" "$out/page"
ls -1 "$out"/page*.png
