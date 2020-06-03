class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @item = Item.new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = @merchant.items.create(item_params)
    if item.save
      flash[:success] = "Your item has been saved"
      redirect_to admin_merchant_items_path(@merchant.id)
    else
      flash[:error] = item.errors.full_messages.to_sentence
      @item = Item.new(item_params)
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
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
        redirect_to admin_merchant_items_path(@item.merchant.id)
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

  private

  def item_params
    params.require(:item).permit(:name,:description,:price,:inventory,:image)
  end
end
