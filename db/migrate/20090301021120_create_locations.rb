class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :venue
      t.text :address
      t.float :lat
      t.float :lng
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
