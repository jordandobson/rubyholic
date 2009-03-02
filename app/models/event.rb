class Event < ActiveRecord::Base
  belongs_to :location
  belongs_to :group

  validates_presence_of :group_id, :location_id, :start_date, :end_date
end
