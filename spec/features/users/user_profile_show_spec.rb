require 'rails_helper'

RSpec.describe "User Profile page" do
  it "User sees all of their information minus password" do
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
    fill_in :password_confirmation, with: password

    click_on "Submit"

    expect(current_path).to eq('/profile')
    expect(page).to have_content("funbucket13")
    expect(page).to have_content("test")
    expect(page).to have_content("denver")
    expect(page).to have_content("CO")
    expect(page).to have_content("80127")
    expect(page).to have_content("bucket@bucket.com")
    expect(page).to_not have_content("1234")
    expect(page).to have_link("Update Profile Information")

  end
  it "Edit user profile" do
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
    fill_in :password_confirmation, with: password

    click_on "Submit"


    click_on "Update Profile Information"
    expect(current_path).to eq('/register/edit')
    expect(find_field(:name).value).to eq "funbucket13"
    expect(find_field(:address).value).to eq "test"
    expect(find_field(:city).value).to eq "denver"
    expect(find_field(:state).value).to eq "CO"
    expect(find_field(:zip).value).to eq "80127"
    expect(find_field(:email).value).to eq "bucket@bucket.com"

    fill_in :city, with: "Littlton"
    fill_in :state, with: "AZ"
    fill_in :zip, with: "22222"
    fill_in :email, with: "funbucket13.com"
    click_on "Submit"
    expect(current_path).to eq('/profile')
    expect(page).to have_content("funbucket13")
    expect(page).to have_content("test")
    expect(page).to have_content("Littlton")
    expect(page).to have_content("AZ")
    expect(page).to have_content("22222")
    expect(page).to have_content("funbucket13.com")
    expect(page).to have_content("Your data is updated!")
  end
  it "Edit user profile with existing email" do
    user = create(:user)
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
    fill_in :password_confirmation, with: password

    click_on "Submit"


    click_on "Update Profile Information"
    expect(current_path).to eq('/register/edit')
    expect(find_field(:name).value).to eq "funbucket13"
    expect(find_field(:address).value).to eq "test"
    expect(find_field(:city).value).to eq "denver"
    expect(find_field(:state).value).to eq "CO"
    expect(find_field(:zip).value).to eq "80127"
    expect(find_field(:email).value).to eq "bucket@bucket.com"

    fill_in :city, with: "Littlton"
    fill_in :state, with: "AZ"
    fill_in :zip, with: "22222"
    fill_in :email, with: "test.com"
    click_on "Submit"

    expect(page).to have_content("Email has already been taken")

  end
  it "User sees all of their information minus password" do
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
    fill_in :password_confirmation, with: password

    click_on "Submit"

    expect(current_path).to eq('/profile')
    click_on "Change Password"
    expect(current_path).to eq('/register/password')
    fill_in :password, with: "5678"
    fill_in :password_confirmation, with: "5678"
    click_on "Submit"
    expect(current_path).to eq('/profile')
    expect(page).to have_content("Your password has been changed!")

  end
  it "displays orders link" do
    @user = create(:user)
    bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    order1 = Order.create(name: @user.name, address: @user.address, city: @user.city,
      state: @user.state, zip: @user.zip, user_id: @user.id, status: "pending")
      ItemOrder.create(order_id: order1.id, item_id: tire.id, price: 100, quantity: 1)
    visit '/'
    click_on "Login"
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"

    visit "/profile"

    click_on "My Orders"

    expect(current_path).to eq('/profile/orders')
  end
end

# User Story 27, User Profile displays Orders link
#
# As a registered user
# When I visit my Profile page
# And I have orders placed in the system
# Then I see a link on my profile page called "My Orders"
# When I click this link my URI path is "/profile/orders"
