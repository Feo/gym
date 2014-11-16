class AddScoreToMembers < ActiveRecord::Migration
  def change
    add_column :members, :score,  :integer
  end
end
