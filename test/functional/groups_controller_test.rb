require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  def setup
    @grps = YAML.load_file("#{RAILS_ROOT}/test/fixtures/groups.yml")
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups)
    assert_template "index"
  end

  test "should get a list of data at index" do
    get :index
    assert_match /<ol>.*<li>.*<\/li>.*<\/ol>/m, @response.body
  end

  test "should set up interface for default display" do
    get :index
    assert_equal assigns(:sort_order),  'asc'
    assert_equal assigns(:order_by),    'groups'

    # Toggle Arrow is Up
    assert_match /#{"&#9650;"}/, @response.body

    # Groups are selected
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=groups&amp;s=asc\">Group<\/a>\s*<\/b>\s*<\/li>/m, @response.body

    # Add group exists
    assert_match /<a href.+>Add Group<\/a>/i, @response.body
  end

  test "should have interface select groups and set arrow up" do
    get :index, :s => 'asc', :by => 'groups'
    assert_match /#{"&#9650;"}/, @response.body
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=groups&amp;s=asc\">Group<\/a>\s*<\/b>\s*<\/li>/m, @response.body
  end

  test "should have interface select groups and set arrow down" do
    get :index, :s => 'desc', :by => 'groups'
    assert_match /#{"&#9660;"}/, @response.body
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=groups&amp;s=asc\">Group<\/a>\s*<\/b>\s*<\/li>/m, @response.body
  end

  test "should have interface select locations and set arrow up" do
    get :index, :s => 'asc', :by => 'locations'
    assert_match /#{"&#9650;"}/, @response.body
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=locations&amp;s=asc\">Location<\/a>\s*<\/b>\s*<\/li>/m, @response.body
  end

  test "should have interface select locations and set arrow down" do
    get :index, :s => 'desc', :by => 'locations'
    assert_match /#{"&#9660;"}/, @response.body
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=locations&amp;s=asc\">Location<\/a>\s*<\/b>\s*<\/li>/m, @response.body
  end

  test "should sort by group ascending" do
    get :index, :s => 'asc', :by => 'groups'
    groups =  assigns(:groups)
    n = 'name'
    assert_equal groups[0].name, @grps['one']   [n]
    assert_equal groups[1].name, @grps['two']   [n]
    assert_equal groups[2].name, @grps['three'] [n]
    assert_equal groups[3].name, @grps['four']  [n]
    assert_equal groups[4].name, @grps['five']  [n]
    assert_equal groups[5].name, @grps['six']   [n]
    assert_equal groups[6].name, @grps['seven'] [n]
    assert_equal groups[7].name, @grps['eight'] [n]
    assert_equal groups[8].name, @grps['nine']  [n]
    assert_equal groups[9].name, @grps['ten']   [n]
  end

  test "should sort by group descending" do
    get :index, :s => 'desc', :by => 'groups'
    groups =  assigns(:groups)
    n = 'name'
    assert_equal groups[0].name, @grps['twelve'][n]
    assert_equal groups[1].name, @grps['eleven'][n]
    assert_equal groups[2].name, @grps['ten']   [n]
    assert_equal groups[3].name, @grps['nine']  [n]
    assert_equal groups[4].name, @grps['eight'] [n]
    assert_equal groups[5].name, @grps['seven'] [n]
    assert_equal groups[6].name, @grps['six']   [n]
    assert_equal groups[7].name, @grps['five']  [n]
    assert_equal groups[8].name, @grps['four']  [n]
    assert_equal groups[9].name, @grps['three'] [n]
  end

  test "should sort by location ascending" do
    get :index, :s => 'asc', :by => 'locations'
    groups =  assigns(:groups)
    n = 'name'
    assert_equal groups[0].name, @grps['one']   [n]
    assert_equal groups[1].name, @grps['ten']   [n]
    assert_equal groups[2].name, @grps['two']   [n]
    assert_equal groups[3].name, @grps['three'] [n]
    assert_equal groups[4].name, @grps['four']  [n]
    assert_equal groups[5].name, @grps['five']  [n]
  end

  test "should sort by location descending" do
    get :index, :s => 'desc', :by => 'locations'
    groups =  assigns(:groups)
    n = 'name'
    assert_equal groups[0].name, @grps['five']  [n]
    assert_equal groups[1].name, @grps['four']  [n]
    assert_equal groups[2].name, @grps['three'] [n]
    assert_equal groups[3].name, @grps['two']   [n]
    assert_equal groups[4].name, @grps['one']   [n]
    assert_equal groups[5].name, @grps['ten']   [n]
  end

end
