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

ActiveRecord::Schema.define(:version => 20110406010754) do

  create_table "comments", :force => true do |t|
    t.string   "content",        :limit => 240, :null => false
    t.integer  "measurement_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geigercounters", :force => true do |t|
    t.string   "name",         :limit => 100,                 :null => false
    t.integer  "tolerance",                   :default => 25, :null => false
    t.string   "manufacturer"
    t.string   "url"
    t.string   "filename"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "measurements", :force => true do |t|
    t.string   "name",       :limit => 200, :null => false
    t.string   "content",    :limit => 240, :null => false
    t.float    "lat"
    t.float    "lon"
    t.float    "msph"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "measurements", ["name"], :name => "index_measurements_on_name"
  add_index "measurements", ["user_id"], :name => "index_measurements_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "users", :force => true do |t|
    t.string   "username",           :limit => 50,                     :null => false
    t.string   "fullname",           :limit => 50,                     :null => false
    t.string   "email",              :limit => 254,                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",                                   :null => false
    t.string   "salt",                                                 :null => false
    t.boolean  "admin",                             :default => false
    t.string   "fb_id",              :limit => 100
    t.string   "fb_token"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["fb_id"], :name => "index_users_on_fb_id"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
