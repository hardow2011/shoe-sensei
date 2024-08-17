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

ActiveRecord::Schema[7.1].define(version: 2024_08_17_011344) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.string "handle", null: false
    t.string "overview", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["handle"], name: "index_brands_on_handle", unique: true
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "collections", force: :cascade do |t|
    t.string "name", null: false
    t.string "overview", null: false
    t.string "handle", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_collections_on_brand_id"
    t.index ["handle", "brand_id"], name: "index_collections_on_handle_and_brand_id", unique: true
    t.index ["name", "brand_id"], name: "index_collections_on_name_and_brand_id", unique: true
  end

  create_table "models", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "discontinued", null: false
    t.float "weight", null: false
    t.integer "heel_to_toe_drop", null: false
    t.boolean "apma_accepted", null: false
    t.bigint "collection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "tags", default: {}, null: false
    t.index ["collection_id"], name: "index_models_on_collection_id"
    t.index ["name", "collection_id"], name: "index_models_on_name_and_collection_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "collections", "brands"
  add_foreign_key "models", "collections"
end
