#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/lib-root.sh"
CLI="${PW_CHROMIUM_ROOT}/node_modules/@playwright/mcp/cli.js"
if [ -f "${CLI}" ]; then exit 0; fi
echo "ensure-deps: npm install (re-Build recommended)" >&2
cd "${PW_CHROMIUM_ROOT}"
npm install --no-save @playwright/mcp@latest playwright@latest
npx playwright install --with-deps chromium
node environment/scripts/patch-playwright-mcp-headless.js
