/*

1. remove 'uuid' column from hosts, apps, sites, services.
2. add 'rdn' column to services.
3. remove 'agents' table
4. remove 'agent_id' column from apps, sites, hosts, services
5. services: 'servicable_id' -> 'object_id'
6. services: 'servicable_type' -> 'object_type'
7. disco_services: 'serviceable_type' -> 'object_type'
8. disco_services: 'serviceable_id' -> 'object_id'
 */

ALTER TABLE services
CHANGE serviceable_type object_type int(2),
CHANGE serviceable_id object_id int(2),
ADD COLUMN localtion char(50),
ADD COLUMN rdn char(30);

ALTER TABLE disco_services
CHANGE serviceable_type object_type int(2),
CHANGE serviceable_id object_id int(2);

ALTER TABLE users
ADD COLUMN session_id char(30);

