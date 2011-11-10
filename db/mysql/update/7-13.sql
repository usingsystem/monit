/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
DROP TABLE IF EXISTS operators;

CREATE TABLE `operators` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`host` varchar(255) NOT NULL COMMENT '域名',
	`title` varchar(255) NOT NULL COMMENT '网站名称',
	`logo_url` varchar(255) DEFAULT NULL COMMENT '登录后顶部LOGO',
	`biglogo_url` varchar(255) DEFAULT NULL,
	`footer` text COMMENT '底部',
	`descr` text COMMENT '描述',
	`telphone` varchar(255) DEFAULT NULL,
	`contact` varchar(255) DEFAULT NULL,
	`email` varchar(255) DEFAULT NULL,
	`remember_token` varchar(40) DEFAULT NULL,
	`remember_token_expires_at` datetime default NULL,
	`crypted_password` varchar(255) DEFAULT NULL,
	`salt` varchar(255) DEFAULT NULL,
	`activated_at` date DEFAULT NULL,
	`activation_code` varchar(255) DEFAULT NULL,
	`company` varchar(100) DEFAULT NULL COMMENT '公司名称',
	`is_support_bank` tinyint(1) DEFAULT '0' COMMENT '是否支持银行支付',
	`bank` varchar(100) DEFAULT NULL COMMENT '开户银行',
	`bank_account_name` varchar(100) DEFAULT NULL COMMENT '开户名称',
	`bank_account` varchar(50) DEFAULT NULL COMMENT '开户帐号',
	`bank_tax_number` varchar(50) DEFAULT NULL COMMENT '税务登记号',
	`bank_payment_number` varchar(50) DEFAULT NULL COMMENT '现代化支付系统行号',
	`is_support_alipay` tinyint(1) DEFAULT '0' COMMENT '是否支持支付宝',
	`alipay_email` varchar(255) DEFAULT NULL COMMENT '支付宝帐号',
	`alipay_partner` varchar(255) DEFAULT NULL COMMENT '支付宝partner',
	`alipay_key` varchar(255) DEFAULT NULL COMMENT '支付宝key',
	`created_at` datetime DEFAULT NULL,
	`updated_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`),
	KEY `index_operators_on_host` (`host`)
) ENGINE=InnoDB AUTO_INCREMENT=123522 DEFAULT CHARSET=utf8;

INSERT INTO `operators` (`id`,`host`,`title`,`logo_url`,`biglogo_url`,`footer`,`descr`,`telphone`,`contact`,`email`,`remember_token`,`crypted_password`,`salt`,`activated_at`,`activation_code`,`company`,`is_support_bank`,`bank`,`bank_account_name`,`bank_account`,`bank_tax_number`,`bank_payment_number`,`is_support_alipay`,`alipay_email`,`alipay_partner`,`alipay_key`,`created_at`,`updated_at`)
VALUES
	(0, 'www.monit.cn', 'Monit监控云', 'logo.png', 'index_logo.png', '\n  <span id=\"copyright\">Monit © 2010 <a href=\"http://www.miibeian.gov.cn\" target=\"_blank\">苏ICP备10047828号</a></span>\n  <span>\n    <a href=\"http://blog.monit.cn\">博客</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/about\">关于我们</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/contact\">联系我们</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/jobs\">加入我们</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/terms\">服务条款</a>\n  </span>\n  ', '', NULL, NULL, NULL, '', 'b7c99973abf4a7e21639539034477d38214a23c6', '992483525875bab39e3e0265ac0691f6535f376f', NULL, '', '杭州华思通信技术有限公司', 1, '中国农业银行杭州科技城支行', '杭州华思通信技术有限公司', '036401040014662', '330100679889642', NULL, 1, 'admin@monit.cn', '2088301806356608', 'nu93h8f8jpruxqg1rhfhp8z9rn1jgbsf', NULL, NULL);


DROP TABLE IF EXISTS orders;
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
	`is_paid` tinyint(1) DEFAULT '0',
	`pay_mode` int(1) DEFAULT NULL COMMENT '支付方式 1:支付宝 2:线下支付',
	`paid_at` datetime DEFAULT NULL COMMENT '支付日期',
	`paid_desc` text COMMENT '支付描述',
	`trade_no` varchar(50) DEFAULT NULL,
	`is_support_alipay` tinyint(1) DEFAULT NULL COMMENT '是否支持支付宝',
	`alipay_notify_params` text COMMENT '支付宝付费通知参数',
	`alipay_return_params` text COMMENT '支付宝返回参数',
	`alipay_url` text COMMENT '支付宝支付连接',
	`created_at` datetime default NULL,
	`updated_at` datetime default NULL,
	PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121291 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS packages;
