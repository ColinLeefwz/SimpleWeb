class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.string :duty

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
