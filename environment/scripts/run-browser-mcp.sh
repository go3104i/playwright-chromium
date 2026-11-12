#!/usr/bin/env bash
# Build スナップショットの @playwright/mcp を、headless + config + secrets 付きで起動する。
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib-root.sh
. "${SCRIPT_DIR}/lib-root.sh"

ROOT="${PW_CHROMIUM_ROOT}"
CLI="${ROOT}/node_modules/@playwright/mcp/cli.js"
CONFIG="${ROOT}/playwright-mcp.json"
SECRETS="${ROOT}/environment/playwright-mcp.secrets.env"
GEN="${ROOT}/environment/scripts/generate-secrets.sh"

if [ -f "${GEN}" ]; then
  bash "${GEN}"
elif [ ! -f "${SECRETS}" ]; then
  umask 077
  mkdir -p "${ROOT}/environment"
  : >"${SECRETS}"
  chmod 600 "${SECRETS}"
fi

if [ ! -f "${CLI}" ]; then
  echo "run-browser-mcp: missing ${CLI} (Build install or /opt/playwright-chromium?)" >&2
  exit 1
fi

export PLAYWRIGHT_MCP_HEADLESS=true
export PLAYWRIGHT_MCP_CONFIG="${CONFIG}"
export PLAYWRIGHT_MCP_SECRETS_FILE="${SECRETS}"

exec node "${CLI}" \
  --headless \
  --config "${CONFIG}" \
  --secrets "${SECRETS}"
