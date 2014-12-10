class AddMoreAttributesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :photo_url,  :string
    add_column :events, :nickname,  :string
    add_column :events, :title,  :string
  end
end
