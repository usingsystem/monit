require 'sms_socket'

describe SMSSocket, "Short message service socket" do

  it "can send" do
    client = SMSSocket.open("sms.todaynic.com", "20002")
    client.user = "ms25239"
    client.password = "mtuwnj"
    client.send("18757111138", "For test")
    client.is_success?.should == true
    puts client.respond
    puts client.respond.scan("<result code=\"2000\">")
    client.close
  end

end
