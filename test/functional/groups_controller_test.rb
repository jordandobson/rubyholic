require 'test_helper'
require 'flexmock/test_unit'

class GroupsControllerTest < ActionController::TestCase

  # COMPLETED GROUP TESTS
  #
  # Index
  # New
  # Create
  # Edit
  # Update
  # Show

  # NEED TESTS FOR
  # Show - location info

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
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=groups&amp;s=asc\">Group<\/a>\s*<\/b>\s*<\/li>/m,       @response.body
    # Add group exists
    assert_match /<a href.+>Add Group<\/a>/i, @response.body
  end

  test "should have interface select groups and set arrow up" do
    get :index, :s => 'asc', :by => 'groups'
    assert_match /#{"&#9650;"}/, @response.body
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=groups&amp;s=asc\">Group<\/a>\s*<\/b>\s*<\/li>/m,       @response.body
  end

  test "should have interface select groups and set arrow down" do
    get :index, :s => 'desc', :by => 'groups'
    assert_match /#{"&#9660;"}/, @response.body
    assert_match /<li>\s*<b>\s*<a href=\"\/groups\?by=groups&amp;s=asc\">Group<\/a>\s*<\/b>\s*<\/li>/m,       @response.body
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

    %w{ two three four five six seven eight nine ten eleven }.each_with_index do |name, i|
      assert_equal grps[i].name, groups(name).name
    end
  end

  test "should sort by group descending" do
    get :index, :s => 'desc', :by => 'groups'
    grps =  assigns(:groups)

    %w{ one twelve eleven ten nine eight seven six five four }.each_with_index do |name, i|
      assert_equal grps[i].name, groups(name).name
    end
  end

  test "should sort by location ascending" do
    get :index, :s => 'asc', :by => 'locations'
    grps =  assigns(:groups)

    %w{ ten three four five one }.each_with_index do |name, i|
      assert_equal grps[i].name, groups(name).name
    end
  end

  test "should sort by location descending" do
    get :index, :s => 'desc', :by => 'locations'
    grps =  assigns(:groups)

    %w{ one five four three ten }.each_with_index do |name, i|
      assert_equal grps[i].name, groups(name).name
    end
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

  test "new should have a cancel link" do
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
    assert_tag  :tag        => 'input', 
                :attributes => {
                  :name     => 'group[name]', 
                  :type     => 'text',
                  :value    => groups(:one).name
    }
    assert_tag  :tag        => 'input', 
                :attributes => {
                  :name     => 'group[url]', 
                  :type     => 'text',
                  :value    =>  groups(:one).url
    }
    assert_tag  :tag        => 'textarea', 
                :content    => groups(:one).description, 
                :attributes => {
                  :name     => 'group[description]'
    }
    assert_tag  :tag        => 'input', 
                :attributes => {
                  :type     => 'submit',
                  :id       => 'group_submit'
    }
    assert_response :success
  end

  test "edit should have a cancel link" do
    get :edit, :id => groups(:one).id
    assert_match /<a.*href.*\/groups.*>cancel<\/a>/i, @response.body
  end

  test "should update group name" do
    put :update, :id => groups(:one).id, :group => {
      :name => 'Pop'
    }
    grp = assigns(:group)
    assert_redirected_to :controller => "groups", :action => grp.id
    assert_equal 'Pop', Group.find(groups(:one).id).name
  end

  test "should error when updating with duplicate group name" do
    put :update, :id => groups(:one).id, :group => {
      :name => groups(:two).name
    }
    assert_template 'groups/edit'
    assert_tag :tag => 'div', :attributes => {
      :id => 'errorExplanation'
    }
    assert "div.fieldWithErrors input[name*=group[name]]"
  end

  test "should error when updating with blank group name" do
    put :update, :id => groups(:one).id, :group => {
      :name => ''
    }
    assert_template 'groups/edit'
    assert_tag :tag => 'div', :attributes => {
      :id => 'errorExplanation'
    }
    assert "div.fieldWithErrors input[name*=group[name]]"
  end

  test "should not include http in url" do
    put :update, :id => groups(:one).id, :group => {
      :url => 'http://'
    }
    grp = assigns(:group) 
    assert_response :redirect
    assert_redirected_to :controller => "groups", :action => grp.id
    assert_nil grp.url
  end


  test "should show group" do
    get :show, :id => groups(:one).id
    assert_response :success
    assert_not_nil assigns(:group)
    assert_template "groups/show"
  end

  test "should show group name" do
    get :show, :id => groups(:one).id
    assert_tag  :tag     => 'span',
                :content => assigns(:group).name,
                :parent  => {
                  :tag   => 'h2'
    } 
  end

  test "show should have an edit link" do
    get :show, :id => groups(:one).id
    grp = assigns(:group)
    assert_match /<a.*href.*\/groups\/#{grp.id}\/edit.*>edit group<\/a>/i, @response.body
  end

  test "show should have an add event link" do
    get :show, :id => groups(:one).id
    assert_match /<a.*href.*>Add Event<\/a>/i, @response.body
  end

  test "show should display group url" do
    get :show, :id => groups(:one).id
    grp = assigns(:group)
    assert_match /<em>SITE<\/em>/i, @response.body
    assert_match /<a.*href.*#{grp.url}.*_blank.*>#{grp.url}<\/a>/i, @response.body
  end

  test "show should display group description" do
    get :show, :id => groups(:one).id
    grp = assigns(:group)
    assert_match /<em>INFO<\/em> #{grp.description}/im, @response.body
  end

  test "show not should display group url label if it doesn't exist" do
    get :show, :id => groups(:five).id
    assert assigns(:group)
    assert_no_match /<em>SITE<\/em>/i, @response.body
  end

  test "show not should display group info label if it doesn't exist" do
    get :show, :id => groups(:three).id
    assert assigns(:group)
    assert_no_match /<em>INFO<\/em>/i, @response.body
  end

  test "show error with invalid group id" do
    assert_raise ActiveRecord::RecordNotFound do
      get :show, :id => 'bad'
    end
  end

#   test "get index with ip address" do
#     ip = "66.234.6.100"
#     @request.env['REMOTE_HOST'] = ip
#     
#     flexmock(GeoIPClient).should_receive(:city).once.with(ip).and_return(
#       [#... all GEO IP STUFF]
#     )
#     get :index
#   end

#   test "get with no query param calls find(:all)" do
# 
#     flexmock(Group).should_receive(:all).once.and_return(
#       [groups(:one)]
#     )
# 
#   end

end
