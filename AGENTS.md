# Cloud Agent 向けガイド

## 多摩市立図書館オートメーション（日付）

返却期限の「今日／明日／明後日」判定を誤ると延長・通知が一切ずれる。**実行の最初のシェル操作**として次を必ず実行し、標準出力の `TODAY_TOKYO_*` だけを「今日」として使う。

```bash
bash environment/scripts/today-tokyo.sh
```

### 使ってはいけないもの

- `user_info` の `Today's date`（多くの場合 **UTC 日付**）
- メッセージの `<timestamp>`（UTC）
- cron の `triggeredAt`（UTC）
- エージェントの推測や前回実行の `loans.json` の `lastRun`

UTC と東京で日付が分かれるのは **UTC 15:00 以降（JST 0:00 以降）** が典型。22:00 UTC 前後の cron では東京はすでに翌日になっている。

### 記録

`loans.json` の `lastRun` には **`TODAY_TOKYO_ISO` の値**（`YYYY-MM-DD`）を入れる。画面の返却期限と突き合わせるときは `TODAY_TOKYO_JP`（例: `2026年11月18日`）を使う。

### 事故（2026-11-17 実行）

UTC 17 日と見なし 18 日期限を「明日」扱いにした。再発防止のため上記スクリプトを導入した。