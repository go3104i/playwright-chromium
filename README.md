# playwright-chromium

**Cursor Cloud Agent / Automations 向けの共通 Environment 定義**です。  
Web ブラウジングが必要な Automation に、Chromium と Playwright MCP（`wrapped-playwright`）を載せるためのリポジトリです。業務ロジックは含みません。

## 構成

```text
playwright-chromium/
  .cursor/
    environment.json          # install + start
    mcp.json                  # IDE 用（Automation は Dashboard で同名 MCP を手動登録）
  environment/
    scripts/
      generate-secrets.sh       # start: dotenv 生成
      run-browser-mcp.sh        # MCP 起動（headless + config + secrets）
      verify-setup.sh           # 疎通確認
      patch-playwright-mcp-headless.js
    playwright-mcp.secrets.env.example
  playwright-mcp.json           # Chromium / headless 既定
  docs/AUTOMATION_MCP_SETUP.md
```

生成される secrets（Git 対象外）: `environment/playwright-mcp.secrets.env`

## Environment の使い方

1. Dashboard → **Environments** → このリポジトリを追加
2. **Build** して install が通るまで待つ（Chromium 含む）
3. 成功 Build を **Activate**
4. Automation にこの Environment を割り当て、[docs/AUTOMATION_MCP_SETUP.md](docs/AUTOMATION_MCP_SETUP.md) のとおり **`wrapped-playwright`** を登録

### install / start

| 項目 | 内容 |
|------|------|
| `install` | `@playwright/mcp` / `playwright`、Chromium、CLI パッチ、スクリプト実行権 |
| `start` | `generate-secrets.sh` — バインド済み Secret を dotenv に書き出す |

`start` は Build では走らず、**エージェント起動のたび**に実行されます。

## Secrets と Playwright MCP

1. Dashboard の **Secrets** にキーを登録し、Environment にバインドする。
2. `start` が **Environment にバインドされた Secret**（`CLOUD_AGENT_INJECTED_SECRET_NAMES`）を `environment/playwright-mcp.secrets.env` に書き込む（実値はリポジトリに含めない）。
3. `run-browser-mcp.sh` が `--secrets` で MCP を起動する。

## マルチリポ

タスク用リポジトリと併用する場合、Automation の MCP **cwd は `playwright-chromium` のルート**にしてください。  
パスは `environment/scripts/run-browser-mcp.sh` を使う（汎用の `scripts/` だけでは他リポと取り違えます）。

## ローカル確認（任意）

```bash
npm install --no-save @playwright/mcp@latest playwright@latest
npx playwright install --with-deps chromium
node environment/scripts/patch-playwright-mcp-headless.js
chmod +x environment/scripts/*.sh
bash environment/scripts/run-browser-mcp.sh
```

## 由来

[tama-library-automation](https://github.com/go3104i/tama-library-automation) の Environment まわりを汎用化し、パスを `environment/scripts/` に整理したものです。
