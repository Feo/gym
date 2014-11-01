class AddGradeAttributesToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :accuracy_grade,  :float, :default => 0.0
    add_column :coaches, :appetency_grade,  :float, :default => 0.0
    add_column :coaches, :professional_grade,  :float, :default => 0.0
    add_column :coaches, :level,  :string
  end
end
