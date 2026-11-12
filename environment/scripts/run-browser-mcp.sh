#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/lib-root.sh"

if [ -f "${SCRIPT_DIR}/ensure-deps.sh" ]; then
  bash "${SCRIPT_DIR}/ensure-deps.sh"
fi

ROOT="${PW_CHROMIUM_ROOT}"
CLI="${ROOT}/node_modules/@playwright/mcp/cli.js"
CONFIG="${ROOT}/playwright-mcp.json"
SECRETS="${ROOT}/environment/playwright-mcp.secrets.env"
GEN="${ROOT}/environment/scripts/generate-secrets.sh"

umask 077
mkdir -p "${ROOT}/environment"
if [ ! -f "${SECRETS}" ]; then
  : >"${SECRETS}"
  chmod 600 "${SECRETS}"
fi
if [ -f "${GEN}" ]; then
  bash "${GEN}" || true
fi

if [ ! -f "${CLI}" ]; then
  echo "run-browser-mcp: missing ${CLI}" >&2
  exit 1
fi

HEADLESS_FLAG="${PLAYWRIGHT_CHROMIUM_HEADLESS:-0}"
export PLAYWRIGHT_MCP_CONFIG="${CONFIG}"
export PLAYWRIGHT_MCP_SECRETS_FILE="${SECRETS}"
unset PLAYWRIGHT_MCP_HEADLESS

MCP_ARGS=(--config "${CONFIG}" --secrets "${SECRETS}")
if [ "${HEADLESS_FLAG}" = "1" ] || [ "${HEADLESS_FLAG}" = "true" ]; then
  export PLAYWRIGHT_MCP_HEADLESS=true
  MCP_ARGS=(--headless "${MCP_ARGS[@]}")
  echo "run-browser-mcp: mode=headless (PLAYWRIGHT_CHROMIUM_HEADLESS)" >&2
else
  export PLAYWRIGHT_MCP_HEADLESS=false
  # shellcheck source=ensure-display.sh
  . "${SCRIPT_DIR}/ensure-display.sh"
  echo "run-browser-mcp: mode=headed DISPLAY=${DISPLAY:-unset}" >&2
fi

exec node "${CLI}" "${MCP_ARGS[@]}"
