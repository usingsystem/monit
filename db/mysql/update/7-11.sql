
/*groups*/
CREATE TABLE `groups` (
	  `id` int(11) NOT NULL auto_increment,
	  `tenant_id` int(11) default NULL,
	  `parent_id` int(11) default NULL,
	  `name_alias` varchar(50) default NULL,
	  `name` varchar(50) default NULL,
	  `descr` varchar(50) default NULL,
	  `created_at` datetime default NULL,
	  `updated_at` datetime default NULL,
	  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
INSERT INTO `groups` (`id`,`tenant_id`,`parent_id`,`name_alias`,`name`,`descr`,`created_at`,`updated_at`)
VALUES
	(1, 0, NULL, '/', '/', '缺省分组', NULL, NULL);

