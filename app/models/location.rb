class Location < ActiveRecord::Base

  before_validation :geocode_address

  has_many :event
  has_many :group, :through => :events

  validates_presence_of :name

private

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