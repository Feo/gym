class SetDefaultValueToMembers < ActiveRecord::Migration
  def up
    change_column :members, :level,  :string, :default => "0"
    change_column :members, :score,  :integer, :default => 0
  end

  def down
    change_column :members, :level,  :string, :default => ""
    change_column :members, :score,  :integer
  end
end
