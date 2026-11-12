#!/usr/bin/env bash
# headed 用 DISPLAY。run-browser-mcp.sh から source される（exit しない）
set -euo pipefail

export LIBGL_ALWAYS_SOFTWARE="${LIBGL_ALWAYS_SOFTWARE:-1}"
export GALLIUM_DRIVER="${GALLIUM_DRIVER:-llvmpipe}"

wait_xdpyinfo() {
  local d="${1}"
  local i
  for i in $(seq 1 60); do
    if xdpyinfo -display "${d}" >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done
  return 1
}

if [ -n "${DISPLAY:-}" ]; then
  if wait_xdpyinfo "${DISPLAY}"; then
    echo "ensure-display: DISPLAY=${DISPLAY} (already set, xdpyinfo ok)" >&2
    return 0 2>/dev/null || exit 0
  fi
  echo "ensure-display: DISPLAY=${DISPLAY} set but xdpyinfo failed; re-probing" >&2
  unset DISPLAY
fi

for d in ":1" ":0"; do
  xsock="/tmp/.X11-unix/X${d#:}"
  if [ -S "${xsock}" ]; then
    if wait_xdpyinfo "${d}"; then
      export DISPLAY="${d}"
      echo "ensure-display: DISPLAY=${DISPLAY}" >&2
      return 0 2>/dev/null || exit 0
    fi
    echo "ensure-display: stale socket ${xsock}, skip" >&2
  fi
done

echo "ensure-display: no responsive display (not falling back to :99)" >&2
return 1 2>/dev/null || exit 1
