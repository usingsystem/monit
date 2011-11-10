class FeedbacksController < ApplicationController
  layout 'welcome'
  skip_before_filter :login_required

  def show
    @feedback = Feedback.new(:email => (current_user && current_user.email.split(',').first), :subject => "建议", :referer => request.referer)    
    render :action => 'new'
  end

  def new
    @feedback = Feedback.new(:email => (current_user && current_user.email.split(',').first), :subject => "建议", :referer => request.referer)    
  end

  def create

    @feedback = Feedback.new(params[:feedback])
    if @feedback.valid?
      FeedbackMailer.deliver_feedback(@feedback)
      flash[:notice] = "谢谢您的反馈。"
      redirect_to feedback_path
      #render :status => :created, :text => '<h3>Thank you for your feedback!</h3>'
    else
      @error_message = "反馈内容不能为空"

      # Returns the whole form back. This is not the most effective
      # use of AJAX as we could return the error message in JSON, but
      # it makes easier the customization of the form with error messages
      # without worrying about the javascript.
      render :action => 'new', :status => :unprocessable_entity
    end
  end
end
