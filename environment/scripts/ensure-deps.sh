#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/lib-root.sh"

CLI="${PW_CHROMIUM_ROOT}/node_modules/@playwright/mcp/cli.js"
[ -f "${CLI}" ] && exit 0

WS="$(cd "${SCRIPT_DIR}/../.." && pwd)"
[ -f "${WS}/node_modules/@playwright/mcp/cli.js" ] && exit 0

echo "ensure-deps: installing @playwright/mcp (trigger Environment re-Build)" >&2
cd "${WS}"
npm install --no-save @playwright/mcp@latest playwright@latest
npx playwright install --with-deps chromium
node environment/scripts/patch-playwright-mcp-headless.js

if [ -d /opt/playwright-chromium ]; then
  cp -a "${WS}/." /opt/playwright-chromium/
  PW_CHROMIUM_ROOT=/opt/playwright-chromium node environment/scripts/patch-playwright-mcp-headless.js
fi
