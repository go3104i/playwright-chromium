# playwright-chromium

**Cursor Cloud Agent / Automations 向けの共通 Environment 定義**です。

Chromium は **headed（デフォルト）** で起動します（一部サイトの headless 検知回避）。  
headless に戻すときは `PLAYWRIGHT_CHROMIUM_HEADLESS=1` を Environment に設定してください。

## Automation MCP（重要）

```json
{
  "command": "bash",
  "args": ["/usr/local/bin/wrapped-playwright-mcp"]
}
```

Build の install が `/opt/playwright-chromium` に実体を置き、上記ランチャーを `/usr/local/bin` に配置します。

確認: `bash /opt/playwright-chromium/environment/scripts/verify-setup.sh`

詳細: [docs/AUTOMATION_MCP_SETUP.md](docs/AUTOMATION_MCP_SETUP.md)
