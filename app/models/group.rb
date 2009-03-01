class Group < ActiveRecord::Base
  has_many :events
  has_many :locations, :through => :events

  validates_presence_of :title
  validates_length_of :title, :minimum => 4,
                      :message => 'must be at least 4 characters long.'
  validates_uniqueness_of :title

end
