/*Upate status*/
update hosts set status=1 where status=2;
update hosts set status=2 where status=4;

update sites set status=1 where status=2;
update sites set status=2 where status=3;

update apps set status=1 where status=2;
update apps set status=2 where status=3;
	
/*Create notify rule*/
drop table if exists notify_rules;
ALTER TABLE hosts
ADD COLUMN last_notification datetime DEFAULT NULL,
ADD COLUMN current_notification_number int(11) default 0,
ADD COLUMN notifications_enabled tinyint(2) default 1,
ADD COLUMN first_notification_delay int(11) default 360,
ADD COLUMN notification_interval int(11) default 7200,
ADD COLUMN notification_times int(11) default 1,
ADD COLUMN notify_on_recovery tinyint(2) default 1,
ADD COLUMN notify_on_down tinyint(2) default 1,
ADD COLUMN notify_on_unreachable tinyint(2) default 0;

ALTER TABLE networks
ADD COLUMN last_notification datetime DEFAULT NULL,
ADD COLUMN current_notification_number int(11) default 0,
ADD COLUMN notifications_enabled tinyint(2) default 1,
ADD COLUMN first_notification_delay int(11) default 360,
ADD COLUMN notification_interval int(11) default 7200,
ADD COLUMN notification_times int(11) default 1,
ADD COLUMN notify_on_recovery tinyint(2) default 1,
ADD COLUMN notify_on_down tinyint(2) default 1,
ADD COLUMN notify_on_unreachable tinyint(2) default 0;

ALTER TABLE sites
ADD COLUMN last_notification datetime DEFAULT NULL,
ADD COLUMN current_notification_number int(11) default 0,
ADD COLUMN notifications_enabled tinyint(2) default 1,
ADD COLUMN first_notification_delay int(11) default 360,
ADD COLUMN notification_interval int(11) default 7200,
ADD COLUMN notification_times int(11) default 1,
ADD COLUMN notify_on_recovery tinyint(2) default 1,
ADD COLUMN notify_on_down tinyint(2) default 1;

ALTER TABLE apps
ADD COLUMN last_notification datetime DEFAULT NULL,
ADD COLUMN current_notification_number int(11) default 0,
ADD COLUMN notifications_enabled tinyint(2) default 1,
ADD COLUMN first_notification_delay int(11) default 360,
ADD COLUMN notification_interval int(11) default 7200,
ADD COLUMN notification_times int(11) default 1,
ADD COLUMN notify_on_recovery tinyint(2) default 1,
ADD COLUMN notify_on_down tinyint(2) default 1;

ALTER TABLE services
ADD COLUMN last_notification datetime DEFAULT NULL,
ADD COLUMN current_notification_number int(11) default 0,
ADD COLUMN notifications_enabled tinyint(2) default 1,
ADD COLUMN first_notification_delay int(11) default 360,
ADD COLUMN notification_interval int(11) default 7200,
ADD COLUMN notification_times int(11) default 1,
ADD COLUMN notify_on_recovery tinyint(2) default 1,
ADD COLUMN notify_on_warning tinyint(2) default 0,
ADD COLUMN notify_on_unknown tinyint(2) default 0,
ADD COLUMN notify_on_critical tinyint(2) default 1;

/*Create alert_notifications*/
CREATE TABLE `alert_notifications` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `method` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `alert_id` int(11) DEFAULT NULL,
  `alert_name` varchar(100) DEFAULT NULL,
  `alert_severity` int(2) DEFAULT NULL,
  `alert_status` int(2) DEFAULT NULL,
  `alert_last_status` int(2) DEFAULT NULL,
  `alert_summary` varchar(255) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `source_type` int(11) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0' COMMENT '0:unsent 1:sent',
  `last_notification` datetime DEFAULT NULL,
  `current_notification_number` int(11) default 0,
  `occured_at` datetime DEFAULT NULL,
  `changed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

drop table if exists notifications;
CREATE TABLE `notifications` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `method` int(11) DEFAULT NULL COMMENT '0:email 1:phone',
  `address` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL COMMENT '1:alert 2:report',
  `tenant_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0' COMMENT '0:unsent 1:sent 2:read',
  `title` varchar(100) DEFAULT NULL,
  `summary` varchar(255) DEFAULT NULL,
  `content` blob,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;

DELIMITER ;
DROP PROCEDURE IF EXISTS `clear_alerts`;
DELIMITER ;;
CREATE PROCEDURE `clear_alerts`()
BEGIN
		delete from alerts where changed_at < now() - interval 1 day and severity = 0;
END 
;;

DELIMITER ;
DROP PROCEDURE IF EXISTS `create_notifications`;

