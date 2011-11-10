/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;

DROP EVENT IF EXISTS `clear_alerts_event`;

CREATE EVENT `clear_alerts_event` ON SCHEDULE EVERY 1 DAY DO CALL clear_alerts();

DROP EVENT IF EXISTS `merge_status_event`;

CREATE EVENT `merge_status_event` ON SCHEDULE EVERY 1 MINUTE DO CALL merge_status();

DROP EVENT IF EXISTS `clear_disco_services_event`;

CREATE EVENT `clear_disco_services_event` ON SCHEDULE EVERY 1 DAY DO CALL clear_disco_services();


