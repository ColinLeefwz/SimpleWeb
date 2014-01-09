module LandingPageHelper
  def currect_path(session)
    if session.is_a? Session
      article_path(session)
    elsif session.is_a? VideoInterview
      video_interview_path(session)
    elsif session.is_a? Announcement
      announcement_path(session)
    end
  end

	def expert_link(item)
		expert_email = item.expert.email
		if expert_email == "prodygia@prodygia.com"
			item.expert.name
		else
			link_to item.expert.name, profile_url(subdomain: item.expert.subdomain)
		end
	end

	def expert_image_link(item)
		expert_email = item.expert.email
		if expert_email == "prodygia@prodygia.com"
			image_tag(item.expert.avatar.url)
		else
			link_to image_tag(item.expert.avatar.url), profile_url(subdomain: item.expert.subdomain)
		end
	end
end
