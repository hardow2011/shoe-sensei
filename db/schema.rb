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

ActiveRecord::Schema[7.1].define(version: 2025_03_16_173654) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.string "handle", null: false
    t.string "overview_en", null: false
    t.string "overview_es", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company_color", limit: 7, null: false
    t.index ["handle"], name: "index_brands_on_handle", unique: true
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "collections", force: :cascade do |t|
    t.string "name", null: false
    t.string "overview_en", null: false
    t.string "overview_es", null: false
    t.string "handle", null: false
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_collections_on_brand_id"
    t.index ["handle", "brand_id"], name: "index_collections_on_handle_and_brand_id", unique: true
    t.index ["name", "brand_id"], name: "index_collections_on_name_and_brand_id", unique: true
  end

  create_table "mobility_string_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.string "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_string_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_string_translations_on_keys", unique: true
    t.index ["translatable_type", "key", "value", "locale"], name: "index_mobility_string_translations_on_query_keys"
  end

  create_table "mobility_text_translations", force: :cascade do |t|
    t.string "locale", null: false
    t.string "key", null: false
    t.text "value"
    t.string "translatable_type"
    t.bigint "translatable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["translatable_id", "translatable_type", "key"], name: "index_mobility_text_translations_on_translatable_attribute"
    t.index ["translatable_id", "translatable_type", "locale", "key"], name: "index_mobility_text_translations_on_keys", unique: true
  end

  create_table "models", force: :cascade do |t|
    t.string "name", null: false
    t.float "weight", null: false
    t.integer "heel_to_toe_drop", null: false
    t.bigint "collection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "tags", default: {}, null: false
    t.string "handle", null: false
    t.index ["collection_id"], name: "index_models_on_collection_id"
    t.index ["name", "collection_id"], name: "index_models_on_name_and_collection_id", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "title_en", null: false
    t.string "title_es", null: false
    t.string "overview_en", null: false
    t.string "overview_es", null: false
    t.string "handle"
    t.boolean "published", null: false
    t.string "tags", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_en", null: false
    t.string "content_es", null: false
    t.jsonb "table_of_contents_en", default: [], null: false
    t.jsonb "table_of_contents_es", default: [], null: false
    t.date "published_at", default: "2024-10-07"
    t.boolean "has_affiliate_links", default: false
    t.index ["handle"], name: "index_posts_on_handle", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "admin", default: false
    t.string "username"
    t.string "subdomain", default: "", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "collections", "brands"
  add_foreign_key "models", "collections"
end
