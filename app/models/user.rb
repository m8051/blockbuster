class User < ApplicationRecord
  
  # Callback Bonus Chapter 40
  before_save :format_username

  has_many :reviews , dependent: :destroy
  has_many :favorites, dependent: :destroy

  # Through Association chapter 37
  has_many :favorite_movies, through: :favorites, source: :movie


  has_secure_password

  # Use of a built-in model validations to enforce the following rules about a user:
  validates :username, presence: true, format: { with: /\A[A-Z0-9]+\z/i }, uniqueness: { case_sensitive: false }, length: { minimum: 6 }
  validates :name,  presence: true
  validates :email, presence: true, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 10, allow_blank: true }

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  # Returns all Users ordered by their name in alphanumerical
  scope :by_name, lambda { order("name") }

  # Returns all non admin users ordered by alphanumerical
  scope :not_admins, lambda { by_name.where(admin: false) }
  
  def to_param
    username
  end

  private

    def format_username
      self.username = username.lowercase
    end

  end
