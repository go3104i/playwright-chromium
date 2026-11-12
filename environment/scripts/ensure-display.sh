#!/usr/bin/env bash
# headed 用 DISPLAY。run-browser-mcp.sh から source される（exit しない）
set -euo pipefail

if [ -n "${DISPLAY:-}" ]; then
  return 0 2>/dev/null || exit 0
fi

for d in ":99" ":1" ":0"; do
  xsock="/tmp/.X11-unix/X${d#:}"
  if [ -S "${xsock}" ]; then
    export DISPLAY="${d}"
    echo "ensure-display: DISPLAY=${DISPLAY}" >&2
    return 0 2>/dev/null || exit 0
  fi
done

export DISPLAY="${DISPLAY:-:99}"
echo "ensure-display: fallback DISPLAY=${DISPLAY}" >&2
