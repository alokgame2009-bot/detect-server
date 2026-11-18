#!/usr/bin/env bash
set -euo pipefail

# Zyren Tech Server Detector - upstream fetch helper
# Author: Zyren
# Powered by Zyren Tech

SOURCE_URL="https://raw.githubusercontent.com/hopingboyz/linux/main/detect-server.sh"
DEST="./detect-server.sh"

printf '\n========================================\n'
printf '  Zyren Tech Server Detector\n'
printf '  Author: Zyren\n'
printf '  Powered by Zyren Tech\n'
printf '========================================\n\n'

if ! command -v curl >/dev/null 2>&1; then
  echo "Error: curl is required."
  exit 1
fi

curl -fsSL "$SOURCE_URL" -o "$DEST"
echo "Downloaded to: $DEST"
echo "Review the script before running it:"
printf '  less %q\n' "$DEST"
printf '\nPowered by Zyren Tech\n'
