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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120907230223) do

  create_table "buds", :force => true do |t|
    t.string   "name"
    t.string   "uid"
    t.string   "hardware_v"
    t.string   "firmware_v"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "active",      :default => false
    t.integer  "building_id"
  end

  add_index "buds", ["building_id", "created_at"], :name => "index_buds_on_building_id_and_created_at"

  create_table "bldg_relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.string   "followed_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "bldg_relationships", ["followed_id", "followed_type"], :name => "index_bldg_relationships_on_followed_id_and_followed_type"
  add_index "bldg_relationships", ["follower_id", "followed_id", "followed_type"], :name => "uniquify_each_relation", :unique => true
  add_index "bldg_relationships", ["follower_id"], :name => "index_bldg_relationships_on_follower_id"

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "avatar"
    t.integer  "creator_id"
  end

  add_index "buildings", ["name", "address"], :name => "index_buildings_on_name_and_address", :unique => true

  create_table "circuits", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "bud_id"
    t.float    "location"
    t.integer  "side"
  end

  add_index "circuits", ["bud_id", "created_at"], :name => "index_circuits_on_bud_id_and_created_at"

  create_table "microalerts", :force => true do |t|
    t.string   "content"
    t.integer  "vocal_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "vocal_type"
  end

  add_index "microalerts", ["vocal_id", "vocal_type", "created_at"], :name => "index_microalerts_on_vocal_id_and_vocal_type_and_created_at"

  create_table "user_relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.string   "followed_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "user_relationships", ["followed_id", "followed_type"], :name => "index_user_relationships_on_followed_id_and_followed_type"
  add_index "user_relationships", ["follower_id", "followed_id", "followed_type"], :name => "unique_user_relation", :unique => true
  add_index "user_relationships", ["follower_id"], :name => "index_user_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",               :default => false
    t.integer  "default_building_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
