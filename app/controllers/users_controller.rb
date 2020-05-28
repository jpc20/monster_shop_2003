class UsersController < ApplicationController

  def show
    render file: "/public/404" unless current_user

  end

  def new
    return @user if params[:user]
    @user = Hash.new("")
  end

  def edit

  end

  def password

  end

  def password_change
    current_user.update_attribute(:password, params[:password])
    if current_user.save
      flash[:success] = "Your password has been changed!"
      redirect_to "/profile"
    end
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

  def update
    current_user.update(user_params)
    if current_user.save
      flash[:success] = "Your data is updated!"
      redirect_to "/profile"
    else
      flash[:error] = current_user.errors.full_messages.to_sentence
      render :edit
    end

  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
