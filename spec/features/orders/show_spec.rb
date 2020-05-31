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
      expect(page).to have_css(".order-#{Order.last.id}")
      expect(page).to have_content("Cart: 0")

    end
    it "can cancel order" do
      visit "/orders/#{Order.last.id}"
      click_on "Cancel Order"
      expect(Order.last.status).to eq("cancelled")
      expect(ItemOrder.first.status).to eq("unfulfilled")
      expect(ItemOrder.last.status).to eq("unfulfilled")



    end
  end
end
