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
  echo "install: FAIL missing cli.js" >&2
  exit 1
fi

WRAPPER="${ROOT}/environment/scripts/run-browser-mcp.sh"
if command -v sudo >/dev/null 2>&1; then
  sudo ln -sf "${WRAPPER}" /usr/local/bin/wrapped-playwright-mcp
else
  ln -sf "${WRAPPER}" /usr/local/bin/wrapped-playwright-mcp 2>/dev/null || true
fi

bash "${ROOT}/environment/scripts/link-opt.sh"

echo "install: OK"
