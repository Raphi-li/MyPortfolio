#!/bin/sh
# Prints the OneDrive root folder on this device.
# Override with PORTFOLIO_ONEDRIVE=<path>. Exit 3 if none is found.
if [ -n "$PORTFOLIO_ONEDRIVE" ] && [ -d "$PORTFOLIO_ONEDRIVE" ]; then
  echo "$PORTFOLIO_ONEDRIVE"; exit 0
fi
for d in "$HOME/Library/CloudStorage/OneDrive-Personal" "$HOME"/Library/CloudStorage/OneDrive-* "$HOME/OneDrive"; do
  if [ -d "$d" ]; then echo "$d"; exit 0; fi
done
echo "OneDrive folder not found on this device - set PORTFOLIO_ONEDRIVE or ask for the path" >&2
exit 3
