class AddTitleAndCategoryToNotices < ActiveRecord::Migration
  def change
    add_column :notices, :title, :string
    add_column :notices, :category, :string
  end
end
