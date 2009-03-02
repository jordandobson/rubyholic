class Location < ActiveRecord::Base

  has_many :event
  has_many :group, :through => :events

  validates_presence_of :name
end

#   has_many :group