# Include hook code here
#
#require 'helpers'
#
#init is in [rails/init.rb]
#ActionView::Base.send(:include, UI::Helpers)
#ActiveRecord::Base.send(:include, UI::ActiveRecord)
#ActionController::Base.send(:include, UI::ActionController)
#

::ActionView::Base.field_error_proc = Proc.new do |html_tag, instance| 
  html_tag
end

require 'ui_form_builder'

module ViewHelpers
  def self.included(base)
    base.alias_method_chain :write_asset_file_contents, :compress
  end
  def write_asset_file_contents_with_compress joined_asset_path, asset_paths
    write_asset_file_contents_without_compress joined_asset_path, asset_paths
  end
end

ActionView::Base.send(:include, ViewHelpers)

# Remove javascirpt and stylesheet cache
js = File.join(RAILS_ROOT, "public/javascripts/base.js")
css = File.join(RAILS_ROOT, "public/stylesheets/base.css")
if File.exist?(js)
  File.delete(js)
  puts "=> Rm js cache ok [#{js}]"
end
if File.exist?(css)
  File.delete(css)
  puts "=> Rm css cache ok [#{css}]"
end
