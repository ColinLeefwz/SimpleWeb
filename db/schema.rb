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

ActiveRecord::Schema.define(version: 20131216141712) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chapters", force: true do |t|
    t.text     "description"
    t.integer  "course_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "chapters", ["course_id"], name: "index_chapters_on_course_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "contact_messages", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "categories",         default: [],  array: true
    t.string   "title"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.decimal  "price",              default: 0.0
  end

  add_index "courses", ["categories"], name: "index_courses_on_categories", using: :gin

  create_table "courses_users", force: true do |t|
    t.integer "course_id"
    t.integer "expert_id"
  end

  add_index "courses_users", ["course_id"], name: "index_courses_users_on_course_id", using: :btree
  add_index "courses_users", ["expert_id"], name: "index_courses_users_on_expert_id", using: :btree

  create_table "email_messages", force: true do |t|
    t.string   "subject"
    t.string   "to"
    t.text     "message"
    t.boolean  "copy_me"
    t.string   "from_name"
    t.string   "from_address"
    t.string   "reply_to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "invited_type"
    t.string   "invite_token"
  end

  add_index "email_messages", ["user_id"], name: "index_email_messages_on_user_id", using: :btree

  create_table "followings", force: true do |t|
    t.integer  "the_followed"
    t.integer  "follower"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", force: true do |t|
    t.string   "long_version"
    t.string   "short_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.integer  "session_id"
    t.string   "payment_id"
    t.string   "state"
    t.string   "amount"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["session_id"], name: "index_orders_on_session_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "profiles", force: true do |t|
    t.string   "title"
    t.string   "company"
    t.string   "location"
    t.text     "expertise"
    t.text     "favorite_quote"
    t.text     "career"
    t.text     "education"
    t.text     "web_site"
    t.text     "article_reports"
    t.text     "additional"
    t.text     "testimonials"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "propose_topics", force: true do |t|
    t.string   "Name"
    t.string   "Location"
    t.string   "Email"
    t.text     "Topic"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "resources", force: true do |t|
    t.integer  "expert_id"
    t.string   "attached_file_file_path"
    t.string   "direct_upload_url"
    t.string   "attached_file_file_name"
    t.string   "attached_file_content_type"
    t.integer  "attached_file_file_size"
    t.datetime "attached_file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id"
    t.string   "video_definition"
  end

  add_index "resources", ["section_id"], name: "index_resources_on_section_id", using: :btree

  create_table "sections", force: true do |t|
    t.text     "description"
    t.integer  "chapter_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  add_index "sections", ["chapter_id"], name: "index_sections_on_chapter_id", using: :btree

  create_table "sessions", force: true do |t|
    t.string   "title"
    t.integer  "expert_id"
    t.text     "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type"
    t.string   "video_url"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.string   "location"
    t.decimal  "price"
    t.string   "language"
    t.boolean  "always_show",        default: false
    t.datetime "start_date"
    t.string   "categories",         default: [],    array: true
    t.boolean  "draft",              default: false
    t.string   "time_zone",          default: "UTC"
    t.datetime "end_date_time"
    t.boolean  "canceled"
  end

  add_index "sessions", ["categories"], name: "index_sessions_on_categories", using: :gin
  add_index "sessions", ["expert_id"], name: "index_sessions_on_expert_id", using: :btree

  create_table "sessions_users", force: true do |t|
    t.integer "user_id"
    t.integer "session_id"
  end

  create_table "static_pages", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "subscriptions", force: true do |t|
    t.integer  "subscriber_id"
    t.integer  "subscribed_session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["subscribed_session_id"], name: "index_subscriptions_on_subscribed_session_id", using: :btree
  add_index "subscriptions", ["subscriber_id"], name: "index_subscriptions_on_subscriber_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: ""
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
    t.integer  "rolable_id"
    t.string   "rolable_type"
    t.string   "type"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "time_zone",              default: "UTC"
  end

  add_index "users", ["email", "provider"], name: "index_users_on_email_and_provider", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "video_interviews", force: true do |t|
    t.string   "title"
    t.integer  "expert_id"
    t.string   "categories",                     default: [], array: true
    t.text     "description"
    t.string   "attached_video_hd_file_name"
    t.string   "attached_video_hd_content_type"
    t.integer  "attached_video_hd_file_size"
    t.datetime "attached_video_hd_updated_at"
    t.string   "attached_video_sd_file_name"
    t.string   "attached_video_sd_content_type"
    t.integer  "attached_video_sd_file_size"
    t.datetime "attached_video_sd_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hd_url"
    t.string   "sd_url"
    t.string   "language"
    t.string   "cover_file_name"
    t.string   "cover_content_type"
    t.integer  "cover_file_size"
    t.datetime "cover_updated_at"
    t.string   "cover_url"
  end

  add_index "video_interviews", ["categories"], name: "index_video_interviews_on_categories", using: :gin
  add_index "video_interviews", ["expert_id"], name: "index_video_interviews_on_expert_id", using: :btree

end
