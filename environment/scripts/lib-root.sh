# shellcheck disable=SC2034
# Build スナップショットでは /opt/playwright-chromium にコピーされる。
# Automation が別リポだけ checkout しても /opt は消えない。
if [ -d /opt/playwright-chromium/node_modules/@playwright/mcp ]; then
  PW_CHROMIUM_ROOT=/opt/playwright-chromium
else
  PW_CHROMIUM_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
fi
