CREATE TABLE `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `tenant_id` int(11) default NULL,
  `package_id` int(11) default NULL,
  `name` varchar(255) collate utf8_unicode_ci default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `agents` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(50) default NULL,
  `password` varchar(40) default NULL,
  `name` varchar(50) default NULL,
  `tenant_id` int(11) default NULL,
  `host_id` int(11) default NULL,
  `presence` varchar(40) default 'unavailable' COMMENT 'available, unavailable, busy',
  `summary` varchar(100) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;

CREATE TABLE `alert_notifications` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `method` int(11) default NULL,
  `user_id` int(11) default NULL,
  `alert_id` int(11) default NULL,
  `alert_name` varchar(100) default NULL,
  `alert_severity` int(2) default NULL,
  `alert_status` int(2) default NULL,
  `alert_last_status` int(2) default NULL,
  `alert_summary` varchar(255) default NULL,
  `service_id` int(11) default NULL,
  `source_id` int(11) default NULL,
  `source_type` int(11) default NULL,
  `tenant_id` int(11) default NULL,
  `status` int(11) default '0' COMMENT '0:unsent 1:sent',
  `last_notification` datetime default NULL,
  `current_notification_number` int(11) default '0',
  `occured_at` datetime default NULL,
  `changed_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11881 DEFAULT CHARSET=utf8;

