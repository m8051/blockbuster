class GenresController < ApplicationController
  # Gatekeeper to validate a user has signed in to control the admin access
  before_action :require_signin, except: [:index, :show]

  # Gatekeeper to validate a user is admin after signed in
  before_action :require_admin, except: [:index, :show]

  # Calls the set_genre method that finds a genre by its name and assigns the genre to an @genre instance variable
  before_action :set_genre, only: [:show, :edit, :update, :destroy]
  
  def index
    @genres = Genre.all
  end

  def show
    # @genre = Genre.find(params[:id])
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to @genre, notice: "Genre succesfully created"
    else
      render :new
    end
  end

  def edit
   # @genre = Genre.find(params[:id])
  end

  def update
    # @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to genres_url, notice: "Genre succesfully updated"
    else
      render :new
    end
  end

  def destroy
    # @genre = Genre.find(params[:id])
    @genre.destroy()
    redirect_to @genre, alert: "Genre successfully deleted"
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end

  def set_genre
    @genre = Genre.find_by!(slug: params[:id])
  end

end
