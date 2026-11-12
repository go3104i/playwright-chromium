# shellcheck disable=SC2034
if [ -f /opt/playwright-chromium/node_modules/@playwright/mcp/cli.js ]; then
  PW_CHROMIUM_ROOT=/opt/playwright-chromium
elif [ -f "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/node_modules/@playwright/mcp/cli.js" ]; then
  PW_CHROMIUM_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
else
  PW_CHROMIUM_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi
