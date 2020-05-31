class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders

  belongs_to :user, optional: true

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def unfulfilled_item_orders
    item_orders.each do |item_order|
      item_order.status = "unfulfilled"
    end
  end
end
