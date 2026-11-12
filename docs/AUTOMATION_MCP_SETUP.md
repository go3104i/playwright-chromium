# Automation MCP

```json
{
  "name": "wrapped-playwright",
  "type": "stdio",
  "command": "bash",
  "args": ["/usr/local/bin/wrapped-playwright-mcp"]
}
```

Dashboard の MCP も **必ず** 上記を使う（`/opt/.../run-browser-mcp.sh` 直指定は起動時にパスが無く失敗しやすい）。

**必須:** Environment **playwright-chromium** で Build **成功 → Activate**。

確認: `bash /opt/playwright-chromium/environment/scripts/verify-setup.sh`（Build 後）
