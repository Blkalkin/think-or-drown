class User < ApplicationRecord
  attr_reader :password

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6, allow_nil: true }

  has_secure_password
  has_many :portfolios, dependent: :destroy
  
  before_validation :ensure_session_token
  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    if user&.authenticate(password)
      user
    else
      nil
    end
  end

  def password=(plain_password)
    @password = plain_password
    self.password_digest = BCrypt::Password.create(plain_password)
  end

  def is_password?(plain_password)
    password_obj = BCrypt::Password.new(password_digest)
    password_obj.is_password?(plain_password)
  end

  def reset_session_token!
    self.session_token = generate_session_token
    save!
    session_token
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
  end


  def get_value
    portfolios.sum('bought_price * bought_quantity')
  end

  private
  def generate_session_token
    loop do
      token = SecureRandom::urlsafe_base64
      return token unless User.exists?(session_token: token)
    end
  end
end
  