class AddDayToEvents < ActiveRecord::Migration
  def change
    add_column :events, :day, :string, :default => ""
  end
end
