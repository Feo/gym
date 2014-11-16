class AddDefaultValuesToMembers < ActiveRecord::Migration
  def up
    change_column :members, :nickname,  :string, :default => ""
    change_column :members, :name,  :string, :default => ""
    change_column :members, :gender,  :string, :default => ""
    change_column :members, :profession,  :string, :default => ""
    change_column :members, :province,  :string, :default => ""
    change_column :members, :city,  :string, :default => ""
    change_column :members, :district,  :string, :default => ""
    change_column :members, :street,  :string, :default => ""
    change_column :members, :phone,  :string, :default => ""
    change_column :members, :email,  :string, :default => ""
    change_column :members, :qq,  :string, :default => ""
    change_column :members, :weixin,  :string, :default => ""
    change_column :members, :sports,  :text, :default => ""
    change_column :members, :grade,  :string, :default => ""
    change_column :members, :level,  :string, :default => ""
  end

  def down
    change_column :members, :nickname,  :string
    change_column :members, :name,  :string
    change_column :members, :gender,  :string
    change_column :members, :profession,  :string
    change_column :members, :province,  :string
    change_column :members, :city,  :string
    change_column :members, :district,  :string
    change_column :members, :street,  :string
    change_column :members, :phone,  :string
    change_column :members, :email,  :string
    change_column :members, :qq,  :string
    change_column :members, :weixin,  :string
    change_column :members, :sports,  :text
    change_column :members, :grade,  :string
    change_column :members, :level,  :string
  end
end

