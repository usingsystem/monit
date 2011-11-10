namespace :tenant do
  desc "Tenant pay for the package."
  task :pay_package => :environment do
    file = File.join(RAILS_ROOT, "log", "tenant.log")
    logger = Logger.new(file)
    now = Time.now
    tenants = Tenant.all(:conditions => [ "next_paid_at = ?", Date.today ], :include => [:package])
    tenants.each do |tenant|
      tenant.pay_package
    end
    logger.info("#{now}(#{(Time.now - now)*100}ms)\nTenant pay for the package #{tenants.size}\n\n")
  end

  desc "Set the tenants who had expired to free."
  task :handle_expired => :environment do
    file = File.join(RAILS_ROOT, "log", "tenant.log")
    logger = Logger.new(file)
    now = Time.now
    tenants = Tenant.all(:conditions => [ "expired_at = ?", Date.today ])
    tenants.each do |tenant|
      tenant.to_free
    end
    logger.info("#{now}(#{(Time.now - now)*100}ms)\nSet the tenants who had expired to free #{tenants.size}\n\n")
  end

end
