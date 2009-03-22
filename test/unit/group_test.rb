require 'test_helper'


class GroupTest < ActiveSupport::TestCase

  should_have_many :events
  should_have_many :locations, :through => :events
  should_not_allow_values_for :name, "'"

  def setup
    @group = Group.new
  end

  test "create group without name fails" do
    @group.name = ""
    assert ! @group.save
    assert ! @group.valid?
    assert @group.errors.on(:name)
  end

  test "create group with name works" do
    count = Group.count
    @group.name = "Portland"
    assert @group.valid?
    assert @group.save!
    assert_not_equal count, Group.count
  end

  test "created group with http:// only in url gets scrubbed" do
    count = Group.count
    @group.name = "Tacoma Ruby Group"
    @group.url  = "http://"
    assert @group.save!
    assert @group.valid?
    assert_not_equal count, Group.count
    assert_equal nil, @group.url
  end

  test "scrubbing of url" do
    @group.url = 'http://'
    @group.scrub_url
    assert_equal nil, @group.url
  end

  test "that names are unique" do
    group = Group.new(groups(:one).attributes)
    assert ! group.valid?
    assert group.errors.on(:name)
  end

  test "can access location via groups" do
    grp = Group.find(groups(:one).id, :include => :locations)
    assert grp.locations.length > 0
  end

  test "Getting group returns expected results" do
    grp = Group.find(groups(:one).id)
    assert_equal groups(:one).name,         grp.name
    assert_equal groups(:one).url,          grp.url
    assert_equal groups(:one).description,  grp.description 
  end

  test "can access events via groups" do
    grp = Group.find(groups(:one).id, :include => :locations)
    assert grp.events.length > 0
  end

  test "can access event name via group" do
    grp = Group.find(groups(:one).id, :include => :locations)
    assert grp.events[0].name
    assert_equal grp.events[0].name, events(:one).name
  end

end
