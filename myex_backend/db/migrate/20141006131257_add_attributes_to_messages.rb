class AddAttributesToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :member_phone_array, :string, :default => ""
    add_column :messages, :coach_phone_array, :string, :default => ""
  end
end
