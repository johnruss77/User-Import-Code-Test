class User < ActiveRecord::Base
	has_many :memberships
	has_many :projects, :through => :memberships

	enum gender: { male: 1, female: 0 }

	INVALID_EMAIL = "is not a valid email address"

	validates_presence_of :email
	validates_uniqueness_of :email, :case_sensitive => false
	validate :must_be_valid_email

	validates :gender, inclusion: { in: ['male', 'female', nil] }

	def must_be_valid_email
      unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        errors.add(:email, User::INVALID_EMAIL)
      end
  	end
end
