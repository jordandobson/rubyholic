class Group < ActiveRecord::Base

  has_many :events
  has_many :location, :through => :events

  validates_presence_of :name
end

#     belongs_to :location