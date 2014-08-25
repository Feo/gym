class RemoveIndexToCoaches < ActiveRecord::Migration
  def up
    remove_index :coaches, :email
  end

  def down
    add_index :coaches, :email, unique: true
  end
end
