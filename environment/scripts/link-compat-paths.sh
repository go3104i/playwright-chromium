#!/usr/bin/env bash
# install / start: 絶対パスで MCP を起動できるよう symlink を張る
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib-root.sh
. "${SCRIPT_DIR}/lib-root.sh"

ROOT="${PW_CHROMIUM_ROOT}"
WRAPPER="${ROOT}/environment/scripts/run-browser-mcp.sh"

link_one() {
  local target="$1"
  local link="$2"
  if command -v sudo >/dev/null 2>&1; then
    sudo ln -sf "${target}" "${link}"
  else
    ln -sf "${target}" "${link}"
  fi
}

link_one "${WRAPPER}" /usr/local/bin/wrapped-playwright-mcp
link_one "${ROOT}" /opt/playwright-chromium

echo "link-compat-paths: OK (/usr/local/bin/wrapped-playwright-mcp, /opt/playwright-chromium -> ${ROOT})"
