class AddGroupAndLocationIdsToEvents < ActiveRecord::Migration
  def self.up
    add_column(     :events, :group_id,     :integer)
    add_column(     :events, :location_id,  :integer)
    change_column(  :events, :start_date,   :datetime)
    change_column(  :events, :end_date,     :datetime)
  end

  def self.down
    change_column(  :events, :start_date,   :date)
    change_column(  :events, :end_date,     :date)
    remove_column(  :events, :group_id    )
    remove_column(  :events, :location_id )
  end
end
