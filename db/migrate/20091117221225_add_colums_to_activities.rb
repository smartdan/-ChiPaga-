class AddColumsToActivities < ActiveRecord::Migration
   def self.up
          add_column :activities, :user_id, :integer
          add_column :activities, :house_id, :integer
   end

   def self.down
         remove_column :activities, :user_id
         remove_column :activities, :house_id
   end
end