DELIMITER ;;
CREATE PROCEDURE `create_notifications`()
BEGIN
	/*create services notifications*/
	insert into alert_notifications (last_notification, current_notification_number, method, user_id, alert_id, alert_name, alert_severity, alert_status, alert_last_status, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, changed_at, created_at, updated_at)	
		select t2.last_notification last_notification, (t2.current_notification_number+1) current_notification_number, 
			0 method, t3.id user_id, t1.id alert_id, t1.name alert_name, t1.severity, t1.status alert_status, t1.last_status alert_last_status, t1.summary alert_summary, t1.service_id service_id, t1.source_id source_id, t1.source_type source_type, t1.tenant_id tenant_id, 0 status, t1.occured_at occured_at, t1.changed_at changed_at, now() created_at, now() updated_at
			from alerts t1, services t2, users t3 
			where t1.service_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
				and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
				and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_warning=1,1, -1) or t1.status=IF(t2.notify_on_critical=1,2, -1) or t1.status=IF(t2.notify_on_unknown=1,3, -1))
				and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
				and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number)
				and t2.current_notification_number > IF(t1.status=0,0,-1);


	update alerts t1, services t2, users t3 
		set t2.last_notification = (case when t1.status=0 then null else now() end), t2.current_notification_number = (case when t1.status=0 then 0 else t2.current_notification_number+1 end) 
		where t1.service_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
			and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
			and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_warning=1,1, -1) or t1.status=IF(t2.notify_on_critical=1,2, -1) or t1.status=IF(t2.notify_on_unknown=1,3, -1))
			and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
			and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number) 
			and t2.current_notification_number > IF(t1.status=0,0,-1);

	/*create hosts notifications*/
	insert into alert_notifications (last_notification, current_notification_number, method, user_id, alert_id, alert_name, alert_severity, alert_status, alert_last_status, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, changed_at, created_at, updated_at)	
		select t2.last_notification last_notification, (t2.current_notification_number+1) current_notification_number, 
			0 method, t3.id user_id, t1.id alert_id, t1.name alert_name, t1.severity, t1.status alert_status, t1.last_status alert_last_status, t1.summary alert_summary, t1.service_id service_id, t1.source_id source_id, t1.source_type source_type, t1.tenant_id tenant_id, 0 status, t1.occured_at occured_at, t1.changed_at changed_at, now() created_at, now() updated_at
			from alerts t1, hosts t2, users t3 
			where t1.service_id is null and t1.source_type = 1 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
				and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
				and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1) or t1.status=IF(t2.notify_on_unreachable=1,3, -1))
				and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
				and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number)
				and t2.current_notification_number > IF(t1.status=0,0,-1);


	update alerts t1, hosts t2, users t3 
		set t2.last_notification = (case when t1.status=0 then null else now() end), t2.current_notification_number = (case when t1.status=0 then 0 else t2.current_notification_number+1 end) 
		where t1.service_id is null and t1.source_type = 1 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
			and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
			and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1) or t1.status=IF(t2.notify_on_unreachable=1,3, -1))
			and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
			and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number) 
			and t2.current_notification_number > IF(t1.status=0,0,-1);

	/*create networks notifications*/
	insert into alert_notifications (last_notification, current_notification_number, method, user_id, alert_id, alert_name, alert_severity, alert_status, alert_last_status, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, changed_at, created_at, updated_at)	
		select t2.last_notification last_notification, (t2.current_notification_number+1) current_notification_number, 
			0 method, t3.id user_id, t1.id alert_id, t1.name alert_name, t1.severity, t1.status alert_status, t1.last_status alert_last_status, t1.summary alert_summary, t1.service_id service_id, t1.source_id source_id, t1.source_type source_type, t1.tenant_id tenant_id, 0 status, t1.occured_at occured_at, t1.changed_at changed_at, now() created_at, now() updated_at
			from alerts t1, networks t2, users t3 
			where t1.service_id is null and t1.source_type = 4 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
				and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
				and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1) or t1.status=IF(t2.notify_on_unreachable=1,3, -1))
				and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
				and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number)
				and t2.current_notification_number > IF(t1.status=0,0,-1);


	update alerts t1, networks t2, users t3 
		set t2.last_notification = (case when t1.status=0 then null else now() end), t2.current_notification_number = (case when t1.status=0 then 0 else t2.current_notification_number+1 end) 
		where t1.service_id is null and t1.source_type = 4 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
			and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
			and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1) or t1.status=IF(t2.notify_on_unreachable=1,3, -1))
			and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
			and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number) 
			and t2.current_notification_number > IF(t1.status=0,0,-1);

	/*create apps notifications*/
	insert into alert_notifications (last_notification, current_notification_number, method, user_id, alert_id, alert_name, alert_severity, alert_status, alert_last_status, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, changed_at, created_at, updated_at)	
		select t2.last_notification last_notification, (t2.current_notification_number+1) current_notification_number, 
			0 method, t3.id user_id, t1.id alert_id, t1.name alert_name, t1.severity, t1.status alert_status, t1.last_status alert_last_status, t1.summary alert_summary, t1.service_id service_id, t1.source_id source_id, t1.source_type source_type, t1.tenant_id tenant_id, 0 status, t1.occured_at occured_at, t1.changed_at changed_at, now() created_at, now() updated_at
			from alerts t1, apps t2, users t3 
			where t1.service_id is null and t1.source_type = 2 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
				and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
				and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1))
				and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
				and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number)
				and t2.current_notification_number > IF(t1.status=0,0,-1);


	update alerts t1, apps t2, users t3 
		set t2.last_notification = (case when t1.status=0 then null else now() end), t2.current_notification_number = (case when t1.status=0 then 0 else t2.current_notification_number+1 end) 
		where t1.service_id is null and t1.source_type = 2 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
			and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
			and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1))
			and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
			and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number) 
			and t2.current_notification_number > IF(t1.status=0,0,-1);
			
	/*create sites notifications*/
	insert into alert_notifications (last_notification, current_notification_number, method, user_id, alert_id, alert_name, alert_severity, alert_status, alert_last_status, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, changed_at, created_at, updated_at)	
		select t2.last_notification last_notification, (t2.current_notification_number+1) current_notification_number, 
			0 method, t3.id user_id, t1.id alert_id, t1.name alert_name, t1.severity, t1.status alert_status, t1.last_status alert_last_status, t1.summary alert_summary, t1.service_id service_id, t1.source_id source_id, t1.source_type source_type, t1.tenant_id tenant_id, 0 status, t1.occured_at occured_at, t1.changed_at changed_at, now() created_at, now() updated_at
			from alerts t1, sites t2, users t3 
			where t1.service_id is null and t1.source_type = 3 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
				and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
				and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1))
				and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
				and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number)
				and t2.current_notification_number > IF(t1.status=0,0,-1);


	update alerts t1, sites t2, users t3 
		set t2.last_notification = (case when t1.status=0 then null else now() end), t2.current_notification_number = (case when t1.status=0 then 0 else t2.current_notification_number+1 end) 
		where t1.service_id is null and t1.source_type = 3 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
			and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
			and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1))
			and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
			and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number) 
			and t2.current_notification_number > IF(t1.status=0,0,-1);
			
		
