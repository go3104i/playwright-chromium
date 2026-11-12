# Automation に wrapped-playwright を登録する

## Automation に stdio MCP を追加

```json
{
  "name": "wrapped-playwright",
  "type": "stdio",
  "command": "bash",
  "args": ["/opt/playwright-chromium/environment/scripts/run-browser-mcp.sh"]
}
```

Build 後は install 結果が **`/opt/playwright-chromium`** にあります（タスク用リポだけ checkout しても残る）。

## 確認

```bash
bash /opt/playwright-chromium/environment/scripts/verify-setup.sh
```

Build → Activate → Automation **新規実行**。
