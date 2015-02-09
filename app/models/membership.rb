class Membership < ActiveRecord::Base
	serialize :other_info

	belongs_to :project
	belongs_to :user

	validates_presence_of :project_id
	validates_presence_of :user_id

	def view_info
		view_info = ""
		if other_info.present?
			self.other_info.each do |name, value|
				view_info += "#{name} - #{value}\n"
			end
		end
		view_info
	end
end
