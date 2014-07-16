class AddProfessionAndExperienceToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :profession, :string
    add_column :coaches, :experience, :string
  end
end
