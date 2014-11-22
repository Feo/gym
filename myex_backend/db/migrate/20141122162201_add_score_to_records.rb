class AddScoreToRecords < ActiveRecord::Migration
  def change
    add_column :records, :score,  :integer, :default => 0
  end
end
