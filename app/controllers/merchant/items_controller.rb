class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = Merchant.find(@current_user.merchant_id)
  end

  def update
    item = Item.find(params[:id])
    if params[:type] == "deactivate"
      item.update_attributes(active?: false)
      flash[:success] = "#{item.name} is no longer for sale"
    elsif params[:type] == "activate"
      item.update_attributes(active?: true)
      flash[:success] = "#{item.name} is now available for sale"
    else
      item.update(item_params)
      if item.save
        flash[:succes] = "Item Updated"
        redirect_to "/merchant/items" and return
      else
        flash[:error] = item.errors.full_messages.to_sentence
        render :edit
      end
    end
    redirect_to "/merchant/items"
  end

  def destroy
    item = Item.find(params[:id])
    Item.destroy(item.id)
    flash[:success] = "#{item.name} has been deleted"
    redirect_to "/merchant/items"
  end

  def edit
    @item = Item.find(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end

end