END 

;;

DELIMITER ;
DROP PROCEDURE IF EXISTS `merge_alerts`;
DELIMITER ;;
CREATE PROCEDURE `merge_alerts`()
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

	update alerts t1, services t2 set t1.name = t2.name, t1.ctrl_state = t2.ctrl_state,
	t1.source_id = t2.serviceable_id,
	t1.source_type = t2.serviceable_type, t1.tenant_id = t2.tenant_id
	where t1.service_id = t2.id;
	
	/*merge source alert*/
	insert into alerts (source_type, source_id, name, tenant_id, created_at, updated_at)
		select t1.source_type, t1.source_id, t1.name, t1.tenant_id, now(), now()
		from alerts t1
		where not exists (select 1 from alerts a1 where a1.source_type = t1.source_type and a1.source_id = t1.source_id and a1.service_id is null)
		and t1.ctrl_state = 1;
	

	update alerts t1, alerts t2 set t1.summary = t2.summary, t1.status_type = t2.status_type, 
		t1.occur_count = t2.occur_count, t1.last_check = t2.last_check, t1.next_check = t2.next_check, 
		t1.occured_at = t2.occured_at, t1.changed_at = t2.changed_at, t1.severity = t2.severity,
		t1.status = (case when t2.status in (0,1) then 0 when t2.status in (2,3) then 1 when t2.status = 4 then 2 else 0 end),
		t1.last_status = (case when t2.last_status in (0,1) then 0 when t2.last_status in (2,3) then 1 when t2.last_status = 4 then 2 else 0 end)
	where t1.service_id is null and t2.ctrl_state = 1 and t1.source_type = t2.source_type and t1.source_id = t2.source_id;
END 
;;

DELIMITER ;
DROP PROCEDURE IF EXISTS `merge_status`;
DELIMITER ;;
CREATE PROCEDURE `merge_status`()
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
	t1.status = (case when t2.status in (0,1) then 0 when t2.status in (2,3) then 1 when t2.status = 4 then 2 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status in (2,3) then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end)
	where t2.serviceable_type = 1 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;
	
	
	update apps t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status in (2,3) then 1 when t2.status = 4 then 2 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status in (2,3) then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end)
	where t2.serviceable_type = 2 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;

	
	update sites t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status in (2,3) then 1 when t2.status = 4 then 2 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status in (2,3) then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end)
	where t2.serviceable_type = 3 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;

	update networks t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status in (2,3) then 1 when t2.status = 4 then 2 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status in (2,3) then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end)
	where t2.serviceable_type = 4 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;	
	call create_notifications();
END 
;;




/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;

DROP EVENT IF EXISTS `clear_alerts_event`;

CREATE EVENT `clear_alerts_event` ON SCHEDULE EVERY 1 DAY DO CALL clear_alerts();

DROP EVENT IF EXISTS `merge_status_event`;

CREATE EVENT `merge_status_event` ON SCHEDULE EVERY 1 MINUTE DO CALL merge_status();

