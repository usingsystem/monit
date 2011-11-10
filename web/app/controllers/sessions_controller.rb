# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  layout "entry" ,:only=>[:new]
  skip_before_filter :login_required
  skip_after_filter :log_operation

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password], @operator.id)
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      session[:login] = user.login
      session[:name] = user.name
      session[:login_time] =Time.now
      session[:ip] = request.remote_ip

      self.current_user = user
      @current_user = user
      #登陆成功直接保存安全日志
      LogmSecurity.new(
        :session => request.session_options[:id],
        :user =>user.id,
        :user_name =>user.login,
        :terminal_ip =>request.remote_ip,
        :host_name =>request.env["HTTP_HOST"],
        :security_cause =>"成功登入.",
        :security_action =>params[:controller]+'/'+params[:action],
        :result => '成功',
        :details =>"操作成功").save

      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
    else #if user.nil?
      if params[:login]
        user = User.find(:first, :conditions =>["login = '#{params[:login]}'"])
        if user
          user_id = user.id
          user_name = user.login
          details = "密码错误"
          security_cause = "登陆失败"
        else
          user_id = ""
          user_name = params[:login]
          details = "用户名不存在"
          security_cause = "登陆失败"
        end
        LogmSecurity.new(
          :session => request.session_options[:id],
          :user => user_id,
          :user_name => user_name,
          :terminal_ip =>request.remote_ip,
          :host_name =>request.env["HTTP_HOST"],
          :security_cause =>security_cause,
          :security_action =>params[:controller]+'/'+params[:action],
          :result => '失败',
          :details => details).save
      end
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new', :layout=>"entry"
    end
  end

  def destroy
    logout_killing_session!
    #flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  protected
  # Track failed login attempts
  def note_failed_signin
    #flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    @error = "用户名或密码错误"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
