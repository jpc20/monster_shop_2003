require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

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

    it "Admin can disable a merchant account" do
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

    it "Admin can disable a merchant account and that merchants items are all deactivated" do
      visit "/"
      click_on "Login"
      fill_in :email, with: @admin.email
      fill_in :password, with: @admin.password
      click_on "Log In"
      visit "/admin/merchants"
      click_on "Disable #{@bike_shop.name}"
      visit "/merchants/#{@bike_shop.id}/items"
      within "#item-#{@tire.id}" do
        expect(page).to have_content("Inactive")
      end
    end
  end
end
