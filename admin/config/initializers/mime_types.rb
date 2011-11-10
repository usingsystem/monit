# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register_alias "text/html", :iphone
Mime::Type.register_alias "text/html", :ajax unless Mime.const_defined?(:AJAX)
Mime::Type.register_alias "text/plain", :tsv unless Mime.const_defined?(:TSV)
Mime::Type.register_alias "image/png", :png unless Mime.const_defined?(:PNG)
Mime::Type.register_alias "image/gif", :gif unless Mime.const_defined?(:GIF)
