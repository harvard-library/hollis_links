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

ActiveRecord::Schema.define(version: 20150113140215) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ledgers", force: true do |t|
    t.string   "user_email",          default: "<Admin Console>", null: false
    t.string   "ext_id",                                          null: false
    t.string   "ext_id_type",                                     null: false
    t.datetime "time"
    t.string   "event_type"
    t.json     "serialized_linklist"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ledgers", ["ext_id_type", "ext_id"], name: "index_ledgers_on_ext_id_type_and_ext_id", using: :btree

  create_table "link_lists", force: true do |t|
    t.string   "ext_id",                               null: false
    t.string   "ext_id_type",       default: "hollis", null: false
    t.string   "continues_name"
    t.string   "continues_url"
    t.string   "continued_by_name"
    t.string   "continued_by_url"
    t.string   "fts_search_url"
    t.text     "comment"
    t.text     "cached_metadata"
    t.boolean  "dateable",          default: true
    t.text     "title"
    t.text     "author"
    t.text     "publication"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.integer  "links_count",       default: 0,        null: false
  end

  create_table "links", force: true do |t|
    t.integer "position",     null: false
    t.integer "link_list_id", null: false
    t.string  "name",         null: false
    t.string  "url",          null: false
  end

  add_index "links", ["link_list_id"], name: "index_links_on_link_list_id", using: :btree

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
    t.string   "affiliation"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
