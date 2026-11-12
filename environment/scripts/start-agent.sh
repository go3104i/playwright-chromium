#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

bash "${SCRIPT_DIR}/generate-secrets.sh"
bash "${SCRIPT_DIR}/start-vnc-display.sh" || true
bash "${SCRIPT_DIR}/wait-display-ready.sh"
