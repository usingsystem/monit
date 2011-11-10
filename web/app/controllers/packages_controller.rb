class PackagesController < ApplicationController
  skip_before_filter :login_required, :only => :plans
  menu_item 'accounts'
  def index
    submenu_item 'packages'
    @package = current_user.tenant.package
    all_packages
  end

  def plans
    all_packages
    render :layout=>"welcome"  
  end

  private

  def all_packages
    @packages = @operator.packages.all(:order=>"charge asc")
    @free_package = @packages.select{ |o| o.category == 0 }[0]
    @standard_packages = @packages.select{ |o| o.category == 1 }
    @enterprise_packages = @packages.select{ |o| o.category == 2 }
  end

end
