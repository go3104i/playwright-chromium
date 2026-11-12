#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/lib-root.sh"

ROOT="${PW_CHROMIUM_ROOT}"
SECRETS_FILE="${ROOT}/environment/playwright-mcp.secrets.env"
TMP="${SECRETS_FILE}.tmp.$$"

umask 077
: >"${TMP}"

written=0
SECRET_LIST="${CLOUD_AGENT_INJECTED_SECRET_NAMES:-${CLOUD_AGENT_ALL_SECRET_NAMES:-}}"

if [ -n "${SECRET_LIST}" ]; then
  IFS=',' read -ra KEYS <<<"${SECRET_LIST}"
  for key in "${KEYS[@]}"; do
    key="${key#"${key%%[![:space:]]*}"}"
    key="${key%"${key##*[![:space:]]}"}"
    [ -n "${key}" ] || continue
    val="${!key:-}"
    if [ -n "${val}" ]; then
      printf '%s=%s\n' "${key}" "${val}" >>"${TMP}"
      written=$((written + 1))
    fi
  done
else
  echo "generate-secrets: CLOUD_AGENT_*_SECRET_NAMES unset" >&2
fi

mkdir -p "$(dirname "${SECRETS_FILE}")"
if command -v install >/dev/null 2>&1; then
  install -m 600 "${TMP}" "${SECRETS_FILE}"
else
  mv "${TMP}" "${SECRETS_FILE}"
  chmod 600 "${SECRETS_FILE}"
fi
rm -f "${TMP}"
echo "generate-secrets: wrote ${written} entries (${SECRETS_FILE})" >&2

export PLAYWRIGHT_MCP_HEADLESS=true
export PLAYWRIGHT_MCP_CONFIG="${ROOT}/playwright-mcp.json"
export PLAYWRIGHT_MCP_SECRETS_FILE="${SECRETS_FILE}"
