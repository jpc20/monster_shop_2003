require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)


    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end
    end

  it "I can see all items in system unless disabled "do

    visit '/items'

    within "#item-#{@tire.id}" do
      expect(page).to have_link(@tire.name)
      expect(page).to have_content(@tire.description)
      expect(page).to have_content("Price: $#{@tire.price}")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: #{@tire.inventory}")
      expect(page).to have_link(@meg.name)
      expect(page).to have_css("img[src*='#{@tire.image}']")
    end
    within "#item-#{@pull_toy.id}" do
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_content(@pull_toy.description)
      expect(page).to have_content("Price: $#{@pull_toy.price}")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
      expect(page).to have_link(@brian.name)
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
    end

      expect(page).not_to have_link(@dog_bone.name)
      expect(page).not_to have_content(@dog_bone.description)
      expect(page).not_to have_content("Price: $#{@dog_bone.price}")
      expect(page).not_to have_content("Inactive")
      expect(page).not_to have_content("Inventory: #{@dog_bone.inventory}")
      expect(page).not_to have_css("img[src*='#{@dog_bone.image}']")
    end
    it "I can see an area with statistics "do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @seat = @bike_shop.items.create(name: "Seat", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @pedal = @bike_shop.items.create(name: "Pedal", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @handle_bars = @bike_shop.items.create(name: "Handle Bars", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @cards = @bike_shop.items.create(name: "Cards", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @spokes = @bike_shop.items.create(name: "Spokes", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @gum = @bike_shop.items.create(name: "Gum", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 51)
      @glitter = @bike_shop.items.create(name: "Spokes", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 15)
      @streamers = @bike_shop.items.create(name: "Gum", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 15)
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

      visit '/items'
      within ".most_popular" do
        expect("#{@pedal.name} quantity: 10").to appear_before("#{@streamers.name} quantity: 9")
        expect("#{@streamers.name} quantity: 9").to appear_before("#{@glitter.name} quantity: 8")
        expect("#{@glitter.name} quantity: 8").to appear_before("#{@gum.name} quantity: 7")
        expect("#{@gum.name} quantity: 7").to appear_before("#{@spokes.name} quantity: 6")
      end
      within ".least_popular" do
        expect("#{@tire.name} quantity: 1").to appear_before("#{@pull_toy.name} quantity: 2")
        expect("#{@pull_toy.name} quantity: 2").to appear_before("#{@seat.name} quantity: 3")
        expect("#{@seat.name} quantity: 3").to appear_before("#{@handle_bars.name} quantity: 4")
        expect("#{@handle_bars.name} quantity: 4").to appear_before("#{@cards.name} quantity: 5")
      end
    end
  end
end
# User Story 18, Items Index Page Statistics
#
# As any kind of user on the system
# When I visit the items index page ("/items")
# I see an area with statistics:
# - the top 5 most popular items by quantity purchased, plus the quantity bought
# - the bottom 5 least popular items, plus the quantity bought
#
# "Popularity" is determined by total quantity of that item ordered
