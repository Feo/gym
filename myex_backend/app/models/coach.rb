class Coach < ActiveRecord::Base
  attr_accessible :nickname, :name, :province, :city, :district, :phone, :email, :organization, :notification, :open_question, :one_to_one_teaching, :one_to_many_teaching, :password, :password_confirmation, :profession, :experience, :street, :qq, :weixin, :grade, :gender, :age, :token, :activated, :photo_url
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
