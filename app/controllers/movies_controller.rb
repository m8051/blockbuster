class MoviesController < ApplicationController

  # Gatekeeper to validate a user has signed in to control the admin access
  before_action :require_signin, except: [:index, :show]

  # Gatekeeper to validate a user is admin after signed in
  before_action :require_admin, except: [:index, :show]
  
  # Calls the set_movie method that finds a movie by its slug and assigns the movie to an @movie instance variable
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index
    @movies = Movie.send(movies_filter)
    # case params[:filter]
    # when "upcoming"
    #   @movies = Movie.upcoming
    # when "recent"
    #   @movies = Movie.recent(3)
    # when "hits"
    #   @movies = Movie.hit_movies
    # when "flops"
    #   @movies = Movie.flop_movies
    # else
    #   @movies = Movie.released
    # end
  end

  # Method not in use for now, I would need to render the shared/form in the show movie template
  # <%= render "shared/form", object: @review %> 
  def show
    # @movie = Movie.find(params[:id])
    # @movie = Movie.find_by!(slug: params[:id])
    # rescue ActiveRecord::RecordNotFound
    #  flash[:error] = "Invalid movie!"
    #   redirect_to movies_url
    @fans = @movie.fans
    @critics = @movie.critics
    @genres  = @movie.genres
    if current_user
      @favorite = current_user.favorites.find_by(movie_id: @movie.id)
    end
  end
  
  def edit
    # @movie = Movie.find(params[:id])
  end

  def update
    # @movie = Movie.find(params[:id])
    if @movie.update(movie_params)
      #redirect_to movie_path(@movie)
      
      # We can use a redirect with a flash as an argument( Rails shortcut )
      # flash[:notice] = "Movie successfully updated!"
      # redirect_to @movie
      redirect_to @movie, notice: "Movie successfully updated!"
      
    else
      render :new
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to @movie, notice: "Movie succesfully created"
    else
      render :new
    end
  end

  def destroy
    # @movie = Movie.find(params[:id])
    @movie.destroy()
    redirect_to @movie, alert: "Movie successfully deleted"
  end

  private

    def movie_params
      params.require(:movie).
        permit(:title, :description, :description, :director, :duration, :image_file_name, :rating, :released_on, :total_gross, genre_ids: [])
    end

    def movies_filter
      if params[:filter].in? %w(upcoming recent hit_movies flop_movies)
        params[:filter]
      else
        :released
      end
    end

    def set_movie
      @movie = Movie.find_by!(slug: params[:id])
    end


end
