class CreateHouseSharings < ActiveRecord::Migration
  def self.up
    create_table :house_sharings do |t|
      t.references :user
      t.references :house
      t.integer :active
      t.timestamps
    end
  end

  def self.down
    drop_table :house_sharings
  end
end
