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

ActiveRecord::Schema.define(version: 20160222161027) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blogs", force: :cascade do |t|
    t.text     "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entries", force: :cascade do |t|
    t.string   "title"
    t.text     "url"
    t.string   "author"
    t.text     "content"
    t.datetime "published"
    t.integer  "blog_id"
    t.text     "summary"
    t.string   "categories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "entries", ["blog_id"], name: "index_entries_on_blog_id", using: :btree

  create_table "reader_blogs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "blog_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reader_blogs", ["user_id"], name: "index_reader_blogs_on_user_id", using: :btree

  create_table "todos", force: :cascade do |t|
    t.datetime "duedate"
    t.text     "description"
    t.boolean  "is_completed", default: false
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "todos", ["user_id"], name: "index_todos_on_user_id", using: :btree

  create_table "user_stars", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "entry_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_stars", ["entry_id"], name: "index_user_stars_on_entry_id", using: :btree
  add_index "user_stars", ["user_id"], name: "index_user_stars_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "location"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "weathers", force: :cascade do |t|
    t.string   "icon"
    t.string   "conditions"
    t.text     "text"
    t.string   "pop"
    t.string   "high_temp"
    t.string   "low_temp"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "weathers", ["user_id"], name: "index_weathers_on_user_id", using: :btree

  add_foreign_key "entries", "blogs"
  add_foreign_key "reader_blogs", "users"
  add_foreign_key "todos", "users"
  add_foreign_key "user_stars", "entries"
  add_foreign_key "user_stars", "users"
  add_foreign_key "weathers", "users"
end
