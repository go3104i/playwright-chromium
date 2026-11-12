# Automation MCP

**起動コマンドはこれだけでよい（Build が入れる）。**

```json
{
  "name": "wrapped-playwright",
  "type": "stdio",
  "command": "bash",
  "args": ["/usr/local/bin/wrapped-playwright-mcp"]
}
```

Customize（Dashboard）の Arguments も **必ず** 上記と同じにする。

## うまくいかないとき

`/usr/local/bin/wrapped-playwright-mcp` が無い = **この実行が Build スナップショット上で起動していない**（`materialize` が走った Activate 済み Build から boot していない）。

その場合 `/agent/repos/...` を Arguments に書いても、多くは **git checkout だけで `node_modules` が無く**同様に失敗する。対処は **Environment の Build 成功 → Activate** と Automation の **Environment = playwright-chromium** の確認。

**禁止:** `verify-setup.sh`（診断用・即終了）、相対パス `environment/scripts/...`
