class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :name
      t.text :description
      t.decimal :cost
      t.datetime :expiration
      t.decimal :duration
      t.integer :done

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
