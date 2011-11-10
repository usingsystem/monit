class Bill < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :operator
  named_scope :order,lambda{|sort|{:order=>"bills.#{sort[:name] || 'id'} #{sort[:direction] || "desc"}"}}   
  named_scope :by_tenant,:include=>"tenant",:conditions=>{:type_id => 0}
  named_scope :by_monit,:conditions=>{:type_id => 1}
  
  after_create :deliver_mail

  def deliver_mail
    if self.type_id == 0 && self.tenant
      UserNotifier.deliver_gen_bill(self.tenant,self) if self.tenant.email.present?
    elsif self.type_id == 1 && self.operator
      UserNotifier.deliver_gen_operator_bill(self.operator,self) if self.operator.email.present?
    end
  end
end
