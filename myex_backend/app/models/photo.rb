class Photo < ActiveRecord::Base
  attr_accessible :title, :image_file_name, :image_file_size, :user_id, :time
end
