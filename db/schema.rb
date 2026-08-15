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

ActiveRecord::Schema[8.1].define(version: 2026_08_15_212025) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.uuid "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "posting_application_id", null: false
    t.uuid "question_id", null: false
    t.datetime "updated_at", null: false
    t.jsonb "value"
    t.index ["posting_application_id", "question_id"], name: "index_answers_on_posting_application_id_and_question_id", unique: true
    t.index ["posting_application_id"], name: "index_answers_on_posting_application_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "configurations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "org_name"
    t.datetime "updated_at", null: false
  end

  create_table "job_postings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "department"
    t.text "description"
    t.string "slug"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_job_postings_on_slug", unique: true
  end

  create_table "permissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "key"
    t.datetime "updated_at", null: false
  end

  create_table "personnel_people", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "department"
    t.date "end_date"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.text "notes"
    t.string "position"
    t.date "start_date"
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.index ["user_id"], name: "index_personnel_people_on_user_id"
  end

  create_table "posting_applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "job_posting_id", null: false
    t.string "status", default: "in_progress", null: false
    t.datetime "submitted_at"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["job_posting_id"], name: "index_posting_applications_on_job_posting_id"
    t.index ["user_id", "job_posting_id"], name: "index_posting_applications_on_user_id_and_job_posting_id", unique: true
    t.index ["user_id"], name: "index_posting_applications_on_user_id"
  end

  create_table "questions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "label"
    t.text "options"
    t.integer "position"
    t.string "question_type"
    t.boolean "required"
    t.uuid "section_id", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_questions_on_section_id"
  end

  create_table "role_permissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "permission_id", null: false
    t.uuid "role_id", null: false
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id", "permission_id"], name: "index_role_permissions_on_role_id_and_permission_id", unique: true
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "sections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "job_posting_id", null: false
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["job_posting_id"], name: "index_sections_on_job_posting_id"
  end

  create_table "user_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "role_id", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_user_roles_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workspace_deliverables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.uuid "feature_id", null: false
    t.uuid "milestone_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id"], name: "index_workspace_deliverables_on_feature_id"
    t.index ["milestone_id"], name: "index_workspace_deliverables_on_milestone_id"
  end

  create_table "workspace_features", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.uuid "project_id", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_workspace_features_on_project_id"
  end

  create_table "workspace_milestones", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "locked", default: false, null: false
    t.string "name", null: false
    t.uuid "project_id", null: false
    t.date "target_date"
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_workspace_milestones_on_project_id"
  end

  create_table "workspace_projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workspace_submissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "notes"
    t.uuid "submitted_by_id", null: false
    t.datetime "updated_at", null: false
    t.uuid "work_item_id", null: false
    t.index ["submitted_by_id"], name: "index_workspace_submissions_on_submitted_by_id"
    t.index ["work_item_id"], name: "index_workspace_submissions_on_work_item_id"
  end

  create_table "workspace_work_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "assignee_id"
    t.boolean "blocked", default: false, null: false
    t.text "blocked_reason"
    t.datetime "created_at", null: false
    t.uuid "deliverable_id", null: false
    t.text "description"
    t.date "due_date"
    t.string "status", default: "backlog", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["assignee_id"], name: "index_workspace_work_items_on_assignee_id"
    t.index ["deliverable_id"], name: "index_workspace_work_items_on_deliverable_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "posting_applications"
  add_foreign_key "answers", "questions"
  add_foreign_key "personnel_people", "users"
  add_foreign_key "posting_applications", "job_postings"
  add_foreign_key "posting_applications", "users"
  add_foreign_key "questions", "sections"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "sections", "job_postings"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "workspace_deliverables", "workspace_features", column: "feature_id"
  add_foreign_key "workspace_deliverables", "workspace_milestones", column: "milestone_id"
  add_foreign_key "workspace_features", "workspace_projects", column: "project_id"
  add_foreign_key "workspace_milestones", "workspace_projects", column: "project_id"
  add_foreign_key "workspace_submissions", "personnel_people", column: "submitted_by_id"
  add_foreign_key "workspace_submissions", "workspace_work_items", column: "work_item_id"
  add_foreign_key "workspace_work_items", "personnel_people", column: "assignee_id"
  add_foreign_key "workspace_work_items", "workspace_deliverables", column: "deliverable_id"
end
