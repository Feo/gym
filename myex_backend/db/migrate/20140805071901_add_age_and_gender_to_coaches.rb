class AddAgeAndGenderToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :age, :string
    add_column :coaches, :gender, :string
  end
end
