class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :tenant_id
      t.integer :package_id
      t.string :name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
