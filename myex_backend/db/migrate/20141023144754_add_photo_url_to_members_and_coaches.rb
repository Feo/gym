class AddPhotoUrlToMembersAndCoaches < ActiveRecord::Migration
  def change
    add_column :members, :photo_url, :string
    add_column :coaches, :photo_url, :string
  end
end
