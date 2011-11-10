class Bill < ActiveRecord::Base
   belongs_to :tenant
   belongs_to :operator

   named_scope :order,lambda{|sort|{:order=>"bills.#{sort[:name] || 'id'} #{sort[:direction] || "desc"}"}}
   named_scope :by_monit,:conditions=>{:type_id => 1},:include=>"operator"

   validates_presence_of :amount
   validates_numericality_of :amount,:greater_than=>0
end
