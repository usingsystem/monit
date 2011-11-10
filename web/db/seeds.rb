# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
# Operator.create(:host=>"www.monit.cn",:password=>"public123",:password_confirmation=>"public123")
 ActiveRecord::Base.connection.execute("UPDATE `monit`.`operators` SET `id`='0' WHERE `id`='1';")
 Tenant.update_all("operator_id=0","operator_id is null" )