class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.references :user
      t.string :name
      t.text :surname
      t.decimal :money
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
