class Project < ActiveRecord::Base

	has_many :memberships
	has_many :users, :through => :memberships

	validates_presence_of :name

	def self.generate_test_projects
		(0..20).each{|i| self.create(:name => Faker::Commerce.product_name)}
	end
end
