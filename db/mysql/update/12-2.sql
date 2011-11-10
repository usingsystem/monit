
ALTER TABLE tenants
ADD COLUMN `login` varchar(50) DEFAULT NULL,
ADD COLUMN `work_number` varchar(50) DEFAULT NULL,
ADD COLUMN `birthday` date DEFAULT NULL,
ADD COLUMN `remember_token` varchar(40) DEFAULT NULL,
ADD COLUMN `crypted_password` varchar(40) DEFAULT NULL,
ADD COLUMN `old_password` varchar(50) DEFAULT NULL,
ADD COLUMN `remember_token_expires_at` datetime DEFAULT NULL,
ADD COLUMN `salt` varchar(40) DEFAULT NULL,
ADD COLUMN `role_id` int(11) DEFAULT NULL,
ADD COLUMN `department` varchar(50) DEFAULT NULL,
ADD COLUMN `job` varchar(50) DEFAULT NULL,
ADD COLUMN `phone` varchar(50) DEFAULT NULL,
ADD COLUMN `description` varchar(50) DEFAULT NULL,
ADD COLUMN `creator` int(11) DEFAULT NULL,
ADD COLUMN `state` int(2) DEFAULT '1' COMMENT '0:invalid 1:valid',
ADD COLUMN `activation_code` varchar(40) DEFAULT NULL,
ADD COLUMN `reset_password_code` varchar(40) DEFAULT NULL,
ADD COLUMN `activated_at` datetime DEFAULT NULL,
ADD COLUMN `weekly` tinyint(1) DEFAULT '1' COMMENT '支持周报',
ADD COLUMN `daily` tinyint(1) DEFAULT '1' COMMENT '支持日报',
ADD COLUMN `monthly` tinyint(1) DEFAULT '1',
ADD COLUMN `industry` varchar(255) DEFAULT NULL,
ADD COLUMN `session_id` char(30) DEFAULT NULL;

update tenants t1, users t2 set t1.login = t2.login, t1.work_number = t2.work_number, t1.birthday = t2.birthday, t1.remember_token = t2.remember_token, t1.crypted_password = t2.crypted_password, t1.old_password = t2.old_password, t1.remember_token_expires_at = t2.remember_token_expires_at, t1.salt = t2.salt, t1.role_id = t2.role_id, t1.department = t2.department, t1.job = t2.job, t1.phone = t2.phone, t1.description = t2.description, t1.creator = t2.creator, t1.state = t2.state, t1.activation_code = t2.activation_code, t1.reset_password_code = t2.reset_password_code, t1.activated_at = t2.activated_at, t1.weekly = t2.weekly, t1.daily = t2.daily, t1.monthly = t2.monthly, t1.industry = t2.industry, t1.session_id = t2.session_id where t2.tenant_id = t1.id;


/*
[id] => 3
[account_id] => 3
[create_on] => 2009-03-17 21:03:13
[level_id] => 1
[member_type] => 2
[vp_type] => 0
[approved] => 1
[name] => 董松生
[country] => CN
[province] => BJ
[city] => 浙江省
[address1] => 杭州
[address2] => 杭州
[postcode] => 310014
[telno] => 0571-86661351
[faxno] => 0571-86661353
[email] => dongsheng329@163.com
网络  18:51:55
[country] => CN
[province] => BJ  这个不用了
[name] => 董松生
[city] => 浙江省
[address1] => 杭州
[address2] => 杭州
[postcode] => 310014
[telno] => 0571-86661351
[faxno] => 0571-86661353
[email] => dongsheng329@163.com
*/
