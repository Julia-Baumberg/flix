# frozen_string_literal: true

class MoviesController < ApplicationController
  before_action :set_movie, only: %i[show edit update destroy]
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]

  # GET /movies
  # GET /movies.json
  def index
    @movies = Movie.send(movies_filter)
  end

  def show
    @review = @movie.reviews.new
    @fans = @movie.fans
    @favorite = current_user&.favorites&.find_by(movie_id: @movie.id)
    @genres = @movie.genres.order(name: :asc)

    # how to redirect back to movie page w/ error instead of review page
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movie_path(@movie), notice: 'Movie successfully created!'
    else
      flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @movie.update(movie_params)
      redirect_to movie_path(@movie), notice: 'Movie successfully updated!'
    else
      flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path, status: :see_other, alert: 'Movie successfully deleted!'
  end

  private

  def movie_params
    params.require(:movie)
          .permit(:title,
                  :description,
                  :rating,
                  :released_on,
                  :total_gross,
                  :director,
                  :duration,
                  :image_file_name, genre_ids: [])
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end

  def movies_filter
    if params[:filter].in? %w[upcoming recent hits flops]
      params[:filter]
    else
      :released
    end
  end
end
