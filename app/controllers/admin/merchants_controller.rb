class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    if params[:activate] == "true"
      merchant.activate
      flash[:success] = "#{merchant.name} has been activated"
      redirect_to "/admin/merchants"
    else
      merchant.deactivate
      flash[:success] = "#{merchant.name} has been disabled"
      redirect_to "/admin/merchants"
    end
  end
end
