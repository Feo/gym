class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :kind
      t.string :name
      t.string :weight_or_duration
      t.string :group_or_speed
      t.string :time_or_rate
      t.integer :record_id

      t.timestamps
    end
  end
end
