# playwright-chromium

**Cursor Cloud Agent / Automations 向けの共通 Environment 定義**です。

Chromium は **headed（デフォルト）** で起動します（一部サイトの headless 検知回避）。  
headless に戻すときは `PLAYWRIGHT_CHROMIUM_HEADLESS=1` を Environment に設定してください。

## Automation MCP（重要）

タスク用リポだけを checkout しても動くよう、Build は **`/opt/playwright-chromium`** にコピーします。

```json
{
  "command": "bash",
  "args": ["/opt/playwright-chromium/environment/scripts/run-browser-mcp.sh"]
}
```

確認: `bash /opt/playwright-chromium/environment/scripts/verify-setup.sh`

詳細: [docs/AUTOMATION_MCP_SETUP.md](docs/AUTOMATION_MCP_SETUP.md)
