module LandingPageHelper
  def correct_path(content)
    if content.is_a? Session
      article_path(content)
    elsif content.is_a? VideoInterview
      video_interview_path(content)
    elsif content.is_a? Announcement
      announcement_path(content)
    end
  end

	def expert_link(item)
		expert_email = item.expert.email
		if expert_email == "prodygia@prodygia.com"
			item.expert.name
		else
			link_to item.expert.name, profile_expert_path(item.expert)
		end
	end

	def expert_image_link(item)
		expert_email = item.expert.email
		if expert_email == "prodygia@prodygia.com"
			image_tag(item.expert.avatar.url)
		else
			link_to image_tag(item.expert.avatar.url), profile_expert_path(item.expert)
		end
	end
end
