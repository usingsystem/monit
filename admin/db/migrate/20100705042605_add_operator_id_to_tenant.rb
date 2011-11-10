class AddOperatorIdToTenant < ActiveRecord::Migration
  def self.up
    add_column :tenants, :operator_id, :integer
    add_column :tenants, :package_id, :integer
    add_column :tenants, :package_category, :integer
    rename_column(:tenants, :expired, :expired_at)
    add_column :tenants, :amount, :decimal
    add_column :tenants, :status, :boolean
    add_column :tenants, :balance, :decimal

    add_column :tenants, :month_num, :integer
    add_column :tenants, :is_pay_account, :boolean


    Operator.create(:id=>1,:host=>"www.monit.cn",:password=>"public123",:password_confirmation=>"public123")
    ActiveRecord::Base.connection.execute("UPDATE `monit`.`operators` SET `id`='0' WHERE `id`='1';")
    Tenant.update_all("operator_id=0","operator_id is null" )
  end

  def self.down
    remove_column :tenants, :operator_id
    remove_column :tenants,:package_id
    remove_column :tenants,:package_category
    rename_column(:tenants, :expired_at, :expired)
    remove_column :tenants,:amount
    remove_column :tenants,:status
    remove_column :tenants,:balance
    remove_column :tenants,:month_num
    remove_column :tenants,:is_pay_account

  end
end
