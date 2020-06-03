require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
    it {should validate_numericality_of(:inventory).is_greater_than_or_equal_to(0)}
    it {should validate_numericality_of(:price).is_greater_than(0)}
  end


  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @seat = @bike_shop.items.create(name: "Seat", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @pedal = @bike_shop.items.create(name: "Pedal", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @handle_bars = @bike_shop.items.create(name: "Handle Bars", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @cards = @bike_shop.items.create(name: "Cards", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @spokes = @bike_shop.items.create(name: "Spokes", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @gum = @bike_shop.items.create(name: "Gum", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @glitter = @bike_shop.items.create(name: "Spokes", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 15)
      @streamers = @bike_shop.items.create(name: "Gum", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 15)
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @bike_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @order_1.item_orders.create!(item: @pedal, price: @pedal.price, quantity: 10)
      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 1)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 2)
      @order_1.item_orders.create!(item: @seat, price: @seat.price, quantity: 3)
      @order_1.item_orders.create!(item: @handle_bars, price: @handle_bars.price, quantity: 4)
      @order_1.item_orders.create!(item: @cards, price: @cards.price, quantity: 5)
      @order_1.item_orders.create!(item: @spokes, price: @spokes.price, quantity: 6)
      @order_1.item_orders.create!(item: @gum, price: @gum.price, quantity: 7)
      @order_1.item_orders.create!(item: @glitter, price: @glitter.price, quantity: 8)
      @order_1.item_orders.create!(item: @streamers, price: @streamers.price, quantity: 9)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @gold_chain = @bike_shop.items.create(name: "Gold Chain", description: "It might never break!", price: 60, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 3, active?:false)
      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it 'all active' do
      expect(Item.all_active).to eq([@seat, @pedal, @handle_bars, @cards,
         @spokes, @gum, @glitter, @streamers, @tire, @pull_toy, @chain])
      expect(Item.all_active).not_to eq([@gold_chain])
    end

    it 'most_popular' do
      expect(Item.most_popular.first.name).to eq("Pedal")
      expect(Item.most_popular.first.total_quantity).to eq(10)
      expect(Item.most_popular.last.name).to eq("Spokes")
      expect(Item.most_popular.last.total_quantity).to eq(6)
    end

    it 'least_popular' do
      expect(Item.least_popular.first.name).to eq("Gatorskins")
      expect(Item.least_popular.first.total_quantity).to eq(1)
      expect(Item.least_popular.last.name).to eq("Cards")
      expect(Item.least_popular.last.total_quantity).to eq(5)
    end

    it "all_by_merchant" do
      book_shop = Merchant.create(name: "Brian's Book Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      book = book_shop.items.create(name: "Book", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      expect(Item.all_by_merchant(book_shop.id)).to eq([book])
    end
  end
end
