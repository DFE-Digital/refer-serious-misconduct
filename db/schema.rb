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

ActiveRecord::Schema[7.0].define(version: 2024_02_21_164638) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
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

  create_table "eligibility_checks", force: :cascade do |t|
    t.string "reporting_as", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "serious_misconduct"
    t.string "teaching_in_england"
    t.string "unsupervised_teaching"
    t.string "is_teacher"
    t.boolean "complained"
    t.string "continue_with"
    t.string "complaint_status"
  end

  create_table "feature_flags_features", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_feature_flags_features_on_name", unique: true
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "satisfaction_rating", null: false
    t.text "improvement_suggestion", null: false
    t.boolean "contact_permission_given", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organisations", force: :cascade do |t|
    t.bigint "referral_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "street_1"
    t.string "street_2"
    t.string "city"
    t.string "postcode"
    t.boolean "complete"
    t.index ["referral_id"], name: "index_organisations_on_referral_id"
  end

  create_table "referrals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_known"
    t.string "email_address", limit: 256
    t.string "first_name"
    t.string "last_name"
    t.string "previous_name"
    t.string "name_has_changed"
    t.date "date_of_birth"
    t.string "trn"
    t.boolean "trn_known"
    t.string "has_qts"
    t.boolean "address_known"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "town_or_city"
    t.string "postcode", limit: 11
    t.string "country"
    t.boolean "phone_known"
    t.string "phone_number"
    t.boolean "personal_details_complete"
    t.boolean "contact_details_complete"
    t.bigint "user_id", null: false
    t.boolean "age_known"
    t.boolean "role_start_date_known"
    t.date "role_start_date"
    t.string "allegation_format"
    t.text "allegation_details"
    t.boolean "dbs_notified"
    t.boolean "allegation_details_complete"
    t.boolean "has_evidence"
    t.boolean "evidence_details_complete"
    t.string "employment_status"
    t.date "role_end_date"
    t.string "reason_leaving_role"
    t.string "previous_misconduct_reported"
    t.string "job_title"
    t.boolean "same_organisation"
    t.string "duties_format"
    t.text "duties_details"
    t.text "previous_misconduct_details"
    t.boolean "teacher_role_complete"
    t.datetime "submitted_at", precision: nil
    t.string "working_somewhere_else"
    t.bigint "eligibility_check_id"
    t.boolean "work_location_known"
    t.string "work_organisation_name"
    t.string "work_address_line_1"
    t.string "work_address_line_2"
    t.string "work_town_or_city"
    t.string "work_postcode"
    t.boolean "organisation_address_known"
    t.string "organisation_name"
    t.string "organisation_address_line_1"
    t.string "organisation_address_line_2"
    t.string "organisation_town_or_city"
    t.string "organisation_postcode", limit: 11
    t.boolean "role_end_date_known"
    t.text "allegation_consideration_details"
    t.string "ni_number"
    t.boolean "ni_number_known"
    t.string "previous_misconduct_format"
    t.boolean "previous_misconduct_complete"
    t.text "declaration"
    t.index ["eligibility_check_id"], name: "index_referrals_on_eligibility_check_id"
    t.index ["user_id"], name: "index_referrals_on_user_id"
  end

  create_table "referrers", force: :cascade do |t|
    t.bigint "referral_id", null: false
    t.string "first_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.string "job_title"
    t.string "last_name"
    t.boolean "complete"
    t.index ["referral_id"], name: "index_referrers_on_referral_id"
  end

  create_table "reminder_emails", force: :cascade do |t|
    t.bigint "referral_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["referral_id"], name: "index_reminder_emails_on_referral_id"
  end

  create_table "staff", force: :cascade do |t|
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "view_support", default: false
    t.boolean "manage_referrals", default: false
    t.datetime "deleted_at", precision: nil
    t.boolean "developer", default: false
    t.index ["confirmation_token"], name: "index_staff_on_confirmation_token", unique: true
    t.index ["email"], name: "index_staff_on_email", unique: true
    t.index ["invitation_token"], name: "index_staff_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_staff_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_staff_on_invited_by"
    t.index ["reset_password_token"], name: "index_staff_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_staff_on_unlock_token", unique: true
  end

  create_table "uploads", force: :cascade do |t|
    t.string "section", null: false
    t.string "filename", default: "", null: false
    t.string "uploadable_type"
    t.bigint "uploadable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "malware_scan_result", default: "pending", null: false
    t.index ["uploadable_type", "uploadable_id"], name: "index_uploads_on_uploadable"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "secret_key"
    t.integer "otp_guesses", default: 0
    t.datetime "otp_created_at", precision: nil
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  create_table "validation_errors", force: :cascade do |t|
    t.string "form_object"
    t.jsonb "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "organisations", "referrals"
  add_foreign_key "referrals", "eligibility_checks"
  add_foreign_key "referrals", "users"
  add_foreign_key "referrers", "referrals"
  add_foreign_key "reminder_emails", "referrals"
end
