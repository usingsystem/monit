namespace :invite do
  desc "Generate invite code."
  task :gen, [:num] => :environment do |t, args|
    file = File.join(RAILS_ROOT, "log", "invite.log")
    logger = Logger.new(file)
    host = ActionMailer::Base.default_url_options[:host]
    url = "http://#{host}/signup?code="
    codes = ""
    1.upto args[:num].to_i do |i|
      c = InviteCode.new
      c.generate
      codes << url + c.code + "\n"
    end
    str = "#{Time.now}\n成功生成邀请码#{args[:num]}个"
    logger.info("#{str}\n#{codes}\n")
    p str
    p "邀请码查看文件：#{file}"
  end

  desc "Statistic invite code."
  task :sta => :environment do
    codes = InviteCode.all
    p "邀请码总个数：#{codes.size}"
    p "已使用：#{codes.select{|x| x.status == 1}.size}"
    p "未使用：#{codes.select{|x| !x.status == 0}.size}"
  end
end
