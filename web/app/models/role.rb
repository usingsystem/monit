
class Role < ActiveRecord::Base
  has_and_belongs_to_many :permissions,:join_table => 'roles_permissions'
  has_many :users
  validates_presence_of :role_name,:message => "角色名不能为空!"

  validates_uniqueness_of :role_name,:message => "角色名不能重复!"

  def before_destroy
    if  User.count(:conditions => {:role_id => id }) > 0
      return false
    end
  end

end
