class Group < ActiveRecord::Base

  before_validation :scrub_url

  has_many :events
  has_many :locations, :through => :events

  validates_presence_of   :name
  validates_uniqueness_of :name

# Sphinx indexes
  define_index do
    indexes name
    indexes event.description, :as => :event_descriptions
    indexes [locations.name, locations.address], :as => :location_addresses
  end

  def scrub_url
    if self.url == "http://"
      self.url = nil
    end
  end

end