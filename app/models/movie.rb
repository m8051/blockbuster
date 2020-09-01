class Movie < ApplicationRecord
  
  # Callbacks (Chapter 40)
  before_save :set_slug

  # Declaring the has_many Association with the review Model but in the plural 
  # form of the child and also the database name which is in plural
  #
  # This declaration tells Rails to expect a movie_id foreign key column in the table wrapped 
  # by the Review model, which by convention will be the reviews table. 
  # Rails also dynamically defines methods for accessing a movie's related reviews.
  
  # Look up again chapter 22 One-to-Many: has_many
  # has_many :reviews , dependent: :destroy

  # Wanted to change the ordering of movie reviews 
  # so that the most-recent review appeared first in the listing on http://localhost:3000/movies/1/reviews.
  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  
  has_many :favorites, dependent: :destroy
  
  # Through Association, chapter 37
  has_many :fans, through: :favorites, source: :user

  # Through Association, chapter 37, Bonus Round
  has_many :critics, through: :reviews, source: :user

  # Through Association, chapter 38.
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  # Use of a built-in model validations to enforce the following rules about a movie:
  validates :title, presence: true, uniqueness: true
  validates :released_on, :director, :duration, presence: true
  validates :description, length: { maximum: 1000 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }

  validates :image_file_name, format: {
    with: /\w+\.(jpg|png)\z/i,
    message: "must be a JPG or PNG image"
  }

  # Ratings is a constang in Ruby
  RATINGS = %w(G PG PG-13 R NC-17)
  validates :rating, inclusion: { in: RATINGS }

  # For example, if a movie has more than 50 reviews and the average review is 4 stars or better,
  # then the movie shouldn't be a flop regardless of the total gross.
  def flop?
    if (reviews.sum(:stars) > 3 && (reviews.average(:stars) >= 3))
      false
    else
      total_gross.blank? || total_gross < 255_000_000
    end
  end

  # Chapter 39, Custom Scopes and Routes
  scope :released, lambda { where("released_on < ?", Time.now).order("released_on desc") }
  scope :upcoming, lambda { where("released_on > ?", Time.now).order("released_on asc") }
  scope :recent,   lambda { |max=5| released.limit(max) }

  # Remember that class-level methods are defined on self.
  # I can call these methods using the class (e.g. Movie).
  # def self.released
  #   where("released_on"<"?",Time.now).order("released_on desc")
  # end
  
  scope :hit_movies,  -> { released.where("total_gross >= 300000000").order(total_gross: :desc) }
  scope :flop_movies, -> { released.where("total_gross < 22500000").order(total_gross: :asc) }

  # def self.hit_movies
  #   where("total_gross > ?", 300_000_000).order("total_gross desc")
  # end

  # def self.flop_movies
  #   where("total_gross > ?", 225_000_000).order("total_gross asc")
  # end


  def self.recently_added_movies
    where("created_at").order("created_at desc").limit(3)
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent 
    (self.average_stars / 5.0) * 100
  end
  
  # You don't have to use self when reading the slug attribute.
  # You only have to use self when writing to an attribute.
  def to_param
    slug
  end

  private

    def set_slug
      self.slug = title.parameterize
    end

end
