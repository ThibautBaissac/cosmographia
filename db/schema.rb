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

ActiveRecord::Schema[8.0].define(version: 2025_01_11_141015) do
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

  create_table "billing_plan_versions", force: :cascade do |t|
    t.bigint "billing_plan_id", null: false
    t.integer "price_cents", default: 0, null: false
    t.string "currency", default: "EUR", null: false
    t.integer "visualization_limit", default: 0, null: false
    t.integer "version_number", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_billing_plan_versions_on_active"
    t.index ["billing_plan_id", "version_number"], name: "idx_on_billing_plan_id_version_number_d0c9de3032", unique: true
    t.index ["billing_plan_id"], name: "index_billing_plan_versions_on_billing_plan_id"
  end

  create_table "billing_plans", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_billing_plans_on_active"
  end

  create_table "billing_subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "billing_plan_version_id", null: false
    t.date "start_date", null: false
    t.date "end_date"
    t.string "status", default: "ACTIVE", null: false
    t.string "external_subscription_id"
    t.string "external_customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_plan_version_id"], name: "index_billing_subscriptions_on_billing_plan_version_id"
    t.index ["status"], name: "index_billing_subscriptions_on_status"
    t.index ["user_id"], name: "index_billing_subscriptions_on_user_id"
  end

  create_table "challenge_discussions", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id", null: false
    t.bigint "challenge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "mentioned_user_ids", default: []
    t.index ["challenge_id"], name: "index_challenge_discussions_on_challenge_id"
    t.index ["mentioned_user_ids"], name: "index_challenge_discussions_on_mentioned_user_ids", using: :gin
    t.index ["user_id", "created_at"], name: "index_challenge_discussions_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_challenge_discussions_on_user_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.date "start_date"
    t.date "end_date", null: false
    t.string "difficulty", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_challenges_on_category"
    t.index ["difficulty"], name: "index_challenges_on_difficulty"
    t.index ["end_date"], name: "index_challenges_on_end_date"
    t.index ["start_date"], name: "index_challenges_on_start_date"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "subject"
    t.text "message"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_feedbacks_on_user_id"
  end

  create_table "softwares", force: :cascade do |t|
    t.string "name", null: false
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_softwares_on_category"
    t.index ["name"], name: "index_softwares_on_name", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.string "concurrency_key", null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.text "error"
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name", null: false
    t.string "class_name", null: false
    t.text "arguments"
    t.integer "priority", default: 0, null: false
    t.string "active_job_id"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.string "queue_name", null: false
    t.datetime "created_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.bigint "supervisor_id"
    t.integer "pid", null: false
    t.string "hostname"
    t.text "metadata"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "task_key", null: false
    t.datetime "run_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.string "key", null: false
    t.string "schedule", null: false
    t.string "command", limit: 2048
    t.string "class_name"
    t.text "arguments"
    t.string "queue_name"
    t.integer "priority", default: 0
    t.boolean "static", default: true, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.bigint "job_id", null: false
    t.string "queue_name", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "scheduled_at", null: false
    t.datetime "created_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.string "key", null: false
    t.integer "value", default: 1, null: false
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "sources", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.string "location"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "index_sources_on_description"
    t.index ["location"], name: "index_sources_on_location"
    t.index ["name"], name: "index_sources_on_name"
  end

  create_table "user_challenges", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "challenge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_user_challenges_on_challenge_id"
    t.index ["user_id"], name: "index_user_challenges_on_user_id"
  end

  create_table "user_softwares", force: :cascade do |t|
    t.bigint "software_id", null: false
    t.bigint "user_id", null: false
    t.string "expertise"
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
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "superadmin", default: false
    t.string "locale", default: "en", null: false
    t.string "first_name"
    t.string "last_name"
    t.text "bio"
    t.string "country_code"
    t.string "personal_website"
    t.jsonb "social_links"
    t.boolean "optin_directory", default: false
    t.string "slug", null: false
    t.boolean "public_profile", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "visualization_comments", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "visualization_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "mentioned_user_ids", default: []
    t.index ["mentioned_user_ids"], name: "index_visualization_comments_on_mentioned_user_ids", using: :gin
    t.index ["user_id", "created_at"], name: "index_visualization_comments_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_visualization_comments_on_user_id"
    t.index ["visualization_id"], name: "index_visualization_comments_on_visualization_id"
  end

  create_table "visualization_softwares", force: :cascade do |t|
    t.bigint "software_id", null: false
    t.bigint "visualization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["software_id"], name: "index_visualization_softwares_on_software_id"
    t.index ["visualization_id"], name: "index_visualization_softwares_on_visualization_id"
  end

  create_table "visualizations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.date "creation_date"
    t.integer "scale"
    t.text "sources"
    t.string "geographic_coverage"
    t.string "projection"
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "challenge_id"
    t.index ["category"], name: "index_visualizations_on_category"
    t.index ["challenge_id"], name: "index_visualizations_on_challenge_id"
    t.index ["creation_date"], name: "index_visualizations_on_creation_date"
    t.index ["description"], name: "index_visualizations_on_description"
    t.index ["geographic_coverage"], name: "index_visualizations_on_geographic_coverage"
    t.index ["projection"], name: "index_visualizations_on_projection"
    t.index ["scale"], name: "index_visualizations_on_scale"
    t.index ["sources"], name: "index_visualizations_on_sources"
    t.index ["title"], name: "index_visualizations_on_title"
    t.index ["user_id", "created_at"], name: "index_visualizations_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_visualizations_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "billing_plan_versions", "billing_plans"
  add_foreign_key "billing_subscriptions", "billing_plan_versions"
  add_foreign_key "billing_subscriptions", "users"
  add_foreign_key "challenge_discussions", "challenges"
  add_foreign_key "challenge_discussions", "users"
  add_foreign_key "feedbacks", "users"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "user_challenges", "challenges"
  add_foreign_key "user_challenges", "users"
  add_foreign_key "user_softwares", "softwares"
  add_foreign_key "user_softwares", "users"
  add_foreign_key "visualization_comments", "users"
  add_foreign_key "visualization_comments", "visualizations"
  add_foreign_key "visualization_softwares", "softwares"
  add_foreign_key "visualization_softwares", "visualizations"
  add_foreign_key "visualizations", "challenges"
  add_foreign_key "visualizations", "users"
end
