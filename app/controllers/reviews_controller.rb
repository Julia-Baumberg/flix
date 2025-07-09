class ReviewsController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def show
    @review = @movie.reviews.find_by(id: params[:id])
    @user = @review.user
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to movie_review_path(@movie, @review), notice: 'Review successfully created!'
    else
      flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
      if params[:review][:current_url] == movie_url(@movie)
        render 'movies/show', status: :unprocessable_entity
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
    @review = @movie.reviews.find_by(id: params[:id])
  end

  def update
    @review = @movie.reviews.find_by(id: params[:id])
    if @review.update(review_params)
      redirect_to movie_review_path(@movie, @review), notice: 'Review successfully updated!'
    else
      flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review = @movie.reviews.find_by(id: params[:id])
    @review.destroy
    redirect_to(movies_path, status: :see_other, alert: 'Review successfully deleted!')
  end

  private

  def review_params
    params.require(:review)
          .permit(:movie_id,
                  :stars,
                  :comment)
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end
end
