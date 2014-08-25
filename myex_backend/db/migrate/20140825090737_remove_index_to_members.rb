class RemoveIndexToMembers < ActiveRecord::Migration
  def up
    remove_index :members, :email
  end

  def down
    add_index :members, :email, unique: true
  end
end
