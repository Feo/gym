class AddCategoryToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :category, :boolean, :default => false
    add_column :photos, :coach_id, :integer
  end
end
