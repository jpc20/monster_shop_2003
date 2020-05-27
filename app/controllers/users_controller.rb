class UsersController < ApplicationController

  def show

  end

  def new

  end

  def create
    user = User.new(user_params)
    empty_params = user_params.select{|param, value| value.empty?}
    if user.save
      flash[:message] = "Hi #{user.name} you have registered and logged in!"
      session[:user_id] = user.id
      redirect_to "/profile"
    elsif !empty_params.empty?
      flash[:notice] = "Please fill in #{empty_params.keys.join(", ")}"
      redirect_to '/register'
    else
      flash.now[:message] = "This email already exists"
      @user = params
      render :action => :new
    end
  end

# elsif !pet.save
#   missing_params = []
#   pet_params.each do |key, value|
#     if value == ""
#       missing_params << "#{key}"
#     end
#   end
#   flash[:notice] = "Pet not created. Missing one or more of the following fields: #{missing_params.join(", ")}."
#   redirect_to "/shelters/#{shelter.id}/pets/new"
# end

private


def user_params
  params.permit(:name, :address, :city, :state, :zip, :email, :password)
end

end
