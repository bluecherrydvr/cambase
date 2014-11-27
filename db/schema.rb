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

ActiveRecord::Schema.define(version: 20141127100107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "documents", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_fingerprint"
  end

  create_table "images", force: true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "position"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_fingerprint"
  end

  create_table "models", force: true do |t|
    t.integer  "vendor_id"
    t.string   "model"
    t.text     "manual_url"
    t.text     "jpeg_url"
    t.text     "h264_url"
    t.text     "mjpeg_url"
    t.string   "resolution"
    t.string   "firmware"
    t.string   "shape"
    t.integer  "fov"
    t.boolean  "onvif"
    t.boolean  "psia"
    t.boolean  "ptz"
    t.boolean  "infrared"
    t.boolean  "varifocal"
    t.boolean  "sd_card"
    t.boolean  "upnp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "model_slug"
    t.boolean  "audio_in"
    t.boolean  "audio_out"
    t.string   "default_username"
    t.string   "default_password"
    t.hstore   "additional_information"
    t.boolean  "discontinued"
    t.boolean  "wifi"
    t.boolean  "poe"
    t.string   "official_url"
  end

  add_index "models", ["model_slug"], name: "index_models_on_model_slug", using: :btree
  add_index "models", ["vendor_id"], name: "index_models_on_vendor_id", using: :btree

  create_table "recorders", force: true do |t|
    t.integer  "vendor_id"
    t.string   "recorder_slug"
    t.string   "name"
    t.string   "model"
    t.string   "official_url"
    t.text     "jpeg_url"
    t.text     "h264_url"
    t.text     "mjpeg_url"
    t.string   "resolution"
    t.string   "default_username"
    t.string   "default_password"
    t.string   "recorder_type"
    t.integer  "input_channels"
    t.integer  "playback_channels"
    t.boolean  "audio_in"
    t.boolean  "audio_out"
    t.boolean  "onvif"
    t.boolean  "psia"
    t.boolean  "ptz"
    t.boolean  "upnp"
    t.boolean  "discontinued"
    t.boolean  "support_3rdparty"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usb"
    t.integer  "sdhc"
    t.boolean  "hot_swap"
    t.boolean  "hdmi"
    t.boolean  "digital_io"
    t.string   "mobile_access"
    t.string   "alarms"
    t.string   "raid_support"
    t.string   "storage"
    t.string   "additional_information"
  end

  add_index "recorders", ["vendor_id"], name: "index_recorders_on_vendor_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.text     "info"
    t.text     "mac",         default: [], array: true
    t.text     "text",        default: [], array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vendor_slug"
    t.string   "url"
  end

  add_index "vendors", ["vendor_slug"], name: "index_vendors_on_vendor_slug", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
