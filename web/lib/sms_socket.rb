require 'socket'
require 'iconv'
require 'base64'
require 'digest'
class SMSSocket < TCPSocket

  attr_accessor :user
  attr_accessor :content
  attr_accessor :password
  attr_accessor :type

  #   短信账户名称：ms25239     短信账户密码：mtuwnj
  #   ID：d583824 monit odm1mz opengossmonit
  #   "sms.todaynic.com:20002"
  #   example:
  #
  #     client = SMSSocket.open("sms.todaynic.com", "20002")
  #     client.user = "ms25236"
  #     client.password = "mje1mz"
  #     client.send("18677777536", "For test")
  #     puts client.is_success? #=> true
  #     client.close
  #
  def initialize *args
    #@user = "ms25236"
    #@password = "mje1mz"
    @type = 2
    super
  end

  def send phone_number , msg
    #apitype
    #2: 通道二 (发送1条扣去1条)
    #3: 即时通道(客服类推荐) (发送1条扣去1.3条)
    id = cltrid()
    login = encid(id, @password)
    @content = %Q{<?xml version="1.0" encoding="GB2312"?>
                <scp xmlns="urn:mobile:params:xml:ns:scp-1.0"
                        xmlns:sms="urn:todaynic.com:sms"
                        xmlns:user="urn:todaynic.com:user">
                        <command>
                                <action>SMS:sendSMS</action>
                                <sms:mobile>#{phone_number}</sms:mobile>
                                <sms:message>#{en_msg(msg)}</sms:message>
                                <sms:datetime></sms:datetime>
                                <sms:apitype>#{@type}</sms:apitype>
                        </command>
                        <security>
                                <smsuser>#{@user}</smsuser>
                                <cltrid>#{id}</cltrid>
                                <login>#{login}</login>
                        </security>
    </scp>}
    
    super(@content, 0)
  end

  def is_success?
    self.respond.scan("<result code=\"2000\">").size == 1
  end

  def respond
    @respond ||= to_utf8(readlines.to_s.scan(/<result.*?<\/result>/).to_s)
  end

  private
  def cltrid
    time = (Time.now.to_f*100).round
  end

  def encid cltrid, password
    Digest::MD5.hexdigest("#{cltrid}-#{password}")
  end

  def en_msg msg
    Base64.encode64(to_gb2312(msg))
  end

  def to_utf8 msg
    Iconv.new('UTF-8//IGNORE', 'GB2312').iconv(msg)
  end

  def to_gb2312 msg
    Iconv.new('GB2312//IGNORE', 'UTF-8').iconv(msg)
  end

end

