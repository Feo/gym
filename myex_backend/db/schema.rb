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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140805071901) do

  create_table "coaches", :force => true do |t|
    t.string   "nickname"
    t.string   "name"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "phone"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "organization"
    t.boolean  "notification",         :default => true
    t.boolean  "open_question",        :default => true
    t.boolean  "one_to_one_teaching",  :default => true
    t.boolean  "one_to_many_teaching", :default => true
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "profession"
    t.string   "experience"
    t.string   "street"
    t.string   "qq"
    t.string   "weixin"
    t.float    "grade"
    t.string   "age"
    t.string   "gender"
  end

  add_index "coaches", ["email"], :name => "index_coaches_on_email", :unique => true

  create_table "member_habits", :force => true do |t|
    t.integer  "member_id"
    t.boolean  "smoking"
    t.integer  "smoking_times"
    t.boolean  "drinking"
    t.integer  "drinking_times"
    t.boolean  "drug"
    t.text     "drug_name"
    t.text     "drug_reason"
    t.text     "disease_history"
    t.float    "sleep_amount"
    t.datetime "sleep_time"
    t.string   "sleep_quality"
    t.string   "self_assessment"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "members", :force => true do |t|
    t.string   "nickname"
    t.string   "name"
    t.string   "gender"
    t.string   "age"
    t.string   "profession"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "street"
    t.string   "phone"
    t.string   "email"
    t.string   "qq"
    t.string   "weixin"
    t.string   "password_digest"
    t.string   "remember_token"
    t.text     "sports"
    t.boolean  "have_coach",      :default => false
    t.integer  "coach_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "members", ["email"], :name => "index_members_on_email", :unique => true

end
