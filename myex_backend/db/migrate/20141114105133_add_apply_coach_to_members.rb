class AddApplyCoachToMembers < ActiveRecord::Migration
  def change
    add_column :members, :apply_coach,  :text
  end
end
