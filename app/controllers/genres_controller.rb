class GenresController < ApplicationController
  before_action :require_signin, except: %i[index show]
  before_action :require_admin, except: %i[index show]
  before_action :set_genre, only: %i[show edit update destroy]

  def index
    @genres = Genre.all
  end

  def show
    @movie_genres = @genre.movies
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to genre_path(@genre), notice: 'Genre successfully created!'
    else
      flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @genre.update(genre_params)
      redirect_to genre_path(@genre), notice: 'Genre successfully updated!'
    else
      flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @genre.destroy
    redirect_to genres_path, status: :see_other, alert: 'Genre successfully deleted!'
  end

  private

  def genre_params
    params.require(:genre)
          .permit(:name)
  end

  def set_genre
    @genre = Genre.find_by!(params[:slug])
  end
end
