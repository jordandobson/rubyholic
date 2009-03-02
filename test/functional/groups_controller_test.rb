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
    assert_template "index"
  end

  test "should sort by group ascending as default" do
    get :index
    assert_response :success
    assert_template "index"
    # Check Arrow was set correctly
    assert_match /#{"&#9650;"}/, @response.body
    # Check that the Group sort link is selected
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=groups&amp;s=asc\">Group<\/a>\s*<\/b>\s*<\/li>/m, @response.body
    # Fixtures are listed in alphabetical order
    n = 'name'
    expected = /#{@grps['one'][n]}.*#{@grps['two'][n]}.*#{@grps['three'][n]}.*#{@grps['four'][n]}.*#{@grps['five'][n]}.*#{@grps['six'][n]}.*#{@grps['seven'][n]}.*#{@grps['eight'][n]}.*#{@grps['nine'][n]}.*#{@grps['ten'][n]}.*/m
    assert_match expected, @response.body
  end

  test "should sort by group descending" do
    get :index, :s => 'desc', :by => 'groups'
    assert_response :success
    assert_template "index"
    # Check Arrow was set correctly
    assert_match /#{"&#9660;"}/, @response.body
    # Check that the Group sort link is selected
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=groups&amp;s=asc\">Group<\/a>\s*<\/b>\s*<\/li>/m, @response.body
    # Fixtures are listed in reverse alphabetical order
    n = 'name'
    expected = /#{@grps['twelve'][n]}.*#{@grps['eleven'][n]}.*#{@grps['ten'][n]}.*#{@grps['nine'][n]}.*#{@grps['eight'][n]}.*#{@grps['seven'][n]}.*#{@grps['six'][n]}.*#{@grps['five'][n]}.*#{@grps['four'][n]}.*#{@grps['three'][n]}.*/m
    assert_match expected, @response.body
  end

  test "should sort by group ascending" do
    get :index, :s => 'asc', :by => 'groups'
    assert_response :success
    assert_template "index"
    assert_match /#{"&#9650;"}/, @response.body
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=groups&amp;s=asc\">Group<\/a>\s*<\/b>\s*<\/li>/m, @response.body
    n = 'name'
    expected = /#{@grps['one'][n]}.*#{@grps['two'][n]}.*#{@grps['three'][n]}.*#{@grps['four'][n]}.*#{@grps['five'][n]}.*#{@grps['six'][n]}.*#{@grps['seven'][n]}.*#{@grps['eight'][n]}.*#{@grps['nine'][n]}.*#{@grps['ten'][n]}.*/m
    assert_match expected, @response.body
  end

end
