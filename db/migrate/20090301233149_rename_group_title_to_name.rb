class RenameGroupTitleToName < ActiveRecord::Migration
  def self.up
    rename_column(:groups,    :title, :name)
    rename_column(:locations, :venue, :name)
  end

  def self.down
    rename_column(:groups, :name, :title)
    rename_column(:locations, :name, :venue)
  end
end
