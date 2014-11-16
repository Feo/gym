class Action < ActiveRecord::Base
  attr_accessible :kind, :name, :weight_or_duration, :group_or_speed, :time_or_rate, :record_id
end
