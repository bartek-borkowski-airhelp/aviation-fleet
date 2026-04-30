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

ActiveRecord::Schema[8.1].define(version: 2026_04_30_075422) do
  create_table "aircraft_families", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "manufacturer_id", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["manufacturer_id"], name: "index_aircraft_families_on_manufacturer_id"
  end

  create_table "aircraft_variants", force: :cascade do |t|
    t.integer "aircraft_family_id", null: false
    t.string "body_type"
    t.datetime "created_at", null: false
    t.string "engine_type"
    t.date "entry_into_service"
    t.string "iata_code"
    t.float "max_cargo_tonnes"
    t.integer "max_passengers"
    t.string "name"
    t.string "range_category"
    t.integer "range_km"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["aircraft_family_id"], name: "index_aircraft_variants_on_aircraft_family_id"
  end

  create_table "airlines", force: :cascade do |t|
    t.string "country"
    t.datetime "created_at", null: false
    t.string "iata_code"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "fleet_entries", force: :cascade do |t|
    t.integer "aircraft_variant_id", null: false
    t.integer "airline_id", null: false
    t.float "avg_age_years"
    t.datetime "created_at", null: false
    t.integer "fleet_count"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["aircraft_variant_id"], name: "index_fleet_entries_on_aircraft_variant_id"
    t.index ["airline_id"], name: "index_fleet_entries_on_airline_id"
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string "country"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "aircraft_families", "manufacturers"
  add_foreign_key "aircraft_variants", "aircraft_families"
  add_foreign_key "fleet_entries", "aircraft_variants"
  add_foreign_key "fleet_entries", "airlines"
end
