class AddAttributesToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :member_phone_array,  :text, :default => ""
    add_column :notices, :coach_phone_array,  :text, :default => ""
  end
end
