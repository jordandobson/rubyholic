require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  def setup
    @grps = YAML.load_file("#{RAILS_ROOT}/test/fixtures/groups.yml")
    @locs = YAML.load_file("#{RAILS_ROOT}/test/fixtures/locations.yml")
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
  end

  test "should sort by group ascending as default" do
    get :index
    assert_response :success

    # Check Arrow was set correctly
    assert_match /#{"&#9650;"}/, @response.body
    
    # Check that the Group sort link is selected
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=groups&amp;s=asc\">Group<\/a>\s*<\/b>\s*<\/li>/m, @response.body

    # Make sure all fixtures are listed in correct order
    n = 'name'
    expected = /#{@grps['one'][n]}.*#{@grps['two'][n]}.*#{@grps['three'][n]}.*#{@grps['four'][n]}.*#{@grps['five'][n]}.*#{@grps['six'][n]}.*#{@grps['seven'][n]}.*#{@grps['eight'][n]}.*#{@grps['nine'][n]}.*#{@grps['ten'][n]}.*/m
    assert_match expected, @response.body
  end

end
