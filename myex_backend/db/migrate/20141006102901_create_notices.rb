class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string :content, :default => ""
      t.string :member_phone, :default => ""
      t.string :coach_phone, :default => ""

      t.timestamps
    end
  end
end
