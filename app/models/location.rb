require "geokit"

class Location < ActiveRecord::Base

  include GeoKit::Geocoders

  before_validation :geocode_address

  has_many :event
  has_many :group, :through => :events

  validates_presence_of :name

  def geocode_address
    if self.address
      address = MultiGeocoder.geocode(self.address)
      if address.all.length == 1
        self.lat = address.lat
        self.lng = address.lng
      end
    end
  end

end