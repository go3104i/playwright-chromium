# playwright-chromium

**Cursor Cloud Agent / Automations 向けの共通 Environment 定義**です。

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
