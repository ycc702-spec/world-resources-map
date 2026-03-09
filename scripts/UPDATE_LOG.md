# AI資源地圖更新記錄

## 自動更新排程

### 每週更新（已設置 Cron Job）
- **時間**：每週一早上 9:00
- **腳本**：`/root/.openclaw/workspace/world-resources-map/scripts/weekly-update.sh`
- **日誌**：`/root/.openclaw/workspace/world-resources-map/scripts/update.log`

### 更新內容
1. **能源價格檢查**：Henry Hub, TTF, JKM
2. **AI 資料中心新聞**：Microsoft, Google, Amazon, Meta
3. **自動提交**：如有變更則自動推送到 GitHub

---

## 更新歷史

### 2026-03-09
- ✅ 設置每週自動更新機制
- ✅ 建立 weekly-update.sh 腳本
- ✅ 設置 Cron Job（每週一 9:00）

---

## 手動更新指令

如果需要手動執行更新：

```bash
/root/.openclaw/workspace/world-resources-map/scripts/weekly-update.sh
```

查看更新日誌：

```bash
tail -f /root/.openclaw/workspace/world-resources-map/scripts/update.log
```

---

## 注意事項

1. 每週更新僅檢查能源價格變動，如有重大變化（>5%）才會更新
2. 年度儲量數據仍需手動更新（BP/USGS 年度報告）
3. AI 公司能耗數據需等待各公司 CSR 報告發布
