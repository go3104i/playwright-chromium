# playwright-chromium

図書館など **ブラウザ Automation 用の Cursor Environment**（Chromium + Playwright MCP）。

- デフォルト **headed**（`PLAYWRIGHT_CHROMIUM_HEADLESS=1` で headless）
- **Build → Activate** 後、cwd はこのリポジトリルート想定

## MCP（Automation Customize）

```json
{
  "command": "bash",
  "args": ["environment/scripts/run-browser-mcp.sh"]
}
```

`.cursor/mcp.json` と同じにする。

確認: `bash environment/scripts/verify-setup.sh`

## cron / Automation（headed 安定化）

Pod 起動時の `start`（`environment/scripts/start-agent.sh`）は、`:1` に TigerVNC が無い／落ちている場合に `start-vnc-display.sh` で VNC + XFCE を起動してから `wait-display-ready.sh` で待機します。MCP 起動時（`ensure-display.sh`）も同じ起動スクリプトへフォールバックします。

手動確認:

```bash
bash environment/scripts/start-agent.sh
bash environment/scripts/verify-setup.sh   # xdpyinfo :1 / xfwm4 が OK
```

`PLAYWRIGHT_CHROMIUM_HEADLESS` は設定しない（headed 必須）。
