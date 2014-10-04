class RenameUserIdToMemberIdToPhotos < ActiveRecord::Migration
  def up
    rename_column :photos, :user_id, :member_id
  end

  def down
    rename_column :photos, :member_id, :user_id
  end
end
