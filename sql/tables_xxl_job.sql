#
# XXL-JOB v2.2.1-SNAPSHOT
# Copyright (c) 2015-present, xuxueli.

CREATE database if NOT EXISTS `xxl_job` default character set utf8mb4 collate utf8mb4_unicode_ci;
use `xxl_job`;

SET NAMES utf8mb4;

CREATE TABLE `xxl_job_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_group` int(11) NOT NULL COMMENT '執行器主鍵ID',
  `job_cron` varchar(128) NOT NULL COMMENT '任務執行CRON',
  `job_desc` varchar(255) NOT NULL,
  `add_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `author` varchar(64) DEFAULT NULL COMMENT '作者',
  `alarm_email` varchar(255) DEFAULT NULL COMMENT '報警郵件',
  `executor_route_strategy` varchar(50) DEFAULT NULL COMMENT '執行器路由策略',
  `executor_handler` varchar(255) DEFAULT NULL COMMENT '執行器任務handler',
  `executor_param` varchar(512) DEFAULT NULL COMMENT '執行器任務參數',
  `executor_block_strategy` varchar(50) DEFAULT NULL COMMENT '阻塞處理策略',
  `executor_timeout` int(11) NOT NULL DEFAULT '0' COMMENT '任務執行超時時間，單位秒',
  `executor_fail_retry_count` int(11) NOT NULL DEFAULT '0' COMMENT '失敗重試次數',
  `glue_type` varchar(50) NOT NULL COMMENT 'GLUE類型',
  `glue_source` mediumtext COMMENT 'GLUE源代碼',
  `glue_remark` varchar(128) DEFAULT NULL COMMENT 'GLUE備註',
  `glue_updatetime` datetime DEFAULT NULL COMMENT 'GLUE更新時間',
  `child_jobid` varchar(255) DEFAULT NULL COMMENT '子任務ID，多個逗號分隔',
  `trigger_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '調度狀態：0-停止，1-運行',
  `trigger_last_time` bigint(13) NOT NULL DEFAULT '0' COMMENT '上次調度時間',
  `trigger_next_time` bigint(13) NOT NULL DEFAULT '0' COMMENT '下次調度時間',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `job_group` int(11) NOT NULL COMMENT '執行器主鍵ID',
  `job_id` int(11) NOT NULL COMMENT '任務，主鍵ID',
  `executor_address` varchar(255) DEFAULT NULL COMMENT '執行器地址，本次執行的地址',
  `executor_handler` varchar(255) DEFAULT NULL COMMENT '執行器任務handler',
  `executor_param` varchar(512) DEFAULT NULL COMMENT '執行器任務參數',
  `executor_sharding_param` varchar(20) DEFAULT NULL COMMENT '執行器任務分片參數，格式如 1/2',
  `executor_fail_retry_count` int(11) NOT NULL DEFAULT '0' COMMENT '失敗重試次數',
  `trigger_time` datetime DEFAULT NULL COMMENT '調度-時間',
  `trigger_code` int(11) NOT NULL COMMENT '調度-結果',
  `trigger_msg` text COMMENT '調度-日誌',
  `handle_time` datetime DEFAULT NULL COMMENT '執行-時間',
  `handle_code` int(11) NOT NULL COMMENT '執行-狀態',
  `handle_msg` text COMMENT '執行-日誌',
  `alarm_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '告警狀態：0-默認、1-無需告警、2-告警成功、3-告警失敗',
  PRIMARY KEY (`id`),
  KEY `I_trigger_time` (`trigger_time`),
  KEY `I_handle_code` (`handle_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_log_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trigger_day` datetime DEFAULT NULL COMMENT '調度-時間',
  `running_count` int(11) NOT NULL DEFAULT '0' COMMENT '運行中-日誌數量',
  `suc_count` int(11) NOT NULL DEFAULT '0' COMMENT '執行成功-日誌數量',
  `fail_count` int(11) NOT NULL DEFAULT '0' COMMENT '執行失敗-日誌數量',
  PRIMARY KEY (`id`),
  UNIQUE KEY `i_trigger_day` (`trigger_day`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_logglue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_id` int(11) NOT NULL COMMENT '任務，主鍵ID',
  `glue_type` varchar(50) DEFAULT NULL COMMENT 'GLUE類型',
  `glue_source` mediumtext COMMENT 'GLUE源代碼',
  `glue_remark` varchar(128) NOT NULL COMMENT 'GLUE備註',
  `add_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_registry` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registry_group` varchar(50) NOT NULL,
  `registry_key` varchar(255) NOT NULL,
  `registry_value` varchar(255) NOT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `i_g_k_v` (`registry_group`,`registry_key`,`registry_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_name` varchar(64) NOT NULL COMMENT '執行器AppName',
  `title` varchar(12) NOT NULL COMMENT '執行器名稱',
  `address_type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '執行器地址類型：0=自動註冊、1=手動錄入',
  `address_list` varchar(512) DEFAULT NULL COMMENT '執行器地址列表，多地址逗號分隔',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL COMMENT '賬號',
  `password` varchar(50) NOT NULL COMMENT '密碼',
  `role` tinyint(4) NOT NULL COMMENT '角色：0-普通用戶、1-管理員',
  `permission` varchar(255) DEFAULT NULL COMMENT '權限：執行器ID列表，多個逗號分割',
  PRIMARY KEY (`id`),
  UNIQUE KEY `i_username` (`username`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `xxl_job_lock` (
  `lock_name` varchar(50) NOT NULL COMMENT '鎖名稱',
  PRIMARY KEY (`lock_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO `xxl_job_group`(`id`, `app_name`, `title`, `address_type`, `address_list`) VALUES (1, 'xxl-job-executor-sample', '示例執行器', 0, NULL);
INSERT INTO `xxl_job_info`(`id`, `job_group`, `job_cron`, `job_desc`, `add_time`, `update_time`, `author`, `alarm_email`, `executor_route_strategy`, `executor_handler`, `executor_param`, `executor_block_strategy`, `executor_timeout`, `executor_fail_retry_count`, `glue_type`, `glue_source`, `glue_remark`, `glue_updatetime`, `child_jobid`) VALUES (1, 1, '0 0 0 * * ? *', '測試任務1', '2018-11-03 22:21:31', '2018-11-03 22:21:31', 'XXL', '', 'FIRST', 'demoJobHandler', '', 'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代碼初始化', '2018-11-03 22:21:31', '');
INSERT INTO `xxl_job_user`(`id`, `username`, `password`, `role`, `permission`) VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);
INSERT INTO `xxl_job_lock` ( `lock_name`) VALUES ( 'schedule_lock');

commit;
