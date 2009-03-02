require 'test_helper'

class EventTest < ActiveSupport::TestCase

  def setup
    @event = Event.new
  end

  test "create event without required data fails" do
    assert ! @event.save
    assert ! @event.valid?
    assert @event.errors.on(:group_id)
    assert @event.errors.on(:location_id)
    assert @event.errors.on(:start_date)
    assert @event.errors.on(:end_date)
  end

  test "create event with valid data" do
    count = Event.count
    @event.group_id    = groups(:one).id
    @event.location_id = locations(:one).id
    @event.start_date  = events(:one).start_date
    @event.end_date    = events(:one).end_date
    assert @event.save!
    assert @event.valid?
    assert_not_equal count, Event.count
  end

end
