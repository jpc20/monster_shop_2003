class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @item = Item.find(params[:id])
    if params[:type] == "deactivate"
      @item.update_attributes(active?: false)
      flash[:success] = "#{@item.name} is no longer for sale"
      redirect_to admin_merchant_items_path(params[:merchant_id])
    elsif params[:type] == "activate"
      @item.update_attributes(active?: true)
      flash[:success] = "#{@item.name} is now available for sale"
      redirect_to admin_merchant_items_path(params[:merchant_id])
    else
      @item.update(item_params)
      if @item.save
        flash[:success] = "Item Updated"
        redirect_to admin_merchant_items_path(params[:merchant_id])
      else
        flash[:error] = @item.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  def destroy
    item = Item.find(params[:id])
    Item.destroy(item.id)
    flash[:success] = "#{item.name} has been deleted"
    redirect_to admin_merchant_items_path(params[:merchant_id])
  end
end
