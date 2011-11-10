/*views*/
insert into views (id, name, visible_type, visible_id, template, dimensionality, width, height) select (id + 300) id, name, 'service_current' visible_type, visible_id, 'ampie' template, 2 dimensionality, '90%' width, '270' height from views where visible_type = 'service_history';

insert into view_items (id, view_id, name, alias, data_type, data_unit, data_format, color) select (t1.id*2 + 500) id, (t1.view_id + 300) view_id, t1.name, t1.alias, t1.data_type, t1.data_unit, t1.data_format, t1.color from view_items t1, views t2 where t2.visible_type = 'service_history' and t2.id = t1.view_id and t1.name <> 'parent_key';

/*default*/
insert into views (id, name, visible_type, visible_id, template, dimensionality) select (id + 600) id, name, 'service_default' visible_type, visible_id, 'metric' template, 2 dimensionality from views where visible_type = 'service_history';

insert into view_items (id, view_id, name, alias, data_type, data_unit, data_format) select (t1.id*2 + 1000) id, (t1.view_id + 600) view_id, t1.name, t1.alias, t1.data_type, t1.data_unit, t1.data_format from view_items t1, views t2 where t2.visible_type = 'service_history' and t2.id = t1.view_id and t1.name <> 'parent_key';
