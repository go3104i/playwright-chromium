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

export PLAYWRIGHT_MCP_HEADLESS=true
export PLAYWRIGHT_MCP_CONFIG="${CONFIG}"
export PLAYWRIGHT_MCP_SECRETS_FILE="${SECRETS}"

exec node "${CLI}" --headless --config "${CONFIG}" --secrets "${SECRETS}"