CREATE TABLE `packages` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`operator_id` int(11) DEFAULT NULL,
	`category` int(11) DEFAULT NULL COMMENT '0:free, 1:standard, 2:enterprise',
	`name` varchar(255) DEFAULT NULL,
	`charge` int(9) DEFAULT NULL COMMENT '费用，整数',
	`year_charge` int(9) DEFAULT NULL COMMENT '年付费',
	`year_discount` int(9) DEFAULT '0' COMMENT '年折扣（节省）',
	`year_discount_rate` int(3) DEFAULT NULL,
	`max_hosts` int(11) DEFAULT NULL,
	`max_services` int(11) DEFAULT NULL,
	`min_check_interval` int(11) DEFAULT '300',
	`remark` varchar(255) DEFAULT NULL,
	`created_at` datetime DEFAULT NULL,
	`updated_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

INSERT INTO `packages` (`id`,`operator_id`,`category`,`name`,`charge`,`year_charge`,`year_discount`,`year_discount_rate`,`max_hosts`,`max_services`,`min_check_interval`,`remark`,`created_at`,`updated_at`)
VALUES
(1, 0, 0, '免费版', 0, 0, 0, 0, 2, 10, 600, NULL, NULL, NULL),
(2, 0, 1, '5主机', 50, 510, 90, 15, 5, 50, 300, NULL, NULL, NULL),
(3, 0, 1, '10主机', 90, 918, 162, 15, 10, 100, 300, NULL, NULL, NULL),
(4, 0, 1, '25主机', 200, 1968, 432, 18, 25, 250, 300, NULL, NULL, NULL),
(5, 0, 1, '50主机', 350, 3360, 840, 20, 50, 500, 300, NULL, NULL, NULL),
(6, 0, 2, '10主机', 160, 1632, 288, 15, 10, 100, 120, NULL, NULL, NULL),
(7, 0, 2, '25主机', 350, 3570, 630, 15, 25, 250, 120, NULL, NULL, NULL),
(8, 0, 2, '50主机', 600, 5904, 1296, 18, 50, 500, 120, NULL, NULL, NULL),
(9, 0, 2, '100主机', 1000, 9840, 2160, 18, 100, 1000, 120, NULL, NULL, NULL);

DROP TABLE IF EXISTS bills;
CREATE TABLE `bills` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`tenant_id` int(11) DEFAULT NULL,
	`amount` decimal(9,2) DEFAULT NULL COMMENT '涉及金额',
	`balance` decimal(9,2) DEFAULT NULL,
	`summary` varchar(255) DEFAULT NULL COMMENT '使用描述',
	`begin_date` datetime DEFAULT NULL,
	`end_date` datetime DEFAULT NULL,
	`created_at` datetime DEFAULT NULL COMMENT '产生时间',
	`updated_at` datetime DEFAULT NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13424 DEFAULT CHARSET=utf8;


/*****************/

ALTER TABLE `tenants`
ADD COLUMN operator_id int(11) DEFAULT 0;

ALTER TABLE `tenants`
ADD COLUMN `balance` decimal(10,2) DEFAULT '0.00' COMMENT '帐户余额',
ADD COLUMN `package_id` int(11) DEFAULT NULL,
ADD COLUMN `begin_at` date DEFAULT NULL COMMENT '套餐使用开始日期',
ADD COLUMN `month_num` int(11) DEFAULT '0' COMMENT '套餐使用月数',
ADD COLUMN `end_at` date DEFAULT NULL COMMENT '套餐使用结束日期',
ADD COLUMN `expired_at` date DEFAULT NULL COMMENT '使用过期日期',
ADD COLUMN `current_month` int(11) DEFAULT '0' COMMENT '当前月数',
ADD COLUMN `current_paid_at` date DEFAULT NULL COMMENT '当前月付费日期',
ADD COLUMN `next_paid_at` date DEFAULT NULL COMMENT '下月付费日期',
ADD COLUMN `status` tinyint(1) DEFAULT NULL COMMENT '',
ADD COLUMN `is_pay_account` tinyint(1) DEFAULT '0' COMMENT '是否付费帐户';


update tenants set package_id = 1, begin_at = created_at;

ALTER TABLE `tenants`
ADD COLUMN role int(3) DEFAULT 0 COMMENT '0:普通用户，1:测试用户';

update tenants set role = 1 where name = 'root';
	
update tenants, users set tenants.email = users.email where tenants.name = users.login;

ALTER TABLE `apps`
ADD COLUMN group_id int(11) DEFAULT NULL;
ALTER TABLE `sites`
ADD COLUMN group_id int(11) DEFAULT NULL;
ALTER TABLE `hosts`
ADD COLUMN group_id int(11) DEFAULT NULL;
ALTER TABLE `devices`
ADD COLUMN group_id int(11) DEFAULT NULL;

ALTER TABLE `devices`
ADD COLUMN dev_type varchar(50) DEFAULT NULL,
ADD COLUMN dev_vendor varchar(50) DEFAULT NULL;



INSERT INTO `packages` (`operator_id`,`category`,`name`,`charge`,`year_charge`,`year_discount`,`year_discount_rate`,`max_hosts`,`max_services`,`min_check_interval`,`remark`,`created_at`,`updated_at`)
VALUES
	(123525, 0, '免费版', 0, 0, 0, 0, 2, 10, 600, NULL, NULL, NULL),
	(123525, 1, '5主机', 50, 510, 90, 15, 5, 50, 300, NULL, NULL, NULL),
	(123525, 1, '10主机', 90, 918, 162, 15, 10, 100, 300, NULL, NULL, NULL),
	(123525, 1, '25主机', 200, 1968, 432, 18, 25, 250, 300, NULL, NULL, NULL),
	(123525, 1, '50主机', 350, 3360, 840, 20, 50, 500, 300, NULL, NULL, NULL),
	(123525, 2, '10主机', 160, 1632, 288, 15, 10, 100, 120, NULL, NULL, NULL),
	(123525, 2, '25主机', 350, 3570, 630, 15, 25, 250, 120, NULL, NULL, NULL),
	(123525, 2, '50主机', 600, 5904, 1296, 18, 50, 500, 120, NULL, NULL, NULL),
	(123525, 2, '100主机', 1000, 9840, 2160, 18, 100, 1000, 120, NULL, NULL, NULL);
INSERT INTO `packages` (`operator_id`,`category`,`name`,`charge`,`year_charge`,`year_discount`,`year_discount_rate`,`max_hosts`,`max_services`,`min_check_interval`,`remark`,`created_at`,`updated_at`)
VALUES
	(123526, 0, '免费版', 0, 0, 0, 0, 2, 10, 600, NULL, NULL, NULL),
	(123526, 1, '5主机', 50, 510, 90, 15, 5, 50, 300, NULL, NULL, NULL),
	(123526, 1, '10主机', 90, 918, 162, 15, 10, 100, 300, NULL, NULL, NULL),
	(123526, 1, '25主机', 200, 1968, 432, 18, 25, 250, 300, NULL, NULL, NULL),
	(123526, 1, '50主机', 350, 3360, 840, 20, 50, 500, 300, NULL, NULL, NULL),
	(123526, 2, '10主机', 160, 1632, 288, 15, 10, 100, 120, NULL, NULL, NULL),
	(123526, 2, '25主机', 350, 3570, 630, 15, 25, 250, 120, NULL, NULL, NULL),
	(123526, 2, '50主机', 600, 5904, 1296, 18, 50, 500, 120, NULL, NULL, NULL),
	(123526, 2, '100主机', 1000, 9840, 2160, 18, 100, 1000, 120, NULL, NULL, NULL);
INSERT INTO `packages` (`operator_id`,`category`,`name`,`charge`,`year_charge`,`year_discount`,`year_discount_rate`,`max_hosts`,`max_services`,`min_check_interval`,`remark`,`created_at`,`updated_at`)
VALUES
	(123527, 0, '免费版', 0, 0, 0, 0, 2, 10, 600, NULL, NULL, NULL),
	(123527, 1, '5主机', 50, 510, 90, 15, 5, 50, 300, NULL, NULL, NULL),
	(123527, 1, '10主机', 90, 918, 162, 15, 10, 100, 300, NULL, NULL, NULL),
	(123527, 1, '25主机', 200, 1968, 432, 18, 25, 250, 300, NULL, NULL, NULL),
	(123527, 1, '50主机', 350, 3360, 840, 20, 50, 500, 300, NULL, NULL, NULL),
	(123527, 2, '10主机', 160, 1632, 288, 15, 10, 100, 120, NULL, NULL, NULL),
	(123527, 2, '25主机', 350, 3570, 630, 15, 25, 250, 120, NULL, NULL, NULL),
	(123527, 2, '50主机', 600, 5904, 1296, 18, 50, 500, 120, NULL, NULL, NULL),
	(123527, 2, '100主机', 1000, 9840, 2160, 18, 100, 1000, 120, NULL, NULL, NULL);
