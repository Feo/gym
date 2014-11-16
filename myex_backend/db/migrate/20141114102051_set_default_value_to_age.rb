class SetDefaultValueToAge < ActiveRecord::Migration
  def up
    change_column :members, :age,  :integer, :default => 0
  end

  def down
    change_column :members, :age,  :integer
  end
end
