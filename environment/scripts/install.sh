#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${ROOT}"

echo "install: ROOT=${ROOT}"

npm install --no-save @playwright/mcp@latest playwright@latest
npx playwright install --with-deps chromium

node environment/scripts/patch-playwright-mcp-headless.js
chmod +x environment/scripts/*.sh

if [ ! -f "${ROOT}/node_modules/@playwright/mcp/cli.js" ]; then
  echo "install: FAIL missing workspace cli.js" >&2
  exit 1
fi

mkdir -p /opt/playwright-chromium
cp -a "${ROOT}/." /opt/playwright-chromium/

PW_CHROMIUM_ROOT=/opt/playwright-chromium node environment/scripts/patch-playwright-mcp-headless.js

if [ ! -f /opt/playwright-chromium/node_modules/@playwright/mcp/cli.js ]; then
  echo "install: FAIL missing /opt cli.js" >&2
  exit 1
fi

if command -v sudo >/dev/null 2>&1; then
  sudo ln -sf /opt/playwright-chromium/environment/scripts/run-browser-mcp.sh /usr/local/bin/wrapped-playwright-mcp
else
  ln -sf /opt/playwright-chromium/environment/scripts/run-browser-mcp.sh /usr/local/bin/wrapped-playwright-mcp
fi

echo "install: OK"
