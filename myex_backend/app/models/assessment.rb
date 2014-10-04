class Assessment < ActiveRecord::Base
  attr_accessible :member_id, :coach_id, :time, :head, :shoulders, :spine, :foot, :shoulder_and_chest, :height, :weight, :hr_resting, :blood_perssure_high, :blood_perssure_low, :chest_tricep, :abdomen_pelvis, :thighs, :lipid_percenteage, :metabolic_rate, :BMI, :arm_left, :arm_right, :chest_resting, :chest_inhale, :waist, :hips, :waist_hips, :leg_left, :leg_right, :calf_left, :calf_right, :body_bend, :flex_grade, :speed, :heart_rate, :heart_mark, :heart_grade, :chest, :abdomen, :legs, :advice, :conclusion, :submitter
end
