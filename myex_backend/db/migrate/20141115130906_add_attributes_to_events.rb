class AddAttributesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :monday,  :boolean, :default => false
    add_column :events, :tuesday,  :boolean, :default => false
    add_column :events, :wednesday,  :boolean, :default => false
    add_column :events, :thursday,  :boolean, :default => false
    add_column :events, :friday,  :boolean, :default => false
    add_column :events, :saturday,  :boolean, :default => false
    add_column :events, :sunday,  :boolean, :default => false
  end
end
