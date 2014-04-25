class CourseDecorator < ApplicationDecorator
  delegate_all

  def producer_links
    expert_links = []
    object.experts.each do |expert|
      expert_links << link_to(expert.name, profile_expert_path(expert))
    end
    raw "by #{expert_links.join(" and ")}"
  end
end
