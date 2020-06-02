class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders

  belongs_to :user, optional: true

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def unfulfill_item_orders
    item_orders.each do |item_order|
      item_order.update_attribute(:status, "unfulfilled")
      item_order.save
    end
  end

  def packaged_check
    fulfilled_status = item_orders.map do |item_order|
       item_order.status
     end
    if !fulfilled_status.include?("unfulfilled")
      self.status = "packaged"
      self.save
    end
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def total_merchant_quantity(merchant_id)
    Merchant.joins(:orders)
          .where("merchants.id = ?", merchant_id)
          .where("orders.id = ?", id)
          .sum("item_orders.quantity")
  end

  def total_merchant_value(merchant_id)
    Merchant.joins(:orders)
          .where("merchants.id = ?", merchant_id)
          .where("orders.id = ?", id)
          .sum("item_orders.quantity * item_orders.price")
  end
end
