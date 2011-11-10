require File.dirname(__FILE__) + '/../test_helper'
#require 'user_notifier'

class UserNotifierTest < ActionMailer::TestCase
  #  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  #  CHARSET = "utf-8"

  #  include ActionMailer::Quoting
  #
  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    #    @expected = TMail::Mail.new
    #    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end


  test "gen bill" do
    monit=operators(:monit)
    kehao1=monit.tenants.create(:name=>"kehao1",:email=>"kehao1.qiu@gmail.com",:package_id=>1,:balance=>100)

    assert_emails 1 do
      Bill.create(:tenant_id=>kehao1.id,:amount=>-10,:balance=>100-10,:summary=>"test扣除",:type_id=>0)
    end

    email =  ActionMailer::Base.deliveries.last

    assert_equal [kehao1.email], email.to
    assert_match "[#{monit.title}]",email.subject
   

		assert_match /您在monit监控云消费了10.0/, email.body
  end

  test "gen bill1" do
    monit=operators(:monit)
    kehao1=monit.tenants.create(:name=>"kehao1",:email=>"kehao1.qiu@gmail.com",:package_id=>1,:balance=>100)
    assert_emails 1 do
      Bill.create(:tenant_id=>kehao1.id,:amount=>10,:balance=>10,:summary=>"test扣除",:type_id=>0)
    end
    assert_no_emails do
      Bill.create(:tenant_id=>kehao1.id,:amount=>10,:balance=>10,:summary=>"test扣除",:type_id=>1)
    end
    email = ActionMailer::Base.deliveries.last

    assert_equal [kehao1.email], email.to
    assert_match "[#{monit.title}]",email.subject


		assert_match /您在monit监控云充值了10.0/, email.body
  end

  test "gen operator bill" do
    new_operator=Operator.create(:host=>"www.test.cn",:password=>"public123",:email=>"kehao.qiu@gmail.com",:password_confirmation=>"public123",:title=>"test title")
    assert !new_operator.new_record?

    assert_emails 1 do
      Bill.create(:operator_id=>new_operator.id,:amount=>10,:balance=>10,:summary=>"test扣除",:type_id=>1)
    end
    email = ActionMailer::Base.deliveries.last

    assert_equal [new_operator.email], email.to
    assert_match "[来自Monit的账单!]",email.subject


		assert_match "#{new_operator.host}", email.body
  end

  test "gen order" do
    monit=operators(:monit)
    new_package=monit.packages.create(:id=>20,:category=>2,:name=>"10监控器",:max_services=>10,:max_hosts=>3,:charge=> 6,
      :min_check_interval=> 5)
    kehao1=monit.tenants.create(:name=>"kehao1",:email=>"kehao1.qiu@gmail.com",:package_id=>new_package.id,:balance=>100)

    assert_emails 1 do
      order=Order.create(:tenant_id=>kehao1.id,:package_id=>new_package.id,:month_num=>3,:is_paid=>false)
      assert !order.new_record?
    end

    email = ActionMailer::Base.deliveries.last
    
    assert_equal [kehao1.email], email.to
    assert_match "[#{monit.title}]",email.subject

		assert_match /下面是您在monit监控云上的订单/, email.body
  end

  test "destroy order" do
    monit=operators(:monit)
    new_package=monit.packages.create(:id=>20,:category=>2,:name=>"10监控器",:max_services=>10,:max_hosts=>3,:charge=> 6,
      :min_check_interval=> 5)
    kehao1=monit.tenants.create(:name=>"kehao1",:email=>"kehao1.qiu@gmail.com",:package_id=>new_package.id,:balance=>100)
    assert_emails 2 do
      order=Order.create(:tenant_id=>kehao1.id,:package_id=>new_package.id,:month_num=>3,:is_paid=>false)
      order.destroy
    end
    assert ActionMailer::Base.deliveries.size,2
    email = ActionMailer::Base.deliveries.last

    assert_equal [kehao1.email], email.to
    assert_match "[#{monit.title}]",email.subject
    assert ActionMailer::Base.deliveries.size,1

		assert_match /您取消了订单/, email.body
  end

  

  #  private
  #    def read_fixture(action)
  #      IO.readlines("#{FIXTURES_PATH}/user_notifier/#{action}")
  #    end
  #
  #    def encode(subject)
  #      quoted_printable(subject, CHARSET)
  #    end
end
