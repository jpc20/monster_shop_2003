require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      @admin = create(:user, role:2)
    end

    it 'I can see a list of merchants in the system' do
      visit '/merchants'

      expect(page).to have_link("Brian's Bike Shop")
      expect(page).to have_link("Meg's Dog Shop")
    end

    it 'I can see a link to create a new merchant' do
      visit '/merchants'

      expect(page).to have_link("New Merchant")

      click_on "New Merchant"

      expect(current_path).to eq("/merchants/new")
    end

    it "Admin can disabkle a merchant account" do
      visit "/"
      click_on "Login"
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_on "Log In"
      visit "/admin/merchants"
      click_on "Disable #{@bike_shop.name}"
      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("#{@bike_shop.name} has been disabled")
    end
  end
end

# When I visit the admin's merchant index page ('/admin/merchants')
# I see a "disable" button next to any merchants who are not yet disabled
