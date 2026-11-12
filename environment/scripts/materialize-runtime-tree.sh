#!/usr/bin/env bash
# Build の install で /opt に実体を置く（symlink は Automation 起動パスとズレる）
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib-root.sh
. "${SCRIPT_DIR}/lib-root.sh"

ROOT="${PW_CHROMIUM_ROOT}"
DEST="/opt/playwright-chromium"

if [ ! -f "${ROOT}/node_modules/@playwright/mcp/cli.js" ]; then
  echo "materialize: missing ${ROOT}/node_modules/@playwright/mcp/cli.js" >&2
  exit 1
fi

echo "materialize: ROOT=${ROOT} -> ${DEST}"

sudo rm -rf "${DEST}"
sudo mkdir -p "${DEST}"
# Build イメージに rsync が無いことがあるため cp を使う
sudo cp -a "${ROOT}/." "${DEST}/"
sudo rm -rf "${DEST}/.git" 2>/dev/null || true

sudo tee /usr/local/bin/wrapped-playwright-mcp >/dev/null <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
exec bash /opt/playwright-chromium/environment/scripts/run-browser-mcp.sh
EOF
sudo chmod 755 /usr/local/bin/wrapped-playwright-mcp

echo "materialize: OK (${DEST}, /usr/local/bin/wrapped-playwright-mcp)"
