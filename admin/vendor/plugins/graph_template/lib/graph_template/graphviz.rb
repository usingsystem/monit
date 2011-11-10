# Graphviz
module GraphTemplate

  class Graphviz < ::ActionView::TemplateHandler
    LAYOUTS = [:dot, :neato, :twopi, :circo, :fdp, :sfdp]
    FORMATS = [:png, :cmapx, :svg, :gif, :vml, :pdf, :plain, :ps]

    def self.call(template)
      "#{name}.new(self).render(template, local_assigns)"
    end

    def initialize(view = nil)
      @view = view
    end

    def render(template, local_assigns)
      source = template.source
      tpl = @view.render(:inline => source, :locals => local_assigns, :layout => false, :type => :erb)
      #@view.controller.response.content_type ||= Mime::PNG
      #@view.controller.headers['Content-Disposition'] = 'inline'
      format = (local_assigns[:format] || @view.params[:format] || :png).to_sym
      #for test
      return tpl if format == :rdot 
      raise(ArgumentError, "Format must in #{FORMATS.inspect}") unless FORMATS.include?(format)
      layout = tpl.scan(/graph\s*\[.*?layout\s*=\s*["']?(dot|neato|twopi|circo|fdp|sfdp)["']?/i)
      layout = (layout.size > 0 ? layout.last[0] : :dot).to_sym
      gp = IO::popen("dot -q -T#{format} -K#{layout}", "w+")
      gp << tpl
      gp.flush
      gp.close_write
      buf = ""
      gp.read(nil, buf)
      gp.close_read
      buf
    end

  end

end
