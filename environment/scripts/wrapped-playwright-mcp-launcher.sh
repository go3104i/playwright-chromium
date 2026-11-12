#!/usr/bin/env bash
# Automation MCP 入口。warm-fork では /agent/repos のみのことが多い。
set -euo pipefail

try_ensure() {
  local repo="$1"
  local ensure="${repo}/environment/scripts/ensure-deps.sh"
  [ -f "${ensure}" ] || return 0
  bash "${ensure}"
}

for repo in /agent/repos/playwright-chromium /opt/playwright-chromium; do
  [ -d "${repo}" ] || continue
  try_ensure "${repo}" || true
done

find_repo_root() {
  local cand
  for cand in \
    /agent/repos/playwright-chromium \
    /opt/playwright-chromium \
    "${PLAYWRIGHT_CHROMIUM_ROOT:-}"; do
    [ -n "${cand}" ] || continue
    [ -f "${cand}/environment/scripts/run-browser-mcp.sh" ] || continue
    [ -f "${cand}/node_modules/@playwright/mcp/cli.js" ] || continue
    echo "${cand}"
    return 0
  done
  return 1
}

try_materialize() {
  local src="$1"
  if [ ! -f "${src}/environment/scripts/materialize-runtime-tree.sh" ]; then
    return 1
  fi
  if [ ! -f "${src}/node_modules/@playwright/mcp/cli.js" ]; then
    return 1
  fi
  echo "wrapped-playwright-mcp: materialize from ${src}" >&2
  PW_CHROMIUM_ROOT="${src}" bash "${src}/environment/scripts/materialize-runtime-tree.sh"
}

ROOT=""
if ! ROOT="$(find_repo_root)"; then
  for try in /agent/repos/playwright-chromium /opt/playwright-chromium; do
    if [ -d "${try}" ] && try_materialize "${try}"; then
      ROOT="$(find_repo_root)" && break
    fi
  done
fi

if [ -z "${ROOT:-}" ]; then
  ROOT="$(find_repo_root)" || true
fi

if [ -z "${ROOT:-}" ]; then
  echo "wrapped-playwright-mcp: FAIL no @playwright/mcp (playwright-chromium Build を Activate)" >&2
  exit 1
fi

exec bash "${ROOT}/environment/scripts/run-browser-mcp.sh"
