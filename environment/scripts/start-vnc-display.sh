#!/usr/bin/env bash
# headed 用に :1 へ TigerVNC + XFCE を idempotent に起動する。
# Pod で X が落ちている／未起動のとき、cron・MCP の前に呼ぶ。
set -euo pipefail

export DISPLAY="${DISPLAY:-:1}"
export LIBGL_ALWAYS_SOFTWARE="${LIBGL_ALWAYS_SOFTWARE:-1}"
export GALLIUM_DRIVER="${GALLIUM_DRIVER:-llvmpipe}"

display_ok() {
  xdpyinfo -display "${DISPLAY}" >/dev/null 2>&1
}

vnc_running() {
  pgrep -f "Xtigervnc ${DISPLAY}( |$)" >/dev/null 2>&1
}

start_xfce_session() {
  [[ -x /tmp/anyos-xstartup ]] || return 0
  pgrep -x xfwm4 >/dev/null 2>&1 && return 0
  display_ok || return 0
  echo "start-vnc-display: launching XFCE via anyos-xstartup" >&2
  nohup dbus-launch --exit-with-session /tmp/anyos-xstartup >>/tmp/xfce-start.log 2>&1 &
}

xsock="/tmp/.X11-unix/X${DISPLAY#:}"
if [[ -S "${xsock}" ]] && ! display_ok; then
  echo "start-vnc-display: stale socket for ${DISPLAY}, stopping old VNC" >&2
  vncserver -kill "${DISPLAY}" 2>/dev/null || true
fi

if ! display_ok && ! vnc_running; then
  xstartup="${PW_VNC_XSTARTUP:-/tmp/anyos-xstartup}"
  vnc_args=(
    "${DISPLAY}"
    -SecurityTypes
    None
    -geometry
    1920x1080
    -depth
    24
    -localhost
    yes
  )
  if [[ -x "${xstartup}" ]]; then
    vnc_args+=(-xstartup "${xstartup}")
  fi
  echo "start-vnc-display: starting vncserver on ${DISPLAY}" >&2
  vncserver "${vnc_args[@]}"
  for _ in $(seq 1 45); do
    display_ok && break
    sleep 1
  done
fi

if display_ok; then
  start_xfce_session
  for _ in $(seq 1 30); do
    display_ok && pgrep -x xfwm4 >/dev/null 2>&1 && break
    start_xfce_session
    sleep 2
  done
fi

if display_ok; then
  wm=down
  pgrep -x xfwm4 >/dev/null 2>&1 && wm=up
  echo "start-vnc-display: DISPLAY=${DISPLAY} xdpyinfo=ok xfwm4=${wm}" >&2
  exit 0
fi

echo "start-vnc-display: could not start responsive display ${DISPLAY}" >&2
exit 1
