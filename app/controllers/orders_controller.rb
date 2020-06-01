class OrdersController <ApplicationController

  def index
    @orders = User.find(session[:user_id]).orders
  end

  def new
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = Order.create(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      session.delete(:cart)
      if current_user
        current_user.orders << order
        flash[:success] = "Your order has been created!"
        redirect_to "/profile/orders"
      else
        redirect_to "/orders/#{order.id}"
      end
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def ship
    order = Order.find(params[:id])
    order.update_attribute(:status, "shipped")
    order.save
    redirect_to "/admin"
  end

  def cancel
    order = Order.find(params[:id])
    order.unfulfill_item_orders
    order.status = "cancelled"
    order.save
    flash[:success] = "Your order has been cancelled!"
    redirect_to "/profile"
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
