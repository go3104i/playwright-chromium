#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "${SCRIPT_DIR}/lib-root.sh"
ROOT="${PW_CHROMIUM_ROOT}"
TARGET="/opt/playwright-chromium"
if [ -e "${TARGET}" ] && [ ! -L "${TARGET}" ]; then
  echo "link-opt: ${TARGET} exists and is not a symlink" >&2
  exit 1
fi
if command -v sudo >/dev/null 2>&1; then
  sudo ln -sfn "${ROOT}" "${TARGET}"
else
  ln -sfn "${ROOT}" "${TARGET}" 2>/dev/null || true
fi
