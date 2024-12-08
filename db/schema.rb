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

ActiveRecord::Schema[8.0].define(version: 2024_12_02_123428) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "comments", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "map_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id"], name: "index_comments_on_map_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "subject"
    t.text "message"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "map_softwares", force: :cascade do |t|
    t.bigint "software_id", null: false
    t.bigint "map_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["map_id"], name: "index_map_softwares_on_map_id"
    t.index ["software_id"], name: "index_map_softwares_on_software_id"
  end

  create_table "maps", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.date "creation_date"
    t.integer "scale"
    t.text "sources"
    t.string "geographic_coverage"
    t.string "projection"
    t.boolean "is_public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creation_date"], name: "index_maps_on_creation_date"
    t.index ["description"], name: "index_maps_on_description"
    t.index ["geographic_coverage"], name: "index_maps_on_geographic_coverage"
    t.index ["projection"], name: "index_maps_on_projection"
    t.index ["scale"], name: "index_maps_on_scale"
    t.index ["sources"], name: "index_maps_on_sources"
    t.index ["title"], name: "index_maps_on_title"
    t.index ["user_id"], name: "index_maps_on_user_id"
  end

  create_table "softwares", force: :cascade do |t|
    t.string "name", null: false
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_softwares_on_category"
    t.index ["name"], name: "index_softwares_on_name", unique: true
  end

  create_table "user_softwares", force: :cascade do |t|
    t.bigint "software_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["software_id"], name: "index_user_softwares_on_software_id"
    t.index ["user_id"], name: "index_user_softwares_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "superadmin", default: false
    t.string "locale", default: "en", null: false
    t.string "first_name"
    t.string "last_name"
    t.text "bio"
    t.datetime "last_login_at"
    t.string "personal_website"
    t.jsonb "social_links"
    t.boolean "guest", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "maps"
  add_foreign_key "comments", "users"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "map_softwares", "maps"
  add_foreign_key "map_softwares", "softwares"
  add_foreign_key "maps", "users"
  add_foreign_key "user_softwares", "softwares"
  add_foreign_key "user_softwares", "users"
end
