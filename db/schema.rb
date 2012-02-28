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

ActiveRecord::Schema.define(:version => 20120228034211) do

  create_table "account_informations", :force => true do |t|
    t.integer  "user_id"
    t.string   "reddit_name"
    t.string   "character_name"
    t.string   "character_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",           :default => 0
    t.integer  "race",                          :null => false
    t.integer  "league",                        :null => false
  end

  create_table "chat_messages", :force => true do |t|
    t.string   "sender_id",                       :null => false
    t.string   "recipient_id",                    :null => false
    t.string   "message",                         :null => false
    t.boolean  "read",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chat_profiles", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "chat_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_links", :force => true do |t|
    t.integer  "match_id"
    t.integer  "next_match_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_player_relations", :force => true do |t|
    t.integer  "waiting_player_id",                    :null => false
    t.integer  "match_id",                             :null => false
    t.boolean  "accepted",          :default => false
    t.boolean  "contested",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matches", :force => true do |t|
    t.integer  "tournament_id", :null => false
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replays", :force => true do |t|
    t.integer  "match_id",    :null => false
    t.string   "replay_url",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "uploader_id"
  end

  create_table "tournaments", :force => true do |t|
    t.integer  "league",            :default => 0,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time",                           :null => false
    t.integer  "max_players",       :default => 20,    :null => false
    t.string   "type",                                 :null => false
    t.boolean  "locked",            :default => false
    t.datetime "registration_time",                    :null => false
    t.string   "name",                                 :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                             :null => false
    t.string   "email",                             :null => false
    t.string   "persistence_token",                 :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
  end

  create_table "waiting_players", :force => true do |t|
    t.integer  "tournament_id",                      :null => false
    t.integer  "user_id",                            :null => false
    t.boolean  "player_accepted", :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
