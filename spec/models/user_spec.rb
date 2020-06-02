require 'rails_helper'

describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of :password }
  end

  describe "relationships" do
    it { should have_many :orders}
    it { should belong_to(:merchant).optional}
  end

  describe "roles" do
    it "can be created as default user" do
      user = create(:user)
      expect(user.role).to eq("default")
      expect(user.default?).to be_truthy
    end

    it "can be created as a merchant user" do
      user = build(:user, role: 1)
      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
    end

    it "can be created as a admin user" do
      user = build(:user, role: 2)
      expect(user.role).to eq("admin")
      expect(user.admin?).to be_truthy
    end

  end

end
