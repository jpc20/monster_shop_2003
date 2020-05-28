class SessionsController<ApplicationController
  def new
    if current_merchant?
      redirect_to '/merchant'
      flash[:success] = "Already Logged in!"
    elsif current_admin?
      redirect_to '/admin'
      flash[:success] = "Already Logged in!"
    elsif current_user
      redirect_to '/profile'
      flash[:success] = "Already Logged in!"
    end

  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Logged in as #{user.name}!"
      if current_merchant?
        redirect_to '/merchant'
      elsif current_admin?
        redirect_to '/admin'
      else
        redirect_to '/profile'
      end
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end

  def destroy
    session.delete(:cart)
    session.delete(:user_id)
    flash[:success] = 'Logged Out'
    redirect_to root_path

  end

end
