# To change this template, choose Tools | Templates
# and open the template in the editor.

class BusinessController < ApplicationController
  menu_item 'dashboard'
  def index
    redirect_to :action => "automap"
    submenu_item 'business-index'
  end

  def physics
    submenu_item 'business-physics'
  end

  def automap
    submenu_item 'business-automap'

    @hosts = Host.all :include => ['apps', 'type'], :conditions => conditions
    @sites = Site.all :conditions => conditions
    @apps = App.all :include => ['type'], :conditions => conditions
    @devices = Device.all :include => ['type'], :conditions => conditions
    @objects = {:hosts => @hosts, :apps => @apps, :sites => @sites, :devices => @devices}

    respond_to do |format|
      format.html
      format.png
      format.pdf
      format.gif
      format.svg
      format.rdot
      format.cmapx
    end
  end

  private

  def conditions con = {}
    con.update :tenant_id => current_user.tenant_id
  end

end
