require 'rails_helper'

RSpec.describe "As a merchant" do
  before :each do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

    @user = create(:user, role: 1, merchant_id: @bike_shop.id)
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @seat = @bike_shop.items.create(name: "Seat", description: "So comfy!", price: 10, image: "https://images.unsplash.com/photo-1582743779682-351861923531?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 10, active?: false)
    @light = @bike_shop.items.create(name: "Light", description: "Bright!", price: 10, image: "https://images.unsplash.com/photo-1582743779682-351861923531?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 10)
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

  it "Can see all items and deactivate them" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    click_on "Your Items"
    within "#item-#{@seat.id}" do
      expect(page).to have_link(@seat.name)
      expect(page).to have_content(@seat.description)
      expect(page).to have_content("Price: $#{@seat.price}")
      expect(page).to have_content("Inactive")
      expect(page).to have_content("Inventory: #{@seat.inventory}")
      expect(page).to have_css("img[src*='#{@seat.image}']")
      expect(page).to have_link("Activate")
    end

    within "#item-#{@tire.id}" do
      expect(page).to have_link(@tire.name)
      expect(page).to have_content(@tire.description)
      expect(page).to have_content("Price: $#{@tire.price}")
      expect(page).to have_content("Active")
      expect(page).to have_content("Inventory: #{@tire.inventory}")
      expect(page).to have_css("img[src*='#{@tire.image}']")
      click_link "Deactivate"
    end
    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{@tire.name} is no longer for sale")
    within "#item-#{@tire.id}" do
      expect(page).to have_content("Inactive")
    end
  end
  it "Can see all items and activate them" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    click_on "Your Items"
    within "#item-#{@seat.id}" do
      click_link("Activate")
    end

    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{@seat.name} is now available for sale")
    within "#item-#{@seat.id}" do
      expect(page).to have_content("Active")
    end
  end
  it "Can delete an item" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    click_on "Your Items"

    within "#item-#{@seat.id}" do
      expect(page).to_not have_content("delete")
    end

    within "#item-#{@light.id}" do
      click_button("delete")
    end
    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("#{@light.name} has been deleted")
    expect(page).to_not have_css("#item-#{@light.id}")
  end
  it "Can add an item" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    click_on "Your Items"

    name = "Chamois Buttr"
    price = 18
    description = "No more chaffin'!"
    image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
    inventory = 25

    click_button "Add Item"
    expect(current_path).to eq("/merchants/#{@bike_shop.id}/items/new")
    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: description
    fill_in :image, with: image_url
    fill_in :inventory, with: inventory

    click_button "Create Item"
    expect(current_path).to eq("/merchant/items")
    expect(page).to have_content("Your item has been saved")
    new_item = Item.last

    expect(new_item.name).to eq(name)
    expect(new_item.price).to eq(price)
    expect(new_item.description).to eq(description)
    expect(new_item.image).to eq(image_url)
    expect(new_item.inventory).to eq(inventory)
    expect(Item.last.active?).to be(true)
    expect("#item-#{Item.last.id}").to be_present
    expect(page).to have_content(name)
    expect(page).to have_content("Price: $#{new_item.price}")
    expect(page).to have_css("img[src*='#{new_item.image}']")
    expect(page).to have_content("Active")
    expect(page).to have_content(new_item.description)
    expect(page).to have_content("Inventory: #{new_item.inventory}")
  end


  it "When adding item, all info must be correct" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    click_on "Your Items"

    name = ""
    price = 18
    description = "No more chaffin'!"
    image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
    inventory = ""

    click_button "Add Item"
    expect(current_path).to eq("/merchants/#{@bike_shop.id}/items/new")
    fill_in :name, with: name
    fill_in :price, with: price
    fill_in :description, with: description
    fill_in :image, with: image_url
    fill_in :inventory, with: inventory
    click_button "Create Item"

    expect(page).to have_content("Name can't be blank, Inventory can't be blank, and Inventory is not a number")
    expect(page).to have_button("Create Item")
    expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
  end

  it "Can edit an item" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    click_on "Your Items"

    within "#item-#{@seat.id}" do
      click_button "Edit Item"
    end

    expect(current_path).to eq("/merchant/items/#{@seat.id}/edit")
    fill_in "Name", with: "new name"
    fill_in "Description", with: "new description"
    click_button "Update Item"

    within "#item-#{@seat.id}" do
      expect(page).to have_content("new name")
      expect(page).to have_content("new description")
    end
    expect(page).to have_content("Item Updated")
  end

  it "I get a flash message if entire form is not filled out" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    click_on "Your Items"

    within "#item-#{@seat.id}" do
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
end
  describe "As a merchant" do
    it "Can see order show page" do
      @flower_shop = Merchant.create(name: "Flower Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

      @user = create(:user, role: 1, merchant_id: @bike_shop.id)
      @user1 = create(:user, role: 0, email: "merch@merch.com")

      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @seat = @bike_shop.items.create(name: "Seat", description: "So comfy!", price: 10, image: "https://images.unsplash.com/photo-1582743779682-351861923531?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 10)
      @daisy = @flower_shop.items.create(name: "Daisy", description: "So cute!", price: 1, image: "https://images.unsplash.com/photo-1508784411316-02b8cd4d3a3a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 110)

      @order1 = Order.create(name: @user1.name, address: @user1.address, city: @user1.city,
        state: @user1.state, zip: @user1.zip, user_id: @user1.id, status: "pending")
      @order2 = Order.create(name: @user1.name, address: @user1.address, city: @user1.city,
        state: @user1.state, zip: @user1.zip, user_id: @user1.id, status: "fulfilled")

      @item_order1 = ItemOrder.create(order_id: @order1.id, item_id: @tire.id, price: 100, quantity: 2)
      @item_order2 =ItemOrder.create(order_id: @order2.id, item_id: @seat.id, price: 10, quantity: 1)
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
      expect(page).to have_css("img[src*='#{@tire.image}']")
      expect(page).to have_content(@item_order1.quantity)

      click_on "Gatorskins"
      expect(current_path).to eq("/items/#{@tire.id}")
    end

  it "Can fulfill part of an order" do
    @flower_shop = Merchant.create(name: "Flower Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

    @user = create(:user, role: 1, merchant_id: @bike_shop.id)
    @user1 = create(:user, role: 0, email: "merch@merch.com")

    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @seat = @bike_shop.items.create(name: "Seat", description: "So comfy!", price: 10, image: "https://images.unsplash.com/photo-1582743779682-351861923531?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 10)
    @daisy = @flower_shop.items.create(name: "Daisy", description: "So cute!", price: 1, image: "https://images.unsplash.com/photo-1508784411316-02b8cd4d3a3a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 110)

    @order1 = Order.create(name: @user1.name, address: @user1.address, city: @user1.city,
      state: @user1.state, zip: @user1.zip, user_id: @user1.id, status: "pending")
      @order2 = Order.create(name: @user1.name, address: @user1.address, city: @user1.city,
        state: @user1.state, zip: @user1.zip, user_id: @user1.id, status: "pending")

        @item_order1 = ItemOrder.create(order_id: @order1.id, item_id: @tire.id, price: 100, quantity: 2)
        @item_order2 =ItemOrder.create(order_id: @order2.id, item_id: @seat.id, price: 10, quantity: 1, status: "fulfilled")
        @item_order3 = ItemOrder.create(order_id: @order1.id, item_id: @daisy.id, price: 1, quantity: 2, status: "fulfilled")
        visit "/"
        click_on "Login"
        expect(current_path).to eq('/login')
        fill_in :email, with: @user.email
        fill_in :password, with: @user.password
        click_on "Log In"

        expect(current_path).to eq('/merchant')

        click_on "#{@order1.id}"
        expect(current_path).to eq("/merchant/orders/#{@order1.id}")
        expect(@tire.inventory).to eq(12)
        click_button "Fulfill"
        expect(current_path).to eq("/merchant/orders/#{@order1.id}")
        @tire.reload
        @item_order1.reload
        expect(@tire.inventory).to eq(10)
        expect(@item_order1.status).to eq("fulfilled")
        expect(page).to have_content("You have fulfilled #{@tire.name}")
        @order1.reload
        expect(@order1.status).to eq("packaged")

        visit "/merchant/orders/#{@order1.id}"
        expect(page).to have_content("Item already fulfilled")
  end

  it "cannot fulfill an order due to lack of inventory" do
    @flower_shop = Merchant.create(name: "Flower Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

    @user = create(:user, role: 1, merchant_id: @bike_shop.id)
    @user1 = create(:user, role: 0, email: "merch@merch.com")

    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @seat = @bike_shop.items.create(name: "Seat", description: "So comfy!", price: 10, image: "https://images.unsplash.com/photo-1582743779682-351861923531?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 10)
    @daisy = @flower_shop.items.create(name: "Daisy", description: "So cute!", price: 1, image: "https://images.unsplash.com/photo-1508784411316-02b8cd4d3a3a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60", inventory: 110)

    @order1 = Order.create(name: @user1.name, address: @user1.address, city: @user1.city,
      state: @user1.state, zip: @user1.zip, user_id: @user1.id, status: "pending")
    @order2 = Order.create(name: @user1.name, address: @user1.address, city: @user1.city,
      state: @user1.state, zip: @user1.zip, user_id: @user1.id, status: "pending")

    @item_order1 = ItemOrder.create(order_id: @order1.id, item_id: @tire.id, price: 100, quantity: 22)
    @item_order2 =ItemOrder.create(order_id: @order2.id, item_id: @seat.id, price: 10, quantity: 1)
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
    expect(@tire.inventory).to eq(12)
    expect(page).to have_content("You cannot fulfill this item.")

  end

end


# User Story 51, Merchant cannot fulfill an order due to lack of inventory
#
# As a merchant employee
# When I visit an order show page from my dashboard
# For each item of mine in the order
# If the user's desired quantity is greater than my current inventory quantity for that item
# Then I do not see a "fulfill" button or link
# Instead I see a notice next to the item indicating I cannot fulfill this item
