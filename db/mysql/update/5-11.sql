
/*clone view*/
insert into views (enable, data_params, name, visible_type, visible_id, template, dimensionality, width, height) select enable, data_params, name, visible_type, 34 visible_id, template, dimensionality,  width,  height from views where visible_type in ('service_history', 'service_default', 'service_current') and visible_id = 1;

insert into view_items (view_id, name, alias, data_type, data_unit, data_format, color, width, height, fill) select t2.create_view_id view_id, t1.name, t1.alias, t1.data_type, t1.data_unit, t1.data_format, t1.color, t1.width, t1.height, t1.fill from view_items t1, (select tt1.*, tt2.id create_view_id from views tt1, views tt2 where tt1.visible_id = 1 and tt1.visible_type in ('service_history', 'service_default', 'service_current') and tt2.visible_type = tt1.visible_type and tt2.visible_id = 34 and tt2.name = tt1.name) t2 where t2.id = t1.view_id;


insert into views (enable, data_params, name, visible_type, visible_id, template, dimensionality, width, height) select enable, data_params, name, visible_type, 35 visible_id, template, dimensionality,  width,  height from views where visible_type in ('service_history', 'service_default', 'service_current') and visible_id = 6;

insert into view_items (view_id, name, alias, data_type, data_unit, data_format, color, width, height, fill) select t2.create_view_id view_id, t1.name, t1.alias, t1.data_type, t1.data_unit, t1.data_format, t1.color, t1.width, t1.height, t1.fill from view_items t1, (select tt1.*, tt2.id create_view_id from views tt1, views tt2 where tt1.visible_id = 6 and tt1.visible_type in ('service_history', 'service_default', 'service_current') and tt2.visible_type = tt1.visible_type and tt2.visible_id = 35 and tt2.name = tt1.name) t2 where t2.id = t1.view_id;
