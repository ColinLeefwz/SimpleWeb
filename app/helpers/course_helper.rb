module CourseHelper
	def producer_links(course)
		expert_links = []
		course.experts.each do |expert|
			expert_links << link_to(expert.name, profile_expert_path(expert))
		end
		raw "by #{expert_links.join(" and ")}"
	end
end
