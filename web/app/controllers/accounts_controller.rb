class AccountsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  menu_item 'settings'
  skip_before_filter :login_required, :only=>[:new, :create, :activate, :resend_password, :reset_password]
  #before_filter :check_invite, :only => [:new, :create]
  #after_filter :ack_invite, :only => [:create]

  def new
    @package = params[:package_id].blank? ? nil : @operator.packages.find(params[:package_id])
    redirect_to plans_url and return unless @package
    @user = User.new
    render :action => 'new', :layout=>"entry"
  end

  def notify
    @user = current_user
    submenu_item 'user-notify'
  end

  def resend_password
    if request.method == :get
      @user = User.new
    elsif request.method == :post
      @name = params[:user][:login] if params[:user]
      @user = User.first :conditions => ['login = ? or email = ?', @name, @name] unless @name.blank?
      if @user
        @success = true
        @user.resend_password
      else
        @user = User.new(params[:user])
        @user.errors.add(:login, @name.blank? ? "不能为空" : "不存在")
      end
    end
    render :action => 'resend_password', :layout=>"entry"
  end

  def reset_password
    if request.method == :get
      code = params[:reset_password_code]
      @user = User.first(:conditions => { :reset_password_code => code}) unless code.blank?
    elsif request.method == :put
      logout_keeping_session!
      code = params[:user][:reset_password_code] if params[:user].is_a?(Hash)
      @user = User.first(:conditions => { :reset_password_code => code}) unless code.blank?
      if @user and @user.reset_password params[:user]
        self.current_user = @user
        redirect_to dashboard_url and return 
      end
    end
    render :action => 'reset_password', :layout=>"entry"
  end

  def edit
    submenu_item 'user-edit'
    @user = current_user
  end

  def password
    submenu_item 'user-password'
    @user = current_user
  end

  def report
    menu_item 'reports'
    submenu_item 'user-report'
    @user = current_user
  end

  def create
    logout_keeping_session!
    @package = params[:package_id].blank? ? nil : @operator.packages.find(params[:package_id])
    unless @package
      @package = Package.first(:conditions => {:category => 0})
      #redirect_to plans_url and return
    end

    # 用户注册时缺少创建一个租户对象
    @user=@operator.add_tenant(params[:user])
    unless @user.new_record?
      self.current_user = @user
      if @package.category == 0
        @user.tenant.set_free
        redirect_to dashboard_url
      else
        @user.tenant.order_package(@package.id)
        redirect_to new_order_path(:package_id => @package.id)
      end
    else
      render :action => "new", :layout => "entry"
    end
  end

  def activate     
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?   
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      #flash[:notice] = "Signup complete! Please sign in to continue."
      #flash[:notice] = "完成注册，请登录继续操作"
      #redirect_to '/login'
      flash[:notice] = "注册成功"
      self.current_user = user
      redirect_to '/'
    when params[:activation_code].blank?
      #flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      flash[:error] = "无激活码，请使用邮箱中收到的激活信件的链接"
      redirect_back_or_default('/')
    else
      flash[:error] = "激活码无效，请使用邮箱中收到的激活信件的链接"
      #flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def update
    submenu_item 'user-edit'
    @user = current_user
    params[:user].delete(:password)
    if @user.update_attributes(params[:user])
      flash[:notice] = '修改成功'
      redirect_to :action => 'edit'
    else
      render :action => "edit"
    end
  end

  def update_password
    submenu_item 'user-password-edit'
    @user = current_user
    if @user.update_password(params[:user])
      flash[:notice] = '修改密码成功'
      redirect_to :action => 'password'
    else
      render :action => "password" 
    end
  end

  def update_report
    menu_item 'reports'
    submenu_item 'user-report'
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = '通知设置成功。'
      redirect_to :action => 'report'
    else
      render :action => "report" 
    end
  end

  def update_notify
    @user = current_user
    @rules = params[:rules]
    @rules.each do |rule|
      rule[:user_id] = @user.id
      rule[:tenant_id] = @user.tenant_id
      cache = rule.dup
      enable = cache.delete(:enable)
      NotifyRule.delete_all(cache)
      NotifyRule.create(cache) if enable
    end
    flash[:notice] = "通知设置成功。"
    redirect_to :action => "notify" and return
  end

  private

  def ack_invite
    if @user.id and (code = InviteCode.find_by_code(params[:code]))
      code.update_attributes(:status => 1, :user_id => @user.id, :user_name => @user.login )
    end
  end

  def check_invite
    if params[:code].blank?
      @msg = "内测期间，暂未开发注册"
      ok = false
    else
      code = InviteCode.find_by_code(params[:code])
      if !code
        @msg = "邀请码无效"
        ok = false
      elsif code.status == 1
        @msg = "邀请码已被使用"
        ok = false
      else
        ok = true
      end
    end
    unless ok
      render :action => 'invite', :layout=>"entry"
    end
  end

end
