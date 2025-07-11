class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, format: {
    with: /\S+@\S+/
  }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 10, allow_blank: true }
  validates :username,
            presence: true, format: { with: /\A[A-Z0-9]+\z/i },
            uniqueness: { case_sensitive: false }

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  scope :by_name, -> { order(:name) }
  scope :non_admins, -> { by_name.where(admin: false) }

  before_save :format_username
  before_save :format_email
  before_save :set_slug

  def gravatar_id
    Digest::MD5.hexdigest(email.downcase)
  end

  def format_username
    self.username = username.downcase
  end

  def format_email
    self.email = email.downcase
  end

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = username.parameterize
  end
end
