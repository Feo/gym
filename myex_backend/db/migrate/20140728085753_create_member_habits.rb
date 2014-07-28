class CreateMemberHabits < ActiveRecord::Migration
  def change
    create_table :member_habits do |t|
      t.integer :member_id
      t.boolean :smoking
      t.integer :smoking_times
      t.boolean :drinking
      t.integer :drinking_times
      t.boolean :drug
      t.text :drug_name
      t.text :drug_reason
      t.text :disease_history
      t.float :sleep_amount
      t.datetime :sleep_time
      t.string :sleep_quality
      t.string :self_assessment

      t.timestamps
    end
  end
end
