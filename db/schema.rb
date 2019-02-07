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

ActiveRecord::Schema.define(version: 2019_02_05_045510) do

  create_table "changes", force: :cascade do |t|
    t.string "action"
    t.string "target_key"
    t.string "target_type"
    t.integer "target_id"
    t.json "diff"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_type", "target_id"], name: "index_changes_on_target_type_and_target_id"
  end

  create_table "features", force: :cascade do |t|
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_features_on_key", unique: true
  end

  create_table "flags", force: :cascade do |t|
    t.integer "feature_id"
    t.integer "release_id"
    t.boolean "enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id", "release_id"], name: "index_flags_on_feature_id_and_release_id", unique: true
    t.index ["feature_id"], name: "index_flags_on_feature_id"
    t.index ["release_id"], name: "index_flags_on_release_id"
  end

  create_table "releases", force: :cascade do |t|
    t.string "key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_releases_on_key", unique: true
  end

  create_table "silos", force: :cascade do |t|
    t.string "key"
    t.integer "release_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_silos_on_key", unique: true
    t.index ["release_id"], name: "index_silos_on_release_id"
  end

end
