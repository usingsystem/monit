require File.dirname(__FILE__) + '/../test_helper'

class FeedbacksControllerTest < ActionController::TestCase
  
  def setup
    @controller = FeedbacksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  
  def test_should_have_minimal_feedback_form
    get :new    
    assert_select "form#feedback_form", true do      
      assert_select "[action=?]", "/feedbacks" 
      assert_select "[method=?]", /post/i
      assert_select "textarea[name=?]", "feedback[comment]"
    end
  end
  
  def test_should_post_create
    post :create, :feedback => {:comment => "Great website!"}
    assert :success # Doesn't test much  
    assert_nil @error_message
  end
     
  
  def test_should_set_error_message_when_not_valid
    post :create, :feedback => {:comment => ""}
    assert !assigns(:error_message).blank?
  end
  

  protected
  
  def create_feedback(params = {})
    valid_feedback = {
      :subject => "Test",
      :email => "test@yoursite.com",
      :comment => "i like the site"
    }
    Feedback.new(valid_feedback.merge(params))    
  end
end
