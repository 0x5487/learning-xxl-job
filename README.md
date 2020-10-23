# learning-xxl-job

admin: http://localhost:8081/xxl-job-admin/toLogin
默認登錄賬號 “admin/123456”, 登錄後運行界面如下圖所示。


## 心得
1. 一個任務每 5 秒執行一次，一次會執行 7 秒，這時候調度中心會每 5 秒, 發出任務請求，等待空檔的執行器來執行，但因為執行器每次執行需要花 7 秒，結果就是執行器一直追不上調度器，任務會一直執行不完
1. 健康檢查端點: http://localhost:8081/xxl-job-admin/actuator/health , 如果連不到 mysql 狀態會出現 http status 503, 這時候需要重啟 xxl-job server 