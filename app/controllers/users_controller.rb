class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_signin, except: %i[new create]
  before_action :require_correct_user, only: %i[edit update]
  before_action :require_admin, only: %i[destroy]
  def index
    @users = User.non_admins
  end

  def show
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: 'User signed up successfully!'
    else
      flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Account successfully updated!'
    else
      flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    # session[:user_id] = nil
    redirect_to movies_path, status: :see_other, alert: 'Account successfully deleted!'
  end

  private

  def user_params
    params.require(:user)
          .permit(:name,
                  :email,
                  :password,
                  :password_confirmation,
                  :username)
  end

  def set_user
    @user = User.find_by!(slug: params[:id])
  end

  def require_correct_user
    redirect_to movies_path, status: :see_other, alert: 'Not authorized to access account!' unless current_user?(@user)
  end
end
