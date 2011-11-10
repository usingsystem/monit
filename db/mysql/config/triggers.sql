/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;

/*services*/

DROP TRIGGER IF EXISTS trigger_services_insert;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_services_insert` AFTER INSERT ON monit.services FOR EACH ROW
BEGIN
	IF (new.object_type IS NOT NULL) AND (new.object_id IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			0,
			new.id,
			1,
			null,
			null,
			now(),
			now()
		);
   END IF;   
END;;
DELIMITER ;



DROP TRIGGER IF EXISTS trigger_services_update;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_services_update` AFTER UPDATE ON monit.services FOR EACH ROW
BEGIN
	IF (old.object_id is null and new.object_id IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			0,
			new.id,
			1,
			null,
			null,
			old.created_at,
			now()
		);
	elseif (old.object_type <> new.object_type) or (old.object_id <> new.object_id) or (old.name <> new.name) or (old.params <> new.params) or (old.check_interval <> new.check_interval) or (old.threshold_critical <> new.threshold_critical) or (old.threshold_warning <> new.threshold_warning) or (old.max_attempts <> new.max_attempts) or (old.attempt_interval <> new.attempt_interval) or (old.external <> new.external) or (old.tenant_id <> new.tenant_id) then
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			0,
			new.id,
			3,
			null,
			null,
			old.created_at,
			now()
		);
   END IF;   

END;;
DELIMITER ;



DROP TRIGGER IF EXISTS trigger_services_delete;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_services_delete` AFTER DELETE ON monit.services FOR EACH ROW
BEGIN
	IF (old.object_id IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			0,
			old.id,
			2,
			null,
			null,
			old.created_at,
			now()
		);
   END IF;   
END;;
DELIMITER ;



/*apps*/
DROP TRIGGER IF EXISTS trigger_apps_insert;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_apps_insert` AFTER INSERT ON monit.apps FOR EACH ROW
BEGIN
	IF (new.host_id IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			2,
			new.id,
			1,
			new.discovery_state,
			(select addr from hosts where id = new.host_id),
			now(),
			now()
		);
   END IF;   
END;;
DELIMITER ;



DROP TRIGGER IF EXISTS trigger_apps_update;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_apps_update` AFTER UPDATE ON monit.apps FOR EACH ROW
BEGIN
	IF (old.host_id is null and new.host_id IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			2,
			new.id,
			1,
			new.discovery_state,
			(select addr from hosts where id = new.host_id),
			old.created_at,
			now()
		);
	elseif (old.host_id <> new.host_id) or (old.name <> new.name) or (old.tenant_id <> new.tenant_id) or (old.type_id <> new.type_id) or (old.port <> new.port) or (old.login_name <> new.login_name) or (old.password <> new.password) or (old.status_url <> new.status_url) then
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			2,
			new.id,
			3,
			new.discovery_state,
			(select addr from hosts where id = new.host_id),
			old.created_at,
			now()
		);
   END IF;   

END;;
DELIMITER ;



DROP TRIGGER IF EXISTS trigger_apps_delete;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_apps_delete` AFTER DELETE ON monit.apps FOR EACH ROW
BEGIN
	IF (old.host_id IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			2,
			old.id,
			2,
			old.discovery_state,
			(select addr from hosts where id = old.host_id),
			old.created_at,
			now()
		);

   END IF;   
END;;
DELIMITER ;

/*hosts*/
DROP TRIGGER IF EXISTS trigger_hosts_insert;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_hosts_insert` AFTER INSERT ON monit.hosts FOR EACH ROW
BEGIN
	IF (new.addr IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			1,
			new.id,
			1,
			new.discovery_state,
			new.addr,
			now(),
			now()
		);
   END IF;   
END;;
DELIMITER ;



DROP TRIGGER IF EXISTS trigger_hosts_update;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_hosts_update` AFTER UPDATE ON monit.hosts FOR EACH ROW
BEGIN
	IF (old.addr is null and new.addr IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			1,
			new.id,
			1,
			new.discovery_state,
			new.addr,
			old.created_at,
			now()
		);
	elseif (old.addr <> new.addr) or (old.name <> new.name) or (old.tenant_id <> new.tenant_id) or (old.type_id <> new.type_id) or (old.port <> new.port) or (old.snmp_ver <> new.snmp_ver) or (old.community <> new.community) or (old.discovery_state <> new.discovery_state and new.discovery_state = 2) then
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			1,
			new.id,
			3,
			new.discovery_state,
			new.addr,
			old.created_at,
			now()
		);
   END IF;   

