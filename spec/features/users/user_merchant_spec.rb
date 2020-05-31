require 'rails_helper'

RSpec.describe "As a merchant" do
  before :each do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

    @user = create(:user, role: 1, merchant_id: @bike_shop.id)
  end

  it "can log in with as a merchant" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    expect(current_path).to eq('/merchant')

    expect(page).to have_content("Logged in as #{@user.name}")
    expect(page).to have_link("Log out")
    expect(page).to_not have_link("Register")
    expect(page).to_not have_link("Login")
    click_on "Merchant Dashboard"
    expect(current_path).to eq("/merchant")
  end

  it "Doesn't allow me to visit role protected pages" do
    visit "/"
    click_on "Login"
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"

    visit '/admin'
    expect(page).to have_content("The page you were looking for doesn't exist.")

  end

  it "Doesn't allow me log in more than once" do
    visit "/"
    click_on "Login"
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"

    visit "/login"
    expect(page).to have_content('Already Logged in!')
    expect(current_path).to eq('/merchant')
  end

  it "Can see merchant's name and full address in dashboard" do
    visit "/"
    click_on "Login"
    expect(current_path).to eq('/login')
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Log In"
    expect(current_path).to eq('/merchant')

    expect(page).to have_content(@bike_shop.name)
    expect(page).to have_content(@bike_shop.address)
    expect(page).to have_content(@bike_shop.city)
    expect(page).to have_content(@bike_shop.state)
    expect(page).to have_content(@bike_shop.zip)

  end

end
