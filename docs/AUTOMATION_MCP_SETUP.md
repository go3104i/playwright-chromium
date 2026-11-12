# Automation に wrapped-playwright を登録する

## 要点

- **Automations は `.cursor/mcp.json` を自動読み込みしません。** Dashboard で stdio MCP を登録してください。
- Plugin Managed の **Playwright プラグイン**（`npx` のみ）は secrets / headless が効かないことがあるため、**アンインストール**し、この Environment の **wrapper** だけを使います。
- MCP 名は **`wrapped-playwright`** にすること。`playwright` だと公式プラグインに置き換わることがあります。

## Environment

1. [Cursor Dashboard](https://cursor.com/dashboard) → **Cloud Agents** → **Environments**
2. リポジトリ **`playwright-chromium`** を選択
3. `.cursor/environment.json` を参照させ、**Build** → 成功後 **Activate**

## Automation に stdio MCP を追加

```json
{
  "name": "wrapped-playwright",
  "type": "stdio",
  "command": "bash",
  "args": ["environment/scripts/run-browser-mcp.sh"]
}
```

- **作業ディレクトリ（cwd）** はこのリポジトリ（`playwright-chromium`）のルートにする。マルチリポの場合は特に重要（タスク用リポの `scripts/` と取り違えない）。
- 保存後は **新規実行**（既存セッションは MCP が変わらない）。

## Secrets

1. Dashboard → **Secrets** にキーを登録し、この Environment / Automation にバインドする。
2. Agent 起動時の `start` が `environment/playwright-mcp.secrets.env` を生成する。
3. ブラウザ入力では **`browser_fill_form` の `value` に Secret 名**（実値ではない）を渡す。

## 確認

```bash
bash environment/scripts/verify-setup.sh
```

## やってはいけないこと

| 操作 | 結果 |
|------|------|
| プラグインだけ消して Automation に MCP を足さない | `browser_*` ツールが 0 本 |
| Plugin Managed Playwright を再有効化 | secrets / headless が効かないことがある |
| cwd がタスク用リポのまま相対パスだけ指定 | wrapper が見つからない、または別リポを参照 |
