# Include hook code here
Mime::Type.register_alias "application/pdf", :pdf unless Mime.const_defined?(:PDF)
Mime::Type.register_alias "image/png", :png unless Mime.const_defined?(:PNG)
Mime::Type.register_alias "image/gif", :gif unless Mime.const_defined?(:GIF)
Mime::Type.register_alias "image/jpeg", :jpg unless Mime.const_defined?(:JPG)
Mime::Type.register_alias "image/svg+xml", :svg unless Mime.const_defined?(:SVG)
Mime::Type.register_alias "text/html", :vml unless Mime.const_defined?(:VML)
Mime::Type.register_alias "text/plain", :rdot unless Mime.const_defined?(:RDOT)
Mime::Type.register_alias "text/plain", :cmapx unless Mime.const_defined?(:CMAPX)

require 'graph_template'

ActionView::Template.register_template_handler 'rplt', GraphTemplate::Gnuplot
ActionView::Template.register_template_handler 'rgnuplot', GraphTemplate::Gnuplot
ActionView::Template.register_template_handler 'rdot', GraphTemplate::Graphviz
