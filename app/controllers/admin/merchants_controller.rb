class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.deactivate
    flash[:success] = "#{merchant.name} has been disabled"
    redirect_to "/admin/merchants"
  end
end