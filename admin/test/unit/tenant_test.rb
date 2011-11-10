require 'test_helper'

class TenantTest < ActiveSupport::TestCase
  test "add banlance" do
   kehao=tenants(:kehao)
   balance=kehao.balance
   assert kehao.id
   kehao.add_balance(100)
   assert_equal kehao.balance - balance,100
  end

end
