class Member < ActiveRecord::Base
  attr_accessible :nickname, :name, :gender, :age, :profession, :province, :city, :district, :street, :phone, :email, :qq, :weixin, :password, :password_confirmation, :sports, :have_coach, :coach_id, :grade
  has_secure_password
  serialize :sports

  before_save { |member| member.email = email.downcase }
  before_save :create_remember_token

  validates :name, :presence => true, :length => { :maximum => 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true, :format => { :with => VALID_EMAIL_REGEX }, :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true, :length => { :minimum => 6 }, :if => :password
  validates :password_confirmation, :presence => true, :if => :password_confirmation

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
