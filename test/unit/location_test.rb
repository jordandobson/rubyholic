require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  def setup
    @loc = Location.new
  end

  test "create location without name fails" do
    @loc.name = ""
    assert ! @loc.save
    assert ! @loc.valid?
    assert @loc.errors.on(:name)
  end

  test "create location with name works" do
    count = Location.count
    @loc.name = "Portland"
    assert @loc.valid?
    assert @loc.save!
    assert_not_equal count, Location.count
  end

end
