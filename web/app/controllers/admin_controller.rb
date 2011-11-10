# To change this template, choose Tools | Templates
# and open the template in the editor.

class AdminController  < ApplicationController
  before_filter :saas_authorize
  def index

  end
  def saas_authorize
    if current_user.id != 1
      redirect_to(:controller=>"dashboard" )
    end 
  end
end
