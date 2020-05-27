
require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Login'
      end

      expect(current_path).to eq('/login')

    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

    end

    it "Doesn't allow me to visit role protected pages" do

      visit '/merchant'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/admin'
      expect(page).to have_content("The page you were looking for doesn't exist.")

      visit '/profile'
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
