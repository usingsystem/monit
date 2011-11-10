class UserNotifier < ActionMailer::Base
  layout "email"
  def signup_notification(user)
    setup_email(user)
    @subject    += '注册通知'
  end

  def resend_password(user)
    setup_email(user)
    @subject    += "重设#{user.login}的密码"
  end

  def activation(user)
    setup_email(user)
    @subject    += '账号成功激活!'
  end

  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "Monit <no-reply@monit.cn>"
    @subject     = "[monit] "
    @sent_on     = Time.now
    #@reply_to    = "help@monit.cn"
    @content_type = "text/html"
    @body[:user] = user
  end
end
