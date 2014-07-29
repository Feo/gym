class MemberHabit < ActiveRecord::Base
  attr_accessible :member_id, :smoking, :smoking_times, :drinking, :drinking_times, :drug, :drug_name, :drug_reason, :disease_history, :sleep_amount, :sleep_time, :sleep_quality, :self_assessment

  serialize :drug_name
  serialize :drug_reason
  serialize :disease_history
end
