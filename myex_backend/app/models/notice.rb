class Notice < ActiveRecord::Base
  attr_accessible :content, :member_phone, :coach_phone, :title, :category

  validates :title, :presence => true
  validates :content, :presence => true
end
