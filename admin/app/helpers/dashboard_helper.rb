module DashboardHelper
  def status_link type, status, all
    ctr = type.pluralize
    str = link_to(t('all') + ' (' + content_tag('span', all) + ')', :controller => ctr)
    status.each do |s|
      name = s[:name]
      text = s[:title]
      str << (s[:num] == 0 ? content_tag("span", text + " (0)", :class => "gray") : (link_to(text + ' (' + content_tag('span', s[:num], :class => "status-#{type}-" + name) + ')', :controller => ctr, :status => name))) + " "
    end 
    str
  end

  def status_chart(status)
    status.delete_if { |x| x[:num] == 0 }
    status_chart = GoogleChart.new
    status_chart.type = :pie_3d
    status_chart.data = status.collect{|x| x[:num] }
    status_chart.height = 100
    status_chart.width = 280
    status_chart.colors = status.collect{|x| x[:color] }
    status_chart.labels = status.collect{|x| x[:title] }
    status_chart.to_url
  end
end
