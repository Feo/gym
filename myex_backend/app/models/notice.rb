class Notice < ActiveRecord::Base
  attr_accessible :content, :member_phone, :coach_phone, :title, :category, :member_phone_array, :coach_phone_array

  validates :title, :presence => true
  validates :content, :presence => true
end
