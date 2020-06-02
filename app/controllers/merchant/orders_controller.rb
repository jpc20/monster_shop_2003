class Merchant::OrdersController < Merchant::BaseController
  def show
    @order = Order.find(params[:id])
    # @merchant = Merchant.find(params[])
  end
end
