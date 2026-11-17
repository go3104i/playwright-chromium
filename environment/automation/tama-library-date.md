# Automation テンプレート追記用（日付）

オートメーションのシステム／ユーザープロンプトに、次のブロックを **「今日は Asia/Tokyo の暦日」** の直後へ貼り付ける。

---

## 今日の暦日（必須・機械取得）

判定に使う「今日」は **実行開始時に** 次を 1 回だけ実行した結果のみとする。それ以外の日付表記は参照しない。

```bash
bash environment/scripts/today-tokyo.sh
```

- `TODAY_TOKYO_ISO` … 今日（`YYYY-MM-DD`）
- `TODAY_TOKYO_JP` … 画面と同形（例: `2026年11月18日`）

**禁止:** `user_info` の日付、`<timestamp>`、cron `triggeredAt`、UTC の現在時刻からの推測。

`today-tokyo.sh` が `WARN: UTC暦日は …` を出したときは、東京側の日付だけを使うこと。

`loans.json` の `lastRun` は `TODAY_TOKYO_ISO` と一致させる。

---