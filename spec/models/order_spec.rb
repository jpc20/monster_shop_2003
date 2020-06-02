require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should belong_to(:user).optional }
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "fulfilled")
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
    end
    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(230)
    end
    it 'unfulfill_item_orders' do
      expect(ItemOrder.first.status).to eq("fulfilled")
      @order_1.unfulfill_item_orders
      expect(ItemOrder.first.status).to eq("unfulfilled")
      expect(ItemOrder.last.status).to eq("unfulfilled")
    end
    it 'total_quantity' do
      expect(@order_1.total_quantity).to eq(5)
    end
  end
  it "packaged_check" do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "fulfilled")
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")

      expect(@order_1.status).to eq("pending")
      @order_1.packaged_check
      expect(@order_1.status).to eq("packaged")
  end
  it "total_merchant_quantity" do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "fulfilled")
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")

    expect(@order_1.total_merchant_quantity(@meg.id)).to eq(2)
  end

  it "total_merchant_value" do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "fulfilled")
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")

    expect(@order_1.total_merchant_value(@meg.id)).to eq(200)
  end
  it "merchant_item_orders" do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    @user = create(:user, role: 1, merchant_id: @bike_shop.id)
    @user1 = create(:user, role: 0, email: "merch@merch.com")
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

    item_order1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "unfulfilled")
    item_order2 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "unfulfilled")

    expect(@order_1.merchant_item_orders(@meg.id).first.quantity).to eq(item_order1.quantity)
  end
end
