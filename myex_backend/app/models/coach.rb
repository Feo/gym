class Coach < ActiveRecord::Base
  attr_accessible :nickname, :name, :province, :city, :district, :phone, :email, :organization, :notification, :open_question, :one_to_one_teaching, :one_to_many_teaching, :password, :password_confirmation, :profession, :experience
  has_secure_password

  before_save { |user| user.email = email.downcase }
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
