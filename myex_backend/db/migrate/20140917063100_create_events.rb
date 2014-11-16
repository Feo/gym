class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :content, :default => ""
      t.string :week, :default => ""
      t.boolean :whether_weekly, :default => false
      t.string :date, :default => ""
      t.string :time, :default => ""
      t.string :begin_date, :default => ""
      t.string :end_date, :default => ""
      t.integer :coach_id
      t.string :member_phone, :default => ""
      t.boolean :coach_approved, :default => false
      t.string :member_approved, :default => ""


      t.timestamps
    end
  end
end
