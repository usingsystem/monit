/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
ALTER TABLE `users`
ADD COLUMN weekly tinyint(1) DEFAULT 1 COMMENT "支持周报",
ADD COLUMN daily tinyint(1) DEFAULT 1 COMMENT "支持日报";

ALTER TABLE `users`
ADD COLUMN monthly tinyint(1) DEFAULT 1 COMMENT "支持月报";

update users set weekly = 0, daily = 0, monthly =0;
update users set weekly = 1, daily = 1, monthly =1 where id = 1;


