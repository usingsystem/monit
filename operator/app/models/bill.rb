class Bill < ActiveRecord::Base
  belongs_to :tenant
  named_scope :order,lambda{|sort|{:order=>"bills.#{sort[:name] || 'id'} #{sort[:direction] || "desc"}"}}
  named_scope :by_tenant,lambda{|operator|{:include=>"tenant",:conditions=>{:type_id => 0,:operator_id=>operator.id}}}
  named_scope :by_monit,lambda{|operator|{:include=>"tenant",:conditions=>{:type_id => 1,:operator_id=>operator.id}}}
end
