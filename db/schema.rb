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

ActiveRecord::Schema.define(:version => 20130725232629) do

  create_table "memes", :force => true do |t|
    t.string   "url",                        :null => false
    t.integer  "creator_id",                 :null => false
    t.integer  "score",       :default => 0
    t.string   "slug",                       :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "top_text"
    t.string   "bottom_text"
    t.string   "picture"
  end

  add_index "memes", ["creator_id"], :name => "index_memes_on_creator_id"

  create_table "present_memes", :force => true do |t|
    t.string   "order_serialized"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "full_name",                       :null => false
    t.string   "email",                           :null => false
    t.string   "user_token"
    t.string   "user_secret"
    t.string   "auth_status", :default => "user"
    t.integer  "score",       :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "uid"
    t.string   "provider"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "votes", :force => true do |t|
    t.string   "vote_type",  :null => false
    t.integer  "meme_id"
    t.integer  "voter_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "votes", ["meme_id"], :name => "index_votes_on_meme_id"
  add_index "votes", ["voter_id", "meme_id"], :name => "index_votes_on_voter_id_and_meme_id", :unique => true
  add_index "votes", ["voter_id"], :name => "index_votes_on_voter_id"

end
