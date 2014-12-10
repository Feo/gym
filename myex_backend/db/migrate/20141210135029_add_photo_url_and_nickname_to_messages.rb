class AddPhotoUrlAndNicknameToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :photo_url,  :string
    add_column :messages, :nickname,  :string
  end
end
