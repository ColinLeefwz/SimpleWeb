class AddAvatarToExperts < ActiveRecord::Migration
  def self.up
    add_attachment :experts, :avatar
  end

  def self.down
    remove_attachment :experts, :avatar
  end
end
