class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.integer :tenant_id
      t.decimal :amount
      t.decimal :balance
      t.string :summary
      t.datetime :begin_date
      t.datetime :end_date
      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end
