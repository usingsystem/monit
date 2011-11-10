

CREATE TABLE `idea_comments` (
  `id` int(11) NOT NULL auto_increment,
  `idea_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `content` blob,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

CREATE TABLE `idea_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) character set utf8 default NULL,
  `desc` varchar(255) character set utf8 default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

CREATE TABLE `idea_votes` (
  `id` int(11) NOT NULL auto_increment,
  `idea_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `num` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

CREATE TABLE `ideas` (
  `id` int(11) NOT NULL auto_increment,
  `type_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `title` varchar(500) character set utf8 default NULL,
  `content` blob,
  `status` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;


INSERT INTO `idea_types` VALUES (1,'建议','网站建议','2010-05-11 15:49:08','2010-05-11 15:49:17'),(2,'错误','网站错误','2010-05-19 15:50:49','2010-05-19 15:50:56'),(3,'问题','疑问','2010-05-20 15:52:48','2010-05-20 15:52:55');

