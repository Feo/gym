class SetAllAttributesDefaultValuesToCoaches < ActiveRecord::Migration
  def change
    change_column :coaches, :organization,  :string, :default => ""
    change_column :coaches, :qq,  :string, :default => ""
    change_column :coaches, :weixin,  :string, :default => ""
  end
end
