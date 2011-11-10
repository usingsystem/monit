CREATE TABLE `groups` (
	  `id` int(11) NOT NULL AUTO_INCREMENT,
	  `tenant_id` int(11) DEFAULT NULL,
	  `parent` int(11) DEFAULT NULL,
	  `name` varchar(50) DEFAULT NULL,
	  `desc` varchar(255) DEFAULT NULL,
	  `created_at` datetime DEFAULT NULL,
	  `updated_at` datetime DEFAULT NULL,
	  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8;

ALTER TABLE hosts 
add column group_id int(11) default 0;
