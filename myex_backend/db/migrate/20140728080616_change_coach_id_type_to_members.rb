class ChangeCoachIdTypeToMembers < ActiveRecord::Migration
  def change
    change_column :members, :coach_id,  :integer
  end
end
