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

ActiveRecord::Schema.define(version: 20170905090652) do

  create_table "currents", force: :cascade do |t|
    t.string "crypto_curr"
    t.string "curr"
    t.integer "exchange_id"
    t.decimal "buy", precision: 5, scale: 12
    t.decimal "sell", precision: 5, scale: 12
    t.decimal "last_hour_min", precision: 5, scale: 12
    t.decimal "last_day_min", precision: 5, scale: 12
    t.decimal "last_week_min", precision: 5, scale: 12
    t.decimal "last_month_min", precision: 5, scale: 12
    t.decimal "last_hour_max", precision: 5, scale: 12
    t.decimal "last_day_max", precision: 5, scale: 12
    t.decimal "last_week_max", precision: 5, scale: 12
    t.decimal "last_month_max", precision: 5, scale: 12
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
