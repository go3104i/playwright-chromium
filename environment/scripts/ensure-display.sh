#!/usr/bin/env bash
# headed 起動用: Cloud Agent VM の DISPLAY が未設定なら推測する
set -euo pipefail

if [ -n "${DISPLAY:-}" ]; then
  exit 0
fi

for d in ":99" ":1" ":0"; do
  xsock="/tmp/.X11-unix/X${d#:}"
  if [ -S "${xsock}" ]; then
    export DISPLAY="${d}"
    echo "ensure-display: DISPLAY=${DISPLAY}" >&2
    exit 0
  fi
 done

export DISPLAY="${DISPLAY:-:99}"
echo "ensure-display: fallback DISPLAY=${DISPLAY}" >&2
