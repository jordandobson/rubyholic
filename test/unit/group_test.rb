require 'test_helper'

class GroupTest < ActiveSupport::TestCase

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

  test "can access location name via group" do
    grp = Group.find(groups(:one).id, :include => :locations)
    assert grp.locations[0].name
    assert_equal grp.locations[0].name, "A Loc"
    # group.locations.length == 0
    # one that isn't linked up is has no location
  end

  test "can access location via groups" do
    grp = Group.find(:all, :include => :locations)
    assert grp[0].locations.length > 0
  end

#   test "can't access location via invalid group" do
#     grp = Group.find(9999999, :include => :locations)
#     assert_raise grp.locations[0].name
#   end

end
