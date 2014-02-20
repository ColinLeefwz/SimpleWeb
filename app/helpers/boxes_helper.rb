module BoxesHelper
  def expert_image_helper(item)
    if item.is_a? Course
      link_to image_tag(item.experts.first.avatar.url), profile_expert_path(item.experts.first)
    else
      expert = item.expert
      image = image_tag(expert.avatar.url)
      expert.is_staff ? (raw image) : (link_to image, profile_expert_path(expert))
    end
  end

  def expert_name_helper(item)
    html = ""
    if item.is_a? Course
      item.experts.each do |expert|
        html << capture { link_to expert.name_with_inital, profile_expert_path(expert) }
        html << "  "
      end
    else
      expert = item.expert
      name = item.expert.name
      html = expert.is_staff ? (raw name) : (link_to name, profile_expert_path(expert))
    end
    html.html_safe
  end
end
