# Automation MCP

推奨（短いパス）:

```json
{
  "name": "wrapped-playwright",
  "type": "stdio",
  "command": "bash",
  "args": ["/usr/local/bin/wrapped-playwright-mcp"]
}
```

`/opt/...`（どちらでも可。Build の `install` が **`/opt/playwright-chromium` に実体を rsync**）:

```json
{
  "args": ["/opt/playwright-chromium/environment/scripts/run-browser-mcp.sh"]
}
```

**必須:** Environment **playwright-chromium** で Build が **成功し Activate 済み**。`defaultImageFallback` / `no_finished_builds` のままでは MCP は必ず失敗します。

確認: `bash /opt/playwright-chromium/environment/scripts/verify-setup.sh`
