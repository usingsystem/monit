class WelcomeController < ApplicationController

  skip_before_filter :login_required
  def index
    redirect_to dashboard_url and return if current_user
  end

  #隐私条款
  def privacy
  end

  def terms
  end

  #联系我们
  def contact
  end

  #关于我们
  def about
  end

  #加入我们
  def jobs
  end


  #调试中
  def test
  end

  #概括
  def overview
  end

  #功能
  def function
  end

  #技术
  def technologies
  end

  #亮点
  def highlight
  end
end
