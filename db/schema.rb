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

ActiveRecord::Schema.define(version: 20130724061705) do

  create_table "experts", force: true do |t|
    t.string   "name"
    t.string   "image_url"
    t.string   "company"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "join_experts", force: true do |t|
    t.string   "Name"
    t.string   "Location"
    t.string   "Email"
    t.text     "Expertise"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "propose_topics", force: true do |t|
    t.string   "Name"
    t.string   "Location"
    t.string   "Email"
    t.text     "Topic"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proposes", force: true do |t|
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
    t.string   "image_url"
  end

  add_index "sessions", ["expert_id"], name: "index_sessions_on_expert_id", using: :btree

end
