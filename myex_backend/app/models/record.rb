class Record < ActiveRecord::Base
  attr_accessible :time, :submitter, :template, :member_id
end
