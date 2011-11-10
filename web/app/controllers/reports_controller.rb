# To change this template, choose Tools | Templates
# and open the template in the editor.
class ReportsController < ApplicationController
  menu_item 'reports'
  def index
    submenu_item 'reports-index'

  end

  def top
    submenu_item 'reports-top'
    @n = params[:n].to_i
    @n = 5 unless @n > 0
    @n = 10 unless @n <= 10

    tenant = current_user.tenant_id
    @views = View.all(:conditions => {:visible_type => "report_top", :enable => 1}, :include => ['items'])
    @views.each do |view|
      view.data = Report.top(view.data_params.update({ :tenant => tenant, :n => @n}))
    end
    respond_to do |format|
      format.html{
      }
    end
  end
end
