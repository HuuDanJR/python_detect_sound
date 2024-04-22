# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_04_01_091857) do

  create_table "accommodations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "note"
    t.datetime "date_pick", default: "2023-10-30 12:23:24"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "customer_id"
    t.integer "status", default: 1
    t.datetime "time_end", default: "2023-10-30 12:12:10"
    t.string "note_confirm", limit: 2000, default: ""
    t.string "note_cancel", limit: 2000, default: ""
    t.index ["customer_id"], name: "index_accommodations_on_customer_id"
  end

  create_table "attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "file", null: false
    t.string "file_hash", null: false
    t.integer "category", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "benefits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 500, default: ""
    t.bigint "attachment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status"
    t.string "name_ja", limit: 500, default: ""
    t.string "description_ja", limit: 4000, default: ""
    t.string "name_kr", limit: 500, default: ""
    t.string "description_kr", limit: 4000, default: ""
    t.string "name_cn", limit: 500, default: ""
    t.string "description_cn", limit: 4000, default: ""
    t.string "description", limit: 2000
    t.index ["attachment_id"], name: "index_benefits_on_attachment_id"
  end

  create_table "carts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_carts_on_customer_id"
    t.index ["product_id"], name: "index_carts_on_product_id"
  end

  create_table "chat_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "content"
    t.boolean "is_customer"
    t.boolean "is_read"
    t.bigint "user_id"
    t.bigint "chat_room_id"
    t.bigint "attachment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attachment_id"], name: "index_chat_messages_on_attachment_id"
    t.index ["chat_room_id"], name: "index_chat_messages_on_chat_room_id"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "chat_participants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chat_room_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "officer_id"
    t.index ["chat_room_id"], name: "index_chat_participants_on_chat_room_id"
    t.index ["officer_id"], name: "index_chat_participants_on_officer_id"
    t.index ["user_id"], name: "index_chat_participants_on_user_id"
  end

  create_table "chat_rooms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 512, default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "coupon_benefit_times", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "coupon_id"
    t.bigint "benefit_id"
    t.datetime "time_used"
  end

  create_table "coupon_benefits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "coupon_id", null: false
    t.bigint "benefit_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "count_usage"
    t.integer "total_usage"
    t.integer "status"
    t.string "note", limit: 2000, default: ""
    t.index ["benefit_id"], name: "index_coupon_benefits_on_benefit_id"
    t.index ["coupon_id"], name: "index_coupon_benefits_on_coupon_id"
  end

  create_table "coupon_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "benefit_ids"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "benefit_totals", default: ""
    t.text "description_ja"
    t.text "description_kr"
    t.text "description_cn"
    t.string "name_ja", limit: 1000, default: ""
    t.string "name_kr", limit: 1000, default: ""
    t.string "name_cn", limit: 1000, default: ""
  end

  create_table "coupons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "title"
    t.text "description"
    t.string "mb"
    t.string "no"
    t.string "issued"
    t.datetime "expired"
    t.bigint "customer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status"
    t.datetime "time_start", default: "2023-10-30 11:06:41"
    t.string "serial_no"
    t.text "description_ja"
    t.text "description_kr"
    t.text "description_cn"
    t.bigint "coupon_template_id"
    t.integer "used", default: 0
    t.string "note", limit: 2000, default: ""
    t.datetime "modified_date"
    t.string "name_ja", limit: 1000, default: ""
    t.string "name_kr", limit: 1000, default: ""
    t.string "name_cn", limit: 1000, default: ""
    t.index ["coupon_template_id"], name: "index_coupons_on_coupon_template_id"
    t.index ["customer_id"], name: "index_coupons_on_customer_id"
  end

  create_table "customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "age", default: 0
    t.string "card_number", limit: 50, default: ""
    t.decimal "cashless_balance", precision: 10, default: "0"
    t.integer "colour", default: 0
    t.string "colour_html", limit: 50, default: ""
    t.decimal "comp_balance", precision: 10, default: "0"
    t.integer "comp_status_colour", default: 0
    t.string "comp_status_colour_html", limit: 50, default: ""
    t.string "forename", limit: 50, default: ""
    t.decimal "freeplay_balance", precision: 10, default: "0"
    t.string "gender", limit: 10, default: ""
    t.boolean "has_online_account", default: false
    t.boolean "hide_comp_balance", default: false
    t.boolean "is_guest", default: false
    t.decimal "loyalty_balance", precision: 10, default: "0"
    t.integer "loyalty_points_available", default: 0
    t.string "membership_type_name", limit: 50, default: ""
    t.string "middle_name", limit: 50, default: ""
    t.integer "number", default: 0
    t.string "player_tier_name", limit: 50, default: ""
    t.string "player_tier_short_code", limit: 50, default: ""
    t.boolean "premium_player", default: false
    t.string "surname", limit: 50, default: ""
    t.string "title", limit: 10, default: ""
    t.boolean "valid_membership", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "attachment_id"
    t.datetime "date_of_birth"
    t.datetime "membership_last_issue_date"
    t.string "nationality"
    t.datetime "frame_start_date"
    t.datetime "frame_end_date"
    t.datetime "last_update_frame_point"
    t.index ["attachment_id"], name: "index_customers_on_attachment_id"
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "devices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "token"
    t.string "device_type"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "time_expired", precision: 6
    t.string "device_id", limit: 128, default: ""
    t.index ["token"], name: "index_devices_on_token", unique: true
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "drivers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "nickname"
    t.string "position"
    t.datetime "date_of_birth"
    t.string "phone"
    t.boolean "gender", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "gamethemes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "game_type_id"
    t.string "name"
    t.bigint "attachment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attachment_id"], name: "index_gamethemes_on_attachment_id"
  end

  create_table "group_roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_roles_on_group_id"
    t.index ["role_id"], name: "index_group_roles_on_role_id"
  end

  create_table "groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "introductions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "intro_index"
    t.bigint "attachment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attachment_id"], name: "index_introductions_on_attachment_id"
  end

  create_table "jackpot_game_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "jackpot_machines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "mc_number"
    t.string "mc_name"
    t.datetime "jp_date"
    t.float "jp_value", default: 0.0
    t.bigint "jackpot_game_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "mystery_jackpot_level", default: 0
    t.index ["jackpot_game_type_id"], name: "index_jackpot_machines_on_jackpot_game_type_id"
  end

  create_table "jackpot_real_times", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "data", limit: 2000, default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "jjbx_machines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "grand_name"
    t.decimal "grand_value", precision: 15, scale: 2
    t.string "major_name"
    t.decimal "major_value", precision: 15, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "log_mails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email", limit: 512, default: ""
    t.text "content"
    t.string "log_type", default: ""
    t.boolean "log_type_send", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "machine_reservations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.integer "machine_number"
    t.string "machine_name", default: ""
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string "customer_note", default: ""
    t.integer "booking_type", default: 1
    t.string "internal_note", default: ""
    t.integer "status", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "zone", default: ""
    t.string "results_play"
    t.string "approved_by"
    t.string "updated_by"
    t.bigint "gametheme_id"
    t.string "note_confirm", limit: 2000, default: ""
    t.string "note_cancel", limit: 2000, default: ""
    t.string "note_finish", limit: 2000, default: ""
    t.index ["customer_id"], name: "index_machine_reservations_on_customer_id"
    t.index ["gametheme_id"], name: "index_machine_reservations_on_gametheme_id"
  end

  create_table "memberships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "sub"
    t.integer "point"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "attachment_id"
    t.string "color_milestone", default: ""
    t.boolean "is_show_milestone", default: false, null: false
    t.boolean "is_show_name", default: false, null: false
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "content", size: :medium
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "title", default: ""
    t.text "content_ja", size: :medium
    t.text "content_kr", size: :medium
    t.text "content_cn", size: :medium
    t.string "title_ja", limit: 500
    t.string "title_kr", limit: 500
    t.string "title_cn", limit: 500
    t.string "short_description", limit: 1000
    t.string "short_description_ja", limit: 1000
    t.string "short_description_kr", limit: 1000
    t.string "short_description_cn", limit: 1000
    t.string "language", limit: 50
    t.boolean "is_draft", default: false
    t.integer "category", default: 1
    t.text "user_ids"
    t.boolean "is_send", default: false
    t.datetime "time_send"
    t.bigint "attachment_id"
    t.bigint "customer_attachment"
    t.string "name", limit: 2000, default: ""
    t.index ["attachment_id"], name: "index_messages_on_attachment_id"
  end

  create_table "mystery_jackpots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "jp_date", default: "2023-10-12 10:30:15"
    t.string "jp_game_theme"
    t.string "mc_number"
    t.string "mc_name"
    t.decimal "jp_value", precision: 15, scale: 2
    t.integer "jp_occurrence_id", default: 0
    t.boolean "is_send", default: false
    t.boolean "has_send", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "source_id", default: 0
    t.string "source_type", default: ""
    t.integer "notification_type", default: 1
    t.text "content", size: :medium
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status_type", default: 1
    t.integer "status", default: 1
    t.boolean "is_read", default: false
    t.string "title", limit: 500
    t.string "short_description", limit: 1000
    t.text "content_ja", size: :medium
    t.text "content_kr", size: :medium
    t.text "content_cn", size: :medium
    t.string "title_ja", limit: 500
    t.string "title_kr", limit: 500
    t.string "title_cn", limit: 500
    t.string "short_description_ja", limit: 1000
    t.string "short_description_kr", limit: 1000
    t.string "short_description_cn", limit: 1000
    t.integer "category", default: 1
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "oauth_access_grants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.string "code_challenge"
    t.string "code_challenge_method"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", limit: 500, null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "oauth_openid_requests", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "access_grant_id", null: false
    t.string "nonce", null: false
    t.index ["access_grant_id"], name: "fk_rails_77114b3b09"
  end

  create_table "offer_reactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "reaction_type"
    t.bigint "user_id"
    t.bigint "offer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["offer_id"], name: "index_offer_reactions_on_offer_id"
    t.index ["user_id"], name: "index_offer_reactions_on_user_id"
  end

  create_table "offer_subscribers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "time_send"
    t.boolean "is_send", default: false, null: false
    t.bigint "user_id"
    t.bigint "offer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["offer_id"], name: "index_offer_subscribers_on_offer_id"
    t.index ["user_id"], name: "index_offer_subscribers_on_user_id"
  end

  create_table "offers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "title", limit: 512, default: ""
    t.string "title_ja", limit: 512, default: ""
    t.string "title_kr", limit: 512, default: ""
    t.string "title_cn", limit: 512, default: ""
    t.text "description", size: :medium
    t.text "description_ja", size: :medium
    t.text "description_kr", size: :medium
    t.text "description_cn", size: :medium
    t.string "url_news", limit: 512, default: ""
    t.datetime "publish_date"
    t.boolean "is_highlight", default: false
    t.integer "offer_type", default: 2
    t.bigint "attachment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "time_end"
    t.integer "index_order", default: 1
    t.boolean "is_discover", default: false, null: false
    t.bigint "banner_attachment"
    t.index ["attachment_id"], name: "index_offers_on_attachment_id"
  end

  create_table "officer_customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "officer_id", null: false
    t.bigint "customer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["customer_id"], name: "index_officer_customers_on_customer_id"
    t.index ["officer_id"], name: "index_officer_customers_on_officer_id"
  end

  create_table "officers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", default: ""
    t.datetime "date_of_birth"
    t.boolean "gender", default: true
    t.string "home_town", default: ""
    t.string "nationality", limit: 50, default: ""
    t.string "language_support", limit: 50, default: ""
    t.boolean "online", default: false
    t.integer "status", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone", limit: 20, default: ""
    t.bigint "attachment_id"
    t.bigint "user_id"
    t.boolean "is_reception", default: false
    t.index ["attachment_id"], name: "index_officers_on_attachment_id"
    t.index ["user_id"], name: "index_officers_on_user_id"
  end

  create_table "order_products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.decimal "unit_price", precision: 10
    t.decimal "sub_total", precision: 10
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_order_products_on_order_id"
    t.index ["product_id"], name: "index_order_products_on_product_id"
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.decimal "total", precision: 10
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "internal_note"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
  end

  create_table "product_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "index_category", default: 1
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "sku", limit: 10, default: ""
    t.string "qrcode", default: ""
    t.string "name", default: ""
    t.decimal "base_price", precision: 10, default: "0"
    t.decimal "price", precision: 10, default: "0"
    t.integer "point_price", default: 0
    t.integer "product_type", default: 1
    t.bigint "attachment_id"
    t.bigint "product_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "customer_level"
    t.integer "beverage_type"
    t.boolean "is_hide", default: false
    t.text "description"
    t.integer "index_product", default: 1
    t.index ["attachment_id"], name: "index_products_on_attachment_id"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
  end

  create_table "promotion_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "promotion_reactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "reaction_type"
    t.bigint "user_id"
    t.bigint "promotion_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["promotion_id"], name: "index_promotion_reactions_on_promotion_id"
    t.index ["user_id"], name: "index_promotion_reactions_on_user_id"
  end

  create_table "promotion_subscribers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "time_send"
    t.boolean "is_send", default: false, null: false
    t.bigint "user_id"
    t.bigint "promotion_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["promotion_id"], name: "index_promotion_subscribers_on_promotion_id"
    t.index ["user_id"], name: "index_promotion_subscribers_on_user_id"
  end

  create_table "promotions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "terms", limit: 4000
    t.string "prize", limit: 4000
    t.string "issue_date"
    t.string "game_type"
    t.string "day_of_week"
    t.string "day_of_month"
    t.string "day_of_season"
    t.string "time"
    t.string "remark"
    t.integer "status"
    t.bigint "attachment_id", null: false
    t.bigint "promotion_category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "color", limit: 10, default: "#ffffff"
    t.bigint "banner_id"
    t.integer "promotion_type", default: 1
    t.boolean "is_highlight", default: false
    t.string "description", limit: 2000, default: ""
    t.index ["attachment_id"], name: "index_promotions_on_attachment_id"
    t.index ["banner_id"], name: "index_promotions_on_banner_id"
    t.index ["promotion_category_id"], name: "index_promotions_on_promotion_category_id"
  end

  create_table "pyramid_points", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "prize"
    t.integer "min_point"
    t.integer "max_point"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reservations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "address", limit: 1000, default: ""
    t.datetime "pickup_at"
    t.string "customer_note", default: ""
    t.integer "booking_type", default: 1
    t.integer "reservation_type", default: 1
    t.string "driver_name", default: ""
    t.string "driver_mobile", limit: 20, default: ""
    t.string "car_type", default: ""
    t.string "license_plate", limit: 15, default: ""
    t.datetime "arrival_at"
    t.string "internal_note", default: ""
    t.decimal "price", precision: 10, scale: 2
    t.decimal "distance", precision: 10
    t.datetime "drop_off_at"
    t.integer "status", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "current_location", limit: 1000, default: ""
    t.string "note_confirm", limit: 2000, default: ""
    t.string "note_cancel", limit: 2000, default: ""
    t.string "note_finish", limit: 2000, default: ""
    t.string "confirm_by", default: ""
    t.index ["customer_id"], name: "index_reservations_on_customer_id"
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "action"
    t.string "resource"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roulettes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", default: ""
    t.string "description", default: ""
    t.string "streaming_url", limit: 512, default: ""
    t.boolean "publish", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "setting_key"
    t.string "setting_value", limit: 10000
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "slides", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", default: ""
    t.integer "slide_index", default: 0
    t.bigint "attachment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "description", limit: 5000
    t.boolean "is_show", default: true
    t.index ["attachment_id"], name: "index_slides_on_attachment_id"
  end

  create_table "spas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "note"
    t.date "date_pick"
    t.time "time_pick"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "customer_id"
    t.integer "status", default: 1
    t.string "note_confirm", limit: 2000, default: ""
    t.string "note_cancel", limit: 2000, default: ""
    t.index ["customer_id"], name: "index_spas_on_customer_id"
  end

  create_table "staff_introduces", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "customer_number", default: 0
    t.string "customer_name", limit: 200, default: ""
    t.bigint "staff_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["staff_id"], name: "index_staff_introduces_on_staff_id"
  end

  create_table "staffs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", default: ""
    t.string "nick_name", default: ""
    t.boolean "gender", default: true
    t.string "position"
    t.string "code", limit: 6, default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "term_services", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.integer "index"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "attachment_id"
    t.index ["attachment_id"], name: "index_term_services_on_attachment_id"
  end

  create_table "user_first_logins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_first_logins_on_user_id"
  end

  create_table "user_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "session_token"
    t.string "language", limit: 2, default: "en"
    t.string "setting", default: "{\"notfication\":1,\"darkmode\":0,\"face_id\":0,\"finger\":0}"
    t.string "phone", limit: 20
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "oauth_openid_requests", "oauth_access_grants", column: "access_grant_id", on_delete: :cascade
end
