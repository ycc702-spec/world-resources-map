#!/bin/bash

# AI資源地圖每週更新腳本
# 執行時間：每週一早上 9:00
# 功能：檢查能源價格變動，如有重大變化則更新網站

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/update.log"
REPO_DIR="/root/.openclaw/workspace/world-resources-map"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$DATE] 開始執行每週更新檢查..." >> "$LOG_FILE"

# 切換到專案目錄
cd "$REPO_DIR" || exit 1

# 1. 檢查能源價格API（Henry Hub, TTF, JKM）
echo "[$DATE] 檢查能源價格..." >> "$LOG_FILE"

# Henry Hub 價格（EIA API）
HENRY_HUB=$(curl -s "https://api.eia.gov/v2/natural-gas/prices/data?frequency=daily&data[0]=value&facets[product][]=RNGWHHD&sort[0][column]=period&sort[0][direction]=desc&offset=0&length=1&api_key=YOUR_EIA_API_KEY" | jq -r '.data[0].value' 2>/dev/null || echo "N/A")

# 如果有重大變化（>5%），則更新網站
if [ "$HENRY_HUB" != "N/A" ] && [ "$HENRY_HUB" != "null" ]; then
    echo "[$DATE] 當前 Henry Hub 價格: $HENRY_HUB USD/MMBtu" >> "$LOG_FILE"
    
    # 這裡可以添加價格變化檢查邏輯
    # 如果變化 > 5%，則更新 ai-resources.html 中的價格數據
fi

# 2. 檢查是否有新的 AI 資料中心新聞
echo "[$DATE] 檢查 AI 資料中心新聞..." >> "$LOG_FILE"

# 可以使用 NewsAPI 或自定義 RSS 源
# curl -s "https://newsapi.org/v2/everything?q=AI+data+center+Microsoft+Google+Amazon&from=$(date -d '7 days ago' +%Y-%m-%d)&sortBy=publishedAt&apiKey=YOUR_NEWS_API_KEY" | jq -r '.articles[0:5].title'

# 3. 檢查 GitHub 是否有未提交的變更
if [ -n "$(git status --porcelain)" ]; then
    echo "[$DATE] 發現未提交的變更，執行提交..." >> "$LOG_FILE"
    
    git add .
    git commit -m "每週自動更新: $(date '+%Y-%m-%d') 能源價格檢查"
    git push origin main
    
    echo "[$DATE] 已推送更新到 GitHub" >> "$LOG_FILE"
else
    echo "[$DATE] 無需更新，本週無變更" >> "$LOG_FILE"
fi

# 4. 發送通知（可選）
# 可以整合 Telegram Bot 或 Email 通知
# curl -s -X POST "https://api.telegram.org/botYOUR_BOT_TOKEN/sendMessage" \
#     -d "chat_id=YOUR_CHAT_ID" \
#     -d "text=✅ AI資源地圖每週更新完成: $(date '+%Y-%m-%d')"

echo "[$DATE] 更新檢查完成" >> "$LOG_FILE"
echo "---" >> "$LOG_FILE"
