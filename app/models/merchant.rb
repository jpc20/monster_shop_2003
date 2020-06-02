class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :orders, through: :item_orders
  has_many :users, -> { where(role: 1) }

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip
  validates_inclusion_of :active?, :in => [true, false]


  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def deactivate
    update_attributes(active?: false)
    items.update_all(active?: false)
    items.map(&:reload)
  end

  def activate
    update_attributes(active?: true)
    items.update_all(active?: true)
    items.map(&:reload)
  end

  def pending_orders
    orders.where("orders.status = 'pending'").distinct 
  end

end
