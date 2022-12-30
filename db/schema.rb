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

ActiveRecord::Schema.define(version: 2022_12_30_101707) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "date_of_birth"
    t.string "location"
    t.string "username"
    t.string "phone_number"
    t.integer "status", default: 0
    t.integer "admin_type", default: 1
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "banks", force: :cascade do |t|
    t.bigint "user_id"
    t.string "country"
    t.string "currency"
    t.string "account_holder_name"
    t.string "account_holder_type"
    t.string "routing_number"
    t.string "account_number"
    t.string "bank_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "bank_name"
    t.boolean "default", default: false
    t.index ["user_id"], name: "index_banks_on_user_id"
  end

  create_table "block_users", force: :cascade do |t|
    t.bigint "blocked_user_id"
    t.bigint "blocked_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["blocked_by_id"], name: "index_block_users_on_blocked_by_id"
    t.index ["blocked_user_id"], name: "index_block_users_on_blocked_user_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.float "rate"
    t.bigint "send_to_id"
    t.bigint "send_by_id"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_time", default: [], array: true
    t.datetime "end_time", default: [], array: true
    t.index ["send_by_id"], name: "index_bookings_on_send_by_id"
    t.index ["send_to_id"], name: "index_bookings_on_send_to_id"
  end

  create_table "camera_details", force: :cascade do |t|
    t.string "model"
    t.integer "camera_type"
    t.text "equipment", default: [], array: true
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "others", default: [], array: true
    t.index ["user_id"], name: "index_camera_details_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "token"
    t.string "number"
    t.string "exp_month"
    t.integer "exp_year"
    t.integer "cvc"
    t.string "brand"
    t.string "country"
    t.string "card_holder_name"
    t.boolean "default", default: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_cards_on_user_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.integer "unread_messages", default: 0
    t.boolean "is_blocked", default: false
    t.integer "blocked_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recipient_id"], name: "index_conversations_on_recipient_id"
    t.index ["sender_id"], name: "index_conversations_on_sender_id"
  end

  create_table "interests", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "job_posts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_id"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["post_id"], name: "index_job_posts_on_post_id"
    t.index ["user_id"], name: "index_job_posts_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.boolean "is_read", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "mobile_devices", force: :cascade do |t|
    t.string "mobile_token"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_mobile_devices_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.boolean "is_read", default: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "notification_type"
    t.bigint "send_by_id"
    t.string "send_by_name"
    t.index ["send_by_id"], name: "index_notifications_on_send_by_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.string "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "package_id"
    t.string "price_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "permalink"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["permalink"], name: "index_pages_on_permalink"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.datetime "start_time", default: [], array: true
    t.datetime "end_time", default: [], array: true
    t.float "rate"
    t.string "location"
    t.text "camera_type", default: [], array: true
    t.text "description"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "recent_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "recent_user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["recent_user_id"], name: "index_recent_users_on_recent_user_id"
    t.index ["user_id"], name: "index_recent_users_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "description"
    t.bigint "review_by_id"
    t.bigint "review_to_id"
    t.bigint "booking_id"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
    t.index ["review_by_id"], name: "index_reviews_on_review_by_id"
    t.index ["review_to_id"], name: "index_reviews_on_review_to_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.text "month", default: [], array: true
    t.text "day", default: [], array: true
    t.string "start_time"
    t.string "end_time"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_schedules_on_user_id"
  end

  create_table "social_media", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_social_media_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "package_id"
    t.string "subscription_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["package_id"], name: "index_subscriptions_on_package_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "support_conversations", force: :cascade do |t|
    t.bigint "support_id"
    t.integer "recipient_id"
    t.integer "sender_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["support_id"], name: "index_support_conversations_on_support_id"
  end

  create_table "support_messages", force: :cascade do |t|
    t.text "body"
    t.integer "sender_id"
    t.bigint "support_conversation_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["support_conversation_id"], name: "index_support_messages_on_support_conversation_id"
  end

  create_table "supports", force: :cascade do |t|
    t.string "ticket_number"
    t.text "description"
    t.integer "status", default: 0
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_supports_on_user_id"
  end

  create_table "talents", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_interests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "interest_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["interest_id"], name: "index_user_interests_on_interest_id"
    t.index ["user_id"], name: "index_user_interests_on_user_id"
  end

  create_table "user_talents", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "talent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["talent_id"], name: "index_user_talents_on_talent_id"
    t.index ["user_id"], name: "index_user_talents_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "location"
    t.integer "age"
    t.string "experience"
    t.float "rate"
    t.string "country"
    t.string "city"
    t.string "sex"
    t.integer "pronoun"
    t.float "latitude"
    t.float "longitude"
    t.integer "profile_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "otp"
    t.datetime "otp_expiry"
    t.string "login_type"
    t.boolean "profile_completed", default: false
    t.string "stripe_customer_id"
    t.string "stripe_connect_id"
    t.string "country_code"
    t.string "full_name"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "camera_details", "users"
  add_foreign_key "cards", "users"
  add_foreign_key "job_posts", "posts"
  add_foreign_key "job_posts", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "mobile_devices", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "schedules", "users"
  add_foreign_key "social_media", "users"
  add_foreign_key "subscriptions", "packages"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "support_conversations", "supports"
  add_foreign_key "support_messages", "support_conversations"
  add_foreign_key "supports", "users"
  add_foreign_key "user_interests", "interests"
  add_foreign_key "user_interests", "users"
  add_foreign_key "user_talents", "talents"
  add_foreign_key "user_talents", "users"
end
