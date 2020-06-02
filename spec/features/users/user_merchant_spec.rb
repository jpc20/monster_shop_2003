require 'rails_helper'

RSpec.describe "As a merchant" do
  before :each do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

    @user = create(:user, role: 1, merchant_id: @bike_shop.id)
    @user1 = create(:user, role: 0)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @seat = @bike_shop.items.create(name: "Seat", description: "So comfy!", price: 10, image: "https://images.unsplash.com/photo-1582743779682-351861923531?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 10)
    @order1 = Order.create(name: @user.name, address: @user.address, city: @user.city,
      state: @user.state, zip: @user.zip, user_id: @user.id, status: "pending")
    @order2 = Order.create(name: @user.name, address: @user.address, city: @user.city,
      state: @user.state, zip: @user.zip, user_id: @user.id, status: "fulfilled")
    @item_order1 = ItemOrder.create(order_id: @order1.id, item_id: @tire.id, price: 100, quantity: 2)
    @item_order2 =ItemOrder.create(order_id: @order2.id, item_id: @seat.id, price: 10, quantity: 1)
  end

  it "can log in with as a merchant" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    expect(current_path).to eq('/merchant')

    expect(page).to have_content("Logged in as #{@user.name}")
    expect(page).to have_link("Log out")
    expect(page).to_not have_link("Register")
    expect(page).to_not have_link("Login")
    click_on "Merchant Dashboard"
    expect(current_path).to eq("/merchant")
  end

  it "Doesn't allow me to visit role protected pages" do
    visit "/"
    click_on "Login"
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"

    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist.")

  end

  it "Doesn't allow me log in more than once" do
    visit "/"
    click_on "Login"
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"

    visit "/login"
    expect(page).to have_content('Already Logged in!')
    expect(current_path).to eq('/merchant')
  end

  it "Can see merchant's name and full address in dashboard" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    expect(current_path).to eq('/merchant')

    expect(page).to have_content(@bike_shop.name)
    expect(page).to have_content(@bike_shop.address)
    expect(page).to have_content(@bike_shop.city)
    expect(page).to have_content(@bike_shop.state)
    expect(page).to have_content(@bike_shop.zip)
  end

  it "Can see merchants pending orders" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    expect(current_path).to eq('/merchant')

    expect(page).to have_content(@order1.id)
    expect(page).to have_content(@order1.created_at)
    expect(page).to have_content(@order1.total_merchant_quantity(@bike_shop))
    expect(page).to have_content(@order1.total_merchant_value(@bike_shop))
    expect(page).to have_content(@order1.created_at)
    expect(page).to_not have_content(@order2.id)

    click_on @order1.id
    expect(current_path).to eq("/merchant/orders/#{@order1.id}")

  end

  it "Can see a link to all of the merchant's items" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    expect(current_path).to eq('/merchant')

    expect(page).to have_link("Your Items")
    click_on "Your Items"
    expect(current_path).to eq("/merchant/items")
  end
end
describe "As a merchant" do
  it "Can see order show page" do
    @flower_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    @user = create(:user, role: 1, merchant_id: @bike_shop.id)
    @user1 = create(:user, role: 0)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @seat = @bike_shop.items.create(name: "Seat", description: "So comfy!", price: 10, image: "https://images.unsplash.com/photo-1582743779682-351861923531?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 10)
    @order1 = Order.create(name: @user1.name, address: @user1.address, city: @user1.city,
      state: @user1.state, zip: @user1.zip, user_id: @user1.id, status: "pending")
    @order2 = Order.create(name: @user1.name, address: @user1.address, city: @user1.city,
      state: @user1.state, zip: @user1.zip, user_id: @user1.id, status: "fulfilled")
    @item_order1 = ItemOrder.create(order_id: @order1.id, item_id: @tire.id, price: 100, quantity: 2)
    @item_order2 =ItemOrder.create(order_id: @order2.id, item_id: @seat.id, price: 10, quantity: 1)
    @daisy = @flower_shop.items.create(name: "Daisy", description: "So cute!", price: 1, image: "https://images.unsplash.com/photo-1508784411316-02b8cd4d3a3a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 110)
    @item_order3 = ItemOrder.create(order_id: @order1.id, item_id: @daisy.id, price: 1, quantity: 2)
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    expect(current_path).to eq('/merchant')

    click_on "#{@order1.id}"
    expect(current_path).to eq("/merchant/orders/#{@order1.id}")
    expect(page).to have_content(@user1.name)
    expect(page).to have_content(@user1.address)
    expect(page).to have_content(@user1.city)
    expect(page).to have_content(@user1.state)
    expect(page).to have_content(@user1.zip)

    expect(page).to have_content("Gatorskins")
    expect(page).not_to have_content("Daisy")

    expect(page).to have_content(@tire.price)
    expect(page).to have_content(@tire.image)#not gonna work
    expect(page).to have_content(@tire.quantity)

    click_on "Gatorskins"
    expect(current_path).to eq.("/items/#{@tire.id}")
  end
end
# User Story 49, Merchant sees an order show page
#
# As a merchant employee
# When I visit an order show page from my dashboard
# I see the recipients name and address that was used to create this order
# I only see the items in the order that are being purchased from my merchant
# I do not see any items in the order being purchased from other merchants
# For each item, I see the following information:
# - the name of the item, which is a link to my item's show page
# - an image of the item
# - my price for the item
# - the quantity the user wants to purchase
