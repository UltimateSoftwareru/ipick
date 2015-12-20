# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151220160545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.date    "data"
    t.integer "courier_id"
    t.integer "hours"
    t.integer "deals_count"
  end

  create_table "addresses", force: :cascade do |t|
    t.string  "name"
    t.string  "phone"
    t.integer "user_id"
    t.float   "latitude"
    t.float   "longitude"
  end

  create_table "addresses_orders", id: false, force: :cascade do |t|
    t.integer "order_id",   null: false
    t.integer "address_id", null: false
  end

  add_index "addresses_orders", ["order_id", "address_id"], name: "index_addresses_orders_on_order_id_and_address_id", using: :btree

  create_table "complains", force: :cascade do |t|
    t.string   "subject"
    t.string   "resolution"
    t.string   "from_type"
    t.string   "to_type"
    t.integer  "to_id"
    t.integer  "from_id"
    t.integer  "operator_id"
    t.integer  "deal_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "couriers", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "transport_id"
    t.integer  "status"
    t.string   "phone"
    t.float    "latitude"
    t.float    "longitude"
    t.json     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "couriers", ["confirmation_token"], name: "index_couriers_on_confirmation_token", unique: true, using: :btree
  add_index "couriers", ["email"], name: "index_couriers_on_email", using: :btree
  add_index "couriers", ["reset_password_token"], name: "index_couriers_on_reset_password_token", unique: true, using: :btree
  add_index "couriers", ["uid", "provider"], name: "index_couriers_on_uid_and_provider", unique: true, using: :btree

  create_table "deals", force: :cascade do |t|
    t.string   "status",               default: "in_progress"
    t.text     "comment"
    t.integer  "order_id"
    t.integer  "courier_id"
    t.boolean  "interested"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "delivered_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deals", ["order_id", "courier_id"], name: "uniq_deals", unique: true, using: :btree

  create_table "operators", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "email"
    t.string   "name"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.json     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "operators", ["confirmation_token"], name: "index_operators_on_confirmation_token", unique: true, using: :btree
  add_index "operators", ["email"], name: "index_operators_on_email", using: :btree
  add_index "operators", ["reset_password_token"], name: "index_operators_on_reset_password_token", unique: true, using: :btree
  add_index "operators", ["uid", "provider"], name: "index_operators_on_uid_and_provider", unique: true, using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "status",            default: "opened"
    t.string   "name"
    t.text     "description"
    t.boolean  "photo_confirm"
    t.integer  "user_id"
    t.integer  "value"
    t.integer  "price"
    t.integer  "weight"
    t.date     "delivery_estimate"
    t.datetime "grab_from"
    t.datetime "grab_to"
    t.datetime "deliver_from"
    t.datetime "deliver_to"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders_transports", id: false, force: :cascade do |t|
    t.integer "order_id",     null: false
    t.integer "transport_id", null: false
  end

  add_index "orders_transports", ["order_id", "transport_id"], name: "index_orders_transports_on_order_id_and_transport_id", using: :btree

  create_table "transports", force: :cascade do |t|
    t.string "name"
  end

end
