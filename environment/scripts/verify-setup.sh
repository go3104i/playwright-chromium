#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/lib-root.sh"
ROOT="${PW_CHROMIUM_ROOT}"
SECRETS="${ROOT}/environment/playwright-mcp.secrets.env"
fail=0
check() { echo "OK: $*"; }
warn() { echo "WARN: $*" >&2; }
fail_msg() { echo "FAIL: $*" >&2; fail=1; }
echo "INFO: PW_CHROMIUM_ROOT=${ROOT}"
[[ -f "${SECRETS}" ]] && check "secrets file exists" || fail_msg "secrets file missing"
[[ -f "${ROOT}/node_modules/@playwright/mcp/cli.js" ]] && check "cli present" || fail_msg "missing @playwright/mcp"
pgrep -af "@playwright/mcp" 2>/dev/null | grep -q -- '--secrets' && check "MCP has --secrets" || warn "MCP not running with --secrets"
exit "${fail}"
