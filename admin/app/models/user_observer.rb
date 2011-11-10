class UserObserver < ActiveRecord::Observer
  def after_create(user)
    #用户注册通知
    UserNotifier.deliver_signup_notification(user)
  end

  def after_save(user)
    #重设密码通知邮件
    UserNotifier.deliver_resend_password(user) if user.recently_resend_password?
  end
end
