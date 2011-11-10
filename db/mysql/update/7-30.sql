/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
ALTER TABLE `services`
ADD COLUMN notify_by_email tinyint(1) DEFAULT 1 COMMENT "邮件通知",
ADD COLUMN notify_by_sms tinyint(1) DEFAULT 0 COMMENT "短信通知";

ALTER TABLE `sites`
ADD COLUMN notify_by_email tinyint(1) DEFAULT 1 COMMENT "邮件通知",
ADD COLUMN notify_by_sms tinyint(1) DEFAULT 0 COMMENT "短信通知";

ALTER TABLE `hosts`
ADD COLUMN notify_by_email tinyint(1) DEFAULT 1 COMMENT "邮件通知",
ADD COLUMN notify_by_sms tinyint(1) DEFAULT 0 COMMENT "短信通知";

ALTER TABLE `devices`
ADD COLUMN notify_by_email tinyint(1) DEFAULT 1 COMMENT "邮件通知",
ADD COLUMN notify_by_sms tinyint(1) DEFAULT 0 COMMENT "短信通知";

ALTER TABLE `apps`
ADD COLUMN notify_by_email tinyint(1) DEFAULT 1 COMMENT "邮件通知",
ADD COLUMN notify_by_sms tinyint(1) DEFAULT 0 COMMENT "短信通知";

update services set notify_by_sms = 1 where tenant_id = 1;
update sites set notify_by_sms = 1 where tenant_id = 1;
update hosts set notify_by_sms = 1 where tenant_id = 1;
update devices set notify_by_sms = 1 where tenant_id = 1;
update apps set notify_by_sms = 1 where tenant_id = 1;
