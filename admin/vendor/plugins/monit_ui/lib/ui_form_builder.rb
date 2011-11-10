class ::UIFormBuilder < ActionView::Helpers::FormBuilder

  def content_tag *args
    @template.content_tag *args
  end

  def wrap_tag name, content, options = {}
    options = options.stringify_keys
    name = name.to_s
    disabled = (options["disabled"].eql? "disabled" or options["disabled"] === true)
    hl = options["hl"]
    if ['password_field', 'text_field'].include? name
      content_tag(:span, content, :class => "text-wrap" + (disabled ? " text-disabled" : ""))
    elsif ['submit', 'button', 'reset'].include? name
      content_tag(:span, content, :class => "button-wrap" + (disabled ? " button-disabled" : "") + (hl ? " button-hl" : ""))
    else
      content
    end
  end

  def submit value = nil, options = {}
    content_tag(:div, '<label class="form-label">&nbsp;</label>' + content_tag(:span, wrap_tag("submit", super, options), :class=>"form-data"), :class => "form-li clearfix form-actions")  #wrap with a paragraph 
  end

  def label method, text = nil, options = {}
    text ||= @object.class.human_attribute_name(method.to_s)
    options[:class] ||= ""
    options[:class] << " form-label"
    text = text + I18n.translate("monit_ui.label_suffix")
    text = "<em>*</em>" + text if options.delete(:required)
    super method, text, options
  end

  def radio_button_group(method, values, options = {})
    wrap_options = options.dup
    field_options options
    selections = []
    values.each do |value|
      if value.is_a?(Hash)
        tag_value = value[:value]
        value_text = value[:label]
      elsif value.is_a?(Array)
        tag_value = value[1]
        value_text = value[0]
      else
        tag_value = value
        value_text = value
      end
      radio_button = @template.radio_button(@object_name, method, tag_value, objectify_options(options))
      selections << wrap_label(radio_button, value_text, [@object_name.to_s, method.to_s, tag_value.to_s].join("_").downcase )
    end
    wrap_field method, selections.join(""), wrap_options
  end

  def check_box_group(method, values, options = {})
    wrap_options = options.dup
    field_options options
    selections = []
    values.each do |value|
      if value.is_a?(Hash)
        checked_value = value[:checked_value]
        unchecked_value = value[:unchecked_value]
        value_text = value[:label]
      else
        checked_value = 1
        unchecked_value = 0
        value_text = value
      end
      check_box = @template.check_box(@object_name, method, options.merge(:object => @object), checked_value, unchecked_value)
      selections << wrap_label(check_box, value_text)
    end
    wrap_field method, selections.join(""), wrap_options
  end

  def wrap_label(input, text, id = nil)
    %Q{<label class="label-wrap" for="#{id}">#{input} #{text}</label>}
  end

  def wrap_field field, content, options = {}, &block
    if block_given?
      options = content || {}
      content = @template.capture(&block)
    end
    label_text = label field, options[:label], :class => options[:label_class], :required => options[:required]

    help = options[:help]
    append = options.delete(:append)
    prepend = options.delete(:prepend)
    li_class = "form-li clearfix"
    error_message = options[:error] || (error_message_on field, :css_class => "error-help", :prepend_text => (options[:label] || @object.class.human_attribute_name(field.to_s)))
    unless error_message.blank?
      help = error_message
      li_class << " form-error"
    end
    content = content_tag(:span, prepend, :class => "form-prepend") + content unless prepend.blank?
    content << content_tag(:span, append, :class => "form-append") unless append.blank?
    content << content_tag(:span, help, :class => "form-help") unless help.blank?
    content = content_tag(:div, label_text + content_tag(:span, content, :class => "form-data"), :class => li_class)  #wrap with a paragraph 
    if block_given?
      @template.concat(content)
    else
      content
    end
  end


  def field_options options
    options.delete :required
    options.delete :help
    options.delete :error
    options.delete :label
    options.delete :label_class
    options
  end

  helpers = field_helpers +
    %w{date_select datetime_select time_select} +
    %w{collection_select select country_select time_zone_select} -
    %w{hidden_field label fields_for check_box radio_button} # Don't decorate these

  helpers.each do |name|
    define_method(name) do |field, *args|
      options = args.last.is_a?(Hash) ? args.pop : {}
      wrap_options = options.dup
      field_options options
      wrap_field field, wrap_tag(name, super, options), wrap_options
    end
  end
end
