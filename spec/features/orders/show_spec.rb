require 'rails_helper'

RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @user = create(:user)
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @pull_toy = @mike.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      click_on "Login"
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_on "Log In"
      visit "/cart"
      click_on "Checkout"
      fill_in :name, with: @user.name
      fill_in :address, with: @user.address
      fill_in :city, with: @user.city
      fill_in :state, with: @user.state
      fill_in :zip, with: @user.zip
      click_button "Create Order"
      expect(current_path).to eq("/profile/orders")
      expect(page).to have_content("Your order has been created!")
      expect(page).to have_content("Cart: 0")

    end
    it "can cancel order" do
      @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "fulfilled")
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")

      visit "/orders/#{@order_1.id}"
      expect(@order_1.item_orders.first.status).to eq("fulfilled")
      expect(@order_1.item_orders.last.status).to eq("fulfilled")
      expect(@tire.inventory).to eq(12)
      expect(@pull_toy.inventory).to eq(32)


      click_on "Cancel Order"
      @order_1.reload
      @tire.reload
      @pull_toy.reload
      expect(@order_1.status).to eq("cancelled")
      expect(@order_1.item_orders.first.status).to eq("unfulfilled")
      expect(@order_1.item_orders.last.status).to eq("unfulfilled")
      expect(@tire.inventory).to eq(14)
      expect(@pull_toy.inventory).to eq(35)


      expect(current_path).to eq("/profile")
      expect(page).to have_content("Your order has been cancelled!")
    end
  end
  it "can package order" do
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
  it "User views an Order Show Page and see all info about order" do
    @user = create(:user)
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    seat = bike_shop.items.create(name: "Seat", description: "So comfy!", price: 10, image: "https://images.unsplash.com/photo-1582743779682-351861923531?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 10)
    order1 = Order.create(name: @user.name, address: @user.address, city: @user.city,
      state: @user.state, zip: @user.zip, user_id: @user.id, status: "pending")
      item_order1 = ItemOrder.create(order_id: order1.id, item_id: tire.id, price: 100, quantity: 2)
      item_order2 =ItemOrder.create(order_id: order1.id, item_id: seat.id, price: 10, quantity: 1)
    visit '/'
    click_on "Login"
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"

    visit "/profile/orders"

    click_link "#{order1.id}"
    expect(current_path).to eq("/profile/orders/#{order1.id}")

    expect(page).to have_content("Order number: #{item_order1.order_id}")
    within("#order_status") do
      expect(page).to have_content("pending")
    end
    within("#item-#{item_order1.item_id}") do
      expect(page).to have_content("Gatorskins")
      expect(page).not_to have_content("Seat")
      expect(page).to have_content(tire.description)
      expect(page).to have_content(tire.price)
      expect(page).to have_content(item_order1.subtotal)
      expect(page).to have_content(2)
      expect(page).to have_css("img[src*='#{tire.image}']")
    end
    within("#item-#{item_order2.item_id}") do
      expect(page).to have_content("Seat")
      expect(page).not_to have_content("Gatorskins")
      expect(page).to have_content(seat.description)
      expect(page).to have_css("img[src*='#{seat.image}']")
      expect(page).to have_content(seat.price)
      expect(page).to have_content(item_order2.subtotal)
    end
    within("#datecreated") do
      expect(page).to have_content("Created: #{order1.created_at}")
    end
    within("#dateupdated") do
      expect(page).to have_content("Last Updated: #{order1.updated_at}")
    end
    expect(page).to have_content("Grand Total: $210")
  end
end
