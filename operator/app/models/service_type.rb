class ServiceType < ActiveRecord::Base
  @@serviceable_types = [nil, 'host', 'app', 'site']
  cattr_reader :serviceable_types

  belongs_to :host_type, :foreign_key => 'serviceable_id'
  belongs_to :app_type, :foreign_key => 'serviceable_id'
  has_many :params, :foreign_key => 'type_id', :class_name => "ServiceParam"
  has_many :thresholds, :order => "level", :foreign_key => 'type_id', :class_name => "ServiceThreshold"
  has_many :metric_types, :foreign_key => 'type_id'

  validates_presence_of :name
  validates_presence_of :alias
  validates_presence_of :serviceable_id
  validates_presence_of :check_interval
  validates_presence_of :serviceable_type
  validates_presence_of :command
  validates_inclusion_of :discover_type, :in => [1,2,3]

  def serviceable
    return serviceable_type == 1 ? host_type : app_type
  end

  def type_and_alias
    I18n.t(serviceable_type_name) + " - " + read_attribute(:alias)
  end

  def serviceable_type_name
    @@serviceable_types[serviceable_type]
  end

  def services(serviceable_type, serviceable_id)
    Service.all(:conditions => ["type_id = ? and serviceable_type = ? and serviceable_id = ?", id, serviceable_type, serviceable_id])
  end

  def discover_type
    [nil, "snmp", "ssh", "local"]
  end
end
