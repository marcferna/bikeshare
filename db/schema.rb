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

ActiveRecord::Schema.define(version: 20140329072554) do

  create_table "stations", force: true do |t|
    t.integer "station_id"
    t.string  "name"
    t.decimal "lat",          precision: 10, scale: 6
    t.decimal "lng",          precision: 10, scale: 6
    t.integer "dock_count"
    t.string  "landmark"
    t.date    "installed_at"
  end

  add_index "stations", ["landmark"], name: "index_stations_on_landmark", using: :btree

  create_table "trips", force: true do |t|
    t.integer  "trip_id"
    t.integer  "duration"
    t.datetime "started_at"
    t.integer  "start_station_id"
    t.datetime "ended_at"
    t.integer  "end_station_id"
    t.integer  "bike_id"
    t.integer  "subscription_type"
    t.integer  "zip_code"
  end

  add_index "trips", ["end_station_id"], name: "index_trips_on_end_station_id", using: :btree
  add_index "trips", ["start_station_id", "end_station_id"], name: "index_trips_on_start_station_id_and_end_station_id", using: :btree
  add_index "trips", ["start_station_id"], name: "index_trips_on_start_station_id", using: :btree

end
