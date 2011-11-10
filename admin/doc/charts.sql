--`data_items` varchar(100) DEFAULT NULL COMMENT 'From metric_types ep: load1,load5,load15',
--`data_colors` varchar(100) DEFAULT NULL COMMENT 'ep: #FFF000,#FFF333,#FFF555',
/*graphs*/
CREATE TABLE `service_graphs` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	--`type_id` int(2) DEFAULT '1' COMMENT '1:google image chart, 2:amcharts',
	`template` varchar(20) DEFAULT NULL,
	--`template_id` int(11) DEFAULT NULL,
	`service_type_id` int(11) DEFAULT NULL,
	`is_thumbnail` tinyint(1) DEFAULT NULL,
	`title` varchar(50) DEFAULT NULL,
	`width` varchar(10) DEFAULT NULL,
	`height` varchar(10) DEFAULT NULL,
	`data_type` int(2) DEFAULT NULL COMMENT '1:current, 2:history |History data come from user filter',
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

CREATE TABLE `graph_items` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`graph_id` int(11) DEFAULT NULL,
	`metric_type_id` int(11) DEFAULT NULL,
	`color` varchar(15) DEFAULT NULL,
	`created_at` datetime DEFAULT NULL,
	`updated_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `views` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`viewable_type` int(2) DEFAULT '1' COMMENT '1:host, 2:app, 3:service',
	`viewable_id` int(11) DEFAULT NULL,
	`graph_id` int(11) DEFAULT NULL,
	`created_at` datetime DEFAULT NULL,
	`updated_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
