#!/usr/bin/ruby

#http://rubyforge.org/tracker/index.php?func=detail&aid=27102&group_id=2030&atid=7929

require 'rubygems'
files = []
Gem.path.each do |gemdir|
	files += Dir[File.join(gemdir, 'gems/scruff*/lib/scruffy/renderers/base.rb')]
end
re_str = 'svg.svg(:xmlns => "http://www.w3.org/2000/svg", "xmlns:xlink" => "http://www.w3.org/1999/xlink", :viewBox => "0 0 #{options[:size].first} #{options[:size].last}")'

files.each do |file|
	content = ""
	File.open(file, "r") do |f|
		content = f.read
	end
	content = content.gsub(/svg\.svg[^\)]*\)/, re_str)
	File.open(file, "w") do |f|
		f.write(content)
	end
	p "Change view Box in file(#{file})."
end
