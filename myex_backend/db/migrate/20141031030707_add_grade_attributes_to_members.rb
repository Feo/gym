class AddGradeAttributesToMembers < ActiveRecord::Migration
  def change
    add_column :members, :accuracy_grade,  :float, :default => 0.0
    add_column :members, :appetency_grade,  :float, :default => 0.0
    add_column :members, :professional_grade,  :float, :default => 0.0
    add_column :members, :level,  :string
  end
end
