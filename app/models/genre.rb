class Genre < ApplicationRecord
  
  # Callback Chapter 40
  before_save :set_slug

  # Chapter 38
  has_many :characterizations, dependent: :destroy
  has_many :movies, through: :characterizations
  
  validates :name, presence: true, uniqueness: true
  
  def to_param
    slug
  end

  private

    def set_slug
      self.slug = name.parameterize+"-"+"movies"
    end

end
