class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(@current_user.merchant_id)
  end

  def update
    item = Item.find(params[:id])
    if params[:type] == "deactivate"
      item.update_attributes(active?: false)
      flash[:success] = "#{item.name} is no longer for sale"
    else

    end
    redirect_to "/merchant/items"
  end
end