END;;
DELIMITER ;



DROP TRIGGER IF EXISTS trigger_hosts_delete;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_hosts_delete` AFTER DELETE ON monit.hosts FOR EACH ROW
BEGIN
	IF (old.addr IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			1,
			old.id,
			2,
			old.discovery_state,
			old.addr,
			old.created_at,
			now()
		);
   END IF;   
END;;
DELIMITER ;

/*sites*/
DROP TRIGGER IF EXISTS trigger_sites_insert;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_sites_insert` AFTER INSERT ON monit.sites FOR EACH ROW
BEGIN
	IF (new.url IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			3,
			new.id,
			1,
			new.discovery_state,
			new.url,
			now(),
			now()
		);
   END IF;   
END;;
DELIMITER ;



DROP TRIGGER IF EXISTS trigger_sites_update;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_sites_update` AFTER UPDATE ON monit.sites FOR EACH ROW
BEGIN
	IF (old.url is null and new.url IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			3,
			new.id,
			1,
			new.discovery_state,
			new.url,
			old.created_at,
			now()
		);
	elseif (old.url <> new.url) or (old.name <> new.name) or (old.addr <> new.addr) or (old.port <> new.port) or (old.path <> new.path) or (old.tenant_id <> new.tenant_id) then
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			3,
			new.id,
			3,
			new.discovery_state,
			new.url,
			old.created_at,
			now()
		);
   END IF;   

END;;
DELIMITER ;



DROP TRIGGER IF EXISTS trigger_sites_delete;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_sites_delete` AFTER DELETE ON monit.sites FOR EACH ROW
BEGIN
	IF (old.url IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			3,
			old.id,
			2,
			old.discovery_state,
			old.url,
			old.created_at,
			now()
		);
   END IF;   
END;;
DELIMITER ;

/*devices*/
DROP TRIGGER IF EXISTS trigger_devices_insert;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_devices_insert` AFTER INSERT ON monit.devices FOR EACH ROW
BEGIN
	IF (new.addr IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			4,
			new.id,
			1,
			new.discovery_state,
			new.addr,
			now(),
			now()
		);
   END IF;   
END;;
DELIMITER ;



DROP TRIGGER IF EXISTS trigger_devices_update;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_devices_update` AFTER UPDATE ON monit.devices FOR EACH ROW
BEGIN
	IF (old.addr is null and new.addr IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			4,
			new.id,
			1,
			new.discovery_state,
			new.addr,
			old.created_at,
			now()
		);
	elseif (old.addr <> new.addr) or (old.name <> new.name) or (old.tenant_id <> new.tenant_id) or (old.type_id <> new.type_id) or (old.port <> new.port) or (old.snmp_ver <> new.snmp_ver) or (old.community <> new.community) or (old.discovery_state <> new.discovery_state and new.discovery_state = 2) then
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			4,
			new.id,
			3,
			new.discovery_state,
			new.addr,
			old.created_at,
			now()
		);
   END IF;   

END;;
DELIMITER ;



DROP TRIGGER IF EXISTS trigger_devices_delete;
DELIMITER ;;
CREATE TRIGGER `monit`.`trigger_devices_delete` AFTER DELETE ON monit.devices FOR EACH ROW
BEGIN
	IF (old.addr IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			4,
			old.id,
			2,
			old.discovery_state,
			old.addr,
			old.created_at,
			now()
		);
   END IF;   
END;;
DELIMITER ;


