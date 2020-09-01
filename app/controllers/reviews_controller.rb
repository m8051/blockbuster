class ReviewsController < ApplicationController
  
  before_action :require_signin
  
  # We always want to run the set_movie method before running any action's code. To do that, 
  # use before_action to make sure the method is called before any action's code is executed.
  before_action :set_movie
  
  def index
    # Remember, because we're using nested routes, all incoming URLs to the ReviewsController will have
    # a :movie_id parameter that's filled in with the ID of the movie specified in the URL.
    # You'll need to use that parameter to find the corresponding movie in the database.
    # Then to get all the reviews that belong to that movie, use the @movie.reviews association.
    # By using this association method, you ensure that you'll only get back the reviews that are associated with the movie.
    # @movie = Movie.find(params[:movie_id])
    @reviews = @movie.reviews
  end

  # Chapter 24
  # Keying off the last error, define a new action in the ReviewsController. 
  # Begin the action by finding the movie and assigning it to a @movie variable. 
  # Then use that variable to instantiate a new Review object as a child of the movie and assign
  # it to a @review variable.
  def new
    # @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.new()
  end

  # Chapter 24
  # Before you can create a new review, you need to find the movie being reviewed 
  # (the form posts it in the :movie_id parameter).
  # Assign that movie to a @movie variable.

  # Then initialize a new Review object with the contents of the form and
  # (here comes the important part!)
  # remember to use the reviews.new method to associate it with the movie.
  # Assign the new review to a @review variable.
  
  # The key to pulling this off is to use the reviews association to initialize a new Review 
  # as a child of the existing Movie. Using @movie.reviews.new to 
  # initialize the review ensures that the review's movie_id foreign key is automatically 
  # set to point to the movie. After you've initialized the review, 
  # the rest of the action should be very familiar.
  def create
    # @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.new(reviews_param)

    # We assign the current_user value to the user attribute of the review object,
    # !! Remember !! 
    # When you declared belongs_to :user in the Review model, Rails dynamically 
    # defined a user attribute in the Review model. 
    # Reading the user attribute from a Review object returns the associated User object.
    @review.user = current_user
  
    if @review.save
      redirect_to movie_reviews_path(@movie), notice: "Thanks for your review!"
    else
      render :new
    end 
  end
  
  def show
    @review = @movie.reviews.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "No review found!"
      redirect_to @movie
  end
  
  def edit
    #@review = Review.find(params[:id])
    @review = @movie.reviews.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "No review found!"
      redirect_to @movie
    end
  
  def update
    #@review = Review.find(params[:id])
    @review = @movie.reviews.find(params[:id])
    if @review.update(reviews_param)
      redirect_to movie_reviews_url, notice: "Review successfully updated!"
    else
      render :new
    end
  end

  def destroy
    #@review = Review.find(params[:id])
    @review = @movie.reviews.find(params[:id])
    @review.destroy
    redirect_to movie_reviews_url, notice: "Review successfully deleted!"
  end
  
  private
    def reviews_param
      params.require(:review).permit(:comment, :stars)
    end
    
    def set_movie
      # @movie = Movie.find(params[:movie_id])
      @movie = Movie.find_by!(slug: params[:movie_id])
    end

end