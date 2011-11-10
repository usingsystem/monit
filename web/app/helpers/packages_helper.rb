module PackagesHelper

  def signup_link(text, id, option={})
    link_to "<span>#{text}</span>","/signup/#{id}",option
  end

  def order_link(pid, id, option={})
    text = pid ? (pid > id ? "降级套餐" : (pid == id ? "(当前)套餐续费" : "升级套餐")) : "升级套餐"
    link_to "<span>#{text}</span>", new_order_path(:package_id => id), :class=>"button classy personal-plan"
  end

end
