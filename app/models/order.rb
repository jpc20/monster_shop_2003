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
      item = Item.find(item_order.item_id)
      item_order.update_attribute(:status, "unfulfilled")
      item.update_attribute(:inventory, item.inventory + item_order.quantity)
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

  def merchant_item_orders(merchant_id)
    Merchant.joins(:orders)
            .where("merchants.id = ?", merchant_id)
            .where("orders.id = ?", id)
            .select("items.name as name")
            .select("items.image as image")
            .select("items.price as price")
            .select("items.id as item_id")
            .select("items.inventory as inventory")
            .select("item_orders.status as status")
            .select("item_orders.id as item_order_id")
            .select("item_orders.quantity as quantity")
  end

end
