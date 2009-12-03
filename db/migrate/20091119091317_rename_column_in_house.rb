class RenameColumnInHouse < ActiveRecord::Migration
  def self.up
      rename_column(:houses, :user_id, :creator_id)
  end

  def self.down
     rename_column(:houses, :creator_id, :user_id)
  end
end
