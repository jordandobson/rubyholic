require 'test_helper'
require 'flexmock/test_unit'

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

  test "address gets geocodes" do

    @loc.name = "Squad"
    addy = "2508 E Yesler Way, Seattle, WA 98405"
    @loc.address = addy

    fake_address = Struct.new(:all , :lat, :lng).new([:foo],1.5, 1.5)

    flexmock(MultiGeocoder).should_receive(:geocode).with(addy).once.and_return(fake_address)

    assert @loc.save!
    assert_equal 1.5, @loc.lng
    assert_equal 1.5, @loc.lat
  end

end
