namespace :notification do
  desc "Send alerts notification by email."
  task :mail_alerts => :environment do
    file = File.join(RAILS_ROOT, "log", "notification.log")
    logger = Logger.new(file)
    @alert_notifications = AlertNotification.all({
      :include => ['service', 'user'] + AlertNotification.source_names,
      :conditions => {:method => 0, :status => 0}
    })
    if @alert_notifications.size > 0
      @alert_notifications.each do |alert_notification|
        tmail = Notifier.deliver_alert(alert_notification)
        Notification.create({
          :method => 0,
          :status => 1,
          :user_id => alert_notification.user_id,
          :address => alert_notification.user.email,
          :contact => alert_notification.user.name || alert_notification.user.login,
          :tenant_id => alert_notification.tenant_id,
          :type_id => 1,
          :title => tmail.subject,
          :summary => tmail.parts.first.body,
          :content => tmail.parts.second.body
        })
      end
      AlertNotification.update_all({:status => 1}, {:id => @alert_notifications.collect{|x| x.id}})
    end
    logger.info("#{Time.now}\nSend alert notifications #{@alert_notifications.size}\n\n")
  end
end
