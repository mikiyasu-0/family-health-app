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

ActiveRecord::Schema[7.2].define(version: 2026_06_29_145746) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "body_memos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "memo_date", null: false
    t.text "content", null: false
    t.boolean "fallback", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "memo_date"], name: "index_body_memos_on_user_id_and_memo_date", unique: true
    t.index ["user_id"], name: "index_body_memos_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exercise_record_id", null: false
    t.string "body", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_record_id"], name: "index_comments_on_exercise_record_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "exercise_records", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "exercise_type", null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_exercise_records_on_user_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id", "group_id"], name: "index_group_memberships_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "invited_by_id", null: false
    t.bigint "used_by_id"
    t.integer "status", default: 0, null: false
    t.string "token", null: false
    t.datetime "expires_at", null: false
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_invitations_on_group_id"
    t.index ["invited_by_id"], name: "index_invitations_on_invited_by_id"
    t.index ["token"], name: "index_invitations_on_token", unique: true
    t.index ["used_by_id"], name: "index_invitations_on_used_by_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.string "notification_type", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exercise_record_id", null: false
    t.string "reaction_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_record_id"], name: "index_reactions_on_exercise_record_id"
    t.index ["user_id", "exercise_record_id", "reaction_type"], name: "idx_on_user_id_exercise_record_id_reaction_type_e9f543a667", unique: true
    t.index ["user_id"], name: "index_reactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "body_memos", "users"
  add_foreign_key "comments", "exercise_records"
  add_foreign_key "comments", "users"
  add_foreign_key "exercise_records", "users"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "invitations", "groups"
  add_foreign_key "invitations", "users", column: "invited_by_id"
  add_foreign_key "invitations", "users", column: "used_by_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "reactions", "exercise_records"
  add_foreign_key "reactions", "users"
end
