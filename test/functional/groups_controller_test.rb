require 'test_helper'

class GroupsControllerTest < ActionController::TestCase

  fixtures :groups
 
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

  test "should sort by group name ascending" do
    get :index, :s => 'asc', :by => 'groups'
    grps =  assigns(:groups)
    assert_equal grps[0].name, groups('two').name
    assert_equal grps[1].name, groups('three').name
    assert_equal grps[2].name, groups('four').name
    assert_equal grps[3].name, groups('five').name
    assert_equal grps[4].name, groups('six').name
    assert_equal grps[5].name, groups('seven').name
    assert_equal grps[6].name, groups('eight').name
    assert_equal grps[7].name, groups('nine').name
    assert_equal grps[8].name, groups('ten').name
    assert_equal grps[9].name, groups('eleven').name
  end

  test "should sort by group descending" do
    get :index, :s => 'desc', :by => 'groups'
    grps =  assigns(:groups)
    assert_equal grps[0].name, groups('one').name
    assert_equal grps[1].name, groups('twelve').name
    assert_equal grps[2].name, groups('eleven').name
    assert_equal grps[3].name, groups('ten').name
    assert_equal grps[4].name, groups('nine').name
    assert_equal grps[5].name, groups('eight').name
    assert_equal grps[6].name, groups('seven').name
    assert_equal grps[7].name, groups('six').name
    assert_equal grps[8].name, groups('five').name
    assert_equal grps[9].name, groups('four').name
  end

  test "should sort by location ascending" do
    get :index, :s => 'asc', :by => 'locations'
    grps =  assigns(:groups)
    assert_equal grps[0].name, groups('ten').name
    assert_equal grps[1].name, groups('three').name
    assert_equal grps[2].name, groups('four').name
    assert_equal grps[3].name, groups('five').name
    assert_equal grps[4].name, groups('one').name
  end

  test "should sort by location descending" do
    get :index, :s => 'desc', :by => 'locations'
    grps =  assigns(:groups)
    assert_equal grps[0].name, groups('one').name
    assert_equal grps[1].name, groups('five').name
    assert_equal grps[2].name, groups('four').name
    assert_equal grps[3].name, groups('three').name
    assert_equal grps[4].name, groups('ten').name
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_template 'groups/new'
  end

  test "should get new with nessecary inputs" do
    get :new
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[url]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'group[description]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'commit', :type => 'submit'
    }
  end

  test "should have a cancel link" do
    get :new
    assert_match /<a.*href.*\/groups.*>cancel<\/a>/i, @response.body
  end

  test "should have http in url field" do
    get :new
    assert_tag :tag => 'input', :attributes => {
      :name => 'group[url]', :value => 'http://'
    }
  end

  test "should create group without url and description" do
    assert_difference('Group.count') do
      post :create, :group => {
        :name => 'Pop'
      }
    end
    grp =  assigns(:group) 
    assert_response :redirect
    assert_redirected_to :controller => "groups", :action => grp.id
  end

  test "should create group with url and description" do
    assert_difference('Group.count') do
      post :create, :group => {
        :name         => 'Pop', 
        :url          => 'http://pop.com',
        :description  => 'Seattle Pop Group'
      }
    end
    grp =  assigns(:group)
    assert_redirected_to :controller => "groups", :action => grp.id
  end

  test "should error on duplicate group name" do
    expected = Group.count
    post :create, :group => {
      :name => groups(:one).name
    }
    assert_template 'groups/new'
    assert_equal expected, Group.count
    assert_tag :tag => 'div', :attributes => {
      :id => 'errorExplanation'
    }
    assert "div.fieldWithErrors input[name*=group[name]]"
  end

  test "should error on missing group name" do
    expected = Group.count
    post :create, :group => {
      :name => ''
    }
    assert_template 'groups/new'
    assert_equal expected, Group.count
    assert_tag :tag => 'div', :attributes => {
      :id => 'errorExplanation'
    }
    assert "div.fieldWithErrors input[name*=group[name]]"
  end

  test "should not include http in url if left blank" do
    assert_difference('Group.count') do
      post :create, :group => {
        :name => 'Pop',
        :url  => 'http://'
      }
    end
    grp = assigns(:group) 
    assert_response :redirect
    assert_redirected_to :controller => "groups", :action => grp.id
    assert_nil grp.url
  end

  test "should get edit" do
    get :edit, :id => groups(:one).id
    assert_tag :tag => 'input', :attributes => {
      :name   => 'group[name]', 
      :type   => 'text',
      :value  => groups(:one).name
    }
    assert_tag :tag => 'input', :attributes => {
      :name   => 'group[url]', 
      :type   => 'text',
      :value  =>  groups(:one).url
    }
    assert_tag :tag => 'textarea', :content  => groups(:one).description, :attributes => {
      :name   => 'group[description]'
    }
    assert_response :success
  end

end
