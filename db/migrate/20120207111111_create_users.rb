class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string   "phone"
      t.string   "name",             :limit => 20,                                                   :null => false
      t.string   "password",         :limit => 20,                                                   :null => false
      t.integer  "score",                                                         :default => 0,     :null => false
      t.string   "email",            :limit => 20
      t.string   "sex",              :limit => 2
      t.string   "occupation",       :limit => 20
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "confirmed",                                                     :default => false, :null => false
      t.integer  "shop_id"
      t.string   "shop_key"
      t.decimal  "balance",                        :precision => 10, :scale => 2, :default => 0.0,   :null => false
      t.string   "register_style",   :limit => 2
      t.integer  "referer"
      t.string   "nickname"
      t.string   "oauth_t"
      t.string   "oauth_id"
      t.string   "oauth_name"
      t.integer  "upuserid"
      t.string   "cardid"
      t.datetime "birthday"
      t.string   "position"
      t.string   "company"
      t.string   "address"
      t.float    "gift_balance",                                                  :default => 0.0
      t.integer  "flag"
      t.integer  "servetype"
      t.integer  "serveuser_id"
      t.string   "other_phones"
      t.string   "kind"
      t.decimal  "recharge_amount",                :precision => 10, :scale => 2
      t.decimal  "present_balance",                :precision => 10, :scale => 2, :default => 0.0,   :null => false
      t.decimal  "recharge_balance",               :precision => 10, :scale => 2, :default => 0.0,   :null => false
      t.decimal  "upuser_scale",                   :precision => 4,  :scale => 3, :default => 0.0
      t.integer  "recharge_confine",                                              :default => 0
      t.integer  "gift_confine",                                                  :default => 0
    end

    add_index "users", ["name"], :name => "index_users_on_name", :unique => true
    add_index "users", ["phone"], :name => "index_users_on_phone"

  end

  def self.down
    drop_table :users
  end
end
