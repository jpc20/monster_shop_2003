require 'rails_helper'

RSpec.describe "User registration form" do
  it "creates new user" do
    visit "/"

    click_on "Register"

    expect(current_path).to eq('/register')

    name = "funbucket13"
    address = "test"
    city = "denver"
    state = "CO"
    zip = "80127"
    email = "bucket@bucket.com"
    password = "1234"
    # wrong_pass = "2333"

    fill_in :name, with: name
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip, with: zip
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :confirm_password, with: password

    click_on "Submit"

    expect(current_path).to eq('/profile')

    expect(page).to have_content("Hi #{name} you have registered and logged in!")
  end
  it "prevents email reuse" do
    user_1 = User.create(name: "john",
                         address: "1234 town",
                          city: "Denver",
                          state: "CO",
                          zip: "80127",
                          email: "test.com",
                          password: "1234")
    visit "/"

    click_on "Register"

    expect(current_path).to eq('/register')

    name = "funbucket13"
    address = "test"
    city = "denver"
    state = "CO"
    zip = "80127"
    email = "test.com"
    password = "1234"
    # wrong_pass = "2333"

    fill_in :name, with: name
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip, with: zip
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :confirm_password, with: password

    click_on "Submit"

    expect(page).to have_content("This email already exists")
    expect(current_path).to eq('/register')

  end
end

# [ ] done
#
# User Story 10, User Registration
#
# As a visitor
# When I click on the 'register' link in the nav bar
# Then I am on the user registration page ('/register')
# And I see a form where I input the following data:
# - my name
# - my street address
# - my city
# - my state
# - my zip code
# - my email address
# - my preferred password
# - a confirmation field for my password
#
# When I fill in this form completely,
# And with a unique email address not already in the system
# My details are saved in the database
# Then I am logged in as a registered user
# I am taken to my profile page ("/profile")
# I see a flash message indicating that I am now registered and logged in
