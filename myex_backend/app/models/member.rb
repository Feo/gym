class Member < ActiveRecord::Base
  attr_accessible :nickname, :name, :gender, :age, :profession, :province, :city, :district, :street, :phone, :email, :qq, :weixin, :password, :password_confirmation, :sports, :have_coach, :coach_id, :grade, :grade_time, :token, :activated
  has_secure_password
  serialize :sports

  before_save :create_remember_token

  validates :name, :length => { :maximum => 50 }
  validates :phone, :presence => true, :uniqueness => true
  validates :password, :presence => true, :length => { :minimum => 6 }, :if => :password
  validates :password_confirmation, :presence => true, :if => :password_confirmation

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
