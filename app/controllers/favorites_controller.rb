class FavoritesController < ApplicationController
  
  # Gatekeeper to validate a user has signed in to control the admin access
  before_action :require_signin, except: [:index, :show]
  before_action :set_movie

  def create
    @movie.favorites.create!(user: current_user)
    redirect_to @movie
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy
    redirect_to @movie
  end

  private

  def set_movie
    # @movie = Movie.find(params[:movie_id])
    @movie = Movie.find_by!(slug: params[:movie_id])
  end

end
