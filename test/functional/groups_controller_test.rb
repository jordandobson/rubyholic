require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should sort by ascending as default" do
    get :index
    assert_response :success
    assert_match /#{"&#9650;"}/, @response.body
    
  end

end
