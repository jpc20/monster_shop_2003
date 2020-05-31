require 'rails_helper'

RSpec.describe "Order show page" do
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
