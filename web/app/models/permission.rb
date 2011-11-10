class Permission < ActiveRecord::Base
   has_and_belongs_to_many :roles,:join_table => 'roles_permissions'

  def self.default
    find(:all, :conditions => ["default_permission = 1"])
  end
  
end
