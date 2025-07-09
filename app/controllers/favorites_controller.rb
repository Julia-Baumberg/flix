class FavoritesController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def create
    @movie.favorites.create!(user: current_user)
    redirect_to movie_path(@movie)
  end

  def destroy
    current_user.favorites.find(params[:id]).destroy
    redirect_to movie_path(@movie)
  end

  private

  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end
end
