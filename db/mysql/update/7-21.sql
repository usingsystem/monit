/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
ALTER TABLE `users`
ADD COLUMN group_id int(11) DEFAULT NULL;


ALTER TABLE `operators`
ADD COLUMN page_contact text COMMENT '联系我们页面内容',
ADD COLUMN page_about text COMMENT '关于我们页面内容';

update `operators` set	footer = '\n  <span id=\"copyright\">Monit © 2010 <a href=\"http://www.miibeian.gov.cn\" target=\"_blank\">备案号</a></span>\n  <span>\n    <a href=\"http://blog.monit.cn\">博客</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/about\">关于我们</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/contact\">联系我们</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/terms\">服务条款</a>\n  </span>\n  ', page_contact = '      <h3>客服</h3>\n      <p>QQ：100009870</p>\n      <p>手机：(+86).18757111178</p>\n      <p>邮箱：service@monit.cn</p>\n      <p>电话：(+86)-0571-89719990-808</p> \n      <p>传真:(+86)-0571-89719991</p>\n      <p>邮编：3100013</p>\n      <p>地址：杭州市万塘路69号华星科技苑C座3层</p>', page_about = '<h3>公司简介</h3>\n      <p>杭州华思通信技术有限公司是一家座落于杭州市高新区的高科技通信软件企业，公司致力于研发和提供新一代颠覆性的基于云计算和SaaS商业模式的融合网络管理产品与服务。\n      </p>\n      <h3>产品服务</h3>\n      <p>公司提供电信综合网管，广电综合网管，企业IT网管，在线托管监控服务等解决方案。公司的WLAN综合网管、EPON综合网管、融合接入网管等产品在国内处于领先地位。\n      </p>\n      <h3>创新技术</h3>\n      <p>我们研发了业界首个基于Erlang技术，按云计算架构研发设计的新一代融合网络管理平台，支持超大规模并发采集、海量数据存储和智能业务分析。领先业界传统网管一代水平。\n      </p>';

update `operators` set	footer = '\n  <span id=\"copyright\">Monit © 2010 <a href=\"http://www.miibeian.gov.cn\" target=\"_blank\">苏ICP备10047828号</a></span>\n  <span>\n    <a href=\"http://blog.monit.cn\">博客</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/about\">关于我们</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/contact\">联系我们</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/jobs\">加入我们</a>\n    <span class=\"pipe\"> · </span>\n    <a href=\"/terms\">服务条款</a>\n  </span>\n  ', page_contact = '      <h3>客服</h3>\n      <p>QQ：100009870</p>\n      <p>手机：(+86).18757111178</p>\n      <p>邮箱：service@monit.cn</p>\n      <p>电话：(+86)-0571-89719990-808</p> \n      <p>传真:(+86)-0571-89719991</p>\n      <p>邮编：3100013</p>\n      <p>地址：杭州市万塘路69号华星科技苑C座3层</p>\n      <h3>Customer Service</h3>\n      <p>Msn:service@monit.cn</p>\n      <p>Mobile:(+86).18757111178</p>\n      <p>Mail:service@monit.cn</p>\n      <p>Tel:(+86)-0571-89719990-808</p>\n      <p>Fax:(+86)-0571-89719991</p>\n      <p>Zip Code：3100013</p>\n      </p>\n      <p>Address:Block C Level 3,Huaxing Technology Court,NO.69 WanTang Road, Hangzhou</p>', page_about = '<h3>公司简介</h3>\n      <p>杭州华思通信技术有限公司是一家座落于杭州市高新区的高科技通信软件企业，公司致力于研发和提供新一代颠覆性的基于云计算和SaaS商业模式的融合网络管理产品与服务。\n      </p>\n      <h3>产品服务</h3>\n      <p>公司提供电信综合网管，广电综合网管，企业IT网管，在线托管监控服务等解决方案。公司的WLAN综合网管、EPON综合网管、融合接入网管等产品在国内处于领先地位。\n      </p>\n      <h3>创新技术</h3>\n      <p>我们研发了业界首个基于Erlang技术，按云计算架构研发设计的新一代融合网络管理平台，支持超大规模并发采集、海量数据存储和智能业务分析。领先业界传统网管一代水平。\n      </p>' where host = 'www.monit.cn';
	


