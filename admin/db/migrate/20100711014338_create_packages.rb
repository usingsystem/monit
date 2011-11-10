class CreatePackages < ActiveRecord::Migration
  def self.up
    create_table :packages do |t|
      t.integer :operator_id
      t.integer :min_check_interval
      t.integer :category #free 0,basic 1,advanced 2
      t.string :name
      t.decimal :charge,:precision => 8, :scale => 2
      t.integer :max_hosts
      t.integer :max_services
      t.float :year_discount_rate
      t.string :remark

    end
  end

  def self.down
    drop_table :packages
  end
end
