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

ActiveRecord::Schema[7.1].define(version: 2024_06_14_140809) do
  create_table "access_rights", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.string "access_to_email", limit: 30
    t.bigint "access_to_investor_id"
    t.string "access_type", limit: 25
    t.string "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.string "access_to_category", limit: 20
    t.datetime "deleted_at"
    t.boolean "cascade", default: false
    t.bigint "user_id"
    t.bigint "permissions", default: 0, null: false
    t.boolean "notify", default: false
    t.bigint "granted_by_id"
    t.index ["access_to_investor_id"], name: "index_access_rights_on_access_to_investor_id"
    t.index ["deleted_at"], name: "index_access_rights_on_deleted_at"
    t.index ["entity_id"], name: "index_access_rights_on_entity_id"
    t.index ["granted_by_id"], name: "index_access_rights_on_granted_by_id"
    t.index ["owner_type", "owner_id"], name: "index_access_rights_on_owner"
    t.index ["user_id"], name: "index_access_rights_on_user_id"
  end

  create_table "account_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "capital_commitment_id"
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "investor_id"
    t.bigint "form_type_id"
    t.string "folio_id", limit: 20
    t.date "reporting_date"
    t.string "entry_type", limit: 50
    t.string "name", limit: 125
    t.decimal "amount_cents", precision: 30, scale: 8, default: "0.0"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "explanation"
    t.boolean "cumulative", default: false
    t.string "period", limit: 25
    t.string "parent_type"
    t.bigint "parent_id"
    t.boolean "generated", default: false
    t.decimal "folio_amount_cents", precision: 30, scale: 8, default: "0.0"
    t.bigint "exchange_rate_id"
    t.string "commitment_type", limit: 10, default: "Pool"
    t.bigint "fund_formula_id"
    t.string "rule_for", limit: 10, default: "Accounting"
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.datetime "deleted_at"
    t.virtual "generated_deleted", type: :datetime, null: false, as: "ifnull(`deleted_at`,_utf8mb4'1900-01-01 00:00:00')"
    t.index ["capital_commitment_id", "name", "entry_type", "reporting_date", "cumulative", "generated_deleted"], name: "idx_account_entries_reporting_date_uniq", unique: true
    t.index ["capital_commitment_id"], name: "index_account_entries_on_capital_commitment_id"
    t.index ["deleted_at"], name: "index_account_entries_on_deleted_at"
    t.index ["entity_id"], name: "index_account_entries_on_entity_id"
    t.index ["entry_type"], name: "index_account_entries_on_entry_type"
    t.index ["exchange_rate_id"], name: "index_account_entries_on_exchange_rate_id"
    t.index ["form_type_id"], name: "index_account_entries_on_form_type_id"
    t.index ["fund_formula_id"], name: "index_account_entries_on_fund_formula_id"
    t.index ["fund_id"], name: "index_account_entries_on_fund_id"
    t.index ["investor_id"], name: "index_account_entries_on_investor_id"
    t.index ["name"], name: "index_account_entries_on_name"
    t.index ["parent_type", "parent_id"], name: "index_account_entries_on_parent"
    t.index ["reporting_date"], name: "index_account_entries_on_reporting_date"
  end

  create_table "action_mailbox_inbound_emails", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "body", size: :long
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_admin_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
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
    t.datetime "created_at", null: false
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

  create_table "adhaar_esigns", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "document_id", null: false
    t.string "esign_doc_id", limit: 100
    t.text "signed_file_url"
    t.boolean "is_signed", default: false
    t.text "esign_document_reponse"
    t.text "esign_retrieve_reponse"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_type"
    t.bigint "owner_id"
    t.index ["document_id"], name: "index_adhaar_esigns_on_document_id"
    t.index ["entity_id"], name: "index_adhaar_esigns_on_entity_id"
    t.index ["owner_type", "owner_id"], name: "index_adhaar_esigns_on_owner"
  end

  create_table "admin_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "aggregate_investments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "shareholder"
    t.bigint "investor_id", null: false
    t.integer "equity", default: 0
    t.integer "preferred", default: 0
    t.integer "options", default: 0
    t.decimal "percentage", precision: 5, scale: 2, default: "0.0"
    t.decimal "full_diluted_percentage", precision: 5, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "funding_round_id"
    t.integer "units", default: 0
    t.integer "preferred_converted_qty", default: 0
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_aggregate_investments_on_deleted_at"
    t.index ["entity_id"], name: "index_aggregate_investments_on_entity_id"
    t.index ["funding_round_id"], name: "index_aggregate_investments_on_funding_round_id"
    t.index ["investor_id"], name: "index_aggregate_investments_on_investor_id"
  end

  create_table "aggregate_portfolio_investments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "portfolio_company_id", null: false
    t.decimal "quantity", precision: 20, scale: 2, default: "0.0"
    t.decimal "fmv_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "avg_cost_cents", precision: 20, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "portfolio_company_name", limit: 100
    t.decimal "bought_quantity", precision: 20, scale: 2, default: "0.0"
    t.decimal "bought_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "sold_quantity", precision: 20, scale: 2, default: "0.0"
    t.decimal "sold_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "cost_cents", precision: 20, scale: 2, default: "0.0"
    t.string "investment_type"
    t.decimal "cost_of_sold_cents", precision: 20, scale: 2, default: "0.0"
    t.string "commitment_type", limit: 10, default: "Pool"
    t.string "investment_domicile", limit: 10
    t.datetime "deleted_at"
    t.bigint "investment_instrument_id"
    t.bigint "form_type_id"
    t.decimal "transfer_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.index ["deleted_at"], name: "index_aggregate_portfolio_investments_on_deleted_at"
    t.index ["entity_id"], name: "index_aggregate_portfolio_investments_on_entity_id"
    t.index ["form_type_id"], name: "index_aggregate_portfolio_investments_on_form_type_id"
    t.index ["fund_id"], name: "index_aggregate_portfolio_investments_on_fund_id"
    t.index ["investment_instrument_id"], name: "idx_on_investment_instrument_id_9bc45b0212"
    t.index ["portfolio_company_id"], name: "index_aggregate_portfolio_investments_on_portfolio_company_id"
  end

  create_table "allocation_runs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "user_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.boolean "fund_ratios"
    t.boolean "generate_soa"
    t.string "template_name", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rule_for", limit: 10, default: "Accounting"
    t.boolean "run_allocations", default: true
    t.index ["entity_id"], name: "index_allocation_runs_on_entity_id"
    t.index ["fund_id"], name: "index_allocation_runs_on_fund_id"
    t.index ["user_id"], name: "index_allocation_runs_on_user_id"
  end

  create_table "aml_reports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "investor_id", null: false
    t.bigint "investor_kyc_id", null: false
    t.bigint "approved_by_id"
    t.string "name"
    t.string "match_status"
    t.boolean "approved", default: false
    t.string "types"
    t.json "source_notes"
    t.json "associates"
    t.json "fields"
    t.json "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "media"
    t.datetime "approved_on"
    t.index ["approved_by_id"], name: "index_aml_reports_on_approved_by_id"
    t.index ["entity_id"], name: "index_aml_reports_on_entity_id"
    t.index ["investor_id"], name: "index_aml_reports_on_investor_id"
    t.index ["investor_kyc_id"], name: "index_aml_reports_on_investor_kyc_id"
  end

  create_table "approval_responses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "response_entity_id", null: false
    t.bigint "response_user_id"
    t.bigint "approval_id", null: false
    t.string "status", limit: 50
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "investor_id", null: false
    t.boolean "notification_sent", default: false
    t.timestamp "deleted_at"
    t.bigint "form_type_id"
    t.json "json_fields"
    t.string "owner_type"
    t.bigint "owner_id"
    t.index ["approval_id"], name: "index_approval_responses_on_approval_id"
    t.index ["deleted_at"], name: "index_approval_responses_on_deleted_at"
    t.index ["entity_id"], name: "index_approval_responses_on_entity_id"
    t.index ["form_type_id"], name: "index_approval_responses_on_form_type_id"
    t.index ["investor_id"], name: "index_approval_responses_on_investor_id"
    t.index ["owner_type", "owner_id"], name: "index_approval_responses_on_owner"
    t.index ["response_entity_id"], name: "index_approval_responses_on_response_entity_id"
    t.index ["response_user_id"], name: "index_approval_responses_on_response_user_id"
  end

  create_table "approvals", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.bigint "entity_id", null: false
    t.integer "approved_count", default: 0
    t.integer "rejected_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pending_count", default: 0
    t.boolean "approved", default: false
    t.bigint "form_type_id"
    t.date "due_date"
    t.bigint "document_folder_id"
    t.string "response_status"
    t.boolean "locked"
    t.json "json_fields"
    t.string "owner_type"
    t.bigint "owner_id"
    t.boolean "enable_approval_show_kycs", default: false
    t.boolean "response_enabled_email", default: false, null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_approvals_on_deleted_at"
    t.index ["document_folder_id"], name: "index_approvals_on_document_folder_id"
    t.index ["entity_id"], name: "index_approvals_on_entity_id"
    t.index ["form_type_id"], name: "index_approvals_on_form_type_id"
    t.index ["owner_type", "owner_id"], name: "index_approvals_on_owner"
  end

  create_table "audits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "blazer_audits", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "call_fees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 50
    t.date "start_date"
    t.date "end_date"
    t.string "notes"
    t.string "fee_type", limit: 20
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "capital_call_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["capital_call_id"], name: "index_call_fees_on_capital_call_id"
    t.index ["entity_id"], name: "index_call_fees_on_entity_id"
    t.index ["fund_id"], name: "index_call_fees_on_fund_id"
  end

  create_table "caphive_agents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.text "task"
    t.json "messages"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_caphive_agents_on_entity_id"
    t.index ["user_id"], name: "index_caphive_agents_on_user_id"
  end

  create_table "capital_calls", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.string "name"
    t.decimal "percentage_called", precision: 11, scale: 8, default: "0.0"
    t.decimal "collected_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "call_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.date "due_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "form_type_id"
    t.boolean "approved", default: false
    t.bigint "approved_by_user_id"
    t.boolean "manual_generation", default: false
    t.boolean "generate_remittances", default: true
    t.boolean "generate_remittances_verified", default: false
    t.datetime "deleted_at"
    t.date "call_date"
    t.bigint "document_folder_id"
    t.text "unit_prices"
    t.string "fund_closes"
    t.string "commitment_type", limit: 10, default: "Pool"
    t.decimal "capital_fee_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "other_fee_cents", precision: 20, scale: 2, default: "0.0"
    t.string "call_basis", limit: 40
    t.decimal "amount_to_be_called_cents", precision: 20, scale: 2, default: "0.0"
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.index ["approved_by_user_id"], name: "index_capital_calls_on_approved_by_user_id"
    t.index ["deleted_at"], name: "index_capital_calls_on_deleted_at"
    t.index ["document_folder_id"], name: "index_capital_calls_on_document_folder_id"
    t.index ["entity_id"], name: "index_capital_calls_on_entity_id"
    t.index ["form_type_id"], name: "index_capital_calls_on_form_type_id"
    t.index ["fund_id"], name: "index_capital_calls_on_fund_id"
  end

  create_table "capital_commitments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "investor_id", null: false
    t.bigint "fund_id", null: false
    t.decimal "committed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "collected_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "form_type_id"
    t.decimal "percentage", precision: 20, scale: 10, default: "0.0"
    t.bigint "ppm_number", default: 0
    t.string "investor_signature_types", limit: 20
    t.string "folio_id", limit: 20
    t.bigint "investor_signatory_id"
    t.boolean "esign_required", default: false
    t.boolean "esign_completed", default: false
    t.string "esign_provider", limit: 10
    t.string "esign_link"
    t.decimal "call_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "distribution_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.boolean "onboarding_completed", default: false
    t.datetime "deleted_at"
    t.bigint "investor_kyc_id"
    t.string "investor_name"
    t.bigint "document_folder_id"
    t.string "unit_type", limit: 25
    t.decimal "total_fund_units_quantity", precision: 20, scale: 2, default: "0.0"
    t.decimal "total_allocated_income_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "total_allocated_expense_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "total_units_premium_cents", precision: 20, scale: 2, default: "0.0"
    t.string "fund_close"
    t.string "virtual_bank_account", limit: 20
    t.string "folio_currency", limit: 5
    t.decimal "folio_committed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "folio_collected_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "folio_call_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "adjustment_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "adjustment_folio_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "orig_committed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "orig_folio_committed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "exchange_rate_id"
    t.string "commitment_type", limit: 10, default: "Pool"
    t.boolean "feeder_fund", default: false
    t.date "commitment_date"
    t.virtual "generated_deleted", type: :datetime, null: false, as: "ifnull(`deleted_at`,_utf8mb4'1900-01-01 00:00:00')"
    t.json "json_fields"
    t.string "esign_emails"
    t.bigint "import_upload_id"
    t.decimal "other_fee_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "arrear_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "arrear_folio_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.index ["deleted_at"], name: "index_capital_commitments_on_deleted_at"
    t.index ["document_folder_id"], name: "index_capital_commitments_on_document_folder_id"
    t.index ["entity_id"], name: "index_capital_commitments_on_entity_id"
    t.index ["exchange_rate_id"], name: "index_capital_commitments_on_exchange_rate_id"
    t.index ["form_type_id"], name: "index_capital_commitments_on_form_type_id"
    t.index ["fund_id", "folio_id", "generated_deleted"], name: "unique_commitment", unique: true
    t.index ["fund_id"], name: "index_capital_commitments_on_fund_id"
    t.index ["investor_id"], name: "index_capital_commitments_on_investor_id"
    t.index ["investor_kyc_id"], name: "index_capital_commitments_on_investor_kyc_id"
    t.index ["investor_signatory_id"], name: "index_capital_commitments_on_investor_signatory_id"
  end

  create_table "capital_distribution_payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "fund_id", null: false
    t.bigint "entity_id", null: false
    t.bigint "capital_distribution_id", null: false
    t.bigint "investor_id", null: false
    t.bigint "form_type_id"
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.date "payment_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed", default: false
    t.decimal "percentage", precision: 12, scale: 8, default: "0.0"
    t.string "folio_id", limit: 20
    t.bigint "capital_commitment_id"
    t.datetime "deleted_at"
    t.string "investor_name"
    t.decimal "units_quantity", precision: 20, scale: 2, default: "0.0"
    t.bigint "document_folder_id"
    t.decimal "cost_of_investment_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "folio_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "exchange_rate_id"
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.index ["capital_commitment_id"], name: "index_capital_distribution_payments_on_capital_commitment_id"
    t.index ["capital_distribution_id"], name: "index_capital_distribution_payments_on_capital_distribution_id"
    t.index ["deleted_at"], name: "index_capital_distribution_payments_on_deleted_at"
    t.index ["document_folder_id"], name: "index_capital_distribution_payments_on_document_folder_id"
    t.index ["entity_id"], name: "index_capital_distribution_payments_on_entity_id"
    t.index ["exchange_rate_id"], name: "index_capital_distribution_payments_on_exchange_rate_id"
    t.index ["form_type_id"], name: "index_capital_distribution_payments_on_form_type_id"
    t.index ["fund_id"], name: "index_capital_distribution_payments_on_fund_id"
    t.index ["investor_id"], name: "index_capital_distribution_payments_on_investor_id"
  end

  create_table "capital_distributions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "fund_id", null: false
    t.bigint "entity_id", null: false
    t.bigint "form_type_id"
    t.decimal "gross_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "carry_cents", precision: 20, scale: 2, default: "0.0"
    t.date "distribution_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.boolean "completed", default: false
    t.decimal "distribution_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "net_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.boolean "approved", default: false
    t.bigint "approved_by_user_id"
    t.boolean "manual_generation", default: false
    t.boolean "generate_payments", default: true
    t.boolean "generate_payments_paid", default: false
    t.datetime "deleted_at"
    t.decimal "fee_cents", precision: 20, scale: 2, default: "0.0"
    t.text "unit_prices"
    t.decimal "reinvestment_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "document_folder_id"
    t.decimal "cost_of_investment_cents", precision: 20, scale: 2, default: "0.0"
    t.string "commitment_type", limit: 10, default: "Pool"
    t.bigint "capital_commitment_id"
    t.integer "distribution_on", default: 0
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.index ["approved_by_user_id"], name: "index_capital_distributions_on_approved_by_user_id"
    t.index ["capital_commitment_id"], name: "index_capital_distributions_on_capital_commitment_id"
    t.index ["deleted_at"], name: "index_capital_distributions_on_deleted_at"
    t.index ["document_folder_id"], name: "index_capital_distributions_on_document_folder_id"
    t.index ["entity_id"], name: "index_capital_distributions_on_entity_id"
    t.index ["form_type_id"], name: "index_capital_distributions_on_form_type_id"
    t.index ["fund_id"], name: "index_capital_distributions_on_fund_id"
  end

  create_table "capital_remittance_payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "fund_id", null: false
    t.bigint "capital_remittance_id", null: false
    t.bigint "entity_id", null: false
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.date "payment_date"
    t.text "payment_proof_data"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference_no", limit: 40
    t.decimal "folio_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "exchange_rate_id"
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.index ["capital_remittance_id"], name: "index_capital_remittance_payments_on_capital_remittance_id"
    t.index ["entity_id"], name: "index_capital_remittance_payments_on_entity_id"
    t.index ["exchange_rate_id"], name: "index_capital_remittance_payments_on_exchange_rate_id"
    t.index ["fund_id"], name: "index_capital_remittance_payments_on_fund_id"
  end

  create_table "capital_remittances", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "capital_call_id", null: false
    t.bigint "investor_id", null: false
    t.string "status", limit: 10
    t.decimal "call_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "collected_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "capital_commitment_id"
    t.bigint "form_type_id"
    t.boolean "verified", default: false
    t.text "payment_proof_data"
    t.string "folio_id", limit: 20
    t.date "payment_date"
    t.datetime "deleted_at"
    t.string "investor_name"
    t.bigint "document_folder_id"
    t.decimal "units_quantity", precision: 20, scale: 2, default: "0.0"
    t.boolean "notification_sent", default: false
    t.decimal "committed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "folio_call_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "folio_collected_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "folio_committed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "exchange_rate_id"
    t.string "created_by", limit: 10
    t.decimal "capital_fee_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "other_fee_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "folio_capital_fee_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "folio_other_fee_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "computed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "percentage", precision: 12, scale: 8, default: "0.0"
    t.date "remittance_date"
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.decimal "arrear_folio_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "arrear_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.index ["capital_call_id"], name: "index_capital_remittances_on_capital_call_id"
    t.index ["capital_commitment_id"], name: "index_capital_remittances_on_capital_commitment_id"
    t.index ["deleted_at"], name: "index_capital_remittances_on_deleted_at"
    t.index ["document_folder_id"], name: "index_capital_remittances_on_document_folder_id"
    t.index ["entity_id"], name: "index_capital_remittances_on_entity_id"
    t.index ["exchange_rate_id"], name: "index_capital_remittances_on_exchange_rate_id"
    t.index ["form_type_id"], name: "index_capital_remittances_on_form_type_id"
    t.index ["fund_id"], name: "index_capital_remittances_on_fund_id"
    t.index ["investor_id"], name: "index_capital_remittances_on_investor_id"
  end

  create_table "ci_profiles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id"
    t.string "title"
    t.string "geography", limit: 50
    t.string "stage", limit: 50
    t.string "sector", limit: 50
    t.decimal "fund_size_cents", precision: 20, scale: 2
    t.decimal "min_investment_cents", precision: 20, scale: 2
    t.string "status"
    t.string "currency", limit: 3
    t.text "details"
    t.bigint "form_type_id"
    t.text "properties"
    t.text "track_record"
    t.bigint "document_folder_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_ci_profiles_on_deleted_at"
    t.index ["entity_id"], name: "index_ci_profiles_on_entity_id"
    t.index ["fund_id"], name: "index_ci_profiles_on_fund_id"
  end

  create_table "ci_track_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "name", limit: 50
    t.decimal "value", precision: 20, scale: 4
    t.string "prefix", limit: 5
    t.string "suffix", limit: 5
    t.string "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "investment_opportunity_id"
    t.index ["entity_id"], name: "index_ci_track_records_on_entity_id"
    t.index ["investment_opportunity_id"], name: "index_ci_track_records_on_investment_opportunity_id"
  end

  create_table "ci_widgets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "title"
    t.text "details"
    t.string "url"
    t.string "image_placement", limit: 6, default: "Left"
    t.text "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "investment_opportunity_id"
    t.index ["entity_id"], name: "index_ci_widgets_on_entity_id"
    t.index ["investment_opportunity_id"], name: "index_ci_widgets_on_investment_opportunity_id"
  end

  create_table "commitment_adjustments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "capital_commitment_id", null: false
    t.decimal "pre_adjustment_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "folio_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "post_adjustment_cents", precision: 20, scale: 2, default: "0.0"
    t.text "reason"
    t.date "as_of"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exchange_rate_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "adjustment_type", limit: 20, default: "Top Up", null: false
    t.datetime "deleted_at"
    t.index ["capital_commitment_id"], name: "index_commitment_adjustments_on_capital_commitment_id"
    t.index ["deleted_at"], name: "index_commitment_adjustments_on_deleted_at"
    t.index ["entity_id"], name: "index_commitment_adjustments_on_entity_id"
    t.index ["exchange_rate_id"], name: "index_commitment_adjustments_on_exchange_rate_id"
    t.index ["fund_id"], name: "index_commitment_adjustments_on_fund_id"
    t.index ["owner_type", "owner_id"], name: "index_commitment_adjustments_on_owner"
  end

  create_table "custom_notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.string "whatsapp"
    t.bigint "entity_id", null: false
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "for_type", limit: 100
    t.boolean "show_details", default: false
    t.boolean "password_protect_attachment", default: false
    t.string "attachment_password"
    t.boolean "no_link", default: false
    t.string "email_method", limit: 100
    t.datetime "deleted_at"
    t.boolean "enabled", default: true
    t.bigint "document_folder_id"
    t.boolean "is_erb", default: false
    t.index ["deleted_at"], name: "index_custom_notifications_on_deleted_at"
    t.index ["document_folder_id"], name: "index_custom_notifications_on_document_folder_id"
    t.index ["entity_id"], name: "index_custom_notifications_on_entity_id"
    t.index ["owner_type", "owner_id"], name: "index_custom_notifications_on_owner"
  end

  create_table "deal_activities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "deal_id", null: false
    t.bigint "deal_investor_id"
    t.date "by_date"
    t.string "status_temp", limit: 20
    t.string "completed", limit: 5, default: "No"
    t.integer "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "details"
    t.integer "sequence"
    t.integer "days"
    t.datetime "deleted_at"
    t.integer "template_id"
    t.boolean "docs_required_for_completion", default: false
    t.boolean "details_required_for_na", default: false
    t.bigint "document_folder_id"
    t.string "status", default: "incomplete"
    t.index ["deal_id"], name: "index_deal_activities_on_deal_id"
    t.index ["deal_investor_id"], name: "index_deal_activities_on_deal_investor_id"
    t.index ["deleted_at"], name: "index_deal_activities_on_deleted_at"
    t.index ["document_folder_id"], name: "index_deal_activities_on_document_folder_id"
    t.index ["entity_id"], name: "index_deal_activities_on_entity_id"
  end

  create_table "deal_docs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "deal_id", null: false
    t.bigint "deal_investor_id"
    t.bigint "deal_activity_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.bigint "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "deleted_at"
    t.integer "impressions_count", default: 0
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
    t.decimal "primary_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "secondary_investment_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "investor_entity_id"
    t.datetime "deleted_at"
    t.integer "impressions_count"
    t.integer "unread_messages_investor", default: 0
    t.integer "unread_messages_investee", default: 0
    t.integer "todays_messages_investor", default: 0
    t.integer "todays_messages_investee", default: 0
    t.decimal "pre_money_valuation_cents", precision: 20, scale: 2, default: "0.0"
    t.string "company_advisor", limit: 100
    t.string "investor_advisor", limit: 100
    t.string "investor_name"
    t.string "tier", limit: 20
    t.decimal "fee_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "document_folder_id"
    t.bigint "deal_activity_id"
    t.decimal "total_amount_cents", precision: 20, scale: 2
    t.string "tags"
    t.string "deal_lead"
    t.string "source"
    t.text "notes"
    t.json "json_fields"
    t.bigint "form_type_id"
    t.index ["deal_activity_id"], name: "index_deal_investors_on_deal_activity_id"
    t.index ["deal_id"], name: "index_deal_investors_on_deal_id"
    t.index ["deleted_at"], name: "index_deal_investors_on_deleted_at"
    t.index ["document_folder_id"], name: "index_deal_investors_on_document_folder_id"
    t.index ["entity_id"], name: "index_deal_investors_on_entity_id"
    t.index ["form_type_id"], name: "index_deal_investors_on_form_type_id"
    t.index ["investor_entity_id"], name: "index_deal_investors_on_investor_entity_id"
    t.index ["investor_id", "deal_id"], name: "index_deal_investors_on_investor_id_and_deal_id", unique: true
    t.index ["investor_id"], name: "index_deal_investors_on_investor_id"
  end

  create_table "deals", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "name"
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.string "status", limit: 20
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "activity_list"
    t.date "start_date"
    t.date "end_date"
    t.datetime "deleted_at"
    t.integer "impressions_count", default: 0
    t.boolean "archived", default: false
    t.string "currency", limit: 10
    t.string "units", limit: 15
    t.bigint "form_type_id"
    t.bigint "clone_from_id"
    t.bigint "data_room_folder_id"
    t.bigint "document_folder_id"
    t.json "json_fields"
    t.string "investment_opportunity_link"
    t.json "card_view_attrs"
    t.string "tags", limit: 50
    t.index ["clone_from_id"], name: "index_deals_on_clone_from_id"
    t.index ["data_room_folder_id"], name: "index_deals_on_data_room_folder_id"
    t.index ["deleted_at"], name: "index_deals_on_deleted_at"
    t.index ["document_folder_id"], name: "index_deals_on_document_folder_id"
    t.index ["entity_id"], name: "index_deals_on_entity_id"
    t.index ["form_type_id"], name: "index_deals_on_form_type_id"
  end

  create_table "devise_api_tokens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "resource_owner_type", null: false
    t.bigint "resource_owner_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token"
    t.integer "expires_in", null: false
    t.datetime "revoked_at"
    t.string "previous_refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_devise_api_tokens_on_access_token"
    t.index ["previous_refresh_token"], name: "index_devise_api_tokens_on_previous_refresh_token"
    t.index ["refresh_token"], name: "index_devise_api_tokens_on_refresh_token"
    t.index ["resource_owner_type", "resource_owner_id"], name: "index_devise_api_tokens_on_resource_owner"
  end

  create_table "doc_questions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "tags", limit: 100
    t.text "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_doc_questions_on_entity_id"
  end

  create_table "document_chats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "document_id"
    t.json "llm_info"
    t.json "qna"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["document_id"], name: "index_document_chats_on_document_id"
    t.index ["entity_id"], name: "index_document_chats_on_entity_id"
    t.index ["user_id"], name: "index_document_chats_on_user_id"
  end

  create_table "documents", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "visible_to", default: "--- []\n"
    t.string "text", default: "--- []\n"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.datetime "deleted_at"
    t.bigint "folder_id", null: false
    t.integer "impressions_count", default: 0
    t.bigint "form_type_id"
    t.boolean "download", default: false
    t.boolean "printing", default: false
    t.text "file_data"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "owner_tag", limit: 40
    t.boolean "orignal", default: false
    t.bigint "user_id", null: false
    t.boolean "signature_enabled", default: false, null: false
    t.bigint "signed_by_id"
    t.bigint "from_template_id"
    t.boolean "signed_by_accept", default: false
    t.boolean "adhaar_esign_enabled", default: false
    t.boolean "adhaar_esign_completed", default: false
    t.string "signature_type", limit: 100
    t.boolean "locked", default: false, null: false
    t.boolean "public_visibility", default: false
    t.string "tag_list", limit: 120
    t.boolean "template", default: false, null: false
    t.boolean "send_email", null: false
    t.boolean "sent_for_esign", default: false, null: false
    t.string "provider_doc_id"
    t.string "esign_status", default: "", null: false
    t.string "display_on_page", limit: 6
    t.bigint "approved_by_id"
    t.boolean "approved", default: false, null: false
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.datetime "sent_for_esign_date"
    t.index ["approved_by_id"], name: "index_documents_on_approved_by_id"
    t.index ["deleted_at"], name: "index_documents_on_deleted_at"
    t.index ["entity_id"], name: "index_documents_on_entity_id"
    t.index ["folder_id"], name: "index_documents_on_folder_id"
    t.index ["form_type_id"], name: "index_documents_on_form_type_id"
    t.index ["owner_type", "owner_id"], name: "index_documents_on_owner"
    t.index ["signed_by_id"], name: "index_documents_on_signed_by_id"
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "e_signatures", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "user_id"
    t.string "label", limit: 30
    t.string "signature_type", limit: 10
    t.integer "position"
    t.text "notes"
    t.string "status", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "api_updates"
    t.string "signer_id", limit: 20
    t.string "email", limit: 60
    t.bigint "document_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_e_signatures_on_deleted_at"
    t.index ["document_id"], name: "index_e_signatures_on_document_id"
    t.index ["entity_id"], name: "index_e_signatures_on_entity_id"
    t.index ["user_id"], name: "index_e_signatures_on_user_id"
  end

  create_table "emailbutler_messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "mailer", null: false
    t.string "action", null: false
    t.json "params", null: false
    t.string "send_to"
    t.integer "status", default: 0, null: false
    t.datetime "timestamp"
    t.integer "lock_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_emailbutler_messages_on_uuid", unique: true
  end

  create_table "entities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "category"
    t.date "founded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "logo_url"
    t.boolean "active", default: true
    t.string "entity_type", limit: 25
    t.integer "created_by"
    t.string "investor_categories"
    t.string "instrument_types"
    t.string "s3_bucket"
    t.datetime "deleted_at"
    t.integer "investors_count", default: 0, null: false
    t.integer "investments_count", default: 0, null: false
    t.integer "deals_count", default: 0, null: false
    t.integer "deal_investors_count", default: 0, null: false
    t.integer "documents_count", default: 0, null: false
    t.decimal "total_investments", precision: 20, default: "0"
    t.boolean "is_holdings_entity", default: false
    t.integer "parent_entity_id"
    t.string "currency", limit: 10
    t.integer "tasks_count"
    t.integer "pending_accesses_count"
    t.integer "active_deal_id"
    t.integer "equity", default: 0
    t.integer "preferred", default: 0
    t.integer "options", default: 0
    t.boolean "percentage_in_progress", default: false
    t.decimal "per_share_value_cents", precision: 15, scale: 2, default: "0.0"
    t.integer "units", default: 0
    t.string "sub_domain"
    t.text "logo_data"
    t.boolean "activity_docs_required_for_completion", default: false
    t.boolean "activity_details_required_for_na", default: false
    t.string "pan", limit: 40
    t.integer "permissions"
    t.string "primary_email"
    t.integer "customization_flags", default: 0
    t.index ["deleted_at"], name: "index_entities_on_deleted_at"
    t.index ["name"], name: "index_entities_on_name"
    t.index ["pan"], name: "index_entities_on_pan"
    t.index ["parent_entity_id"], name: "index_entities_on_parent_entity_id"
    t.index ["sub_domain"], name: "index_entities_on_sub_domain", unique: true
  end

  create_table "entity_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "pan_verification"
    t.boolean "bank_verification"
    t.boolean "trial"
    t.date "trial_end_date"
    t.string "valuation_math"
    t.integer "snapshot_frequency_months"
    t.date "last_snapshot_on"
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "sandbox"
    t.string "sandbox_emails"
    t.string "from_email", limit: 100
    t.string "entity_bcc"
    t.string "reply_to"
    t.string "cc"
    t.string "individual_kyc_doc_list"
    t.string "non_individual_kyc_doc_list"
    t.boolean "aml_enabled", default: false
    t.string "fi_code"
    t.string "sandbox_numbers"
    t.string "kpi_doc_list"
    t.text "kyc_docs_note"
    t.string "stamp_paper_tags"
    t.string "call_basis"
    t.integer "custom_flags", default: 0
    t.integer "email_delay_seconds", default: 0
    t.boolean "ckyc_enabled", default: false
    t.boolean "kra_enabled", default: false
    t.boolean "ckyc_kra_enabled"
    t.string "kpi_reminder_frequency", limit: 10
    t.integer "kpi_reminder_before"
    t.text "custom_dashboards"
    t.text "whatsapp_token"
    t.string "whatsapp_endpoint"
    t.json "whatsapp_templates"
    t.datetime "deleted_at"
    t.string "digio_client_id"
    t.string "digio_client_secret"
    t.datetime "digio_cutover_date"
    t.string "append_to_commitment_agreement"
    t.string "regulatory_env", limit: 20, default: "SEBI"
    t.json "kanban_steps"
    t.index ["deleted_at"], name: "index_entity_settings_on_deleted_at"
    t.index ["entity_id"], name: "index_entity_settings_on_entity_id"
  end

  create_table "esigns", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "user_id", null: false
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.integer "sequence_no"
    t.string "link"
    t.text "reason"
    t.string "status", limit: 100
    t.string "signature_type", limit: 10
    t.string "string", limit: 10
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "document_id"
    t.index ["document_id"], name: "index_esigns_on_document_id"
    t.index ["entity_id"], name: "index_esigns_on_entity_id"
    t.index ["owner_type", "owner_id"], name: "index_esigns_on_owner"
    t.index ["user_id"], name: "index_esigns_on_user_id"
  end

  create_table "exception_tracks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "body", size: :medium
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "excercises", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "holding_id", null: false
    t.bigint "user_id", null: false
    t.bigint "option_pool_id", null: false
    t.integer "quantity", default: 0
    t.decimal "price_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "tax_cents", precision: 20, scale: 2, default: "0.0"
    t.boolean "approved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "tax_rate", precision: 5, scale: 2, default: "0.0"
    t.date "approved_on"
    t.text "payment_proof_data"
    t.datetime "deleted_at"
    t.bigint "document_folder_id"
    t.boolean "cashless"
    t.integer "shares_to_sell"
    t.integer "shares_to_allot"
    t.json "json_fields"
    t.index ["deleted_at"], name: "index_excercises_on_deleted_at"
    t.index ["document_folder_id"], name: "index_excercises_on_document_folder_id"
    t.index ["entity_id"], name: "index_excercises_on_entity_id"
    t.index ["holding_id"], name: "index_excercises_on_holding_id"
    t.index ["option_pool_id"], name: "index_excercises_on_option_pool_id"
    t.index ["user_id"], name: "index_excercises_on_user_id"
  end

  create_table "exchange_rates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "from", limit: 5
    t.string "to", limit: 5
    t.decimal "rate", precision: 20, scale: 8, default: "0.0"
    t.decimal "decimal", precision: 20, scale: 8, default: "0.0"
    t.boolean "latest", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "as_of"
    t.text "notes"
    t.bigint "document_folder_id"
    t.bigint "import_upload_id"
    t.index ["document_folder_id"], name: "index_exchange_rates_on_document_folder_id"
    t.index ["entity_id"], name: "index_exchange_rates_on_entity_id"
    t.index ["import_upload_id"], name: "index_exchange_rates_on_import_upload_id"
  end

  create_table "expression_of_interests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "user_id", null: false
    t.bigint "eoi_entity_id", null: false
    t.bigint "investment_opportunity_id", null: false
    t.decimal "amount_cents", precision: 15, scale: 2, default: "0.0"
    t.boolean "approved", default: false
    t.boolean "verified", default: false
    t.decimal "allocation_percentage", precision: 5, scale: 2, default: "0.0"
    t.decimal "allocation_amount_cents", precision: 15, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.bigint "investor_id", null: false
    t.boolean "esign_required", default: false
    t.boolean "esign_completed", default: false
    t.bigint "investor_signatory_id"
    t.bigint "document_folder_id"
    t.json "json_fields"
    t.bigint "investor_kyc_id"
    t.string "investor_name", limit: 100
    t.index ["document_folder_id"], name: "index_expression_of_interests_on_document_folder_id"
    t.index ["entity_id"], name: "index_expression_of_interests_on_entity_id"
    t.index ["eoi_entity_id"], name: "index_expression_of_interests_on_eoi_entity_id"
    t.index ["investment_opportunity_id"], name: "index_expression_of_interests_on_investment_opportunity_id"
    t.index ["investor_id"], name: "index_expression_of_interests_on_investor_id"
    t.index ["investor_kyc_id"], name: "index_expression_of_interests_on_investor_kyc_id"
    t.index ["investor_signatory_id"], name: "index_expression_of_interests_on_investor_signatory_id"
    t.index ["user_id"], name: "index_expression_of_interests_on_user_id"
  end

  create_table "favorites", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "favoritable_type", null: false
    t.bigint "favoritable_id", null: false
    t.string "favoritor_type", null: false
    t.bigint "favoritor_id", null: false
    t.string "scope", default: "favorite", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked"], name: "index_favorites_on_blocked"
    t.index ["favoritable_id", "favoritable_type"], name: "fk_favoritables"
    t.index ["favoritable_type", "favoritable_id", "favoritor_id", "scope"], name: "uniq_favs_and_favoritables", unique: true
    t.index ["favoritable_type", "favoritable_id"], name: "index_favorites_on_favoritable"
    t.index ["favoritor_id", "favoritor_type"], name: "fk_favorites"
    t.index ["favoritor_type", "favoritor_id"], name: "index_favorites_on_favoritor"
    t.index ["scope"], name: "index_favorites_on_scope"
  end

  create_table "fees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "advisor_name", limit: 30
    t.decimal "amount_cents", precision: 10, scale: 2, default: "0.0"
    t.string "amount_label", limit: 10
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bank_account_number", limit: 40
    t.string "ifsc_code", limit: 20
    t.index ["entity_id"], name: "index_fees_on_entity_id"
    t.index ["owner_type", "owner_id"], name: "index_fees_on_owner"
  end

  create_table "folders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "full_path"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.integer "documents_count", default: 0, null: false
    t.integer "folder_type", default: 0
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "deleted_at"
    t.string "ancestry"
    t.boolean "download", default: false
    t.boolean "printing", default: false
    t.boolean "orignal", default: false
    t.index ["ancestry"], name: "index_folders_on_ancestry"
    t.index ["deleted_at"], name: "index_folders_on_deleted_at"
    t.index ["entity_id"], name: "index_folders_on_entity_id"
    t.index ["owner_type", "owner_id"], name: "index_folders_on_owner"
  end

  create_table "form_custom_fields", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "field_type", limit: 20
    t.boolean "required"
    t.bigint "form_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "meta_data"
    t.boolean "has_attachment", default: false
    t.integer "position"
    t.text "help_text"
    t.boolean "read_only", default: false
    t.string "show_user_ids", limit: 50
    t.integer "step", default: 100
    t.string "label"
    t.string "condition_on"
    t.string "condition_criteria", limit: 10, default: "eq"
    t.string "condition_params"
    t.string "condition_state", limit: 5, default: "show"
    t.boolean "internal", default: false
    t.index ["form_type_id"], name: "index_form_custom_fields_on_form_type_id"
    t.index ["name", "form_type_id"], name: "index_form_custom_fields_on_name_and_form_type_id", unique: true
  end

  create_table "form_types", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.index ["entity_id"], name: "index_form_types_on_entity_id"
  end

  create_table "fund_formulas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "fund_id"
    t.bigint "entity_id"
    t.string "name", limit: 125
    t.text "description"
    t.text "formula"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sequence", default: 0
    t.string "rule_type", limit: 30
    t.boolean "enabled", default: false
    t.string "entry_type", limit: 50
    t.boolean "roll_up", default: true
    t.string "commitment_type", limit: 10
    t.string "rule_for", limit: 10, default: "Accounting"
    t.datetime "deleted_at"
    t.integer "import_upload_id"
    t.index ["deleted_at"], name: "index_fund_formulas_on_deleted_at"
    t.index ["entity_id"], name: "index_fund_formulas_on_entity_id"
    t.index ["fund_id"], name: "index_fund_formulas_on_fund_id"
  end

  create_table "fund_ratios", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "valuation_id"
    t.string "name"
    t.decimal "value", precision: 20, scale: 8, default: "0.0"
    t.string "display_value", limit: 50
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "capital_commitment_id"
    t.date "end_date"
    t.string "owner_type"
    t.bigint "owner_id"
    t.json "cash_flows"
    t.boolean "latest", default: false
    t.index ["capital_commitment_id"], name: "index_fund_ratios_on_capital_commitment_id"
    t.index ["deleted_at"], name: "index_fund_ratios_on_deleted_at"
    t.index ["entity_id"], name: "index_fund_ratios_on_entity_id"
    t.index ["fund_id"], name: "index_fund_ratios_on_fund_id"
    t.index ["owner_type", "owner_id"], name: "index_fund_ratios_on_owner"
    t.index ["valuation_id"], name: "index_fund_ratios_on_valuation_id"
  end

  create_table "fund_reports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "fund_id", null: false
    t.bigint "entity_id", null: false
    t.string "name", limit: 50
    t.string "name_of_scheme"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.date "end_date"
    t.index ["entity_id"], name: "index_fund_reports_on_entity_id"
    t.index ["fund_id"], name: "index_fund_reports_on_fund_id"
  end

  create_table "fund_sebi_infos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "investee_company_name"
    t.string "pan"
    t.string "type_of_investee_company"
    t.string "type_of_security"
    t.string "details_of_security"
    t.string "offshore_investment"
    t.string "isin"
    t.string "sebi_registration_number"
    t.string "is_associate"
    t.string "is_managed_or_sponsored_by_aif"
    t.string "sector"
    t.decimal "amount_invested_in_offshore", precision: 15, scale: 2
    t.bigint "fund_id", null: false
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "liquidation_scheme", limit: 3
    t.date "final_draft_ppm_date"
    t.date "sebi_ppm_communication_date"
    t.date "launch_date"
    t.date "initial_close_date"
    t.decimal "total_commitment_received", precision: 20, scale: 2
    t.date "final_close_date"
    t.integer "tenure"
    t.date "end_date_of_initial_term"
    t.string "any_extension_of_term_permitted", limit: 3
    t.date "end_date_of_extended_term"
    t.date "sebi_intimation_date_of_winding_up"
    t.string "fully_liquidated_before_liquidation_end", limit: 3
    t.date "scheme_winding_up_date"
    t.string "liquidation_scheme_launch_consent", limit: 3
    t.string "in_specie_distribution_consent", limit: 3
    t.string "mandatory_in_specie_distribution", limit: 3
    t.string "name_of_original_scheme", limit: 100
    t.string "name_of_liquidation_scheme", limit: 100
    t.date "liquidation_scheme_ppm_date"
    t.date "liquidation_scheme_launch_date"
    t.integer "liquidation_scheme_tenure"
    t.decimal "liquidation_scheme_unliquidated_investments_cost", precision: 20, scale: 2
    t.decimal "liquidation_scheme_bid_arranged_for", precision: 20, scale: 2
    t.decimal "liquidation_scheme_bid_received_value", precision: 20, scale: 2
    t.decimal "liquidation_scheme_valuer_1_value", precision: 20, scale: 2
    t.decimal "liquidation_scheme_valuer_2_value", precision: 20, scale: 2
    t.date "original_scheme_winding_up_date"
    t.date "liquidation_scheme_end_date"
    t.string "in_specie_scheme_name", limit: 100
    t.decimal "in_specie_unliquidated_investments_cost", precision: 20, scale: 2
    t.decimal "in_specie_bid_arranged_for", precision: 20, scale: 2
    t.decimal "in_specie_bid_received_value", precision: 20, scale: 2
    t.decimal "in_specie_valuer_1_value", precision: 20, scale: 2
    t.decimal "in_specie_valuer_2_value", precision: 20, scale: 2
    t.date "in_specie_distribution_date"
    t.date "in_specie_distribution_winding_up_date"
    t.decimal "mdtin_specie_unliquidated_investments_cost", precision: 20, scale: 2
    t.integer "mdtin_specie_no_of_investors_accepted"
    t.integer "mdtin_specie_no_of_investors_not_accepted"
    t.date "mdtin_specie_distribution_winding_up_date"
    t.decimal "temporary_investments_made_till_eoq", precision: 20, scale: 2
    t.decimal "cash_in_hand_till_eoq", precision: 20, scale: 2
    t.decimal "estimated_expenses", precision: 20, scale: 2
    t.index ["entity_id"], name: "index_fund_sebi_infos_on_entity_id"
    t.index ["fund_id"], name: "index_fund_sebi_infos_on_fund_id"
  end

  create_table "fund_unit_settings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.string "name", limit: 25
    t.decimal "management_fee", precision: 24, scale: 8, default: "0.0"
    t.decimal "setup_fee", precision: 24, scale: 8, default: "0.0"
    t.bigint "form_type_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "carry", precision: 24, scale: 8, default: "0.0"
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.index ["entity_id"], name: "index_fund_unit_settings_on_entity_id"
    t.index ["form_type_id"], name: "index_fund_unit_settings_on_form_type_id"
    t.index ["fund_id"], name: "index_fund_unit_settings_on_fund_id"
  end

  create_table "fund_units", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "fund_id", null: false
    t.bigint "capital_commitment_id", null: false
    t.bigint "investor_id", null: false
    t.string "unit_type", limit: 25
    t.decimal "quantity", precision: 20, scale: 2, default: "0.0"
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.decimal "price", precision: 20, scale: 2, default: "0.0"
    t.string "owner_type"
    t.bigint "owner_id"
    t.decimal "premium", precision: 20, scale: 2, default: "0.0"
    t.decimal "total_premium_cents", precision: 20, scale: 2, default: "0.0"
    t.date "issue_date"
    t.bigint "import_upload_id"
    t.index ["capital_commitment_id"], name: "index_fund_units_on_capital_commitment_id"
    t.index ["entity_id"], name: "index_fund_units_on_entity_id"
    t.index ["fund_id"], name: "index_fund_units_on_fund_id"
    t.index ["investor_id"], name: "index_fund_units_on_investor_id"
    t.index ["owner_type", "owner_id"], name: "index_fund_units_on_owner"
  end

  create_table "funding_rounds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.decimal "total_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.string "currency", limit: 5
    t.decimal "pre_money_valuation_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "post_money_valuation_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount_raised_cents", precision: 20, scale: 2, default: "0.0"
    t.string "status", default: "Open"
    t.date "closed_on"
    t.datetime "deleted_at"
    t.integer "equity", default: 0
    t.integer "preferred", default: 0
    t.integer "options", default: 0
    t.string "liq_pref_type", limit: 25
    t.string "anti_dilution", limit: 50
    t.decimal "price_cents", precision: 20, scale: 2, default: "0.0"
    t.integer "units", default: 0
    t.index ["deleted_at"], name: "index_funding_rounds_on_deleted_at"
    t.index ["entity_id"], name: "index_funding_rounds_on_entity_id"
  end

  create_table "funds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.decimal "committed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.text "details"
    t.decimal "collected_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "entity_id", null: false
    t.string "tag_list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "call_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "form_type_id"
    t.decimal "distribution_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "funding_round_id"
    t.boolean "show_valuations", default: false
    t.boolean "show_fund_ratios", default: false
    t.string "fund_signature_types", limit: 20
    t.string "investor_signature_types", limit: 20
    t.bigint "fund_signatory_id"
    t.bigint "trustee_signatory_id"
    t.string "currency", limit: 5, null: false
    t.string "commitment_doc_list", limit: 100
    t.decimal "rvpi", precision: 10, scale: 6, default: "0.0"
    t.decimal "dpi", precision: 10, scale: 6, default: "0.0"
    t.decimal "tvpi", precision: 10, scale: 6, default: "0.0"
    t.decimal "xirr", precision: 10, scale: 6, default: "0.0"
    t.decimal "moic", precision: 10, scale: 6, default: "0.0"
    t.datetime "deleted_at"
    t.bigint "data_room_folder_id"
    t.bigint "document_folder_id"
    t.string "unit_types"
    t.string "units_allocation_engine", limit: 50
    t.decimal "total_units_premium_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "co_invest_call_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "co_invest_committed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "co_invest_distribution_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "co_invest_collected_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.boolean "editable_formulas", default: false
    t.string "registration_number", limit: 20
    t.string "category", limit: 15
    t.string "sub_category", limit: 40
    t.string "sponsor_name", limit: 100
    t.string "manager_name", limit: 100
    t.string "trustee_name", limit: 100
    t.string "contact_name", limit: 100
    t.string "contact_email", limit: 100
    t.date "start_date"
    t.decimal "target_committed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "capital_fee_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "other_fee_cents", precision: 20, scale: 2, default: "0.0"
    t.json "json_fields"
    t.string "esign_emails"
    t.boolean "show_portfolios", default: false
    t.integer "capital_commitments_count", default: 0, null: false
    t.bigint "import_upload_id"
    t.date "first_close_date"
    t.date "last_close_date"
    t.index ["data_room_folder_id"], name: "index_funds_on_data_room_folder_id"
    t.index ["deleted_at"], name: "index_funds_on_deleted_at"
    t.index ["document_folder_id"], name: "index_funds_on_document_folder_id"
    t.index ["entity_id"], name: "index_funds_on_entity_id"
    t.index ["form_type_id"], name: "index_funds_on_form_type_id"
    t.index ["fund_signatory_id"], name: "index_funds_on_fund_signatory_id"
    t.index ["funding_round_id"], name: "index_funds_on_funding_round_id"
    t.index ["import_upload_id"], name: "index_funds_on_import_upload_id"
    t.index ["trustee_signatory_id"], name: "index_funds_on_trustee_signatory_id"
  end

  create_table "holding_actions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "holding_id", null: false
    t.bigint "user_id"
    t.integer "quantity"
    t.string "action", limit: 20
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_holding_actions_on_entity_id"
    t.index ["holding_id"], name: "index_holding_actions_on_holding_id"
    t.index ["user_id"], name: "index_holding_actions_on_user_id"
  end

  create_table "holding_audit_trails", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "action", limit: 100
    t.string "parent_id", limit: 50
    t.string "owner", limit: 30
    t.bigint "quantity"
    t.integer "operation"
    t.boolean "completed", default: false
    t.string "ref_type", null: false
    t.bigint "ref_id", null: false
    t.text "comments"
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_holding_audit_trails_on_entity_id"
    t.index ["ref_type", "ref_id"], name: "index_holding_audit_trails_on_ref"
  end

  create_table "holdings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "entity_id", null: false
    t.integer "quantity", default: 0
    t.decimal "value_cents", precision: 20, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "investment_instrument", limit: 100
    t.bigint "investor_id", null: false
    t.string "holding_type", limit: 15, null: false
    t.bigint "investment_id"
    t.decimal "price_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "funding_round_id", null: false
    t.bigint "option_pool_id"
    t.integer "excercised_quantity", default: 0
    t.date "grant_date"
    t.integer "vested_quantity", default: 0
    t.boolean "lapsed", default: false
    t.string "employee_id", limit: 20
    t.bigint "import_upload_id"
    t.boolean "fully_vested", default: false
    t.integer "lapsed_quantity", default: 0
    t.integer "orig_grant_quantity", default: 0
    t.integer "sold_quantity", default: 0
    t.bigint "created_from_excercise_id"
    t.boolean "cancelled", default: false
    t.boolean "approved", default: false
    t.bigint "approved_by_user_id"
    t.boolean "emp_ack", default: false
    t.date "emp_ack_date"
    t.integer "uncancelled_quantity", default: 0
    t.integer "cancelled_quantity", default: 0
    t.integer "gross_avail_to_excercise_quantity", default: 0
    t.integer "unexcercised_cancelled_quantity", default: 0
    t.integer "net_avail_to_excercise_quantity", default: 0
    t.integer "gross_unvested_quantity", default: 0
    t.integer "unvested_cancelled_quantity", default: 0
    t.integer "net_unvested_quantity", default: 0
    t.boolean "manual_vesting", default: false
    t.bigint "form_type_id"
    t.string "department", limit: 25
    t.string "option_type", limit: 12
    t.boolean "option_dilutes", default: true
    t.integer "preferred_conversion", default: 1
    t.text "grant_letter_data"
    t.datetime "deleted_at"
    t.json "json_fields"
    t.index ["created_from_excercise_id"], name: "index_holdings_on_created_from_excercise_id"
    t.index ["deleted_at"], name: "index_holdings_on_deleted_at"
    t.index ["entity_id"], name: "index_holdings_on_entity_id"
    t.index ["form_type_id"], name: "index_holdings_on_form_type_id"
    t.index ["funding_round_id"], name: "index_holdings_on_funding_round_id"
    t.index ["investment_id"], name: "index_holdings_on_investment_id"
    t.index ["investor_id"], name: "index_holdings_on_investor_id"
    t.index ["option_pool_id"], name: "index_holdings_on_option_pool_id"
    t.index ["user_id"], name: "index_holdings_on_user_id"
  end

  create_table "import_uploads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "entity_id", null: false
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.bigint "user_id", null: false
    t.string "import_type", limit: 50
    t.text "status"
    t.text "error_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_rows_count", default: 0
    t.integer "processed_row_count", default: 0
    t.integer "failed_row_count", default: 0
    t.text "import_file_data"
    t.text "import_results_data"
    t.text "custom_fields_created"
    t.index ["entity_id"], name: "index_import_uploads_on_entity_id"
    t.index ["owner_type", "owner_id"], name: "index_import_uploads_on_owner"
    t.index ["user_id"], name: "index_import_uploads_on_user_id"
  end

  create_table "impressions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", length: { params: 255 }
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: { message: 255 }
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "interests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "entity_id"
    t.integer "quantity"
    t.decimal "price", precision: 10
    t.bigint "user_id", null: false
    t.integer "interest_entity_id"
    t.bigint "secondary_sale_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "short_listed", default: false
    t.boolean "escrow_deposited", default: false
    t.decimal "final_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "allocation_quantity", default: 0
    t.decimal "allocation_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "allocation_percentage", precision: 5, scale: 2, default: "0.0"
    t.boolean "finalized", default: false
    t.string "buyer_entity_name", limit: 100
    t.text "address"
    t.string "contact_name", limit: 50
    t.string "email"
    t.string "PAN", limit: 15
    t.boolean "final_agreement", default: false
    t.bigint "form_type_id"
    t.integer "offer_quantity", default: 0
    t.boolean "verified", default: false
    t.text "comments"
    t.text "spa_data"
    t.bigint "funding_round_id"
    t.text "signature_data"
    t.string "demat", limit: 20
    t.string "city", limit: 20
    t.string "bank_account_number", limit: 40
    t.string "ifsc_code", limit: 20
    t.bigint "final_agreement_user_id"
    t.string "custom_matching_vals"
    t.datetime "deleted_at"
    t.bigint "document_folder_id"
    t.bigint "investor_id"
    t.json "json_fields"
    t.string "buyer_signatory_emails"
    t.index ["custom_matching_vals"], name: "index_interests_on_custom_matching_vals"
    t.index ["deleted_at"], name: "index_interests_on_deleted_at"
    t.index ["document_folder_id"], name: "index_interests_on_document_folder_id"
    t.index ["entity_id"], name: "index_interests_on_entity_id"
    t.index ["final_agreement_user_id"], name: "index_interests_on_final_agreement_user_id"
    t.index ["form_type_id"], name: "index_interests_on_form_type_id"
    t.index ["funding_round_id"], name: "index_interests_on_funding_round_id"
    t.index ["interest_entity_id"], name: "index_interests_on_interest_entity_id"
    t.index ["investor_id"], name: "index_interests_on_investor_id"
    t.index ["secondary_sale_id"], name: "index_interests_on_secondary_sale_id"
    t.index ["user_id"], name: "index_interests_on_user_id"
  end

  create_table "investment_instruments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "category", limit: 15
    t.string "sub_category", limit: 100
    t.string "sector", limit: 100
    t.bigint "entity_id", null: false
    t.bigint "portfolio_company_id", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "investment_domicile", limit: 15
    t.boolean "startup", default: false
    t.json "json_fields"
    t.bigint "form_type_id"
    t.string "currency", limit: 5
    t.index ["deleted_at"], name: "index_investment_instruments_on_deleted_at"
    t.index ["entity_id"], name: "index_investment_instruments_on_entity_id"
    t.index ["form_type_id"], name: "index_investment_instruments_on_form_type_id"
    t.index ["portfolio_company_id"], name: "index_investment_instruments_on_portfolio_company_id"
  end

  create_table "investment_opportunities", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "company_name", limit: 100
    t.decimal "fund_raise_amount_cents", precision: 15, scale: 2, default: "0.0"
    t.decimal "valuation_cents", precision: 15, scale: 2, default: "0.0"
    t.decimal "min_ticket_size_cents", precision: 15, scale: 2, default: "0.0"
    t.date "last_date"
    t.string "currency", limit: 10
    t.text "logo_data"
    t.text "video_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "form_type_id"
    t.decimal "eoi_amount_cents", precision: 15, scale: 2, default: "0.0"
    t.boolean "lock_allocations", default: false
    t.boolean "lock_eoi", default: false
    t.text "buyer_docs_list"
    t.bigint "funding_round_id"
    t.string "tag_list", limit: 120
    t.bigint "document_folder_id"
    t.json "json_fields"
    t.boolean "shareable", default: false
    t.index ["document_folder_id"], name: "index_investment_opportunities_on_document_folder_id"
    t.index ["entity_id"], name: "index_investment_opportunities_on_entity_id"
    t.index ["form_type_id"], name: "index_investment_opportunities_on_form_type_id"
    t.index ["funding_round_id"], name: "index_investment_opportunities_on_funding_round_id"
  end

  create_table "investment_snapshots", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "investment_type", limit: 100
    t.bigint "investor_id", null: false
    t.string "investor_type", limit: 100
    t.bigint "entity_id", null: false
    t.string "status", limit: 20
    t.string "investment_instrument", limit: 100
    t.integer "quantity", default: 0
    t.decimal "initial_value", precision: 20, scale: 2, default: "0.0"
    t.decimal "current_value", precision: 20, scale: 2, default: "0.0"
    t.string "category", limit: 100
    t.datetime "deleted_at"
    t.decimal "percentage_holding", precision: 5, scale: 2, default: "0.0"
    t.boolean "employee_holdings", default: false
    t.integer "diluted_quantity", default: 0
    t.decimal "diluted_percentage", precision: 5, scale: 2, default: "0.0"
    t.string "currency", limit: 10
    t.string "units", limit: 15
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "price_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "funding_round_id", null: false
    t.decimal "liquidation_preference", precision: 10, scale: 2
    t.string "spv", limit: 50
    t.date "investment_date"
    t.string "liq_pref_type", limit: 25
    t.string "anti_dilution", limit: 50
    t.date "as_of"
    t.string "tag", limit: 20
    t.bigint "investment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_investment_snapshots_on_entity_id"
    t.index ["funding_round_id"], name: "index_investment_snapshots_on_funding_round_id"
    t.index ["investment_id"], name: "index_investment_snapshots_on_investment_id"
    t.index ["investor_id"], name: "index_investment_snapshots_on_investor_id"
  end

  create_table "investments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "investment_type", limit: 100
    t.integer "investor_id"
    t.string "investor_type", limit: 100
    t.integer "entity_id"
    t.string "status", limit: 20
    t.string "investment_instrument", limit: 100
    t.integer "quantity", default: 0
    t.decimal "initial_value", precision: 20, scale: 2, default: "0.0"
    t.decimal "current_value", precision: 20, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", limit: 100
    t.datetime "deleted_at"
    t.decimal "percentage_holding", precision: 5, scale: 2, default: "0.0"
    t.boolean "employee_holdings", default: false
    t.integer "diluted_quantity", default: 0
    t.decimal "diluted_percentage", precision: 5, scale: 2, default: "0.0"
    t.string "currency", limit: 10
    t.string "units", limit: 15
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "price_cents", precision: 20, scale: 2
    t.bigint "funding_round_id"
    t.decimal "liquidation_preference", precision: 10, scale: 2
    t.bigint "aggregate_investment_id"
    t.string "spv", limit: 50
    t.date "investment_date"
    t.string "liq_pref_type", limit: 25
    t.string "anti_dilution", limit: 50
    t.integer "preferred_conversion"
    t.integer "preferred_converted_qty", default: 0
    t.text "notes"
    t.index ["aggregate_investment_id"], name: "index_investments_on_aggregate_investment_id"
    t.index ["deleted_at"], name: "index_investments_on_deleted_at"
    t.index ["entity_id"], name: "index_investments_on_entity_id"
    t.index ["funding_round_id"], name: "index_investments_on_funding_round_id"
    t.index ["investor_id"], name: "index_investments_on_investor"
  end

  create_table "investor_accesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "investor_id"
    t.integer "user_id"
    t.string "email"
    t.boolean "approved"
    t.integer "granted_by"
    t.integer "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "first_name", limit: 20
    t.string "last_name", limit: 20
    t.boolean "send_confirmation", default: false
    t.bigint "investor_entity_id"
    t.boolean "is_investor_advisor", default: false
    t.string "phone", limit: 15
    t.boolean "whatsapp_enabled", default: false
    t.string "cc"
    t.bigint "import_upload_id"
    t.index ["deleted_at"], name: "index_investor_accesses_on_deleted_at"
    t.index ["email"], name: "index_investor_accesses_on_email"
    t.index ["entity_id"], name: "index_investor_accesses_on_entity_id"
    t.index ["investor_entity_id"], name: "index_investor_accesses_on_investor_entity_id"
    t.index ["investor_id"], name: "index_investor_accesses_on_investor_id"
    t.index ["user_id"], name: "index_investor_accesses_on_user_id"
  end

  create_table "investor_advisors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "user_id", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "permissions", default: 0, null: false
    t.string "allowed_roles", limit: 100
    t.integer "extended_permissions"
    t.bigint "import_upload_id"
    t.index ["entity_id"], name: "index_investor_advisors_on_entity_id"
    t.index ["user_id"], name: "index_investor_advisors_on_user_id"
  end

  create_table "investor_kpi_mappings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "investor_id", null: false
    t.string "reported_kpi_name", limit: 50
    t.string "standard_kpi_name", limit: 50
    t.decimal "lower_threshold", precision: 20, scale: 2, default: "0.0"
    t.decimal "upper_threshold", precision: 20, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show_in_report", default: false
    t.index ["entity_id"], name: "index_investor_kpi_mappings_on_entity_id"
    t.index ["investor_id"], name: "index_investor_kpi_mappings_on_investor_id"
    t.index ["reported_kpi_name"], name: "index_investor_kpi_mappings_on_reported_kpi_name"
    t.index ["standard_kpi_name"], name: "index_investor_kpi_mappings_on_standard_kpi_name"
  end

  create_table "investor_kyc_sebi_datas", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "investor_category"
    t.string "investor_sub_category"
    t.bigint "investor_kyc_id", null: false
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_investor_kyc_sebi_datas_on_entity_id"
    t.index ["investor_kyc_id"], name: "index_investor_kyc_sebi_datas_on_investor_kyc_id"
  end

  create_table "investor_kycs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "investor_id", null: false
    t.bigint "entity_id", null: false
    t.bigint "form_type_id"
    t.string "PAN", limit: 15
    t.text "address"
    t.string "bank_account_number", limit: 40
    t.string "ifsc_code", limit: 20
    t.boolean "bank_verified", default: false
    t.text "bank_verification_response"
    t.string "bank_verification_status"
    t.text "signature_data"
    t.text "pan_card_data"
    t.boolean "pan_verified", default: false
    t.text "pan_verification_response"
    t.string "pan_verification_status"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false
    t.string "full_name"
    t.bigint "verified_by_id"
    t.datetime "deleted_at"
    t.string "investor_name"
    t.bigint "document_folder_id"
    t.date "expiry_date"
    t.string "kyc_type", limit: 15, default: "Individual"
    t.string "residency", limit: 10
    t.datetime "birth_date"
    t.text "corr_address"
    t.decimal "committed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "call_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "collected_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "distribution_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.boolean "docs_completed", default: false
    t.boolean "send_kyc_form_to_user", default: false
    t.text "notification_msg"
    t.string "bank_name", limit: 100
    t.string "bank_branch", limit: 40
    t.string "bank_account_type", limit: 40
    t.string "type", limit: 20
    t.json "json_fields"
    t.string "esign_emails"
    t.decimal "due_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "uncalled_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "agreement_committed_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "import_upload_id"
    t.bigint "investor_user_id"
    t.datetime "investor_user_updated_at"
    t.decimal "other_fee_cents", precision: 12, scale: 2, default: "0.0"
    t.string "agreement_unit_type", limit: 20
    t.index ["deleted_at"], name: "index_investor_kycs_on_deleted_at"
    t.index ["document_folder_id"], name: "index_investor_kycs_on_document_folder_id"
    t.index ["entity_id"], name: "index_investor_kycs_on_entity_id"
    t.index ["form_type_id"], name: "index_investor_kycs_on_form_type_id"
    t.index ["investor_id"], name: "index_investor_kycs_on_investor_id"
    t.index ["investor_user_id"], name: "index_investor_kycs_on_investor_user_id"
    t.index ["verified_by_id"], name: "index_investor_kycs_on_verified_by_id"
  end

  create_table "investor_notice_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "investor_notice_id", null: false
    t.bigint "entity_id", null: false
    t.bigint "investor_id", null: false
    t.bigint "investor_entity_id", null: false
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_investor_notice_entries_on_entity_id"
    t.index ["investor_entity_id"], name: "index_investor_notice_entries_on_investor_entity_id"
    t.index ["investor_id"], name: "index_investor_notice_entries_on_investor_id"
    t.index ["investor_notice_id"], name: "index_investor_notice_entries_on_investor_notice_id"
  end

  create_table "investor_notice_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "investor_notice_id", null: false
    t.bigint "entity_id", null: false
    t.string "title"
    t.text "details"
    t.string "link"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_investor_notice_items_on_entity_id"
    t.index ["investor_notice_id"], name: "index_investor_notice_items_on_investor_notice_id"
  end

  create_table "investor_notices", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "owner_type"
    t.bigint "owner_id"
    t.date "start_date"
    t.text "title"
    t.string "link"
    t.string "access_rights_metadata"
    t.date "end_date"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "btn_label", limit: 40
    t.boolean "generate", default: false
    t.string "category", limit: 30
    t.index ["entity_id"], name: "index_investor_notices_on_entity_id"
    t.index ["owner_type", "owner_id"], name: "index_investor_notices_on_owner"
  end

  create_table "investors", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "investor_entity_id", null: false
    t.integer "entity_id", null: false
    t.string "category", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "investor_name"
    t.datetime "deleted_at"
    t.date "last_interaction_date"
    t.integer "investor_access_count", default: 0
    t.integer "unapproved_investor_access_count", default: 0
    t.boolean "is_holdings_entity", default: false
    t.boolean "is_trust", default: false
    t.string "city", limit: 50
    t.bigint "form_type_id"
    t.string "tag_list", limit: 120
    t.boolean "imported", default: false
    t.bigint "document_folder_id"
    t.string "pan", limit: 40
    t.json "json_fields"
    t.string "primary_email"
    t.bigint "import_upload_id"
    t.index ["deleted_at"], name: "index_investors_on_deleted_at"
    t.index ["document_folder_id"], name: "index_investors_on_document_folder_id"
    t.index ["entity_id"], name: "index_investors_on_entity_id"
    t.index ["form_type_id"], name: "index_investors_on_form_type_id"
    t.index ["investor_entity_id", "entity_id", "deleted_at"], name: "idx_on_investor_entity_id_entity_id_deleted_at_983d7c8e7a", unique: true
    t.index ["investor_entity_id"], name: "index_investors_on_investor_entity_id"
    t.index ["investor_name", "entity_id"], name: "index_investors_on_investor_name_and_entity_id", unique: true
    t.index ["pan"], name: "index_investors_on_pan"
  end

  create_table "kanban_boards", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "owner_id"
    t.string "owner_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.index ["entity_id"], name: "index_kanban_boards_on_entity_id"
    t.index ["owner_id", "owner_type"], name: "index_kanban_boards_on_owner_id_and_owner_type"
  end

  create_table "kanban_cards", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "data_source_id"
    t.string "data_source_type"
    t.datetime "deleted_at"
    t.bigint "entity_id", null: false
    t.bigint "kanban_board_id", null: false
    t.bigint "kanban_column_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "info_field"
    t.text "notes"
    t.string "tags"
    t.index ["entity_id"], name: "index_kanban_cards_on_entity_id"
    t.index ["kanban_board_id"], name: "index_kanban_cards_on_kanban_board_id"
    t.index ["kanban_column_id"], name: "index_kanban_cards_on_kanban_column_id"
  end

  create_table "kanban_columns", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.integer "sequence"
    t.datetime "deleted_at"
    t.bigint "entity_id", null: false
    t.bigint "kanban_board_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_kanban_columns_on_entity_id"
    t.index ["kanban_board_id"], name: "index_kanban_columns_on_kanban_board_id"
  end

  create_table "kpi_reports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "form_type_id"
    t.date "as_of"
    t.text "notes"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "document_folder_id"
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.bigint "portfolio_company_id"
    t.string "tag_list", default: ""
    t.bigint "owner_id"
    t.string "period", limit: 12, default: "Quarter"
    t.index ["document_folder_id"], name: "index_kpi_reports_on_document_folder_id"
    t.index ["entity_id"], name: "index_kpi_reports_on_entity_id"
    t.index ["form_type_id"], name: "index_kpi_reports_on_form_type_id"
    t.index ["owner_id"], name: "index_kpi_reports_on_owner_id"
    t.index ["portfolio_company_id"], name: "index_kpi_reports_on_portfolio_company_id"
    t.index ["user_id"], name: "index_kpi_reports_on_user_id"
  end

  create_table "kpis", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "form_type_id"
    t.string "name", limit: 50
    t.decimal "value", precision: 20, scale: 6
    t.string "display_value", limit: 30
    t.string "notes"
    t.bigint "kpi_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.decimal "percentage_change", precision: 5, scale: 2, default: "0.0"
    t.bigint "portfolio_company_id"
    t.bigint "owner_id"
    t.index ["entity_id"], name: "index_kpis_on_entity_id"
    t.index ["form_type_id"], name: "index_kpis_on_form_type_id"
    t.index ["kpi_report_id"], name: "index_kpis_on_kpi_report_id"
    t.index ["owner_id"], name: "index_kpis_on_owner_id"
    t.index ["portfolio_company_id"], name: "index_kpis_on_portfolio_company_id"
  end

  create_table "kyc_data", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "investor_kyc_id"
    t.string "source"
    t.json "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_kyc_data_on_entity_id"
    t.index ["investor_kyc_id"], name: "index_kyc_data_on_investor_kyc_id"
  end

  create_table "messages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.bigint "investor_id"
    t.index ["entity_id"], name: "index_messages_on_entity_id"
    t.index ["investor_id"], name: "index_messages_on_investor_id"
    t.index ["owner_type", "owner_id"], name: "index_messages_on_owner"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "details"
    t.integer "entity_id"
    t.integer "user_id"
    t.integer "investor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.date "on"
    t.index ["deleted_at"], name: "index_notes_on_deleted_at"
    t.index ["entity_id"], name: "index_notes_on_entity_id"
    t.index ["investor_id"], name: "index_notes_on_investor_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "noticed_events", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "type"
    t.string "record_type"
    t.bigint "record_id"
    t.json "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notifications_count"
    t.virtual "entity_id", type: :bigint, as: "json_extract(`params`,_utf8mb4'$.entity_id')"
    t.index ["entity_id"], name: "index_noticed_events_on_entity_id"
    t.index ["record_type", "record_id"], name: "index_noticed_events_on_record"
  end

  create_table "noticed_notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "type"
    t.bigint "event_id", null: false
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.datetime "read_at", precision: nil
    t.datetime "seen_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_sent", default: false
    t.json "email"
    t.boolean "whatsapp_sent", default: false
    t.text "whatsapp"
    t.index ["event_id"], name: "index_noticed_notifications_on_event_id"
    t.index ["recipient_type", "recipient_id"], name: "index_noticed_notifications_on_recipient"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.json "params"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id", null: false
    t.boolean "email_sent", default: false
    t.text "email"
    t.boolean "whatsapp_sent", default: false
    t.text "whatsapp"
    t.index ["entity_id"], name: "index_notifications_on_entity_id"
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "nudges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "to"
    t.text "subject"
    t.text "msg_body"
    t.bigint "user_id", null: false
    t.bigint "entity_id", null: false
    t.string "item_type"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "cc"
    t.text "bcc"
    t.index ["entity_id"], name: "index_nudges_on_entity_id"
    t.index ["item_type", "item_id"], name: "index_nudges_on_item"
    t.index ["user_id"], name: "index_nudges_on_user_id"
  end

  create_table "offers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "entity_id", null: false
    t.bigint "secondary_sale_id", null: false
    t.integer "quantity", default: 0
    t.decimal "percentage", precision: 10, default: "0"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "holding_id", null: false
    t.boolean "approved", default: false
    t.integer "granted_by_user_id"
    t.bigint "investor_id", null: false
    t.string "offer_type", limit: 15
    t.string "PAN", limit: 15
    t.text "address"
    t.string "bank_account_number", limit: 40
    t.string "bank_name", limit: 50
    t.text "bank_routing_info"
    t.string "buyer_confirmation", limit: 10
    t.text "buyer_notes"
    t.bigint "buyer_id"
    t.decimal "final_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "allocation_quantity", default: 0
    t.decimal "allocation_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "allocation_percentage", precision: 5, scale: 2, default: "0.0"
    t.string "acquirer_name"
    t.boolean "verified", default: false
    t.text "comments"
    t.boolean "final_agreement", default: false
    t.bigint "interest_id"
    t.bigint "form_type_id"
    t.text "signature_data"
    t.text "spa_data"
    t.text "id_proof_data"
    t.text "address_proof_data"
    t.text "docs_uploaded_check"
    t.boolean "auto_match", default: true
    t.text "pan_card_data"
    t.boolean "pan_verified", default: false
    t.text "pan_verification_response"
    t.string "pan_verification_status"
    t.string "ifsc_code", limit: 20
    t.boolean "bank_verified", default: false
    t.text "bank_verification_response"
    t.string "bank_verification_status"
    t.string "full_name", limit: 100
    t.string "demat", limit: 20
    t.string "city", limit: 20
    t.bigint "final_agreement_user_id"
    t.string "custom_matching_vals"
    t.boolean "esign_completed", default: false
    t.datetime "deleted_at"
    t.bigint "document_folder_id"
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.string "seller_signatory_emails"
    t.index ["buyer_id"], name: "index_offers_on_buyer_id"
    t.index ["custom_matching_vals"], name: "index_offers_on_custom_matching_vals"
    t.index ["deleted_at"], name: "index_offers_on_deleted_at"
    t.index ["document_folder_id"], name: "index_offers_on_document_folder_id"
    t.index ["entity_id"], name: "index_offers_on_entity_id"
    t.index ["final_agreement_user_id"], name: "index_offers_on_final_agreement_user_id"
    t.index ["form_type_id"], name: "index_offers_on_form_type_id"
    t.index ["holding_id"], name: "index_offers_on_holding_id"
    t.index ["interest_id"], name: "index_offers_on_interest_id"
    t.index ["investor_id"], name: "index_offers_on_investor_id"
    t.index ["secondary_sale_id"], name: "index_offers_on_secondary_sale_id"
    t.index ["user_id"], name: "index_offers_on_user_id"
  end

  create_table "option_pools", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.bigint "number_of_options", default: 0
    t.decimal "excercise_price_cents", precision: 20, scale: 2, default: "0.0"
    t.integer "excercise_period_months", default: 0
    t.bigint "entity_id", null: false
    t.bigint "funding_round_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "allocated_quantity", default: 0
    t.bigint "excercised_quantity", default: 0
    t.bigint "vested_quantity", default: 0
    t.bigint "lapsed_quantity", default: 0
    t.boolean "approved", default: false
    t.bigint "cancelled_quantity", default: 0
    t.bigint "gross_avail_to_excercise_quantity", default: 0
    t.bigint "unexcercised_cancelled_quantity", default: 0
    t.bigint "net_avail_to_excercise_quantity", default: 0
    t.bigint "gross_unvested_quantity", default: 0
    t.bigint "unvested_cancelled_quantity", default: 0
    t.bigint "net_unvested_quantity", default: 0
    t.boolean "manual_vesting", default: false
    t.text "properties"
    t.bigint "form_type_id"
    t.text "certificate_signature_data"
    t.text "grant_letter_data"
    t.datetime "deleted_at"
    t.bigint "document_folder_id"
    t.text "formula"
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.index ["deleted_at"], name: "index_option_pools_on_deleted_at"
    t.index ["document_folder_id"], name: "index_option_pools_on_document_folder_id"
    t.index ["entity_id"], name: "index_option_pools_on_entity_id"
    t.index ["form_type_id"], name: "index_option_pools_on_form_type_id"
    t.index ["funding_round_id"], name: "index_option_pools_on_funding_round_id"
  end

  create_table "payments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "plan", limit: 30
    t.decimal "discount", precision: 10, scale: 2, default: "0.0"
    t.string "reference_number"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_payments_on_deleted_at"
    t.index ["entity_id"], name: "index_payments_on_entity_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "permissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.string "email"
    t.integer "permissions"
    t.bigint "entity_id", null: false
    t.bigint "granted_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", limit: 20
    t.index ["entity_id"], name: "index_permissions_on_entity_id"
    t.index ["granted_by_id"], name: "index_permissions_on_granted_by_id"
    t.index ["owner_type", "owner_id"], name: "index_permissions_on_owner"
    t.index ["user_id"], name: "index_permissions_on_user_id"
  end

  create_table "portfolio_attributions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "sold_pi_id", null: false
    t.bigint "bought_pi_id", null: false
    t.decimal "quantity", precision: 20, scale: 8, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "cost_of_sold_cents", precision: 20, scale: 2, default: "0.0"
    t.datetime "deleted_at"
    t.index ["bought_pi_id"], name: "index_portfolio_attributions_on_bought_pi_id"
    t.index ["deleted_at"], name: "index_portfolio_attributions_on_deleted_at"
    t.index ["entity_id"], name: "index_portfolio_attributions_on_entity_id"
    t.index ["fund_id"], name: "index_portfolio_attributions_on_fund_id"
    t.index ["sold_pi_id"], name: "index_portfolio_attributions_on_sold_pi_id"
  end

  create_table "portfolio_cashflows", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "portfolio_company_id", null: false
    t.bigint "aggregate_portfolio_investment_id", null: false
    t.date "payment_date"
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "import_upload_id"
    t.string "tag", limit: 100, default: ""
    t.string "instrument"
    t.bigint "investment_instrument_id", null: false
    t.bigint "form_type_id"
    t.json "json_fields"
    t.bigint "document_folder_id"
    t.index ["aggregate_portfolio_investment_id"], name: "index_portfolio_cashflows_on_aggregate_portfolio_investment_id"
    t.index ["document_folder_id"], name: "index_portfolio_cashflows_on_document_folder_id"
    t.index ["entity_id"], name: "index_portfolio_cashflows_on_entity_id"
    t.index ["form_type_id"], name: "index_portfolio_cashflows_on_form_type_id"
    t.index ["fund_id"], name: "index_portfolio_cashflows_on_fund_id"
    t.index ["investment_instrument_id"], name: "index_portfolio_cashflows_on_investment_instrument_id"
    t.index ["portfolio_company_id"], name: "index_portfolio_cashflows_on_portfolio_company_id"
  end

  create_table "portfolio_investments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "form_type_id"
    t.bigint "portfolio_company_id", null: false
    t.string "portfolio_company_name", limit: 100
    t.date "investment_date"
    t.decimal "amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "quantity", precision: 20, scale: 2, default: "0.0"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "fmv_cents", precision: 20, scale: 2, default: "0.0"
    t.bigint "document_folder_id"
    t.bigint "aggregate_portfolio_investment_id", null: false
    t.decimal "sold_quantity", precision: 20, scale: 2, default: "0.0"
    t.decimal "net_quantity", precision: 20, scale: 2, default: "0.0"
    t.decimal "cost_of_sold_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "gain_cents", precision: 20, scale: 2, default: "0.0"
    t.string "commitment_type", limit: 10, default: "Pool"
    t.string "folio_id", limit: 20
    t.bigint "capital_commitment_id"
    t.string "category", limit: 10
    t.string "sub_category", limit: 100
    t.string "sector", limit: 100
    t.boolean "startup", default: true
    t.string "investment_domicile", limit: 10, default: "Domestic"
    t.datetime "deleted_at"
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.bigint "investment_instrument_id"
    t.decimal "quantity_as_of_date", precision: 10, default: "0"
    t.decimal "base_amount_cents", precision: 20, scale: 2
    t.bigint "exchange_rate_id"
    t.decimal "transfer_quantity", precision: 20, scale: 2, default: "0.0"
    t.decimal "transfer_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.index ["aggregate_portfolio_investment_id"], name: "index_portfolio_investments_on_aggregate_portfolio_investment_id"
    t.index ["capital_commitment_id"], name: "index_portfolio_investments_on_capital_commitment_id"
    t.index ["deleted_at"], name: "index_portfolio_investments_on_deleted_at"
    t.index ["document_folder_id"], name: "index_portfolio_investments_on_document_folder_id"
    t.index ["entity_id"], name: "index_portfolio_investments_on_entity_id"
    t.index ["exchange_rate_id"], name: "index_portfolio_investments_on_exchange_rate_id"
    t.index ["form_type_id"], name: "index_portfolio_investments_on_form_type_id"
    t.index ["fund_id"], name: "index_portfolio_investments_on_fund_id"
    t.index ["investment_date"], name: "index_portfolio_investments_on_investment_date"
    t.index ["investment_instrument_id"], name: "index_portfolio_investments_on_investment_instrument_id"
    t.index ["portfolio_company_id"], name: "index_portfolio_investments_on_portfolio_company_id"
  end

  create_table "portfolio_scenarios", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.string "name", limit: 100
    t.bigint "user_id", null: false
    t.text "calculations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_portfolio_scenarios_on_entity_id"
    t.index ["fund_id"], name: "index_portfolio_scenarios_on_fund_id"
    t.index ["user_id"], name: "index_portfolio_scenarios_on_user_id"
  end

  create_table "quick_link_steps", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "link"
    t.text "description"
    t.bigint "quick_link_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quick_link_id"], name: "index_quick_link_steps_on_quick_link_id"
  end

  create_table "quick_links", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "tags"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_quick_links_on_entity_id"
  end

  create_table "reminders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.boolean "sent", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "note"
    t.date "due_date"
    t.string "email"
    t.index ["entity_id"], name: "index_reminders_on_entity_id"
    t.index ["owner_type", "owner_id"], name: "index_reminders_on_owner"
  end

  create_table "reports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id"
    t.bigint "user_id", null: false
    t.string "name"
    t.string "category", limit: 20
    t.text "description"
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tag_list"
    t.string "curr_role", limit: 10, default: "employee"
    t.index ["entity_id"], name: "index_reports_on_entity_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "roles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "scenario_investments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "portfolio_scenario_id", null: false
    t.bigint "user_id", null: false
    t.date "transaction_date"
    t.bigint "portfolio_company_id", null: false
    t.decimal "price_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "quantity", precision: 20, scale: 2, default: "0.0"
    t.string "category", limit: 15, null: false
    t.string "sub_category", limit: 100, null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "investment_instrument_id"
    t.index ["entity_id"], name: "index_scenario_investments_on_entity_id"
    t.index ["fund_id"], name: "index_scenario_investments_on_fund_id"
    t.index ["investment_instrument_id"], name: "index_scenario_investments_on_investment_instrument_id"
    t.index ["portfolio_company_id"], name: "index_scenario_investments_on_portfolio_company_id"
    t.index ["portfolio_scenario_id"], name: "index_scenario_investments_on_portfolio_scenario_id"
    t.index ["user_id"], name: "index_scenario_investments_on_user_id"
  end

  create_table "secondary_sales", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "entity_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.integer "percent_allowed", default: 0
    t.decimal "min_price", precision: 20, scale: 2
    t.decimal "max_price", precision: 20, scale: 2
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_offered_quantity", default: 0
    t.boolean "visible_externally", default: false
    t.datetime "deleted_at"
    t.decimal "final_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "total_offered_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "total_interest_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.integer "total_interest_quantity", default: 0
    t.bigint "offer_allocation_quantity", default: 0
    t.bigint "interest_allocation_quantity", default: 0
    t.decimal "allocation_percentage", precision: 7, scale: 4, default: "0.0"
    t.decimal "allocation_offer_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "allocation_interest_amount_cents", precision: 20, scale: 2, default: "0.0"
    t.string "allocation_status", limit: 10
    t.string "price_type", limit: 15
    t.boolean "finalized", default: false
    t.text "seller_doc_list"
    t.decimal "seller_transaction_fees_pct", precision: 5, scale: 2
    t.bigint "form_type_id"
    t.boolean "lock_allocations", default: false
    t.date "offer_end_date"
    t.string "support_email"
    t.text "buyer_doc_list"
    t.string "sale_type", limit: 10, default: "Regular"
    t.bigint "indicative_quantity", default: 0
    t.string "show_quantity", limit: 10
    t.boolean "no_offer_emails", default: false
    t.boolean "no_interest_emails", default: false
    t.boolean "manage_offers", default: false
    t.boolean "manage_interests", default: false
    t.text "spa_data"
    t.boolean "disable_pan_kyc", default: false
    t.boolean "disable_bank_kyc", default: false
    t.text "custom_matching_fields"
    t.text "cmf_allocation_percentage"
    t.bigint "document_folder_id"
    t.json "json_fields"
    t.boolean "show_holdings", default: true
    t.bigint "data_room_folder_id"
    t.index ["data_room_folder_id"], name: "index_secondary_sales_on_data_room_folder_id"
    t.index ["deleted_at"], name: "index_secondary_sales_on_deleted_at"
    t.index ["document_folder_id"], name: "index_secondary_sales_on_document_folder_id"
    t.index ["entity_id"], name: "index_secondary_sales_on_entity_id"
    t.index ["form_type_id"], name: "index_secondary_sales_on_form_type_id"
  end

  create_table "share_transfers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "from_investor_id"
    t.bigint "from_investment_id"
    t.bigint "to_investor_id"
    t.bigint "to_investment_id"
    t.integer "quantity"
    t.decimal "price", precision: 20, scale: 2, default: "0.0"
    t.date "transfer_date"
    t.bigint "transfered_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transfer_type", limit: 10
    t.integer "to_quantity", default: 0
    t.bigint "from_holding_id"
    t.bigint "to_holding_id"
    t.bigint "to_user_id"
    t.bigint "from_user_id"
    t.index ["entity_id"], name: "index_share_transfers_on_entity_id"
    t.index ["from_holding_id"], name: "index_share_transfers_on_from_holding_id"
    t.index ["from_investment_id"], name: "index_share_transfers_on_from_investment_id"
    t.index ["from_investor_id"], name: "index_share_transfers_on_from_investor_id"
    t.index ["from_user_id"], name: "index_share_transfers_on_from_user_id"
    t.index ["to_holding_id"], name: "index_share_transfers_on_to_holding_id"
    t.index ["to_investment_id"], name: "index_share_transfers_on_to_investment_id"
    t.index ["to_investor_id"], name: "index_share_transfers_on_to_investor_id"
    t.index ["to_user_id"], name: "index_share_transfers_on_to_user_id"
    t.index ["transfered_by_id"], name: "index_share_transfers_on_transfered_by_id"
  end

  create_table "signature_workflows", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.bigint "entity_id", null: false
    t.text "state"
    t.string "status"
    t.boolean "sequential", default: true
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "paused", default: false
    t.bigint "document_id"
    t.index ["document_id"], name: "index_signature_workflows_on_document_id"
    t.index ["entity_id"], name: "index_signature_workflows_on_entity_id"
    t.index ["owner_type", "owner_id"], name: "index_signature_workflows_on_owner"
  end

  create_table "solid_cache_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.binary "key", limit: 1024, null: false
    t.binary "value", size: :long, null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_solid_cache_entries_on_key", unique: true
  end

  create_table "stamp_papers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.text "notes"
    t.string "tags"
    t.string "sign_on_page", limit: 5
    t.string "note_on_page", limit: 5
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state"
    t.string "stamp_type"
    t.string "duty_paid_by"
    t.string "duty_payment_method"
    t.string "document_category"
    t.string "doc_ref_id"
    t.string "ref_id"
    t.string "duty_payer_phone_number"
    t.string "duty_payer_email_id"
    t.string "amounts"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_stamp_papers_on_deleted_at"
    t.index ["entity_id"], name: "index_stamp_papers_on_entity_id"
    t.index ["owner_type", "owner_id"], name: "index_stamp_papers_on_owner"
  end

  create_table "stock_adjustments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "portfolio_company_id", null: false
    t.bigint "user_id", null: false
    t.decimal "adjustment", precision: 10, scale: 8, default: "0.0"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", limit: 10
    t.string "sub_category", limit: 100
    t.bigint "investment_instrument_id"
    t.index ["entity_id"], name: "index_stock_adjustments_on_entity_id"
    t.index ["investment_instrument_id"], name: "index_stock_adjustments_on_investment_instrument_id"
    t.index ["portfolio_company_id"], name: "index_stock_adjustments_on_portfolio_company_id"
    t.index ["user_id"], name: "index_stock_adjustments_on_user_id"
  end

  create_table "stock_conversions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.bigint "from_portfolio_investment_id", null: false
    t.bigint "fund_id", null: false
    t.bigint "from_instrument_id", null: false
    t.decimal "from_quantity", precision: 20, scale: 2
    t.bigint "to_instrument_id", null: false
    t.decimal "to_quantity", precision: 20, scale: 2
    t.bigint "to_portfolio_investment_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "conversion_date"
    t.datetime "deleted_at"
    t.index ["conversion_date"], name: "index_stock_conversions_on_conversion_date"
    t.index ["deleted_at"], name: "index_stock_conversions_on_deleted_at"
    t.index ["entity_id"], name: "index_stock_conversions_on_entity_id"
    t.index ["from_instrument_id"], name: "index_stock_conversions_on_from_instrument_id"
    t.index ["from_portfolio_investment_id"], name: "index_stock_conversions_on_from_portfolio_investment_id"
    t.index ["fund_id"], name: "index_stock_conversions_on_fund_id"
    t.index ["to_instrument_id"], name: "index_stock_conversions_on_to_instrument_id"
    t.index ["to_portfolio_investment_id"], name: "index_stock_conversions_on_to_portfolio_investment_id"
  end

  create_table "support_client_mappings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "entity_id", null: false
    t.date "end_date"
    t.boolean "enabled", default: true
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_support_client_mappings_on_deleted_at"
    t.index ["entity_id"], name: "index_support_client_mappings_on_entity_id"
    t.index ["user_id"], name: "index_support_client_mappings_on_user_id"
  end

  create_table "taggings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", collation: "utf8mb3_bin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tasks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "details"
    t.bigint "entity_id", null: false
    t.bigint "for_entity_id"
    t.boolean "completed", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_type"
    t.bigint "owner_id"
    t.bigint "form_type_id"
    t.date "due_date"
    t.integer "assigned_to_id"
    t.string "tags", limit: 50
    t.text "response"
    t.index ["entity_id"], name: "index_tasks_on_entity_id"
    t.index ["for_entity_id"], name: "index_tasks_on_for_entity_id"
    t.index ["form_type_id"], name: "index_tasks_on_form_type_id"
    t.index ["owner_type", "owner_id"], name: "index_tasks_on_owner"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "user_alerts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "message"
    t.bigint "entity_id", null: false
    t.string "level", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_user_alerts_on_entity_id"
    t.index ["user_id"], name: "index_user_alerts_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "phone", limit: 100
    t.boolean "active", default: true
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "entity_id"
    t.datetime "deleted_at"
    t.boolean "system_created", default: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "accept_terms", default: false
    t.boolean "whatsapp_enabled", default: false
    t.boolean "sale_notification", default: false
    t.string "curr_role", limit: 20
    t.bigint "permissions", default: 0, null: false
    t.string "dept", limit: 20
    t.text "signature_data"
    t.string "entity_type", limit: 25
    t.timestamp "accepted_terms_on"
    t.bigint "advisor_entity_id"
    t.bigint "investor_advisor_id"
    t.string "call_code", limit: 3, default: "91"
    t.integer "extended_permissions", default: 0
    t.boolean "enable_support"
    t.string "advisor_entity_roles", limit: 50
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.json "json_fields"
    t.bigint "form_type_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["entity_id"], name: "index_users_on_entity_id"
    t.index ["form_type_id"], name: "index_users_on_form_type_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "valuations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "entity_id", null: false
    t.date "valuation_date"
    t.decimal "valuation_cents", precision: 20, scale: 2, default: "0.0"
    t.decimal "per_share_value_cents", precision: 20, scale: 8, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "form_type_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.text "report_data"
    t.decimal "net_valuation_cents", precision: 20, scale: 2, default: "0.0"
    t.datetime "deleted_at"
    t.string "category", limit: 10
    t.string "sub_category", limit: 100
    t.json "json_fields"
    t.bigint "import_upload_id"
    t.bigint "investment_instrument_id"
    t.decimal "base_amount_cents", precision: 20, scale: 2
    t.index ["deleted_at"], name: "index_valuations_on_deleted_at"
    t.index ["entity_id"], name: "index_valuations_on_entity_id"
    t.index ["form_type_id"], name: "index_valuations_on_form_type_id"
    t.index ["investment_instrument_id"], name: "index_valuations_on_investment_instrument_id"
    t.index ["owner_type", "owner_id"], name: "index_valuations_on_owner"
    t.index ["valuation_date"], name: "index_valuations_on_valuation_date"
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "item_type"
    t.string "{:null=>false, :limit=>191}"
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "vesting_schedules", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "months_from_grant"
    t.integer "vesting_percent"
    t.bigint "option_pool_id", null: false
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_vesting_schedules_on_entity_id"
    t.index ["option_pool_id"], name: "index_vesting_schedules_on_option_pool_id"
  end

  create_table "video_kycs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "investor_kyc_id", null: false
    t.bigint "entity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_video_kycs_on_entity_id"
    t.index ["investor_kyc_id"], name: "index_video_kycs_on_investor_kyc_id"
    t.index ["user_id"], name: "index_video_kycs_on_user_id"
  end

  create_table "whatsapp_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "notification_id", null: false
    t.json "params"
    t.json "response"
    t.json "entity_name"
    t.boolean "name_matched"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "entity_id"
    t.index ["notification_id"], name: "index_whatsapp_logs_on_notification_id"
  end

  add_foreign_key "access_rights", "entities"
  add_foreign_key "access_rights", "investors", column: "access_to_investor_id"
  add_foreign_key "access_rights", "users"
  add_foreign_key "access_rights", "users", column: "granted_by_id"
  add_foreign_key "account_entries", "capital_commitments"
  add_foreign_key "account_entries", "entities"
  add_foreign_key "account_entries", "exchange_rates"
  add_foreign_key "account_entries", "form_types"
  add_foreign_key "account_entries", "fund_formulas"
  add_foreign_key "account_entries", "funds"
  add_foreign_key "account_entries", "investors"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "adhaar_esigns", "documents"
  add_foreign_key "adhaar_esigns", "entities"
  add_foreign_key "aggregate_investments", "entities"
  add_foreign_key "aggregate_investments", "funding_rounds"
  add_foreign_key "aggregate_investments", "investors"
  add_foreign_key "aggregate_portfolio_investments", "entities"
  add_foreign_key "aggregate_portfolio_investments", "form_types"
  add_foreign_key "aggregate_portfolio_investments", "funds"
  add_foreign_key "aggregate_portfolio_investments", "investment_instruments"
  add_foreign_key "aggregate_portfolio_investments", "investors", column: "portfolio_company_id"
  add_foreign_key "allocation_runs", "entities"
  add_foreign_key "allocation_runs", "funds"
  add_foreign_key "allocation_runs", "users"
  add_foreign_key "aml_reports", "entities"
  add_foreign_key "aml_reports", "investor_kycs"
  add_foreign_key "aml_reports", "investors"
  add_foreign_key "aml_reports", "users", column: "approved_by_id"
  add_foreign_key "approval_responses", "approvals"
  add_foreign_key "approval_responses", "entities"
  add_foreign_key "approval_responses", "entities", column: "response_entity_id"
  add_foreign_key "approval_responses", "form_types"
  add_foreign_key "approval_responses", "investors"
  add_foreign_key "approval_responses", "users", column: "response_user_id"
  add_foreign_key "approvals", "entities"
  add_foreign_key "approvals", "folders", column: "document_folder_id"
  add_foreign_key "call_fees", "capital_calls"
  add_foreign_key "call_fees", "entities"
  add_foreign_key "call_fees", "funds"
  add_foreign_key "caphive_agents", "entities"
  add_foreign_key "caphive_agents", "users"
  add_foreign_key "capital_calls", "entities"
  add_foreign_key "capital_calls", "folders", column: "document_folder_id"
  add_foreign_key "capital_calls", "funds"
  add_foreign_key "capital_calls", "users", column: "approved_by_user_id"
  add_foreign_key "capital_commitments", "entities"
  add_foreign_key "capital_commitments", "exchange_rates"
  add_foreign_key "capital_commitments", "folders", column: "document_folder_id"
  add_foreign_key "capital_commitments", "funds"
  add_foreign_key "capital_commitments", "investor_kycs"
  add_foreign_key "capital_commitments", "investors"
  add_foreign_key "capital_commitments", "users", column: "investor_signatory_id"
  add_foreign_key "capital_distribution_payments", "capital_commitments"
  add_foreign_key "capital_distribution_payments", "capital_distributions"
  add_foreign_key "capital_distribution_payments", "entities"
  add_foreign_key "capital_distribution_payments", "exchange_rates"
  add_foreign_key "capital_distribution_payments", "folders", column: "document_folder_id"
  add_foreign_key "capital_distribution_payments", "form_types"
  add_foreign_key "capital_distribution_payments", "funds"
  add_foreign_key "capital_distribution_payments", "investors"
  add_foreign_key "capital_distributions", "capital_commitments"
  add_foreign_key "capital_distributions", "entities"
  add_foreign_key "capital_distributions", "folders", column: "document_folder_id"
  add_foreign_key "capital_distributions", "form_types"
  add_foreign_key "capital_distributions", "funds"
  add_foreign_key "capital_distributions", "users", column: "approved_by_user_id"
  add_foreign_key "capital_remittance_payments", "capital_remittances"
  add_foreign_key "capital_remittance_payments", "entities"
  add_foreign_key "capital_remittance_payments", "exchange_rates"
  add_foreign_key "capital_remittance_payments", "funds"
  add_foreign_key "capital_remittances", "capital_calls"
  add_foreign_key "capital_remittances", "capital_commitments"
  add_foreign_key "capital_remittances", "entities"
  add_foreign_key "capital_remittances", "exchange_rates"
  add_foreign_key "capital_remittances", "folders", column: "document_folder_id"
  add_foreign_key "capital_remittances", "funds"
  add_foreign_key "capital_remittances", "investors"
  add_foreign_key "ci_profiles", "entities"
  add_foreign_key "ci_profiles", "funds"
  add_foreign_key "ci_track_records", "entities"
  add_foreign_key "ci_track_records", "investment_opportunities"
  add_foreign_key "ci_widgets", "entities"
  add_foreign_key "ci_widgets", "investment_opportunities"
  add_foreign_key "commitment_adjustments", "capital_commitments"
  add_foreign_key "commitment_adjustments", "entities"
  add_foreign_key "commitment_adjustments", "exchange_rates"
  add_foreign_key "commitment_adjustments", "funds"
  add_foreign_key "custom_notifications", "entities"
  add_foreign_key "custom_notifications", "folders", column: "document_folder_id"
  add_foreign_key "deal_activities", "deal_investors"
  add_foreign_key "deal_activities", "deals"
  add_foreign_key "deal_activities", "folders", column: "document_folder_id"
  add_foreign_key "deal_docs", "deal_activities"
  add_foreign_key "deal_docs", "deal_investors"
  add_foreign_key "deal_docs", "deals"
  add_foreign_key "deal_docs", "users"
  add_foreign_key "deal_investors", "deal_activities"
  add_foreign_key "deal_investors", "deals"
  add_foreign_key "deal_investors", "entities"
  add_foreign_key "deal_investors", "folders", column: "document_folder_id"
  add_foreign_key "deal_investors", "form_types"
  add_foreign_key "deal_investors", "investors"
  add_foreign_key "deals", "deals", column: "clone_from_id"
  add_foreign_key "deals", "entities"
  add_foreign_key "deals", "folders", column: "data_room_folder_id"
  add_foreign_key "deals", "folders", column: "document_folder_id"
  add_foreign_key "deals", "form_types"
  add_foreign_key "doc_questions", "entities"
  add_foreign_key "document_chats", "documents"
  add_foreign_key "document_chats", "entities"
  add_foreign_key "documents", "folders"
  add_foreign_key "documents", "form_types"
  add_foreign_key "documents", "users"
  add_foreign_key "documents", "users", column: "approved_by_id"
  add_foreign_key "documents", "users", column: "signed_by_id"
  add_foreign_key "e_signatures", "documents"
  add_foreign_key "e_signatures", "entities"
  add_foreign_key "e_signatures", "users"
  add_foreign_key "entity_settings", "entities"
  add_foreign_key "esigns", "documents"
  add_foreign_key "esigns", "entities"
  add_foreign_key "esigns", "users"
  add_foreign_key "excercises", "entities"
  add_foreign_key "excercises", "folders", column: "document_folder_id"
  add_foreign_key "excercises", "holdings"
  add_foreign_key "excercises", "option_pools"
  add_foreign_key "excercises", "users"
  add_foreign_key "exchange_rates", "entities"
  add_foreign_key "exchange_rates", "folders", column: "document_folder_id"
  add_foreign_key "exchange_rates", "import_uploads"
  add_foreign_key "expression_of_interests", "entities"
  add_foreign_key "expression_of_interests", "entities", column: "eoi_entity_id"
  add_foreign_key "expression_of_interests", "folders", column: "document_folder_id"
  add_foreign_key "expression_of_interests", "investment_opportunities"
  add_foreign_key "expression_of_interests", "investor_kycs"
  add_foreign_key "expression_of_interests", "investors"
  add_foreign_key "expression_of_interests", "users"
  add_foreign_key "expression_of_interests", "users", column: "investor_signatory_id"
  add_foreign_key "fees", "entities"
  add_foreign_key "folders", "entities"
  add_foreign_key "form_custom_fields", "form_types"
  add_foreign_key "form_types", "entities"
  add_foreign_key "fund_formulas", "entities"
  add_foreign_key "fund_formulas", "funds"
  add_foreign_key "fund_ratios", "capital_commitments"
  add_foreign_key "fund_ratios", "entities"
  add_foreign_key "fund_ratios", "funds"
  add_foreign_key "fund_ratios", "valuations"
  add_foreign_key "fund_reports", "entities"
  add_foreign_key "fund_reports", "funds"
  add_foreign_key "fund_sebi_infos", "entities"
  add_foreign_key "fund_sebi_infos", "funds"
  add_foreign_key "fund_unit_settings", "entities"
  add_foreign_key "fund_unit_settings", "form_types"
  add_foreign_key "fund_unit_settings", "funds"
  add_foreign_key "fund_units", "capital_commitments"
  add_foreign_key "fund_units", "entities"
  add_foreign_key "fund_units", "funds"
  add_foreign_key "fund_units", "investors"
  add_foreign_key "funding_rounds", "entities"
  add_foreign_key "funds", "entities"
  add_foreign_key "funds", "folders", column: "data_room_folder_id"
  add_foreign_key "funds", "folders", column: "document_folder_id"
  add_foreign_key "funds", "import_uploads"
  add_foreign_key "funds", "users", column: "fund_signatory_id"
  add_foreign_key "funds", "users", column: "trustee_signatory_id"
  add_foreign_key "holding_actions", "entities"
  add_foreign_key "holding_actions", "holdings"
  add_foreign_key "holding_actions", "users"
  add_foreign_key "holding_audit_trails", "entities"
  add_foreign_key "holdings", "entities"
  add_foreign_key "holdings", "excercises", column: "created_from_excercise_id"
  add_foreign_key "holdings", "form_types"
  add_foreign_key "holdings", "investments"
  add_foreign_key "holdings", "investors"
  add_foreign_key "holdings", "option_pools"
  add_foreign_key "holdings", "users"
  add_foreign_key "import_uploads", "entities"
  add_foreign_key "import_uploads", "users"
  add_foreign_key "interests", "folders", column: "document_folder_id"
  add_foreign_key "interests", "form_types"
  add_foreign_key "interests", "funding_rounds"
  add_foreign_key "interests", "investors"
  add_foreign_key "interests", "secondary_sales"
  add_foreign_key "interests", "users"
  add_foreign_key "interests", "users", column: "final_agreement_user_id"
  add_foreign_key "investment_instruments", "entities"
  add_foreign_key "investment_instruments", "form_types"
  add_foreign_key "investment_instruments", "investors", column: "portfolio_company_id"
  add_foreign_key "investment_opportunities", "entities"
  add_foreign_key "investment_opportunities", "folders", column: "document_folder_id"
  add_foreign_key "investment_opportunities", "form_types"
  add_foreign_key "investment_snapshots", "entities"
  add_foreign_key "investment_snapshots", "funding_rounds"
  add_foreign_key "investment_snapshots", "investments"
  add_foreign_key "investment_snapshots", "investors"
  add_foreign_key "investments", "aggregate_investments"
  add_foreign_key "investments", "funding_rounds"
  add_foreign_key "investor_accesses", "entities", column: "investor_entity_id"
  add_foreign_key "investor_advisors", "entities"
  add_foreign_key "investor_advisors", "users"
  add_foreign_key "investor_kpi_mappings", "entities"
  add_foreign_key "investor_kpi_mappings", "investors"
  add_foreign_key "investor_kyc_sebi_datas", "entities"
  add_foreign_key "investor_kyc_sebi_datas", "investor_kycs"
  add_foreign_key "investor_kycs", "entities"
  add_foreign_key "investor_kycs", "folders", column: "document_folder_id"
  add_foreign_key "investor_kycs", "form_types"
  add_foreign_key "investor_kycs", "investors"
  add_foreign_key "investor_kycs", "users", column: "investor_user_id"
  add_foreign_key "investor_kycs", "users", column: "verified_by_id"
  add_foreign_key "investor_notice_entries", "entities"
  add_foreign_key "investor_notice_entries", "entities", column: "investor_entity_id"
  add_foreign_key "investor_notice_entries", "investor_notices"
  add_foreign_key "investor_notice_entries", "investors"
  add_foreign_key "investor_notice_items", "entities"
  add_foreign_key "investor_notice_items", "investor_notices"
  add_foreign_key "investor_notices", "entities"
  add_foreign_key "investors", "folders", column: "document_folder_id"
  add_foreign_key "investors", "form_types"
  add_foreign_key "kanban_boards", "entities"
  add_foreign_key "kanban_cards", "entities"
  add_foreign_key "kanban_cards", "kanban_boards"
  add_foreign_key "kanban_cards", "kanban_columns"
  add_foreign_key "kanban_columns", "entities"
  add_foreign_key "kanban_columns", "kanban_boards"
  add_foreign_key "kpi_reports", "entities"
  add_foreign_key "kpi_reports", "entities", column: "owner_id"
  add_foreign_key "kpi_reports", "folders", column: "document_folder_id"
  add_foreign_key "kpi_reports", "form_types"
  add_foreign_key "kpi_reports", "investors", column: "portfolio_company_id"
  add_foreign_key "kpi_reports", "users"
  add_foreign_key "kpis", "entities"
  add_foreign_key "kpis", "entities", column: "owner_id"
  add_foreign_key "kpis", "form_types"
  add_foreign_key "kpis", "investors", column: "portfolio_company_id"
  add_foreign_key "kpis", "kpi_reports"
  add_foreign_key "kyc_data", "entities"
  add_foreign_key "kyc_data", "investor_kycs"
  add_foreign_key "messages", "investors"
  add_foreign_key "messages", "users"
  add_foreign_key "nudges", "entities"
  add_foreign_key "nudges", "users"
  add_foreign_key "offers", "entities"
  add_foreign_key "offers", "folders", column: "document_folder_id"
  add_foreign_key "offers", "form_types"
  add_foreign_key "offers", "holdings"
  add_foreign_key "offers", "interests"
  add_foreign_key "offers", "secondary_sales"
  add_foreign_key "offers", "users"
  add_foreign_key "offers", "users", column: "final_agreement_user_id"
  add_foreign_key "option_pools", "entities"
  add_foreign_key "option_pools", "folders", column: "document_folder_id"
  add_foreign_key "option_pools", "form_types"
  add_foreign_key "option_pools", "funding_rounds"
  add_foreign_key "payments", "entities"
  add_foreign_key "payments", "users"
  add_foreign_key "permissions", "entities"
  add_foreign_key "permissions", "users"
  add_foreign_key "permissions", "users", column: "granted_by_id"
  add_foreign_key "portfolio_attributions", "entities"
  add_foreign_key "portfolio_attributions", "funds"
  add_foreign_key "portfolio_attributions", "portfolio_investments", column: "bought_pi_id"
  add_foreign_key "portfolio_attributions", "portfolio_investments", column: "sold_pi_id"
  add_foreign_key "portfolio_cashflows", "aggregate_portfolio_investments"
  add_foreign_key "portfolio_cashflows", "entities"
  add_foreign_key "portfolio_cashflows", "folders", column: "document_folder_id"
  add_foreign_key "portfolio_cashflows", "form_types"
  add_foreign_key "portfolio_cashflows", "funds"
  add_foreign_key "portfolio_cashflows", "investment_instruments"
  add_foreign_key "portfolio_cashflows", "investors", column: "portfolio_company_id"
  add_foreign_key "portfolio_investments", "capital_commitments"
  add_foreign_key "portfolio_investments", "entities"
  add_foreign_key "portfolio_investments", "exchange_rates"
  add_foreign_key "portfolio_investments", "folders", column: "document_folder_id"
  add_foreign_key "portfolio_investments", "form_types"
  add_foreign_key "portfolio_investments", "funds"
  add_foreign_key "portfolio_investments", "investment_instruments"
  add_foreign_key "portfolio_investments", "investors", column: "portfolio_company_id"
  add_foreign_key "portfolio_scenarios", "entities"
  add_foreign_key "portfolio_scenarios", "funds"
  add_foreign_key "portfolio_scenarios", "users"
  add_foreign_key "quick_link_steps", "quick_links"
  add_foreign_key "quick_links", "entities"
  add_foreign_key "reminders", "entities"
  add_foreign_key "reports", "entities"
  add_foreign_key "reports", "users"
  add_foreign_key "scenario_investments", "entities"
  add_foreign_key "scenario_investments", "funds"
  add_foreign_key "scenario_investments", "investment_instruments"
  add_foreign_key "scenario_investments", "investors", column: "portfolio_company_id"
  add_foreign_key "scenario_investments", "portfolio_scenarios"
  add_foreign_key "scenario_investments", "users"
  add_foreign_key "secondary_sales", "entities"
  add_foreign_key "secondary_sales", "folders", column: "data_room_folder_id"
  add_foreign_key "secondary_sales", "folders", column: "document_folder_id"
  add_foreign_key "secondary_sales", "form_types"
  add_foreign_key "share_transfers", "entities"
  add_foreign_key "share_transfers", "holdings", column: "from_holding_id"
  add_foreign_key "share_transfers", "holdings", column: "to_holding_id"
  add_foreign_key "share_transfers", "investments", column: "from_investment_id"
  add_foreign_key "share_transfers", "investments", column: "to_investment_id"
  add_foreign_key "share_transfers", "investors", column: "from_investor_id"
  add_foreign_key "share_transfers", "investors", column: "to_investor_id"
  add_foreign_key "share_transfers", "users", column: "from_user_id"
  add_foreign_key "share_transfers", "users", column: "to_user_id"
  add_foreign_key "share_transfers", "users", column: "transfered_by_id"
  add_foreign_key "signature_workflows", "documents"
  add_foreign_key "signature_workflows", "entities"
  add_foreign_key "stamp_papers", "entities"
  add_foreign_key "stock_adjustments", "entities"
  add_foreign_key "stock_adjustments", "investment_instruments"
  add_foreign_key "stock_adjustments", "investors", column: "portfolio_company_id"
  add_foreign_key "stock_adjustments", "users"
  add_foreign_key "stock_conversions", "entities"
  add_foreign_key "stock_conversions", "funds"
  add_foreign_key "stock_conversions", "investment_instruments", column: "from_instrument_id"
  add_foreign_key "stock_conversions", "investment_instruments", column: "to_instrument_id"
  add_foreign_key "stock_conversions", "portfolio_investments", column: "from_portfolio_investment_id"
  add_foreign_key "stock_conversions", "portfolio_investments", column: "to_portfolio_investment_id"
  add_foreign_key "support_client_mappings", "entities"
  add_foreign_key "support_client_mappings", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tasks", "entities"
  add_foreign_key "tasks", "form_types"
  add_foreign_key "tasks", "users"
  add_foreign_key "user_alerts", "entities"
  add_foreign_key "user_alerts", "users"
  add_foreign_key "users", "form_types"
  add_foreign_key "valuations", "entities"
  add_foreign_key "valuations", "form_types"
  add_foreign_key "valuations", "investment_instruments"
  add_foreign_key "vesting_schedules", "entities"
  add_foreign_key "vesting_schedules", "option_pools"
  add_foreign_key "video_kycs", "entities"
  add_foreign_key "video_kycs", "investor_kycs"
  add_foreign_key "video_kycs", "users"
  add_foreign_key "whatsapp_logs", "notifications"
end
