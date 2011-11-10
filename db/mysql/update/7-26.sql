/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
ALTER TABLE `bills`
ADD COLUMN operator_id int(11) DEFAULT NULL;
update bills, tenants set bills.operator_id = tenants.operator_id where tenants.id = bills.tenant_id;

