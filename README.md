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
