class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    if item.inventory > (cart.contents[item.id.to_s] || 0)
      cart.add_item(item.id.to_s)
      flash[:success] = "#{item.name} was successfully added to your cart"
    else
      flash[:error] = "Not enough inventory!"
    end
    redirect_to "/cart" and return if params[:from] == "button"
    redirect_to "/items"
  end

  def show
    render file: "/public/404" if current_admin?
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end


end
