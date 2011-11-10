# Gnuplot
module GraphTemplate

  class Gnuplot < ::ActionView::TemplateHandler

    def self.call(template)
      "#{name}.new(self).render(template, local_assigns)"
    end

    def initialize(view = nil)
      @view = view
    end

    def render(template, local_assigns)
      source = template.source
      tpl = @view.render(:inline => source, :layout => false, :type => :erb, :locals => local_assigns)
      format = (local_assigns[:format] || @view.params[:format] || :png).to_sym
      return tpl if format == :rplt 
      #format = :jpeg if format == :jpg
      #@view.controller.response.content_type ||= Mime::PNG
      #@view.controller.headers['Content-Disposition'] = 'inline'
      #tpl = "set terminal #{format} truecolor font 'simsun.ttc,10'\n" + tpl
      gp = IO::popen('gnuplot', "r+")
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
