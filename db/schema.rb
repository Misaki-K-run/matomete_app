# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_03_27_033627) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "ai_generates", force: :cascade do |t|
    t.integer "budget_request", null: false
    t.string "people_request", null: false
    t.text "allergies"
    t.text "favorite_ingredients"
    t.jsonb "menu_response", default: {}, null: false
    t.jsonb "shopping_list_response", default: {}, null: false
    t.integer "sum_response", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "special_request"
    t.uuid "user_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.uuid "post_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "ai_generate_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["ai_generate_id"], name: "index_favorites_on_ai_generate_id"
  end

  create_table "menus", force: :cascade do |t|
    t.text "monday"
    t.text "tuesday"
    t.text "wednesday"
    t.text "thursday"
    t.text "friday"
    t.text "saturday"
    t.text "sunday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "post_id"
  end

  create_table "posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "memo"
    t.integer "sum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.string "category"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "post_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "budget"
    t.integer "people"
    t.string "introduction"
    t.string "avatar"
    t.string "provider"
    t.string "uid"
    t.integer "ai_usage_count", default: 0
    t.date "ai_usage_date", default: -> { "CURRENT_DATE" }
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "ai_generates", "users"
  add_foreign_key "bookmarks", "posts"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "favorites", "ai_generates"
  add_foreign_key "favorites", "users"
  add_foreign_key "menus", "posts"
  add_foreign_key "posts", "users"
  add_foreign_key "shopping_lists", "posts"
end
