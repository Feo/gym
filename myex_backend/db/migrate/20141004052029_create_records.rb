class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :time
      t.string :submitter
      t.boolean :template, :default => false
      t.integer :member_id

      t.timestamps
    end
  end
end
