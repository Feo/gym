class ChangeMemberPhoneAndCoachPhoneTypeForNotice < ActiveRecord::Migration
  def up
    change_column :notices, :member_phone,  :text, :default => ""
    change_column :notices, :coach_phone,  :text, :default => ""
    change_column :notices, :content,  :text, :default => ""
  end

  def down
    change_column :notices, :member_phone,  :string, :default => ""
    change_column :notices, :coach_phone,  :string, :default => ""
    change_column :notices, :content,  :string, :default => ""
  end
end
