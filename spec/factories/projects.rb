FactoryGirl.define do
  factory :project do
    name "My First Project"

     factory :project_with_user do

      # In later (as of this writing, unreleased) versions of FactoryGirl
      # you will need to use `transitive` instead of `ignore` here
      ignore do
        user { create :user }
      end

      after :create do |project, member|
        project.users << member.user
        project.save
        project_user = project.memberships.where(user:member.user).first

        project_user.other_info = {:hours_worked => Faker::Number.digit}
   
        project_user.save	

      end
    end
  end
end
