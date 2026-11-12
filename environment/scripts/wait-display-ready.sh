#!/usr/bin/env bash
# Pod 起動時: 応答する X と XFCE (xfwm4) が揃うまで待つ。start / run-browser-mcp から呼ぶ。
set -euo pipefail

export DISPLAY="${DISPLAY:-:1}"
export LIBGL_ALWAYS_SOFTWARE="${LIBGL_ALWAYS_SOFTWARE:-1}"
export GALLIUM_DRIVER="${GALLIUM_DRIVER:-llvmpipe}"

display_ok() {
  xdpyinfo -display "${DISPLAY}" >/dev/null 2>&1
}

desktop_ok() {
  display_ok && pgrep -x xfwm4 >/dev/null 2>&1
}

maybe_start_xfce() {
  [[ -x /tmp/anyos-xstartup ]] || return 0
  pgrep -x xfwm4 >/dev/null 2>&1 && return 0
  display_ok || return 0
  if pgrep -x Xtigervnc >/dev/null 2>&1 || pgrep -f "Xvnc.*${DISPLAY}" >/dev/null 2>&1; then
    :
  elif [[ -S "/tmp/.X11-unix/X${DISPLAY#:}" ]]; then
    :
  else
    return 0
  fi
  nohup dbus-launch --exit-with-session /tmp/anyos-xstartup >>/tmp/xfce-start.log 2>&1 &
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

deadline=$((SECONDS + 120))
while (( SECONDS < deadline )); do
  if desktop_ok; then
    echo "wait-display-ready: OK DISPLAY=${DISPLAY} xfwm4 up" >&2
    exit 0
  fi
  bash "${SCRIPT_DIR}/start-vnc-display.sh" || true
  maybe_start_xfce
  sleep 2
done

echo "wait-display-ready: timeout DISPLAY=${DISPLAY} (xdpyinfo=$(display_ok && echo ok || echo fail) xfwm4=$(pgrep -x xfwm4 >/dev/null && echo up || echo down))" >&2
exit 1
