package com.example.demo.jobs;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Component;
import com.xxl.job.core.handler.annotation.*;
import com.xxl.job.core.biz.model.ReturnT;
import com.xxl.job.core.log.XxlJobLogger;

@Component
public class SampleXxlJob {

    // XxlJob annotation for 2.2.0
    @XxlJob("testJobHandler")
    public ReturnT<String> testJobHandler(String param) throws Exception {
        XxlJobLogger.log(" >>用戶等級更新任務開始執行....");

        String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        System.out.println(now + "XXL-JOB, Hello World.");

        Thread.sleep(7000);

        return ReturnT.SUCCESS;

    }

    @XxlJob("failHandler")
    public ReturnT<String> failHandler(String param) throws Exception {
        XxlJobLogger.log(" >>用戶等級更新任務開始執行....");

        String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        System.out.println(now + "XXL-JOB, fail...");

        return ReturnT.FAIL;

    }
}
