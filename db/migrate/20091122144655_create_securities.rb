class CreateSecurities < ActiveRecord::Migration
  def self.up
    create_table :securities do |t|
      t.string :service
      t.integer :value

      t.timestamps
    end
  end

  def self.down
    drop_table :securities
  end
end

