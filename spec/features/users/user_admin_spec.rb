require 'rails_helper'

RSpec.describe "As a Admin" do

  before :each do
    @user_2 = create(:user, email: "greatest.com")

    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user_id: @user_2.id, status: "packaged")
    @order_2 = Order.create!(name: 'Max', address: '321 Stang Ave', city: 'Sershey', state: 'CO', zip: 20033, user_id: @user_2.id)

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2, status: "fulfilled")
    @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: "fulfilled")
  end
  it "can log in with as a admin" do
    user = create(:user, role: 2)
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"
    expect(current_path).to eq('/admin')

    expect(page).to have_content("Logged in as #{user.name}")
    expect(page).to have_link("Log out")
    expect(page).to have_link("All Users")
    expect(page).to_not have_link("Register")
    expect(page).to_not have_link("Login")
    expect(page).to_not have_content("Cart")
    click_on "Admin Dashboard"
    expect(current_path).to eq("/admin")
  end

  it "Doesn't allow me to visit role protected pages" do
    user = create(:user, role: 2)
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"

    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit '/cart'
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end

  it "Doesn't allow me log in more than once" do
    user = create(:user, role: 2)
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"

    visit "/login"
    expect(page).to have_content('Already Logged in!')
    expect(current_path).to eq('/admin')
  end

  it "admin sees all orders and info" do
    user = create(:user, role: 2)

    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"
    visit "/admin"
    expect(page).to have_content(@order_1.id)
    expect(page).to have_content(@order_2.id)
    expect(page).to have_content(@order_1.created_at)
    expect(page).to have_content(@order_2.created_at)
    expect(page).to have_content(@order_1.user.name)
    expect(page).to have_content(@order_2.user.name)
  end

  it "admin can ship orders" do
    user = create(:user, role: 2)

    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"

    visit "/admin"
    click_on "Ship"
    @order_1.reload
    expect(@order_1.status).to eq("shipped")

  end


  it "Admin can see a merchant dashboard" do
    user = create(:user, role: 2)
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"

    visit "/merchants"

    click_on "#{@meg.name}"
    expect(current_path).to eq("/admin/merchants/#{@meg.id}")
    expect(page).to have_content(@meg.name)
    expect(page).to have_content(@meg.address)
    expect(page).to have_content(@meg.city)
    expect(page).to have_content(@meg.state)
    expect(page).to have_content(@meg.zip)
    expect(page).to have_content("Pending Orders:")
  end

end
