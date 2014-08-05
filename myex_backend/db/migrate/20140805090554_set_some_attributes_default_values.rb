class SetSomeAttributesDefaultValues < ActiveRecord::Migration
  def change
    change_column :coaches, :experience,  :integer, :default => 0
    change_column :coaches, :grade,  :float, :default => 0.0
    change_column :coaches, :age,  :integer, :default => 0
    change_column :coaches, :nickname,  :string, :default => ""
    change_column :coaches, :name,  :string, :default => ""
    change_column :coaches, :province,  :string, :default => ""
    change_column :coaches, :city,  :string, :default => ""
    change_column :coaches, :district,  :string, :default => ""
    change_column :coaches, :street,  :string, :default => ""
    change_column :coaches, :email,  :string, :default => ""
    change_column :coaches, :profession,  :string, :default => ""
    change_column :coaches, :gender,  :string, :default => ""
  end
end
