# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130830091129) do

  create_table "contact_messages", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experts", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "company"
    t.string   "location"
    t.text     "expertise"
    t.text     "favorite_quote"
    t.text     "career"
    t.text     "education"
    t.text     "web_site"
    t.text     "article_reports"
    t.text     "speeches"
    t.text     "additional"
    t.text     "testimonials"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url",       default: "default.png"
    t.string   "email"
    t.boolean  "authorized",      default: false
  end

  create_table "propose_topics", force: true do |t|
    t.string   "Name"
    t.string   "Location"
    t.string   "Email"
    t.text     "Topic"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "title"
    t.integer  "expert_id"
    t.text     "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url",    default: "default.png"
    t.string   "content_type"
    t.string   "catalog"
    t.string   "cover"
    t.string   "video_url"
  end

  add_index "sessions", ["expert_id"], name: "index_sessions_on_expert_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
