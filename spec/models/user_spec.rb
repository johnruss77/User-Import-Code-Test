require 'spec_helper'

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_many(:memberships) }
  it { should have_many(:projects) }
  
  it "should allow valid values" do
    ['male', 'female', nil].each do |v|
      should allow_value(v).for(:gender)
    end
  end

  describe "creation" do

    context "valid attributes" do

      it "should be valid" do
        user = FactoryGirl.build(:user)

        user.should be_valid
      end

    end

    context "invalid attributes" do

      it "should not allow blank email" do
        user = FactoryGirl.build(:user, email: "")

        user.should_not be_valid
      end

      it "should not allow invalid email" do
    	user = FactoryGirl.build(:user, email: "test123")
    	user.should_not be_valid
  	  end

    end

  end
end
