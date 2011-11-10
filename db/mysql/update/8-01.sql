/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;

ALTER TABLE `bills`
ADD COLUMN type_id  int(2) DEFAULT 0 COMMENT '0:租户账单，1:运营商账单';

ALTER TABLE `notifications`
ADD COLUMN status_msg  varchar(255) DEFAULT NULL COMMENT '状态消息';

ALTER TABLE `operators`
ADD COLUMN amount  decimal(10,2) DEFAULT '0.00' COMMENT '帐户余额';


ALTER TABLE `monit`.`packages` ADD COLUMN `multi_regional` int(11),
 ADD COLUMN `report` int(11),
 ADD COLUMN `customer_support` VARCHAR(50),
 ADD COLUMN `data_ratention` int(11),
 ADD COLUMN `sms_num` int(11),
 ADD COLUMN `special_features` VARCHAR(50);
