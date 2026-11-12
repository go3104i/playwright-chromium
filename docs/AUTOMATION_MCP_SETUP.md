# Automation MCP

**Customize（Dashboard）の `wrapped-playwright` と、リポの `.cursor/mcp.json` を同じにする。**

```json
{
  "name": "wrapped-playwright",
  "type": "stdio",
  "command": "bash",
  "args": [
    "/agent/repos/playwright-chromium/environment/scripts/wrapped-playwright-mcp-launcher.sh"
  ]
}
```

代替（Build が `/usr/local/bin` まで入れた場合）:

```json
{
  "args": ["/usr/local/bin/wrapped-playwright-mcp"]
}
```

**禁止:** `verify-setup.sh`、`/opt/.../run-browser-mcp.sh` 直指定、`environment/scripts/...` の相対パス。

**必須:** Environment **playwright-chromium** の Build **成功 → Activate**（`node_modules` が VM に載ること）。
