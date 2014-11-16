class Administrator < ActiveRecord::Base
  attr_accessible :name, :email, :phone, :role, :token, :password, :password_confirmation, :last_login

  has_secure_password

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