CREATE TABLE `alerts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL COMMENT 'service name',
  `service_id` int(11) default NULL,
  `source_id` int(11) default NULL COMMENT 'host or application',
  `source_type` int(2) default NULL COMMENT '1:host 2:app 3:site',
  `tenant_id` int(11) default NULL,
  `severity` int(2) default '0',
  `status` int(2) default '0',
  `status_type` int(2) default NULL,
  `last_status` int(2) default '0',
  `ctrl_state` tinyint(2) default NULL,
  `summary` varchar(200) default NULL,
  `occur_count` int(11) default NULL,
  `last_check` datetime default NULL,
  `next_check` datetime default NULL,
  `occured_at` datetime default NULL,
  `changed_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `i_alerts_service_id` (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4912 DEFAULT CHARSET=utf8;

CREATE TABLE `app_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `parent_id` int(11) default NULL COMMENT '1:parent 2:son',
  `level` int(11) default NULL,
  `creator` int(11) default NULL,
  `remark` varchar(100) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `apps` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `tag` varchar(50) default NULL,
  `uuid` varchar(50) default 'uuid()',
  `host_id` int(11) default NULL,
  `tenant_id` int(11) default NULL,
  `agent_id` int(11) default NULL,
  `type_id` int(11) default NULL,
  `port` int(11) default NULL,
  `login_name` varchar(50) default NULL,
  `sid` varchar(50) default NULL,
  `password` varchar(50) default NULL,
  `status_url` varchar(50) default NULL,
  `discovery_state` int(2) default '0' COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `last_check` datetime default NULL,
  `next_check` datetime default NULL,
  `duration` int(11) default NULL,
  `status` int(2) default '2',
  `summary` varchar(200) default NULL,
  `last_update` datetime default NULL,
  `last_time_up` datetime default NULL,
  `last_time_down` datetime default NULL,
  `last_time_pending` datetime default NULL,
  `last_time_unknown` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_notification` datetime default NULL,
  `current_notification_number` int(11) default '0',
  `notifications_enabled` tinyint(2) default '1',
  `first_notification_delay` int(11) default '300',
  `notification_interval` int(11) default '7200',
  `notification_times` int(11) default '1',
  `notify_on_recovery` tinyint(2) default '1',
  `notify_on_down` tinyint(2) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

CREATE TABLE `bills` (
  `id` int(11) NOT NULL auto_increment,
  `tenant_id` int(11) default NULL,
  `amount` decimal(9,2) default NULL COMMENT '涉及金额',
  `balance` decimal(9,2) default NULL,
  `summary` varchar(255) default NULL COMMENT '使用描述',
  `begin_date` datetime default NULL,
  `end_date` datetime default NULL,
  `created_at` datetime default NULL COMMENT '产生时间',
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `business` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `tenant_id` int(11) default NULL,
  `parent_id` int(11) default NULL,
  `remark` varchar(100) default NULL,
  `last_check` datetime default NULL,
  `next_check` datetime default NULL,
  `duration` int(11) default NULL,
  `avail_status` int(2) default NULL,
  `summary` varchar(200) default NULL,
  `last_time_ok` datetime default NULL,
  `last_time_warning` datetime default NULL,
  `last_time_critical` datetime default NULL,
  `last_time_unknown` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `uuid` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `business_services` (
  `business_id` int(11) default NULL,
  `service_id` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `checked_status` (
  `service_id` int(11) default NULL,
  `uuid` varchar(50) default NULL,
  `status` int(11) default NULL,
  `summary` varchar(200) default NULL,
  `last_check` bigint(20) NOT NULL,
  `next_check` bigint(20) NOT NULL,
  `status_type` int(2) default NULL COMMENT '1:Transient 2:Permanent',
  `duration` int(11) default NULL,
  `latency` int(11) default NULL,
  `current_attempts` int(11) default NULL,
  `oper_tag` int(2) default NULL COMMENT 'used when deal with data',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  UNIQUE KEY `i_checked_status_service_id` (`service_id`),
  KEY `i_checked_status_uuid` (`uuid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `device_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `parent_id` int(11) default NULL,
  `level` int(11) default NULL COMMENT '1:parent 2:son',
  `creator` int(11) default NULL,
  `remark` varchar(100) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `devices` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `tag` varchar(50) default NULL,
  `model` varchar(50) default NULL,
  `mac` varchar(20) default NULL,
  `os_desc` varchar(50) default NULL,
  `addr` varchar(50) NOT NULL,
  `uuid` varchar(50) default NULL,
  `tenant_id` int(11) default NULL,
  `agent_id` int(11) default NULL,
  `is_support_snmp` int(2) default NULL COMMENT '0:false 1:true',
  `type_id` int(11) default NULL,
  `port` int(11) default NULL,
  `snmp_ver` varchar(20) default NULL,
  `community` varchar(20) default NULL,
  `discovery_state` int(2) default '0' COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `last_check` datetime default NULL,
  `next_check` datetime default NULL,
  `duration` int(11) default NULL,
  `status` int(2) NOT NULL default '2',
  `summary` varchar(200) default NULL,
  `last_time_up` datetime default NULL,
  `last_time_down` datetime default NULL,
  `last_time_pending` datetime default NULL,
  `last_time_unknown` datetime default NULL,
  `last_time_unreachable` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_notification` datetime default NULL,
  `current_notification_number` int(11) default '0',
  `notifications_enabled` tinyint(2) default '1',
  `first_notification_delay` int(11) default '300',
  `notification_interval` int(11) default '7200',
  `notification_times` int(11) default '1',
  `notify_on_recovery` tinyint(2) default '1',
  `notify_on_down` tinyint(2) default '1',
  `notify_on_unreachable` tinyint(2) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8;

CREATE TABLE `disco_services` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `serviceable_type` int(11) default NULL COMMENT '1:host 2:app 3:site',
  `serviceable_id` int(11) default NULL,
  `tenant_id` int(11) default NULL,
  `agent_id` int(11) default NULL,
  `type_id` int(11) default NULL,
  `params` varchar(200) default NULL,
  `command` varchar(100) default NULL,
  `summary` varchar(200) default NULL,
  `desc` varchar(200) default NULL,
  `updated_at` datetime default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `service_command_params` (`serviceable_type`,`serviceable_id`,`command`,`params`)
) ENGINE=InnoDB AUTO_INCREMENT=932 DEFAULT CHARSET=utf8;

CREATE TABLE `disco_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `object_class` int(2) default '1' COMMENT '1:host_types 2:app_types',
  `object_type` int(11) default NULL,
  `method` int(11) default NULL,
  `command` varchar(100) default NULL,
  `args` varchar(255) default NULL,
  `service_type` int(11) default NULL,
  `external` int(2) default '1',
  `remark` varchar(100) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;

CREATE TABLE `host_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `parent_id` int(11) default NULL,
  `level` int(11) default NULL COMMENT '1:parent 2:son',
  `creator` int(11) default NULL,
  `remark` varchar(100) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

CREATE TABLE `hosts` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `tag` varchar(50) default NULL,
  `model` varchar(50) default NULL,
  `mac` varchar(20) default NULL,
  `os_desc` varchar(50) default NULL,
  `addr` varchar(50) NOT NULL,
  `uuid` varchar(50) default NULL,
  `tenant_id` int(11) default NULL,
  `agent_id` int(11) default NULL,
  `is_support_remote` int(2) default NULL COMMENT '0:false 1:true',
  `is_support_snmp` int(2) default NULL COMMENT '0:false 1:true',
  `is_support_ssh` int(2) default NULL COMMENT '0:false 1:true',
  `type_id` int(11) default NULL,
  `port` int(11) default NULL,
  `snmp_ver` varchar(20) default NULL,
  `community` varchar(20) default NULL,
  `discovery_state` int(2) default '0' COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `last_check` datetime default NULL,
  `next_check` datetime default NULL,
  `duration` int(11) default NULL,
  `status` int(2) default '2',
  `summary` varchar(200) default NULL,
  `last_time_up` datetime default NULL,
  `last_time_down` datetime default NULL,
  `last_time_pending` datetime default NULL,
  `last_time_unknown` datetime default NULL,
  `last_time_unreachable` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_notification` datetime default NULL,
  `current_notification_number` int(11) default '0',
  `notifications_enabled` tinyint(2) default '1',
  `first_notification_delay` int(11) default '300',
  `notification_interval` int(11) default '7200',
  `notification_times` int(11) default '1',
  `notify_on_recovery` tinyint(2) default '1',
  `notify_on_down` tinyint(2) default '1',
  `notify_on_unreachable` tinyint(2) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8;

CREATE TABLE `idea_comments` (
  `id` int(11) NOT NULL auto_increment,
  `idea_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `content` blob,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `idea_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `desc` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `idea_votes` (
  `id` int(11) NOT NULL auto_increment,
  `idea_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `num` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

CREATE TABLE `ideas` (
  `id` int(11) NOT NULL auto_increment,
  `type_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `title` varchar(500) default NULL,
  `content` blob,
  `status` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `invite_codes` (
  `id` int(11) NOT NULL auto_increment,
  `code` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `user_name` varchar(255) default NULL,
  `status` tinyint(2) default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8;

CREATE TABLE `locales` (
  `id` int(11) NOT NULL auto_increment,
  `country` varchar(20) default NULL,
  `language` varchar(20) default NULL,
  `res` varchar(100) default NULL,
  `string` varchar(300) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=utf8;

CREATE TABLE `logm_operations` (
  `id` int(11) NOT NULL auto_increment,
  `sessions` varchar(50) default NULL,
  `user_id` int(11) default NULL,
  `user_name` varchar(100) default NULL,
  `action` varchar(100) default NULL,
  `result` varchar(100) default NULL,
  `details` varchar(100) default NULL,
  `module_name` varchar(10) default NULL,
  `terminal_ip` varchar(20) default NULL,
  `updated_at` datetime default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3051 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=1307 DEFAULT CHARSET=utf8;

CREATE TABLE `notifications` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `method` int(11) default NULL COMMENT '0:email 1:phone',
  `address` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `contact` varchar(255) default NULL,
  `type_id` int(11) default NULL COMMENT '1:alert 2:report',
  `tenant_id` int(11) default NULL,
  `status` int(11) default '0' COMMENT '0:unsent 1:sent 2:read',
  `title` varchar(100) default NULL,
  `summary` varchar(255) default NULL,
  `content` blob,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11459 DEFAULT CHARSET=utf8;

CREATE TABLE `object_changed` (
  `id` int(11) NOT NULL auto_increment,
  `agent_id` int(11) default NULL,
  `object_class` int(2) default NULL,
  `object_id` int(11) default NULL,
  `uuid` varchar(50) default NULL,
  `oper_type` int(2) default NULL COMMENT '1: add 2:delete 3:update',
  `discovery_state` int(2) default NULL COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `addr` varchar(50) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

CREATE TABLE `operators` (
  `id` int(11) NOT NULL auto_increment,
  `host` varchar(255) NOT NULL COMMENT '域名',
  `title` varchar(255) NOT NULL COMMENT '网站名称',
  `logo_url` varchar(255) default NULL COMMENT '登录后顶部LOGO',
  `biglogo_url` varchar(255) default NULL,
  `footer` text COMMENT '底部',
  `descr` text COMMENT '描述',
  `telphone` varchar(255) default NULL,
  `contact` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `remember_token` varchar(40) default NULL,
  `crypted_password` varchar(255) default NULL,
  `salt` varchar(255) default NULL,
  `activated_at` date default NULL,
  `activation_code` varchar(255) default NULL,
  `company` varchar(100) default NULL COMMENT '公司名称',
  `is_support_bank` tinyint(1) default '1' COMMENT '是否支持银行支付',
  `bank` varchar(100) default NULL COMMENT '开户银行',
  `bank_account_name` varchar(100) default NULL COMMENT '开户名称',
  `bank_account` varchar(50) default NULL COMMENT '开户帐号',
  `bank_tax_number` varchar(50) default NULL COMMENT '税务登记号',
  `bank_payment_number` varchar(50) default NULL COMMENT '现代化支付系统行号',
  `is_support_alipay` tinyint(1) default '0' COMMENT '是否支持支付宝',
  `alipay_email` varchar(255) default NULL COMMENT '支付宝帐号',
  `alipay_partner` varchar(255) default NULL COMMENT '支付宝partner',
  `alipay_key` varchar(255) default NULL COMMENT '支付宝key',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token_expires_at` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_operators_on_host` (`host`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `orders` (
  `id` int(11) NOT NULL auto_increment,
  `tenant_id` int(11) NOT NULL COMMENT '租户id',
  `package_id` int(11) default NULL COMMENT '套餐',
  `month_num` int(3) default NULL COMMENT '时长(月)',
  `out_trade_no` varchar(50) default NULL COMMENT '订单号',
  `total_fee` decimal(9,2) default NULL COMMENT '付费金额',
  `body` varchar(255) default NULL COMMENT '标题',
  `subject` varchar(500) default NULL COMMENT '内容',
  `status` int(2) default '0' COMMENT '0:waiting, 1: paid',
  `is_paid` tinyint(1) default '0',
  `pay_mode` int(1) default NULL COMMENT '支付方式 1:支付宝 2:线下支付',
  `paid_at` datetime default NULL COMMENT '支付日期',
  `paid_desc` text COMMENT '支付描述',
  `trade_no` varchar(50) default NULL,
  `is_support_alipay` tinyint(1) default NULL COMMENT '是否支持支付宝',
  `alipay_notify_params` text COMMENT '支付宝付费通知参数',
  `alipay_return_params` text COMMENT '支付宝返回参数',
  `alipay_url` text COMMENT '支付宝支付连接',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121296 DEFAULT CHARSET=utf8;

CREATE TABLE `packages` (
  `id` int(11) NOT NULL auto_increment,
  `operator_id` int(11) default NULL,
  `category` int(11) default NULL,
  `name` varchar(255) default NULL,
  `charge` int(9) default NULL,
  `year_charge` int(9) default NULL,
  `year_discount` int(9) default '0',
  `year_discount_rate` int(3) default NULL,
  `max_hosts` int(11) default NULL,
  `max_services` int(11) default NULL,
  `min_check_interval` int(11) default '300',
  `remark` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

CREATE TABLE `preferences` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `owner_type` varchar(255) NOT NULL,
  `group_id` int(11) default NULL,
  `group_type` varchar(255) default NULL,
  `value` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_preferences_on_owner_and_name_and_preference` (`owner_id`,`owner_type`,`name`,`group_id`,`group_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

CREATE TABLE `roster_version` (
  `username` varchar(250) NOT NULL,
  `version` text NOT NULL,
  PRIMARY KEY  (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `rostergroups` (
  `username` varchar(250) NOT NULL,
  `jid` varchar(250) NOT NULL,
  `grp` text NOT NULL,
  KEY `pk_rosterg_user_jid` (`username`(75),`jid`(75))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `rosterusers` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(250) NOT NULL,
  `jid` varchar(250) NOT NULL,
  `nick` text NOT NULL,
  `subscription` char(1) NOT NULL,
  `ask` char(1) NOT NULL,
  `askmessage` text NOT NULL,
  `server` char(1) NOT NULL,
  `subscribe` text NOT NULL,
  `type` text,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `i_rosteru_user_jid` (`username`(75),`jid`(75)),
  KEY `i_rosteru_username` (`username`),
  KEY `i_rosteru_jid` (`jid`)
) ENGINE=InnoDB AUTO_INCREMENT=235 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) collate utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `service_metrics` (
  `id` int(11) NOT NULL auto_increment,
  `type_id` int(11) default NULL COMMENT 'service_type',
  `name` varchar(50) default NULL,
  `metric_type` varchar(50) default NULL,
  `unit` varchar(20) default NULL,
  `calc` varchar(50) default NULL COMMENT 'counter/derive/gauge',
  `desc` varchar(50) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `group` varchar(50) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8;

CREATE TABLE `service_params` (
  `id` int(11) NOT NULL auto_increment,
  `type_id` int(2) default NULL COMMENT 'belong to service_types',
  `name` varchar(100) default NULL,
  `alias` varchar(100) default NULL,
  `default_value` varchar(100) default NULL,
  `param_type` int(2) default NULL COMMENT '1:value 2:variable',
  `unit` varchar(20) default NULL,
  `required` int(2) default '0',
  `desc` varchar(100) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8;

CREATE TABLE `service_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `default_name` varchar(100) default NULL,
  `alias` varchar(100) default NULL,
  `check_type` int(2) default NULL COMMENT '1:passive 2:active',
  `disco_type` int(2) default '0' COMMENT '1:snmp 2:ssh 3:local',
  `command` varchar(100) default NULL,
  `multi_services` int(2) default '0',
  `ctrl_state` int(2) default '0' COMMENT '0:false 1:true',
  `external` int(2) default '1',
  `check_interval` int(11) default NULL COMMENT 'second',
  `metric_id` int(11) default NULL,
  `serviceable_type` int(11) default NULL COMMENT '1:host_types 2:app_types',
  `serviceable_id` int(11) default NULL COMMENT 'belong to app_types',
  `threshold_warning` varchar(200) default NULL,
  `threshold_critical` varchar(200) default NULL,
  `disco_auto` int(2) default '0' COMMENT '0:false 1:true',
  `creator` int(11) default NULL,
  `remark` varchar(100) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;

CREATE TABLE `services` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `uuid` varchar(50) default NULL,
  `serviceable_type` int(11) default NULL COMMENT '1:host 2:app',
  `serviceable_id` int(11) default NULL,
  `ctrl_state` int(2) default '0' COMMENT '0:false 1:true',
  `external` int(2) default '1',
  `tenant_id` int(11) default NULL,
  `agent_id` int(11) default NULL,
  `type_id` int(11) default NULL,
  `command` varchar(100) default NULL,
  `params` varchar(200) default NULL,
  `check_interval` int(11) default NULL COMMENT 'second',
  `desc` varchar(200) default NULL,
  `is_collect` int(2) default '1' COMMENT '0:false 1:true',
  `last_check` datetime default NULL,
  `next_check` datetime default NULL,
  `max_attempts` int(11) default '3',
  `attempt_interval` int(11) default '30' COMMENT 'second',
  `current_attempts` int(11) default NULL,
  `latency` int(11) default NULL,
  `duration` int(11) default NULL,
  `status` int(2) default '4',
  `status_type` int(2) default '2' COMMENT '1:Transient 2:Permanent',
  `summary` varchar(1000) default NULL,
  `metric_data` text,
  `last_time_ok` datetime default NULL,
  `last_time_warning` datetime default NULL,
  `last_time_critical` datetime default NULL,
  `last_time_unknown` datetime default NULL,
  `threshold_critical` varchar(200) default NULL,
  `threshold_warning` varchar(200) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_notification` datetime default NULL,
  `current_notification_number` int(11) default '0',
  `notifications_enabled` tinyint(2) default '1',
  `first_notification_delay` int(11) default '300',
  `notification_interval` int(11) default '7200',
  `notification_times` int(11) default '1',
  `notify_on_recovery` tinyint(2) default '1',
  `notify_on_warning` tinyint(2) default '0',
  `notify_on_unknown` tinyint(2) default '0',
  `notify_on_critical` tinyint(2) default '1',
  `flap_detection_enabled` tinyint(2) default '1',
  `is_flapping` tinyint(2) default '0',
  `flap_low_threshold` int(11) default '20',
  `flap_high_threshold` int(11) default '30',
  `flap_percent_state_change` int(11) default '0',
  PRIMARY KEY  (`id`),
  KEY `i_service_command` (`serviceable_type`,`serviceable_id`,`command`,`params`)
) ENGINE=InnoDB AUTO_INCREMENT=1419 DEFAULT CHARSET=utf8;

CREATE TABLE `sites` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `url` varchar(255) default NULL,
  `addr` varchar(255) default NULL,
  `port` int(11) default '80',
  `path` varchar(200) default NULL,
  `uuid` varchar(50) default 'uuid()',
  `agent_id` int(11) default NULL,
  `tenant_id` int(11) default NULL,
  `discovery_state` int(2) default '0' COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `last_check` datetime default NULL,
  `next_check` datetime default NULL,
  `duration` int(11) default NULL,
  `status` int(2) default '2',
  `summary` varchar(200) default NULL,
  `last_update` datetime default NULL,
  `last_time_up` datetime default NULL,
  `last_time_down` datetime default NULL,
  `last_time_pending` datetime default NULL,
  `last_time_unknown` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_notification` datetime default NULL,
  `current_notification_number` int(11) default '0',
  `notifications_enabled` tinyint(2) default '1',
  `first_notification_delay` int(11) default '300',
  `notification_interval` int(11) default '7200',
  `notification_times` int(11) default '1',
  `notify_on_recovery` tinyint(2) default '1',
  `notify_on_down` tinyint(2) default '1',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8;

CREATE TABLE `tenants` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `company` varchar(50) default NULL,
  `email` varchar(50) default NULL,
  `mobile` varchar(20) default NULL,
  `expired_at` datetime default NULL,
  `db_host` varchar(40) default NULL,
  `db_name` varchar(40) default NULL,
  `port` int(11) default NULL,
  `username` varchar(40) default NULL,
  `password` varchar(40) default NULL,
  `pay_date` datetime default NULL,
  `avail_date` datetime default NULL,
  `remark` varchar(100) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `operator_id` int(11) default NULL,
  `package_id` int(11) default NULL,
  `package_category` int(11) default NULL,
  `amount` decimal(10,0) default NULL,
  `status` tinyint(1) default NULL,
  `balance` decimal(10,0) default NULL,
  `month_num` int(11) default NULL,
  `is_pay_account` tinyint(1) default '0',
  `begin_at` date default NULL COMMENT '套餐使用开始日期',
  `end_at` date default NULL COMMENT '套餐使用结束日期',
  `current_month` int(11) default '0' COMMENT '当前月数',
  `current_paid_at` date default NULL COMMENT '当前月付费日期',
  `next_paid_at` date default NULL COMMENT '下月付费日期',
  `remember_token_expires_at` date default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(50) default NULL,
  `username` varchar(50) default NULL,
  `work_number` varchar(50) default NULL,
  `name` varchar(50) default NULL,
  `birthday` date default NULL,
  `remember_token` varchar(40) default NULL,
  `crypted_password` varchar(40) default NULL,
  `password` varchar(40) default NULL,
  `old_password` varchar(50) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `salt` varchar(40) default NULL,
  `role_id` int(11) default NULL,
  `tenant_id` int(11) default NULL,
  `company` varchar(50) default NULL,
  `department` varchar(50) default NULL,
  `job` varchar(50) default NULL,
  `phone` varchar(50) default NULL,
  `mobile` varchar(50) default NULL,
  `email` varchar(50) default NULL,
  `description` varchar(50) default NULL,
  `creator` int(11) default NULL,
  `state` int(2) default '1' COMMENT '0:invalid 1:valid',
  `activation_code` varchar(40) default NULL,
  `reset_password_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8;

CREATE TABLE `view_items` (
  `id` int(11) NOT NULL auto_increment,
  `view_id` int(11) default NULL,
  `name` varchar(100) default NULL,
  `alias` varchar(100) default NULL,
  `data_type` varchar(10) default 'int',
  `data_unit` varchar(20) default NULL,
  `data_format` varchar(255) default NULL,
  `data_format_params` varchar(255) default NULL,
  `width` varchar(10) default NULL,
  `height` varchar(10) default NULL,
  `fill` varchar(10) default NULL,
  `color` varchar(15) default NULL,
  `hover_color` varchar(15) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1370 DEFAULT CHARSET=utf8;

CREATE TABLE `views` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `visible_type` varchar(20) default NULL COMMENT '1:host_type, 2:app_type, 3:s\\nervice_type',
  `visible_id` int(11) default NULL,
  `data_params` varchar(255) default NULL,
  `template` varchar(50) default NULL,
  `dimensionality` int(11) default '3',
  `enable` tinyint(4) default '1',
  `width` varchar(10) default NULL,
  `height` varchar(10) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=767 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('20100705021513');

INSERT INTO schema_migrations (version) VALUES ('20100705042605');

INSERT INTO schema_migrations (version) VALUES ('20100711011432');

INSERT INTO schema_migrations (version) VALUES ('20100711014338');

INSERT INTO schema_migrations (version) VALUES ('20100712082205');

INSERT INTO schema_migrations (version) VALUES ('20100712085806');