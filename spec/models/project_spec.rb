require 'spec_helper'

describe Project do

  it { should validate_presence_of(:name) }
  it { should have_many(:memberships) }
  it { should have_many(:users) }

  describe "creation" do

    context "valid attributes" do

      it "should be valid" do
        project = FactoryGirl.build(:project)

        project.should be_valid
      end

    end

    context "invalid attributes" do

      it "should not be valid" do
        project = FactoryGirl.build(:project, name: "")

        project.should_not be_valid
      end

    end

  end

end
