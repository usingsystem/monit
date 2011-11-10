# To change this template, choose Tools | Templates
# and open the template in the editor.

class Float

  # 保留两位小数
  def reserve2
    reserve(2)
  end

  # 保留指定位数的小数
  def reserve(num)
    format("%.#{num}f", self).to_f
  end
end