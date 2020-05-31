require 'rails_helper'

RSpec.describe "Order show page" do
  it "User views an Order Show Page and see all info about order" do
  @user = create(:user)
  bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
  tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
  seat = bike_shop.items.create(name: "Seat", description: "So comfy!", price: 10, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 10)
  order1 = Order.create(name: @user.name, address: @user.address, city: @user.city,
    state: @user.state, zip: @user.zip, user_id: @user.id, status: "pending")
    ItemOrder.create(order_id: order1.id, item_id: tire.id, price: 100, quantity: 2)
    ItemOrder.create(order_id: order1.id, item_id: seat.id, price: 10, quantity: 1)
  visit '/'
  click_on "Login"
  fill_in :email, with: @user.email
  fill_in :password, with: @user.password
  click_on "Log In"

  visit "/profile/orders"

  click_link "#{order1.id}"
  expect(current_path).to eq("/profile/orders/#{order1.id}")

  within("#order-#{order1.id}") do
    expect(page).to have_content(order1.id)
    expect(page).to have_content("Gatorskins")
    expect(page).to have_content("Seat")
    expect(page).to have_content(seat.description)
    expect(page).to have_content(seat.image)
    expect(page).to have_content(seat.price)
    expect(page).to have_content(seat.subtotal) #method in item_order not sure if this will work
    expect(page).to have_content("pending")
    expect(page).to have_content(3)
  end
  within("#datecreated") do
    expect(page).to have_content("Created:")#need to come back for date
  end
  within("#dateupdated") do
    expect(page).to have_content("Last Updated:")#need to come back for date
  end
  expect(page).to have_content("Grand Total: $210")
end
end
# User Story 29, User views an Order Show Page

# As a registered user
# When I visit my Profile Orders page
# And I click on a link for order's show page
# My URL route is now something like "/profile/orders/15"
# I see all information about the order, including the following information:
# - the ID of the order
# - the date the order was made
# - the date the order was last updated
# - the current status of the order
# - each item I ordered, including name, description, thumbnail, quantity, price and subtotal
# - the total quantity of items in the whole order
# - the grand total of all items for that order
#
