require 'spec_helper'

describe Membership do
  it { should validate_presence_of(:project_id) }
  it { should validate_presence_of(:user_id) }
  it { should serialize(:other_info) }

  it { should belong_to(:project) }
  it { should belong_to(:user) }


  describe "creation" do

    context "valid attributes" do

      it "should be valid - associate user to project" do
        project_membership = FactoryGirl.create :project_with_user
        project_membership.memberships.each do |m|
        	m.should be_valid
        	puts m.other_info
        end
      end

      it "should be valid - associate project to user" do
        project_membership = FactoryGirl.create :user_with_project
        project_membership.memberships.each do |m|
        	m.should be_valid
        end
      end

      
    end

  end
end
