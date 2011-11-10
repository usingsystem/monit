/*clear status config*/;
DROP TABLE IF EXISTS `app_states`;
DROP TABLE IF EXISTS `host_states`;
DROP TABLE IF EXISTS `service_states`;
DROP TABLE IF EXISTS `alert_levels`;

/*create networks*/
DROP TABLE IF EXISTS `networks`;
CREATE TABLE `networks` (
	  `id` int(11) NOT NULL AUTO_INCREMENT,
	  `name` varchar(50) DEFAULT NULL,
	  `tag` varchar(50) DEFAULT NULL,
	  `model` varchar(50) DEFAULT NULL,
	  `mac` varchar(20) DEFAULT NULL,
	  `os_desc` varchar(50) DEFAULT NULL,
	  `addr` varchar(50) NOT NULL,
	  `uuid` varchar(50) DEFAULT NULL,
	  `tenant_id` int(11) DEFAULT NULL,
	  `agent_id` int(11) DEFAULT NULL,
	  `is_support_snmp` int(2) DEFAULT NULL COMMENT '0:false 1:true',
	  `type_id` int(11) DEFAULT NULL,
	  `port` int(11) DEFAULT NULL,
	  `snmp_ver` varchar(20) DEFAULT NULL,
	  `community` varchar(20) DEFAULT NULL,
	  `discovery_state` int(2) DEFAULT '0' COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
	  `last_check` datetime DEFAULT NULL,
	  `next_check` datetime DEFAULT NULL,
	  `duration` int(11) DEFAULT NULL,
	  `status` int(2) DEFAULT '2',
	  `summary` varchar(200) DEFAULT NULL,
	  `last_time_up` datetime DEFAULT NULL,
	  `last_time_down` datetime DEFAULT NULL,
	  `last_time_pending` datetime DEFAULT NULL,
	  `last_time_unknown` datetime DEFAULT NULL,
	  `last_time_unreachable` datetime DEFAULT NULL,
	  `created_at` datetime DEFAULT NULL,
	  `updated_at` datetime DEFAULT NULL,
	  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;

/*modify alerts*/
ALTER TABLE alerts
CHANGE level severity int(2),
CHANGE last_level last_status int(2),
CHANGE first_time occured_at datetime,
CHANGE last_time changed_at datetime,
ADD COLUMN status_type int(2),
ADD COLUMN status int(2),
ADD COLUMN last_check datetime,
ADD COLUMN next_check datetime;

ALTER TABLE notify_rules
CHANGE alert_level alert_severity int(2);

ALTER TABLE notifications
CHANGE alert_level alert_severity int(2),
CHANGE occur_time occured_at datetime;

/*modify procedure*/

DROP PROCEDURE IF EXISTS `clear_alerts`;
DROP PROCEDURE IF EXISTS `create_notifications`;
DROP PROCEDURE IF EXISTS `merge_alerts`;
DROP PROCEDURE IF EXISTS `merge_status`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `clear_alerts`()
BEGIN
		delete from alerts where changed_at < now() - interval 1 day and severity = 0;
END
$$

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_notifications`()
BEGIN
	insert into notifications (method, user_id, alert_id, alert_name, alert_severity, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, created_at, updated_at)
		select t2.method, t2.user_id, t1.id alert_id, t1.name alert_name, t1.severity alert_severity, t1.summary alert_summary, t1.service_id, t1.source_id, t1.source_type, t1.tenant_id, 0 status, t1.changed_at, now() created_at, now() update_at from alerts t1 
			inner join notify_rules t2 on t1.tenant_id = t2.tenant_id and t1.severity = t2.alert_severity and t2.source_type = (case when t1.service_id is null then t1.source_type else 0 end) 
			left join notifications t3 on t1.id = t3.alert_id and t1.changed_at = t3.occured_at and t2.user_id = t3.user_id and t2.method = t3.method
		where t3.id is null;
END
$$

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `merge_alerts`()
BEGIN
	insert into alerts (service_id, created_at, updated_at)
	select t1.service_id, now(), now()
	from checked_status t1
	where not exists (select 1 from alerts a1 where a1.service_id = t1.service_id)
	and t1.status <> 0;

	update alerts t1, checked_status t2 set 
	t1.severity = t2.status, t1.status = t2.status, t1.status_type = t2.status_type, t1.summary = t2.summary, 
	t1.last_check = from_unixtime(t2.last_check), t1.next_check = from_unixtime(t2.next_check), t1.updated_at = now(),
	t1.last_status = case when t2.status <> t1.status then t1.status else t1.last_status end,
	t1.changed_at = case when t2.status <> t1.status then from_unixtime(t2.last_check) else t1.changed_at end,
	t1.occured_at = case when t1.status = 0 then from_unixtime(t2.last_check) else t1.occured_at end,
	t1.occur_count = case when t1.status = 0 then 1 else t1.occur_count+1 end
	where t1.service_id = t2.service_id and (t1.status <> 0 or t2.status <> 0);

	update alerts t1, services t2 set t1.name = t2.name,
	t1.source_id = t2.serviceable_id,
	t1.source_type = t2.serviceable_type, t1.tenant_id = t2.tenant_id
	where t1.service_id = t2.id;
END
$$

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `merge_status`()
BEGIN
	
	call merge_alerts();
	update services t1, checked_status t2 set 
	t1.status = t2.status, t1.summary = t2.summary,
	t1.last_check = from_unixtime(t2.last_check), t1.next_check = from_unixtime(t2.next_check), t1.updated_at = now(), 
	t1.last_time_ok = (case when t2.status = 0 then from_unixtime(t2.last_check) else t1.last_time_ok end),
	t1.last_time_warning = (case when t2.status = 1 then from_unixtime(t2.last_check) else t1.last_time_warning end),
	t1.last_time_critical = (case when t2.status = 2 then from_unixtime(t2.last_check) else t1.last_time_critical end),
	t1.last_time_unknown = (case when t2.status = 3 then from_unixtime(t2.last_check) else t1.last_time_unknown end)
	where t1.id = t2.service_id
	and exists (select 1 from checked_status a1 where a1.service_id = t1.id);
	
		
	truncate table checked_status;
	
	update hosts t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 2 when t2.status = 4 then 4 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status = 2 then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end),
	t1.last_time_unknown = (case when t2.status = 3 then t2.last_check else t1.last_time_unknown end)
	where t2.serviceable_type = 1 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;
	
	
	update apps t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 2 when t2.status = 4 then 3 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status = 2 then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end),
	t1.last_time_unknown = (case when t2.status = 3 then t2.last_check else t1.last_time_unknown end)
	where t2.serviceable_type = 2 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;

	
	update sites t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 3 when t2.status = 4 then 2 else 3 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status = 2 then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end),
	t1.last_time_unknown = (case when t2.status = 3 then t2.last_check else t1.last_time_unknown end)
	where t2.serviceable_type = 3 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;

	update networks t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 2 when t2.status = 4 then 4 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status = 2 then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end),
	t1.last_time_unknown = (case when t2.status = 3 then t2.last_check else t1.last_time_unknown end)
	where t2.serviceable_type = 4 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;	
	call create_notifications();
END
$$

DROP EVENT IF EXISTS `merge_status_event`;

CREATE EVENT `merge_status_event` ON SCHEDULE EVERY 1 MINUTE STARTS '2010-04-09 16:52:13' ON COMPLETION PRESERVE ENABLE DO CALL merge_status();
