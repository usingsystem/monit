#Add source alert merge
DROP PROCEDURE IF EXISTS `merge_alerts`;
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

	update alerts t1, services t2 set t1.name = t2.name, t1.ctrl_state = t2.ctrl_state,
	t1.source_id = t2.serviceable_id,
	t1.source_type = t2.serviceable_type, t1.tenant_id = t2.tenant_id
	where t1.service_id = t2.id;
	
	#merge source alert
	insert into alerts (source_type, source_id, name, tenant_id, created_at, updated_at)
		select t1.source_type, t1.source_id, t1.name, t1.tenant_id, now(), now()
		from alerts t1
		where not exists (select 1 from alerts a1 where a1.source_type = t1.source_type and a1.source_id = t1.source_id and a1.service_id is null)
		and t1.ctrl_state = 1;
	

	update alerts t1, alerts t2 set t1.summary = t2.summary, t1.status_type = t2.status_type, 
		t1.occur_count = t2.occur_count, t1.last_check = t2.last_check, t1.next_check = t2.next_check, 
		t1.occured_at = t2.occured_at, t1.changed_at = t2.changed_at, t1.severity = t2.severity,
		t1.status = case when t1.source_type = 1 then (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 2 when t2.status = 4 then 4 else 0 end) when t1.source_type = 2 then (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 2 when t2.status = 4 then 3 else 0 end) when t1.source_type =3 then (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 3 when t2.status = 4 then 2 else 3 end) when t1.source_type = 4 then (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 2 when t2.status = 4 then 4 else 0 end) else (0) end,
		t1.last_status = case when t1.source_type = 1 then (case when t2.last_status in (0,1) then 0 when t2.last_status = 2 then 1 when t2.last_status = 3 then 2 when t2.last_status = 4 then 4 else 0 end) when t1.source_type = 2 then (case when t2.last_status in (0,1) then 0 when t2.last_status = 2 then 1 when t2.last_status = 3 then 2 when t2.last_status = 4 then 3 else 0 end) when t1.source_type =3 then (case when t2.last_status in (0,1) then 0 when t2.last_status = 2 then 1 when t2.last_status = 3 then 3 when t2.last_status = 4 then 2 else 3 end) when t1.source_type = 4 then (case when t2.last_status in (0,1) then 0 when t2.last_status = 2 then 1 when t2.last_status = 3 then 2 when t2.last_status = 4 then 4 else 0 end) else (0) end
	where t1.service_id is null and t2.ctrl_state = 1 and t1.source_type = t2.source_type and t1.source_id = t2.source_id;
END
$$

#Add alert notification task

CREATE TABLE `alert_notifications` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `method` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `alert_id` int(11) DEFAULT NULL,
  `alert_name` varchar(100) DEFAULT NULL,
  `alert_status` int(2) DEFAULT NULL,
  `alert_summary` varchar(255) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `source_type` int(11) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0' COMMENT '0:unsent 1:sent',
  `occured_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

#Modify notify_rule
DROP TABLE IF EXISTS `notify_rules`;
DROP TABLE IF EXISTS `notifications`;