CREATE TABLE `logm_securities` (
  `id` int(11) NOT NULL auto_increment,
  `session` varchar(50) default NULL,
  `user` int(11) default NULL,
  `user_name` varchar(255) default NULL,
  `terminal_ip` varchar(255) default NULL,
  `host_name` varchar(255) default NULL,
  `security_cause` varchar(255) default NULL,
  `details` varchar(255) default NULL,
  `affected_user` varchar(255) default NULL,
  `security_action` varchar(255) default NULL,
  `result` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
)  ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;