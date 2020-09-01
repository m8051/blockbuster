class Review < ApplicationRecord
  # Look up again chapter 21 One-to-Many: belongs_to
  belongs_to :movie
  belongs_to :user
  
  # Use of a built-in model validations to enforce the following rules about a movie:
  # No need of the name validation, column name removed in the migration 20200820123729_make_reviews_a_join_table
  # validates :name, presence: true
  validates :comment, length: { minimum: 4 }
  
  STARS = [1, 2, 3, 4, 5]

  validates :stars, inclusion: {
    in: STARS,
    message: "must be between 1 and 5"
  }
  
  # Declare a past_n_days scope that takes the number of days as a parameter and returns the reviews written during that period.
  # As a hint, remember in Rails you can use 3.days.ago to get the date as of 3 days ago.
  scope :past_n_days,  lambda { |days| where("created_at >= ?" , days.days.ago) }

  scope :grossed_less_than, ->(amount) { released.where("total_gross < ?", amount) }
  scope :grossed_greater_than, ->(amount) { released.where("total_gross > ?", amount) }

  def stars_as_percent
    (stars / 5.0) * 100.0
  end
  
  # scope :released, lambda { where("released_on < ?",Time.now).order("released_on desc") }
  def self.released
    where("released_on"<"?",Time.now).order("released_on desc")
  end

end
