class Notifier < ActionMailer::Base
  layout "email"

  def alert(notification)
    setup_email(notification)
  end

  protected
  def setup_email(notification)
    user = notification.user
    status = notification.human_status_name
    name = notification.source.name + (notification.service ? " / " + notification.service.name : "")
    #name = (notification.service || notification.source).name
    @recipients  = "#{user.email}"
    @from        = "#{I18n.translate("production_name")} <alert@monit.cn>"
    @subject     = "[#{I18n.translate(notification.object_name)}]#{name} #{status}"
    @sent_on     = Time.now
    #@content_type = "text/html"
    #@reply_to    = "help@monit.cn"
    @body[:user] = user
    @body[:notification] = notification
    #@template 
  end
end
