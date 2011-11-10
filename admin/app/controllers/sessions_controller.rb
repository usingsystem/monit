# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  layout "entry" ,:only=>[:new]
  skip_before_filter :login_required
  skip_after_filter  :log_operation

  def new

  end

  def create
    logout_keeping_session!
    @operator = Operator.authenticate(params[:host], params[:password])
    if @operator
      self.current_user = @operator
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      store_details
      #登陆成功直接保存安全日志
      log_authenticate_success
      redirect_back_or_default('/')
    else 
      if params[:host]
        @operator = Operator.first(:conditions =>["host = ?",params[:host]])
        log_authenticate_failure
      end
      note_failed_signin
      render :action => 'new',:layout=>"entry"
    end
  end

  def destroy
    logout_killing_session!
    redirect_back_or_default('/')
  end

  protected
  def store_details
    session[:login] = @operator.host
    session[:login_time] =Time.now
    session[:ip] = request.remote_ip
  end

  def log_authenticate_success
     LogmSecurity.new(
        :session => request.session_options[:id],
        :user =>@operator.id,
        :user_name =>@operator.host,
        :terminal_ip =>request.remote_ip,
        :host_name =>request.env["HTTP_HOST"],
        :security_cause =>"成功登入.",
        :security_action =>params[:controller]+'/'+params[:action],
        :result => '成功',
        :details =>"操作成功").save
  end
  def log_authenticate_failure
     if @operator
          user_id = @operator.id
          user_name = @operator.host
          details = "密码错误"
          security_cause = "登陆失败"
        else
          user_id = ""
          user_name = params[:host]
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

  def note_failed_signin
    @error = "用户名或密码错误"
    @login       = params[:login]
    @remember_me = params[:remember_me]
    logger.warn "Failed login for '#{params[:host]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
