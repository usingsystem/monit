class Notification < ActiveRecord::Base
  @@methods = [{:id => 0, :name => "email", :title => "邮件"}]
  cattr_reader :methods
  belongs_to :user

  def method_name
    @@methods[method][:name]
  end

  def human_method_name
    @@methods[method][:title]
  end
end

