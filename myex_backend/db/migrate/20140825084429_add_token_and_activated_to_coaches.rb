class AddTokenAndActivatedToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :token, :string
    add_column :coaches, :activated, :boolean, :default => false
  end
end
