class Account < ActiveRecord::Base
  belongs_to :tenant
end
