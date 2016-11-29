class User < ActiveRecord::Base
  GROUPS = ["Oct 2015 Cohort", "a/A Staff 2016"]

  attr_reader :password
  after_initialize :ensure_session_token, :ensure_default_taste

  validates :email, :session_token, :password_digest,
      :name, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :name, :session_token, uniqueness: true
  validates :group, inclusion: { in: GROUPS }
  validate :not_a_ghost

  belongs_to :secretsnowman, class_name: :User

  def self.groups
    GROUPS
  end

  def self.assign_secret_santas(group_name)
    user_ids = User.where(group: group_name).pluck(:id)
    offset = rand(user_ids.length - 2) + 1
    snowman_ids = user_ids.drop(offset) + user_ids.take(offset)

    snowman_ids.each_with_index do |el, idx|
      user = User.find(user_ids[idx])
      user.update_attributes(secretsnowman_id: el)
    end

    nil
  end

  def self.remove_secret_santas(group_name)
    users = User.where(group: group_name)

    users.each do |user|
      user.update_attributes(secretsnowman_id: nil)
    end

    nil
  end

  def not_a_ghost
    if group == GROUPS[0]
      errors[:boooo] << " - no hacking!"
      HackingAttempt.create(user_id: 0, description: "Ghost")
    end
  end

  def ensure_default_taste
    self.taste ||= "\nglow in the dark yoyo, \nglow in the dark socks,\na cute lunchbox,\na hug".html_safe
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)

    return nil if user.nil?
    user && user.valid_password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def valid_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  private
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end
end
