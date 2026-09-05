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


ActiveRecord::Schema[8.1].define(version: 2026_09_05_155132) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "card"
    t.integer "card_number"
    t.datetime "created_at", null: false
    t.string "deck"
    t.integer "deck_id"
    t.text "down_meaning"
    t.string "image"
    t.text "meaning"
    t.string "suit"
    t.datetime "updated_at", null: false
  end

  create_table "decks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "reading_id", null: false
    t.string "role"
    t.string "text"
    t.datetime "updated_at", null: false
    t.index ["reading_id"], name: "index_messages_on_reading_id"
  end

  create_table "reading_cards", force: :cascade do |t|
    t.bigint "card_id", null: false
    t.datetime "created_at", null: false
    t.bigint "reading_id", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_reading_cards_on_card_id"
    t.index ["reading_id"], name: "index_reading_cards_on_reading_id"
  end

  create_table "readings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "deck_id"
    t.string "style"
    t.string "subject"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["deck_id"], name: "index_readings_on_deck_id"
    t.index ["user_id"], name: "index_readings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.date "birth_date"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "messages", "readings"
  add_foreign_key "reading_cards", "cards"
  add_foreign_key "reading_cards", "readings"
  add_foreign_key "readings", "users"
end