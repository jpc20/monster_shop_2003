class UsersController < ApplicationController

  def show

  end

  def new

  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:message] = "Hi #{user.name} you have registered and logged in!"
      session[:user_id] = user.id
      redirect_to "/profile"
    else
      flash[:message] = "This email already exists"
      redirect_to '/register'
    end
  end

private


def user_params
  params.permit(:name, :address, :city, :state, :zip, :email, :password)
end

end
