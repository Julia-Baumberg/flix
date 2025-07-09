class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email_or_username]) || User.find_by(username: params[:email_or_username].downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to(session[:intended_url] || user_path(user), notice: "Welcome back #{user.name}!")
      session[:intended_url] = nil
    else
      flash.now[:danger] = "I'm sorry, Dave, I'm afraid I can't do that.. you can't sign in this way"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to signin_path, status: :see_other, alert: 'Logged Out!'
  end
end
