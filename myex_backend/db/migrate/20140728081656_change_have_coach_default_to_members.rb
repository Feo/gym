class ChangeHaveCoachDefaultToMembers < ActiveRecord::Migration
  def change
    change_column :members, :have_coach,  :boolean, :default => false
  end
end
