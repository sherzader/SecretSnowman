class User < ActiveRecord::Base
  after_initialize :ensure_session_token

  attr_reader :password

  validates :password, length: { minimum: 6, allow_nil: true }
  validates :email, :session_token, :password_digest,
      :name, presence: true
  validates :taste, length: { maximum: 140, allow_nil: true }
  validates :email, :name, :session_token, uniqueness: true

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)

    user && user.is_password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password? password
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
