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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110710134709) do

  create_table "cities", :force => true do |t|
    t.string   "name_en"
    t.string   "name_ja"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "city_codes", :force => true do |t|
    t.integer  "city_code"
    t.string   "prefecture"
    t.string   "prefecture_kana"
    t.string   "prefecture_roman"
    t.string   "city"
    t.string   "city_kana"
    t.string   "city_roman"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "city_codes", ["city"], :name => "index_city_codes_on_city"
  add_index "city_codes", ["city_kana"], :name => "index_city_codes_on_city_kana"
  add_index "city_codes", ["city_roman"], :name => "index_city_codes_on_city_roman"
  add_index "city_codes", ["prefecture"], :name => "index_city_codes_on_prefecture"
  add_index "city_codes", ["prefecture_kana"], :name => "index_city_codes_on_prefecture_kana"
  add_index "city_codes", ["prefecture_roman"], :name => "index_city_codes_on_prefecture_roman"

  create_table "intensities", :force => true do |t|
    t.integer  "quake_id"
    t.string   "value"
    t.string   "location_type"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quakes", :force => true do |t|
    t.datetime "quake_time"
    t.datetime "report_time"
    t.integer  "region_id"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "magnitude"
    t.string   "depth"
    t.string   "tenki_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quakes", ["quake_time"], :name => "index_quakes_on_quake_time"

  create_table "regions", :force => true do |t|
    t.string   "name_en"
    t.string   "name_ja"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
