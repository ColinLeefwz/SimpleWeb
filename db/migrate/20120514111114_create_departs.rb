class CreateDeparts < ActiveRecord::Migration
  def self.up
    create_table :departs do |t|
      t.string :name
      t.string :duty

      t.timestamps
    end
  end

  def self.down
    drop_table :departs
  end
end
