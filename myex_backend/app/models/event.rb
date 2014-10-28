class Event < ActiveRecord::Base
  attr_accessible :content, :week, :whether_weekly, :date, :time, :begin_date, :end_date, :coach_id, :member_phone, :coach_approved, :member_approved, :day, :submitter
end
