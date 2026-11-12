#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib-root.sh
. "${SCRIPT_DIR}/lib-root.sh"
ROOT="${PW_CHROMIUM_ROOT}"
SECRETS="${ROOT}/environment/playwright-mcp.secrets.env"
fail=0
check() { echo "OK: $*"; }
warn() { echo "WARN: $*" >&2; }
fail_msg() { echo "FAIL: $*" >&2; fail=1; }
echo "INFO: PW_CHROMIUM_ROOT=${ROOT}"
[[ -f "${SECRETS}" ]] && check "secrets file" || warn "secrets file missing (start で生成)"
[[ -f "${ROOT}/node_modules/@playwright/mcp/cli.js" ]] && check "cli" || fail_msg "missing @playwright/mcp (Build install)"
exit "${fail}"
