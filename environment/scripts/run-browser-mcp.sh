#!/usr/bin/env bash
# Build スナップショットの @playwright/mcp を、headless + config + secrets 付きで起動する。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CLI="${ROOT}/node_modules/@playwright/mcp/cli.js"
CONFIG="${ROOT}/playwright-mcp.json"
SECRETS="${ROOT}/environment/playwright-mcp.secrets.env"
GEN="${ROOT}/environment/scripts/generate-secrets.sh"

# MCP は start と並行起動されうるため、起動直前に secrets を必ず用意する
if [ -f "${GEN}" ]; then
  bash "${GEN}"
elif [ ! -f "${SECRETS}" ]; then
  umask 077
  : >"${SECRETS}"
  chmod 600 "${SECRETS}"
fi

if [ ! -f "${CLI}" ]; then
  echo "run-browser-mcp: missing ${CLI} (run Environment Build install)" >&2
  exit 1
fi

if [ ! -f "${SECRETS}" ]; then
  echo "run-browser-mcp: missing ${SECRETS}" >&2
  exit 1
fi

export PLAYWRIGHT_MCP_HEADLESS=true
export PLAYWRIGHT_MCP_CONFIG="${CONFIG}"
export PLAYWRIGHT_MCP_SECRETS_FILE="${SECRETS}"

exec node "${CLI}" \
  --headless \
  --config "${CONFIG}" \
  --secrets "${SECRETS}"
