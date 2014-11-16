class Message < ActiveRecord::Base
  attr_accessible :content, :member_phone, :coach_phone, :member_phone_array, :coach_phone_array, :submitter
end
