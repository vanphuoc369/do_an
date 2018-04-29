class User < ApplicationRecord
  attr_accessor :remember_token, :reset_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest

  validates :full_name, presence: {accept: true, message: "không được để trống"}
  validates :full_name, length: { maximum: 50, message: "không được vượt quá 50 ký tự" }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: {accept: true, message: "không được để trống"}, length: { maximum: 255, message: "không được vượt quá 255 ký tự" },
  format: { with: VALID_EMAIL_REGEX, message: "không đúng định dạng" },
  uniqueness: { case_sensitive: false, message: "đã được sử dụng để đăng ký tài khoản" }
  has_secure_password validations: false
  validates :password, length: {minimum: 6, message: "quá ngắn (tối thiểu 6 ký tự)"}, allow_nil: true
  validates :password, presence: {accept: true, message: "không được để trống"}, confirmation:{accept: true, message: "không khớp"}

  scope :users_activated, ->{where("activated = true")}
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_send_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_send_at < 6.hours.ago
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
