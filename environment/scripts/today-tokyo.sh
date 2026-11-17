#!/usr/bin/env bash
# 多摩市立図書館オートメーション用の「今日」（Asia/Tokyo 暦日）。判定はこの出力のみを使う。
set -euo pipefail

export TZ=Asia/Tokyo

iso=$(date +%Y-%m-%d)
jp=$(date +%Y年%-m月%-d日)
weekday=$(date +%u) # 1=Mon … 7=Sun
utc_iso=$(date -u +%Y-%m-%d)

echo "TODAY_TOKYO_ISO=${iso}"
echo "TODAY_TOKYO_JP=${jp}"
echo "TODAY_TOKYO_WEEKDAY=${weekday}"

if [[ "${utc_iso}" != "${iso}" ]]; then
  echo "WARN: UTC暦日は ${utc_iso}、東京暦日は ${iso}。user_info・cron・UTC 時刻を「今日」に使わないこと。" >&2
fi