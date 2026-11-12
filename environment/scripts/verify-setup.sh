#!/usr/bin/env bash
# Active Build + start 後の疎通確認（秘密値は表示しない）
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SECRETS="${ROOT}/environment/playwright-mcp.secrets.env"
WRAPPER="${ROOT}/environment/scripts/run-browser-mcp.sh"
fail=0

check() {
  echo "OK: $*"
}

warn() {
  echo "WARN: $*" >&2
}

fail_msg() {
  echo "FAIL: $*" >&2
  fail=1
}

if [[ -f "${SECRETS}" ]]; then
  check "secrets file exists (${SECRETS})"
  stat -c '     mode=%a size=%s' "${SECRETS}" 2>/dev/null || stat -f '     mode=%Lp size=%z' "${SECRETS}"
  entry_count="$(grep -c '=' "${SECRETS}" 2>/dev/null || true)"
  if [ "${entry_count}" -gt 0 ]; then
    check "dotenv has ${entry_count} entries"
  else
    warn "dotenv is empty (no bound secrets at start?)"
  fi
else
  fail_msg "secrets file missing — run start or: bash environment/scripts/generate-secrets.sh"
fi

if grep -q 'run-browser-mcp.sh' "${ROOT}/.cursor/mcp.json" 2>/dev/null; then
  check "repo .cursor/mcp.json references run-browser-mcp.sh"
else
  warn "repo .cursor/mcp.json does not reference run-browser-mcp.sh (Automation uses Dashboard MCP)"
fi

if [ -x "${WRAPPER}" ]; then
  check "run-browser-mcp.sh is executable"
else
  fail_msg "run-browser-mcp.sh missing or not executable"
fi

if [[ -f /tmp/cursor/start-user/start-user.log ]]; then
  if grep -q 'generate-secrets' /tmp/cursor/start-user/start-user.log; then
    check "start-user.log mentions generate-secrets"
  else
    warn "start-user.log exists but no generate-secrets line"
  fi
else
  warn "no /tmp/cursor/start-user/start-user.log (start may not have run yet)"
fi

if pgrep -af "@playwright/mcp|playwright-mcp" 2>/dev/null | grep -q -- '--secrets'; then
  check "running Playwright MCP process includes --secrets"
else
  warn "running Playwright MCP lacks --secrets — use wrapped-playwright (wrapper) and a new agent run"
fi

exit "${fail}"
