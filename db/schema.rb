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

ActiveRecord::Schema.define(version: 20170421015443) do

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active"
    t.string   "mobile"
    t.string   "address"
    t.boolean  "sell_flow"
    t.float    "balance"
    t.float    "frozen_capital"
    t.string   "contact_person"
    t.float    "card_discount"
    t.integer  "parent_id"
    t.string   "description"
    t.integer  "assign_history_id"
    t.integer  "card_valid_period"
    t.string   "callback_url"
    t.float    "deposit",           default: 0.0
    t.boolean  "ip_ah",             default: true
    t.string   "ips"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
