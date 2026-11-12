#!/usr/bin/env bash
# エージェント起動時（environment.json の start）に実行する。
# Environment にバインドされた Secret を dotenv に書き、Playwright MCP の --secrets で読む。
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SECRETS_FILE="${ROOT}/environment/playwright-mcp.secrets.env"
TMP="${SECRETS_FILE}.tmp.$$"

umask 077
: >"${TMP}"

written=0

# Cloud Agent: バインド済み Secret 名の一覧が注入される
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
    else
      echo "generate-secrets: skip ${key} (not in env)" >&2
    fi
  done
else
  echo "generate-secrets: CLOUD_AGENT_*_SECRET_NAMES unset (local?); leaving dotenv empty" >&2
fi

install -m 600 "${TMP}" "${SECRETS_FILE}"
rm -f "${TMP}"

if [ "${written}" -eq 0 ]; then
  echo "generate-secrets: wrote 0 entries to environment/playwright-mcp.secrets.env" >&2
else
  echo "generate-secrets: wrote ${written} entries to environment/playwright-mcp.secrets.env" >&2
fi

export PLAYWRIGHT_MCP_HEADLESS=true
export PLAYWRIGHT_MCP_CONFIG="${ROOT}/playwright-mcp.json"
export PLAYWRIGHT_MCP_SECRETS_FILE="${SECRETS_FILE}"
