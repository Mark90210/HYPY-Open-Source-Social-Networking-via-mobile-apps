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

ActiveRecord::Schema.define(version: 28) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "type"
    t.string "title"
    t.text "messge"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expires_at"
    t.datetime "sent_at"
    t.datetime "delivered_at"
  end

  create_table "app_settings", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comment_flags", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "photo_id"
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "galleries", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "owner_type"
    t.text "description"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.point "location"
    t.string "hero_image"
    t.boolean "bypass_moderation", default: false
    t.text "fb_user_id"
    t.text "fb_password"
    t.text "tw_user_id"
    t.text "tw_password"
    t.text "ig_user_id"
    t.text "ig_password"
    t.text "yt_user_id"
    t.text "yt_password"
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.integer "inviter_id"
    t.integer "invitee_id"
    t.integer "gallery_id"
    t.string "file_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "photo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photo_flags", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "photo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "gallery_id"
    t.string "file_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "moderated", default: false
    t.string "location"
    t.string "dimension"
    t.string "thumb_photo"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.text "bio"
    t.string "email"
    t.string "phone"
    t.string "password_hash"
    t.string "salt"
    t.string "device_identifier"
    t.string "token"
    t.boolean "is_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "profile_image"
    t.string "verification_code"
    t.string "type"
    t.integer "parent_id"
    t.boolean "confirmed", default: false
    t.boolean "is_active", default: true
  end

  add_foreign_key "alerts", "users"
  add_foreign_key "comment_flags", "comments"
  add_foreign_key "comment_flags", "users"
  add_foreign_key "comments", "photos"
  add_foreign_key "comments", "users"
  add_foreign_key "galleries", "users"
  add_foreign_key "invitations", "galleries"
  add_foreign_key "invitations", "users", column: "invitee_id"
  add_foreign_key "invitations", "users", column: "inviter_id"
  add_foreign_key "likes", "photos"
  add_foreign_key "likes", "users"
  add_foreign_key "photo_flags", "photos"
  add_foreign_key "photo_flags", "users"
  add_foreign_key "photos", "galleries"
  add_foreign_key "photos", "users"
  add_foreign_key "users", "users", column: "parent_id"
end
