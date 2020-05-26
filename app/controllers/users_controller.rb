class UsersController < ApplicationController

  def new

  end

  def create
    user = User.create(user_params)
    flash[:message] = "Hi #{user.name} you have registered and logged in!"
    session[:user_id] = user.id
    redirect_to "/merchants"
  end

private


def user_params
  params.permit(:name, :address, :city, :state, :zip, :email, :password, :confirm_password)
end

end
