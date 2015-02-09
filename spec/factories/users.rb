FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
	name Faker::Name.name
	born_on Faker::Date.between(60.years.ago, 20.years.ago)
	gender "male"
	password Faker::Internet.password

	factory :user_with_project do

      # In later (as of this writing, unreleased) versions of FactoryGirl
      # you will need to use `transitive` instead of `ignore` here
      ignore do
        project { create :project }
      end

      after :create do |user, member|
        user.projects << member.project
        user.save
        user_project = user.memberships.where(project:member.project).first

     	user_project.other_info = {:hours_worked => Faker::Number.digit}
        user_project.save	

      end
    end
  end

end
