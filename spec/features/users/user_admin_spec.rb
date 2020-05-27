require 'rails_helper'

RSpec.describe "As a Admin" do
  it "can log in with as a admin" do
    user = create(:user, role: 2)
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"
    expect(current_path).to eq('/profile')

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

end

# User Story 9, Admin Navigation Restrictions
#
# As an admin
# When I try to access any path that begins with the following, then I see a 404 error:
# - '/merchant'
# - '/cart'
