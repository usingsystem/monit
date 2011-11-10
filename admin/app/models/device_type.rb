class DeviceType < ActiveRecord::Base
  has_many :service_types, :conditions => { :serviceable_type => 4 }, :foreign_key => 'serviceable_id'
  has_many :devices, :foreign_key => 'type_id'
  validates_presence_of :name
  validates_presence_of :parent_id
  def service_types
    ServiceType.find_by_sql("select * from service_types t1 where t1.serviceable_type=4 and t1.serviceable_id in (select t2.id from device_types t2 where instr('#{name}}',t2.name) > 0)" )
  end

  def ctrl_service_types
    ServiceType.find_by_sql("select * from service_types t1 where t1.serviceable_type=4 and t1.ctrl_state=1 and t1.serviceable_id in (select t2.id from device_types t2 where instr('#{name}}',t2.name) > 0)" )
  end

  def devices
    #Device.all :conditions => { :type_id => self.class.all(:conditions => ["name like concat(?,'%')", name]) }
    Device.all :conditions => ["type_id in (select id from " + self.class.table_name + " where name like concat(?,'%'))" , name]
  end
end
