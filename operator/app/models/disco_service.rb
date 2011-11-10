class DiscoService < ActiveRecord::Base
  @@serviceable_types = Service.serviceable_types
  @@serviceable_names = Service.serviceable_names
  cattr_reader :serviceable_types, :serviceable_names

  @@serviceable_types.each do |s|
    belongs_to s[:name].to_sym, :foreign_key => 'serviceable_id'
  end
  belongs_to :type, :foreign_key => 'type_id', :class_name => 'ServiceType'

  def service
    t = self.type
    Service.new({
      :name => self.name,
      :serviceable_type => self.serviceable_type,
      :serviceable_id => self.serviceable_id,
      :tenant_id => self.tenant_id,
      :agent_id => self.agent_id,
      :type_id => self.type_id,
      :params => self.params,
      :summary => self.summary,
      :ctrl_state => t.ctrl_state,
      :check_interval => t.check_interval,
      :threshold_critical => t.threshold_critical,
      :threshold_warning => t.threshold_warning
    })
  end

  def serviceable_name
    @serviceable_name || (@serviceable_name = @@serviceable_types.select{ |x| x[:id] == serviceable_type}.first[:name])
  end

  def serviceable
    send(serviceable_name)
  end
end
