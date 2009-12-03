class AddStateToUsers < ActiveRecord::Migration
   def self.up
        add_column :users, :activation_code, :string,  :limit => 40
        add_column :users, :activated_at, :datetime
        add_column :users, :state, :string, :default => "passive"
        add_column :users, :deleted_at, :datetime
        add_column :users, :password_reset_code, :string,  :limit => 40
    end

    def self.down
       remove_column :users, :activation_code
       remove_column :users, :activated_at
       remove_column :users, :state
       remove_column :users, :deleted_at
       remove_column :users, :password_reset_code
    end
end

 