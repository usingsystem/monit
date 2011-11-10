class CreateOperators < ActiveRecord::Migration
  def self.up
    create_table :operators do |t|
      t.string :host,:null=>false
      t.string :biglogo_url
      t.string :logo_url
      t.string :title
      t.text :footer
      t.string :descr
      t.string :telphone
      t.string :contact
      t.string :email

   #   t.string :password
   #   t.string :old_password
      t.string :remember_token,:limit => 40
      t.datetime :remember_token_expires_at

      t.string :crypted_password
      t.string :salt
      t.datetime   :activated_at
      t.string :activation_code
      t.timestamps

     
    end
     add_index :operators, :host
  end

  def self.down
    drop_table :operators
  end
end
