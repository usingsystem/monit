--`template_id` int(11) DEFAULT NULL,
--`parent_id` int(11) DEFAULT NULL, COMMENT 'parent view id'
CREATE TABLE `views` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`name` varchar(50) DEFAULT NULL,
	`template` int(11) DEFAULT NULL,
	`visible_type` int(2) DEFAULT NULL COMMENT '1:host_type, 2:app_type, 3:service_type',
	`visible_id` int(11) DEFAULT NULL,
	`data_action` varchar(100) DEFAULT NULL COMMENT 'metrics',
	`data_query` varchar(100) DEFAULT NULL COMMENT 't=current&select=load1,load5,load15',
	`width` varchar(10) DEFAULT NULL,
	`height` varchar(10) DEFAULT NULL,
	`created_at` datetime DEFAULT NULL,
	`updated_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `view_items` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`view_id` int(11) DEFAULT NULL,
	`name` varchar(15) DEFAULT NULL,
	`alias` varchar(30) DEFAULT NULL,
	`color` varchar(15) DEFAULT NULL,
	`hover_color` varchar(15) DEFAULT NULL,
	`created_at` datetime DEFAULT NULL,
	`updated_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


CREATE TABLE `templates` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`name` varchar(50) DEFAULT NULL,
	`tags` varchar(50) DEFAULT NULL COMMENT 'chart, google, grid, image, charttools, interactive, amcharts, ziya, pie, line, column, bar...',
	`require` varchar(50) DEFAULT NULL,
	`code` blob DEFAULT NULL,
	`desc` varchar(255) DEFAULT NULL,
	`created_at` datetime DEFAULT NULL,
	`updated_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;


