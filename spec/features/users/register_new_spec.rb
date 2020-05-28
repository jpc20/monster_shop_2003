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
    create(:user)
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
    expect(current_path).to eq('/users')

  end

  it "Requires all fields" do
    visit "/"

    click_on "Register"

    expect(current_path).to eq('/register')

    name = "funbucket13"
    address = "test"
    city = ""
    state = "CO"
    zip = "80127"
    email = "test.com"
    password = "1234"

    fill_in :name, with: name
    fill_in :address, with: address
    fill_in :city, with: city
    fill_in :state, with: state
    fill_in :zip, with: zip
    fill_in :email, with: email
    fill_in :password, with: password
    fill_in :confirm_password, with: password

    click_on "Submit"

    expect(page).to have_content("Please fill in city")
    expect(current_path).to eq('/register')

  end

  it "Doesn't allow me to visit role protected pages" do
    user = create(:user, role: 0)
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"


    visit '/merchant'
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist.")

  end

  it "Doesn't allow me log in more than once" do
    user = create(:user, role: 0)
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"

    visit "/login"
    expect(page).to have_content('Already Logged in!')
    expect(current_path).to eq('/profile')
  end

  it "Doesn't allow me log in more than once" do
    user = create(:user, role: 0)
    visit "/"
    click_on "Login"
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on "Log In"

    click_on "Log out"
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Logged Out")
  end
end
