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

ActiveRecord::Schema.define(:version => 20140922082520) do

  create_table "coaches", :force => true do |t|
    t.string   "nickname",             :default => ""
    t.string   "name",                 :default => ""
    t.string   "province",             :default => ""
    t.string   "city",                 :default => ""
    t.string   "district",             :default => ""
    t.string   "phone"
    t.string   "email",                :default => ""
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "organization",         :default => ""
    t.boolean  "notification",         :default => true
    t.boolean  "open_question",        :default => true
    t.boolean  "one_to_one_teaching",  :default => true
    t.boolean  "one_to_many_teaching", :default => true
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.string   "profession",           :default => ""
    t.integer  "experience",           :default => 0
    t.string   "street",               :default => ""
    t.string   "qq",                   :default => ""
    t.string   "weixin",               :default => ""
    t.float    "grade",                :default => 0.0
    t.integer  "age",                  :default => 0
    t.string   "gender",               :default => ""
    t.string   "token"
    t.boolean  "activated",            :default => false
  end

  create_table "events", :force => true do |t|
    t.string   "content",         :default => ""
    t.string   "week",            :default => ""
    t.boolean  "whether_weekly",  :default => false
    t.string   "date",            :default => ""
    t.string   "time",            :default => ""
    t.string   "begin_date",      :default => ""
    t.string   "end_date",        :default => ""
    t.integer  "coach_id"
    t.string   "member_phone",    :default => ""
    t.boolean  "coach_approved",  :default => false
    t.string   "member_approved", :default => ""
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "day",             :default => ""
  end

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
    t.integer  "age"
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
    t.float    "grade"
    t.datetime "grade_time"
    t.string   "token"
    t.boolean  "activated",       :default => false
  end

  create_table "messages", :force => true do |t|
    t.string   "content",      :default => ""
    t.string   "member_phone", :default => ""
    t.string   "coach_phone",  :default => ""
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

end
