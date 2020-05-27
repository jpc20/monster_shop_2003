class UsersController < ApplicationController

  def show

  end

  def new
    return @user if params[:user]
    @user = Hash.new("")
  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:message] = "Hi #{user.name} you have registered and logged in!"
      session[:user_id] = user.id
      redirect_to "/profile"
    elsif user.errors.added?(:email, :taken)
      flash[:message] = "This email already exists"
      @user = user_params
      render :new
    else
      flash[:notice] = "Please fill in #{user.errors.details.keys.join(", ")}"
      redirect_to '/register'
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end

end
