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

end
