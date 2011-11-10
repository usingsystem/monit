class RrdController < ApplicationController
  def graph
    begin
      res = Net::HTTP.get_response(URI.parse("#{$RRD_ADDRESS}#{params[:rrdb]}&time=#{params[:time]}&width=#{params[:width]}&height=#{params[:height]}"))
      send_data(res.body, :type => "image/png", :disposition => "inline")
    rescue
      redirect_to "/images/no_rrd.png"
    end
  end
end