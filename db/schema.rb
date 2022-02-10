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

ActiveRecord::Schema.define(version: 2022_02_10_105426) do

  create_table "access_rights", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.string "access_to_email", limit: 30
    t.integer "access_to_investor_id"
    t.string "access_type", limit: 15
    t.string "metadata"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "entity_id", null: false
    t.string "access_to_category", limit: 20
    t.datetime "deleted_at", precision: 6
    t.index ["deleted_at"], name: "index_access_rights_on_deleted_at"
    t.index ["entity_id"], name: "index_access_rights_on_entity_id"
    t.index ["owner_type", "owner_id"], name: "index_access_rights_on_owner"
  end

  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entity_id"
    t.index ["entity_id"], name: "index_activities_on_entity_id"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable"
  end

  create_table "admin_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "deal_activities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "deal_id", null: false
    t.bigint "deal_investor_id"
    t.date "by_date"
    t.string "status", limit: 20
    t.boolean "completed"
    t.integer "entity_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title"
    t.text "details"
    t.integer "sequence"
    t.integer "days"
    t.datetime "deleted_at", precision: 6
    t.index ["deal_id"], name: "index_deal_activities_on_deal_id"
    t.index ["deal_investor_id"], name: "index_deal_activities_on_deal_investor_id"
    t.index ["deleted_at"], name: "index_deal_activities_on_deleted_at"
    t.index ["entity_id"], name: "index_deal_activities_on_entity_id"
  end

  create_table "deal_docs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "deal_id", null: false
    t.bigint "deal_investor_id"
    t.bigint "deal_activity_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.bigint "file_file_size"
    t.datetime "file_updated_at", precision: 6
    t.datetime "deleted_at", precision: 6
    t.index ["deal_activity_id"], name: "index_deal_docs_on_deal_activity_id"
    t.index ["deal_id"], name: "index_deal_docs_on_deal_id"
    t.index ["deal_investor_id"], name: "index_deal_docs_on_deal_investor_id"
    t.index ["deleted_at"], name: "index_deal_docs_on_deleted_at"
    t.index ["user_id"], name: "index_deal_docs_on_user_id"
  end

  create_table "deal_investors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "deal_id", null: false
    t.bigint "investor_id", null: false
    t.string "status", limit: 20
    t.decimal "primary_amount", precision: 10
    t.decimal "secondary_investment", precision: 10
    t.bigint "entity_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "investor_entity_id"
    t.datetime "deleted_at", precision: 6
    t.index ["deal_id"], name: "index_deal_investors_on_deal_id"
    t.index ["deleted_at"], name: "index_deal_investors_on_deleted_at"
    t.index ["entity_id"], name: "index_deal_investors_on_entity_id"
    t.index ["investor_entity_id"], name: "index_deal_investors_on_investor_entity_id"
    t.index ["investor_id"], name: "index_deal_investors_on_investor_id"
  end

  create_table "deal_messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "deal_investor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_task", default: false
    t.boolean "task_done", default: false
    t.datetime "deleted_at", precision: 6
    t.index ["deal_investor_id"], name: "index_deal_messages_on_deal_investor_id"
    t.index ["deleted_at"], name: "index_deal_messages_on_deleted_at"
    t.index ["user_id"], name: "index_deal_messages_on_user_id"
  end

  create_table "deals", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "name", limit: 100
    t.decimal "amount", precision: 10
    t.string "status", limit: 20
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "activity_list"
    t.date "start_date"
    t.date "end_date"
    t.datetime "deleted_at", precision: 6
    t.index ["deleted_at"], name: "index_deals_on_deleted_at"
    t.index ["entity_id"], name: "index_deals_on_entity_id"
  end

  create_table "documents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "visible_to", default: "--- []\n"
    t.string "text", default: "--- []\n"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.bigint "file_file_size"
    t.datetime "file_updated_at", precision: 6
    t.bigint "entity_id", null: false
    t.datetime "deleted_at", precision: 6
    t.index ["deleted_at"], name: "index_documents_on_deleted_at"
    t.index ["entity_id"], name: "index_documents_on_entity_id"
  end

  create_table "entities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "category", limit: 100
    t.date "founded"
    t.float "funding_amount"
    t.string "funding_unit", limit: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "logo_url"
    t.boolean "active", default: true
    t.string "entity_type", limit: 15
    t.integer "created_by"
    t.string "investor_categories"
    t.string "investment_types"
    t.string "instrument_types"
    t.string "s3_bucket"
    t.datetime "deleted_at", precision: 6
    t.index ["deleted_at"], name: "index_entities_on_deleted_at"
  end

  create_table "investments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "investment_type", limit: 20
    t.integer "investor_id"
    t.string "investor_type", limit: 20
    t.integer "investee_entity_id"
    t.string "status", limit: 20
    t.string "investment_instrument", limit: 50
    t.integer "quantity"
    t.decimal "initial_value", precision: 20
    t.decimal "current_value", precision: 20
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "category", limit: 25
    t.datetime "deleted_at", precision: 6
    t.decimal "percentage_holding", precision: 5, scale: 2
    t.index ["deleted_at"], name: "index_investments_on_deleted_at"
    t.index ["investee_entity_id"], name: "index_investments_on_investee_entity_id"
    t.index ["investor_id", "investor_type"], name: "index_investments_on_investor"
  end

  create_table "investors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "investor_entity_id"
    t.integer "investee_entity_id"
    t.string "category", limit: 50
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "investor_name"
    t.datetime "deleted_at", precision: 6
    t.index ["deleted_at"], name: "index_investors_on_deleted_at"
    t.index ["investee_entity_id"], name: "index_investors_on_investee_entity_id"
    t.index ["investor_entity_id"], name: "index_investors_on_investor_entity_id"
  end

  create_table "notes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "details"
    t.integer "entity_id"
    t.integer "user_id"
    t.integer "investor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at", precision: 6
    t.index ["deleted_at"], name: "index_notes_on_deleted_at"
    t.index ["entity_id"], name: "index_notes_on_entity_id"
    t.index ["investor_id"], name: "index_notes_on_investor_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at", precision: 6
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "first_name", limit: 80
    t.string "last_name", limit: 80
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.string "phone", limit: 20
    t.boolean "active", default: true
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: 6
    t.datetime "confirmation_sent_at", precision: 6
    t.integer "entity_id"
    t.datetime "deleted_at", precision: 6
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["entity_id"], name: "index_users_on_entity_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false, :limit=>191}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at", precision: 6
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "access_rights", "entities"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "deal_activities", "deal_investors"
  add_foreign_key "deal_activities", "deals"
  add_foreign_key "deal_docs", "deal_activities"
  add_foreign_key "deal_docs", "deal_investors"
  add_foreign_key "deal_docs", "deals"
  add_foreign_key "deal_docs", "users"
  add_foreign_key "deal_investors", "deals"
  add_foreign_key "deal_investors", "entities"
  add_foreign_key "deal_investors", "investors"
  add_foreign_key "deal_messages", "deal_investors"
  add_foreign_key "deal_messages", "users"
  add_foreign_key "deals", "entities"
end
