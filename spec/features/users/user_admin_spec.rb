require 'rails_helper'

RSpec.describe "As a Admin" do

  before :each do
    @user_2 = create(:user, email: "greatest.com")

    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12, active?: false)
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

    visit "/admin/merchants"

    click_on "#{@meg.name}"
    expect(current_path).to eq("/admin/merchants/#{@meg.id}")
    expect(page).to have_content(@meg.name)
    expect(page).to have_content(@meg.address)
    expect(page).to have_content(@meg.city)
    expect(page).to have_content(@meg.state)
    expect(page).to have_content(@meg.zip)
    expect(page).to have_content("Pending Orders:")
  end

  it "Admin can see a merchant index" do
    user = create(:user, role: 2)
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"

    visit "/admin/merchants"
    expect(page).to have_content(@meg.city)
    expect(page).to have_content(@meg.state)
    expect(page).to have_content(@brian.city)
    expect(page).to have_content(@brian.state)

    click_on "#{@meg.name}"
    expect(current_path).to eq("/admin/merchants/#{@meg.id}")
    visit "/admin/merchants"

    click_on "#{@brian.name}"
    expect(current_path).to eq("/admin/merchants/#{@brian.id}")
    visit "/admin/merchants"

    click_on "Disable #{@brian.name}"
    expect(current_path).to eq("/admin/merchants")
    expect(page).to have_content("#{@brian.name} has been disabled")
    visit "/admin/merchants"

    click_on "Activate #{@brian.name}"
    expect(current_path).to eq("/admin/merchants")
    expect(page).to have_content("#{@brian.name} has been activated")
  end

  it "Admin can see a merchants items and activate/deactivate them" do
    user = create(:user, role: 2)
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"
    visit "/admin/merchants/#{@meg.id}"
    click_link "Items"
    expect(current_path).to eq("/admin/merchants/#{@meg.id}/items")
    within "#item-#{@tire.id}" do
      expect(page).to have_link(@tire.name)
      expect(page).to have_content(@tire.description)
      expect(page).to have_content("Price: $#{@tire.price}")
      expect(page).to have_content("Inactive")
      expect(page).to have_content("Inventory: #{@tire.inventory}")
      expect(page).to have_css("img[src*='#{@tire.image}']")
      click_link("Activate")
    end
    expect(current_path).to eq("/admin/merchants/#{@meg.id}/items")
    within "#item-#{@tire.id}" do
      expect(page).to have_content("Active")
    end
    within "#item-#{@tire.id}" do
      click_link("Deactivate")
      expect(page).to have_content("Inactive")
    end
  end

  it "Admin can add a merchants items" do
    user = create(:user, role: 2)
    name = "Chamois Buttr"
    price = 18
    description = "No more chaffin'!"
    image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
    inventory = 25
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"
    visit "/admin/merchants/#{@meg.id}"
    click_link "Items"
    click_button "Add Item"
    expect(current_path).to eq("/admin/merchants/#{@meg.id}/items/new")
    fill_in "Name", with: name
    fill_in "Price", with: price
    fill_in "Description", with: description
    fill_in "Image", with: image_url
    fill_in "Inventory", with: inventory
    click_button "Create Item"
    expect(current_path).to eq(admin_merchant_items_path(@meg.id))
    expect(page).to have_content("Your item has been saved")
    expect(page).to have_content(name)
  end
  it "When adding item, all info must be correct" do
    user = create(:user, role: 2)
    name = ""
    price = 18
    description = "No more chaffin'!"
    image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
    inventory = ""
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"
    visit "/admin/merchants/#{@meg.id}"
    click_link "Items"
    click_button "Add Item"

    fill_in "Name", with: name
    fill_in "Price", with: price
    fill_in "Description", with: description
    fill_in "Image", with: image_url
    fill_in "Inventory", with: inventory
    click_button "Create Item"

    expect(page).to have_content("Name can't be blank, Inventory can't be blank, and Inventory is not a number")
    expect(page).to have_button("Create Item")
  end

  it "Admin can edit a merchants items" do
    user = create(:user, role: 2)
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"
    visit "/admin/merchants/#{@meg.id}"
    click_link "Items"
    within "#item-#{@tire.id}" do
      click_button "Edit Item"
    end
    expect(current_path).to eq("/admin/merchants/#{@meg.id}/items/#{@tire.id}/edit")
    fill_in "Name", with: "new name"
    fill_in "Description", with: "new description"
    click_button "Update Item"
    expect(current_path).to eq(admin_merchant_items_path(@meg.id))
    expect(page).to have_content("Item Updated")
    within "#item-#{@tire.id}" do
      expect(page).to have_content("new name")
      expect(page).to have_content("new description")
    end
    expect(page).to have_content("Item Updated")
  end
  it "When editing item, all info must be correct" do
    user = create(:user, role: 2)
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"
    visit "/admin/merchants/#{@meg.id}"
    click_link "Items"
    within "#item-#{@tire.id}" do
      click_button "Edit Item"
    end

    fill_in 'Name', with: ""
    fill_in 'Price', with: 110
    fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
    fill_in 'Image', with: ""
    fill_in 'Inventory', with: -1

    click_button "Update Item"

    expect(page).to have_content("Name can't be blank and Inventory must be greater than or equal to 0")
    expect(page).to have_button("Update Item")
  end
  it "Admin can delete a merchants items" do
    user = create(:user, role: 2)
    test_item = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"
    visit "/admin/merchants/#{@meg.id}"
    click_link "Items"
    within "#item-#{test_item.id}" do
      click_on "delete"
    end
    expect(current_path).to eq(admin_merchant_items_path(@meg.id))
    expect(page).to_not have_css("#item-#{test_item.id}")
  end

  it "Admin can see a user index" do
    user = create(:user, name: "Adam", role: 2)
    merchant_user = create(:user, name: "Marty", role: 1, email: "fake.com")
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"

    click_on "All Users"

    expect(current_path).to eq("/admin/users")

    within "#user-#{@user_2.id}" do
      expect(page).to have_link(@user_2.name)
      expect(page).to have_content(@user_2.created_at)
      expect(page).to have_content("Default")
    end
    within "#user-#{merchant_user.id}" do
      expect(page).to have_link(merchant_user.name)
      expect(page).to have_content(merchant_user.created_at)
      expect(page).to have_content("Merchant")
    end
    within "#user-#{user.id}" do
      expect(page).to have_link(user.name)
      expect(page).to have_content(user.created_at)
      expect(page).to have_content("Admin")
    end
  end

  it "Admin can see a user profile" do
    user = create(:user, name: "Adam", role: 2)
    merchant_user = create(:user, name: "Marty", role: 1, email: "fake.com")
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"

    click_on "All Users"

    expect(current_path).to eq("/admin/users")

    within "#user-#{@user_2.id}" do
      click_link(@user_2.name)
    end
    expect(current_path).to eq("/admin/users/#{@user_2.id}")
    expect(page).to have_content(@user_2.name)
    expect(page).to have_content(@user_2.address)
    expect(page).to have_content(@user_2.city)
    expect(page).to have_content(@user_2.state)
    expect(page).to have_content(@user_2.zip)
    expect(page).to have_content(@user_2.email)
    expect(page).to_not have_content("Change Password")
    expect(page).to_not have_content("Update Profile Information")
  end
end
