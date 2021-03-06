class Photo < ActiveRecord::Base
  attr_accessible :title, :image_file_name, :image_file_size, :member_id, :time, :image_file_size, :category, :coach_id

  mount_uploader :image, ImageUploader
end
