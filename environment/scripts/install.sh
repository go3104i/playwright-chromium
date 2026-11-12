#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "${ROOT}"

echo "install: ROOT=${ROOT}"

npm install --no-save @playwright/mcp@latest playwright@latest
npx playwright install --with-deps chromium

chmod +x environment/scripts/*.sh

if [ ! -f "${ROOT}/node_modules/@playwright/mcp/cli.js" ]; then
  echo "install: FAIL missing cli.js" >&2
  exit 1
fi

bash "${ROOT}/environment/scripts/materialize-runtime-tree.sh"

echo "install: OK"
