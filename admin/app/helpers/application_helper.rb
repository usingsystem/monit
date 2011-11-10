# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  #<% menu_item_tag('dashboard', t('dashboard'), dashboard_url) do %>
  #  <ul>
  #    <%= submenu_item_tag('dashboard', t('dashboard'), dashboard_url) %>
  #  </ul>
  #<% end %>
  include UiHelper

  def redirect_tag url = nil
    hidden_field_tag "redirect_to", (url || params[:redirect_to]) #url_for(params)
  end

  def redirect_object
    {:redirect_to => url_for(params)}
  end

  def format_time time, new_line = false
    if time
      str = l(time, :format => :short)
      new_line ? str.gsub(/\s/,'<br />') : str
    else
      nil
    end
  end

  def extlink_to text, url, options = {}
    add_class_to_options "extlink", options
    options[:target] = "_blank"
    link_to text, url, options
  end

  def inlink_to *args
    "[#{(link_to *args)}]"
  end

  def type_link_to text, url
    str = ""
    unless text.blank?
      keys = text.split("/")
      keys.delete_if { |x| x.blank? }
      key = ""
      while keys.size > 0
        k = keys.shift
        key << "/" + k
        str << "/" + link_to(k, url.update(:type => key))
      end
    end
    str
  end

  def type_class_for name = nil
    name = "default" if name.nil?
    name = name.split("/").uniq
    name.delete_if { |x| x.blank? }
    name.collect! { |x| "type-" + x }
    name.join(" ")
  end

  def sort_link_to name, content, url
    sort = url[:sort]
    url = url.dup
    url.delete :page
    if sort.blank? || sort[0] != 45 
      old_sort_dir = ""
    else
      sort = sort.slice(1,(sort.size-1))
      old_sort_dir = "-"
    end        
    sort_direction_indicator = ''
    sort_dir =''
    if name.to_s == sort
      sort_dir = old_sort_dir == '-' ? '' : '-'
      sort_direction_indicator = icon(sort_dir == "-" ? "desc" : "asc")
    end
    link_to(content + sort_direction_indicator, url.update(:sort => sort_dir + name))

  end

  def td_tag content = nil, options = {}, &block
    content = "&nbsp;" if !block_given? and content.blank? 
    content_tag :td, content, options, &block
  end

  def th_tag content = nil, options = {}, &block
    content = "&nbsp;" if !block_given? and content.blank? 
    content_tag :th, content, options, &block
  end


  def sanitize_for(text='')
    sanitize text, :tags => %w(a img h1 h2 h3 h4 h5 h6 p strong em del ol ul li span br div), :attributes => %w(href src alt style target)
  end

  def truncate_tag text, length = 30, omission = "..."
    text ||= ""
    if text.size > length
      text = content_tag(:span, truncate(text, :length => length, :omission => omission), :title => text)
    end
    text
  end

  def tabs options, selected = nil, html_options = {}
    add_class_to_options 'tabs ul clearfix', html_options
    list = options.collect{ |a| content_tag(:li, link_to(a[1], a[2]), :class => (selected == a[0] ? 'current' :nil )) }
    content_tag 'ul', list.join(""), html_options
  end

  def status_tabs options, selected = nil, html_options = {}
    add_class_to_options 'status-tabs ul', html_options
    n = 1
    len = options.size
    list = '<li class="first"><span>&nbsp;<em>&nbsp;</em></span></li>'
  
    options.each do |a|
      cl = a[0]
      #cl += ' first' if n == 1
      #cl += ' last' if n == len
      cl += ' current' if a[0] == selected
      if a[2] == 0
        cl += ' disabled' 
        content = content_tag 'span', a[1] + content_tag('em', a[2])
      else
        content = link_to a[1] + content_tag('em', a[2]), a[3]
      end
      list << content_tag('li', content, :class => cl)
      n = n + 1
    end
    list << '<li class="last"><span>&nbsp;<em>&nbsp;</em></span></li>'
    content_tag 'ul', list, html_options

  end

  def package_tabs options, selected = nil, html_options = {}
    add_class_to_options 'status-tabs ul', html_options
    n = 1
    list = '<li class="first"><span>&nbsp;<em>&nbsp;</em></span></li>'
    #package.id package.name,数量，当前url,package.charge
    #[5, "50监控器", 1, {"package_id"=>5}, 2]
    proc=Proc.new do |a|
      cl = "package-#{a[0]}"
      cl += ' current' if a[0].to_s == selected
      if a[2] == 0
        cl += ' disabled'
        content = content_tag 'span', a[1] + content_tag('em', a[2])
      else
        content = link_to a[1] + content_tag('em', a[2]), a[3]
      end
      list << content_tag('li', content, :class => cl)
      n = n + 1
    end
    options.values.sort_by{|em|em[4]}.each(&proc)
    list << '<li class="last"><span>&nbsp;<em>&nbsp;</em></span></li>'
    content_tag 'ul', list, html_options
  end

  def menu_item_tag id, title, url, html_options = {}, &block
    raise ArgumentError, "Missing block" unless block_given?
    if id == controller.menu_item 
      class_name =  'item current' + (html_options[:class].blank? ? "" : " current-" + html_options[:class].strip.gsub(/\s+/,"-") )
    else
      class_name =  'item'
    end
    add_class_to_options(class_name, html_options)
    html_options[:id] = id

    concat tag('li', html_options, true) + content_tag('h4', link_to(icon(id) + title + content_tag('span', id.humanize), url))
    yield
    concat '</li>'
  end
  def submenu_item_tag id, title, url, html_options = {}
    add_class_to_options(id == controller.submenu_item ? 'sub-current' : nil, html_options)
    html_options[:id] = id
    content_tag('li', link_to(icon('submenu') + title, url), html_options )
  end
  #icon
  
  def icon_status type, status
    icon "#{type}-#{status}", :title => t("status.#{type}.#{status}")
  end

  def icon class_name, options = {}
    options[:class] = 'icon icon-' + class_name
    content_tag(:em, options[:title], options)
  end
  #board
  def board content_or_options_with_block = nil,options =nil,&block
    board_t = '<div class="board-t clearfix"><div class="board-tr right">&nbsp</div><div class="board-tl left">&nbsp</div></div>'
    board_b = '<div class="board-b clearfix"><div class="board-br right">&nbsp</div><div class="board-bl left">&nbsp</div></div>'
    default_class_name = "board"
    if block_given?
      content_or_options_with_block = add_class_to_options(default_class_name, content_or_options_with_block)
      concat tag("div", content_or_options_with_block, true)
      concat board_t
      yield
      concat board_b
      concat "</div>"
    else
      options = add_class_to_options(default_class_name, options)
      board_t <<  content_or_options_with_block 
      board_t << board_b
      content_tag "div", board_t, options 
    end
  end    
  def board_header content_or_options_with_block = nil,options =nil,&block
    content_tag_with_default_class("h4","board-header",content_or_options_with_block,options,&block)
  end
  def board_content content_or_options_with_block = nil,options =nil,&block
    content_tag_with_default_class("div","board-content",content_or_options_with_block,options,&block)    
  end

  def button_wrap content, options = {}
    wrap_tag("button", content, options)
  end

  def text_wrap content, options = {}
    wrap_tag("text", content, options)
  end

  def link_button_to(*args)
    name         = args.first
    options      = args.second || {}
    html_options = args.third
    url = url_for(options)
    if html_options
      html_options = html_options.stringify_keys
      convert_options_to_javascript!(html_options, url)
    else
      html_options = {}
    end
    html_options["onclick"] ||=  "javascript:document.location.href='#{url}'; return false;"
    html_options.merge!("type" => "button", "value" => name)
    tag("input", html_options)
  end


  def partial_exist?(partial, extension = '.html.erb')
    filename = partial.sub(%r{/([^/]*)$}, '/_\\1') + extension
    FileTest.exist?(File.join(RAILS_ROOT, 'app', 'views', filename))
  end

  def amcharts_tag(type, size, data, settings, options = {})
    defauts = { 
      :width => "400",
      :height             => "300",
      :swf_path           => "/amcharts",
      :flash_version      => "8",
      :background_color   => "#FFFFFF",
      :preloader_color    => "#000000",
      :express_install    => true,
      :id                 => "amcharts#{[].object_id}",
      :help               => "To see this page properly, you need to upgrade your Flash Player",
      :size => size
    }
    if settings.is_a? Hash
      defauts[:settings_file] = url_for(settings) 
    else
      defauts[:chart_settings] = settings.gsub(/\s*\n\s*|<!--.*?-->/, "").gsub(/>\s+</,"><").gsub("'","\\'") unless settings.blank?
    end
    if data.is_a? Hash
      defauts[:data_file] = url_for(data) 
    else
      unless data.blank?
        defauts[:chart_data] = data.gsub(/\s*\n\s*/, "\\n").gsub("'","\\'") 
      end
    end
    options = defauts.merge(options)
    if size = options.delete(:size)
      options[:width], options[:height] = size.split("x") #if size =~ %r{^\d+x\d+$}
    end

    script = "var so = new SWFObject('#{options[:swf_path]}/am#{type}.swf', " + "'swf_#{options[:id]}', '#{options[:width]}', '#{options[:height]}', " + "'#{options[:flash_version]}', '#{options[:background_color]}');"
    script << "so.addVariable('path', '#{options[:swf_path]}/');"
    script << "so.useExpressInstall('#{options[:swf_path]}/expressinstall.swf');" if options[:express_install]
    script << add_variable(options, :settings_file)
    script << add_variable(options, :chart_settings)
    script << add_variable(options, :additional_chart_settings)
    script << add_variable(options, :data_file)
    script << add_variable(options, :chart_data)
    script << add_variable(options, :preloader_color)
    script << add_swf_params(options, :swf_params)
    script << "so.write('#{options[:id]}');"
    content_tag('div', options[:help], :id => options[:id]) + javascript_tag(script)
  end

  def time_gran
    select_tag :date, options_for_select([['最近24小时(Last 24 hours)','last24hours'],['今天(Today)','today'],['昨天(Yesterday)','yesterday'],['本周(This Week)','thisweek'],['最近7天(Last 7 days)','last7days'],['本月(This Month)','thismonth'],['最近30天(Last 30 days)','last30days']],@date), :original_value=>@date
  end

  private
  # Add variable to swfobject
  def add_variable(options, key, escape=true)
    return "" unless options[key]
    stresc = options[key]
    val = escape ? "encodeURIComponent('#{stresc}')" : "'#{stresc}'"
    "so.addVariable('#{key}', #{val});"
  end

  # Add parameters in params[key] to SWFObject
  def add_swf_params(options, key, escape=false)
    return "" unless options[key]
    res = ""
    options[key].each_pair do |key, val|
      stresc = val
      val = escape ? "escape('#{stresc}')" : "'#{stresc}'"
      res << "so.addParam('#{key}', #{val});"
    end
    res
  end

  def add_class_to_options class_name, options = nil
    if class_name
      options ||= {}
      options[:class] = options[:class] ? (options[:class] + " " + class_name) : class_name
    end
    options
  end

  def content_tag_with_default_class tag, default_class_name, content_or_options_with_block = nil, options ={}, &block
    if block_given?
      content_or_options_with_block = add_class_to_options(default_class_name, content_or_options_with_block)
    else
      options = add_class_to_options(default_class_name, options)
    end
    content_tag(tag,content_or_options_with_block,options,&block)
  end

  def wrap_tag type, content, options = {}
    options = options.stringify_keys
    disabled = (options["disabled"].eql? "disabled" or options["disabled"] === true)
    hl = options["hl"]
    content_tag(:span, content, :class => "#{type}-wrap" + (disabled ? " butto-disabled" : "") + (hl ? " #{type}-hl" : ""))
  end

end

