class SinaUser < ActiveRecord::Migration
  def self.up
    create_table :sina_users do |t|
      t.string :sina_uid
      t.string :access_token
      t.string :token_secret

      t.timestamps
    end
  end

  def self.down
    drop_table :sina_users
  end
end
