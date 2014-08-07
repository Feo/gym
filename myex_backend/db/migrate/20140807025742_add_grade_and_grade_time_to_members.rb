class AddGradeAndGradeTimeToMembers < ActiveRecord::Migration
  def change
    add_column :members, :grade, :float
    add_column :members, :grade_time, :datetime
  end
end
