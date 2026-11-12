# Automation MCP

Environment **`playwright-chromium`** を選び、Build **成功 → Activate**。

Customize の `wrapped-playwright`:

```json
{
  "command": "bash",
  "args": ["environment/scripts/run-browser-mcp.sh"]
}
```

`verify-setup.sh` は MCP にしない（診断用）。
