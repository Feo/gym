class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :title
      t.string :image_file_name
      t.integer :image_file_size, :default => 0
      t.integer :user_id
      t.string :time


      t.timestamps
    end
  end
end
