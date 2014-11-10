class ChangeSleepTimeToStringToMemberHabits < ActiveRecord::Migration
  def up
    change_column :member_habits, :sleep_time,  :string
  end

  def down
    change_column :member_habits, :sleep_time,  :datetime
  end
end
