class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.integer :member_id
      t.integer :coach_id
      t.string :time
      t.string :head
      t.string :shoulders
      t.string :spine
      t.string :foot
      t.string :shoulder_and_chest
      t.float :height
      t.float :weight
      t.float :hr_resting
      t.float :blood_perssure_high
      t.float :blood_perssure_low
      t.float :chest_tricep
      t.float :abdomen_pelvis
      t.float :thighs
      t.float :lipid_percenteage
      t.float :metabolic_rate
      t.float :BMI
      t.float :arm_left
      t.float :arm_right
      t.float :chest_resting
      t.float :chest_inhale
      t.float :waist
      t.float :hips
      t.float :waist_hips
      t.float :leg_left
      t.float :leg_right
      t.float :calf_left
      t.float :calf_right
      t.string :body_bend
      t.float :flex_grade
      t.float :speed
      t.float :heart_rate
      t.float :heart_mark
      t.float :heart_grade
      t.string :chest
      t.string :abdomen
      t.string :legs
      t.string :advice
      t.string :conclusion

      t.timestamps
    end
  end
end
