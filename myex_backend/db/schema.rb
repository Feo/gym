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

ActiveRecord::Schema.define(:version => 20141031030707) do

  create_table "actions", :force => true do |t|
    t.string   "kind"
    t.string   "name"
    t.string   "weight_or_duration"
    t.string   "group_or_speed"
    t.string   "time_or_rate"
    t.integer  "record_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "administrators", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "role"
    t.string   "token"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "last_login"
  end

  create_table "assessments", :force => true do |t|
    t.integer  "member_id"
    t.integer  "coach_id"
    t.string   "time"
    t.string   "head"
    t.string   "shoulders"
    t.string   "spine"
    t.string   "foot"
    t.string   "shoulder_and_chest"
    t.float    "height"
    t.float    "weight"
    t.float    "hr_resting"
    t.float    "blood_perssure_high"
    t.float    "blood_perssure_low"
    t.float    "chest_tricep"
    t.float    "abdomen_pelvis"
    t.float    "thighs"
    t.float    "lipid_percenteage"
    t.float    "metabolic_rate"
    t.float    "BMI"
    t.float    "arm_left"
    t.float    "arm_right"
    t.float    "chest_resting"
    t.float    "chest_inhale"
    t.float    "waist"
    t.float    "hips"
    t.float    "waist_hips"
    t.float    "leg_left"
    t.float    "leg_right"
    t.float    "calf_left"
    t.float    "calf_right"
    t.string   "body_bend"
    t.float    "flex_grade"
    t.float    "speed"
    t.float    "heart_rate"
    t.float    "heart_mark"
    t.float    "heart_grade"
    t.string   "chest"
    t.string   "abdomen"
    t.string   "legs"
    t.string   "advice"
    t.string   "conclusion"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "submitter"
    t.string   "photo_url_1"
    t.string   "photo_url_2"
  end

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
    t.string   "photo_url"
    t.float    "accuracy_grade",       :default => 0.0
    t.float    "appetency_grade",      :default => 0.0
    t.float    "professional_grade",   :default => 0.0
    t.string   "level"
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
    t.string   "submitter"
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
    t.boolean  "have_coach",         :default => false
    t.integer  "coach_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.float    "grade"
    t.datetime "grade_time"
    t.string   "token"
    t.boolean  "activated",          :default => false
    t.string   "photo_url"
    t.float    "accuracy_grade",     :default => 0.0
    t.float    "appetency_grade",    :default => 0.0
    t.float    "professional_grade", :default => 0.0
    t.string   "level"
  end

  create_table "messages", :force => true do |t|
    t.string   "content",            :default => ""
    t.string   "member_phone",       :default => ""
    t.string   "coach_phone",        :default => ""
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "member_phone_array", :default => ""
    t.string   "coach_phone_array",  :default => ""
    t.string   "submitter"
  end

  create_table "notices", :force => true do |t|
    t.text     "content"
    t.text     "member_phone"
    t.text     "coach_phone"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "title"
    t.string   "category"
    t.text     "member_phone_array"
    t.text     "coach_phone_array"
  end

  create_table "photos", :force => true do |t|
    t.string   "title"
    t.string   "image_file_name"
    t.integer  "image_file_size", :default => 0
    t.integer  "member_id"
    t.string   "time"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "image"
    t.boolean  "category",        :default => false
    t.integer  "coach_id"
  end

  create_table "records", :force => true do |t|
    t.string   "time"
    t.string   "submitter"
    t.boolean  "template",   :default => false
    t.integer  "member_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

end
