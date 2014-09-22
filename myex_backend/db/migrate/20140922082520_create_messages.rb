class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content, :default => ""
      t.string :member_phone, :default => ""
      t.string :coach_phone, :default => ""

      t.timestamps
    end
  end
end
