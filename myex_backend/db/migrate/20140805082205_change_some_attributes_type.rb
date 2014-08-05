class ChangeSomeAttributesType < ActiveRecord::Migration
  def change
    change_column :members, :age,  :integer
    change_column :coaches, :age,  :integer
    change_column :coaches, :experience,  :integer
  end
end
