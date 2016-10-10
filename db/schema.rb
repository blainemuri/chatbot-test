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

ActiveRecord::Schema.define(version: 20161010180439) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bot_entities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "bot_id"
    t.integer  "entity_id"
  end

  create_table "bots", force: :cascade do |t|
    t.text     "trainingData"
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.text     "context"
    t.integer  "correct"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "conversation_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["conversation_id"], name: "index_comments_on_conversation_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.time     "start"
    t.time     "end"
    t.string   "entity"
    t.integer  "correct"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entity_values", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "entity_id"
    t.integer  "value_id"
  end

  create_table "intents", force: :cascade do |t|
    t.string   "name"
    t.text     "examples"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password"
    t.integer  "accessLevel"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "values", force: :cascade do |t|
    t.string   "name"
    t.text     "synonyms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
