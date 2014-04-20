module BoxableDecorator
  include Draper::LazyHelpers
  def get_tooltip
    Landingitem::TOOL_TIPS[object.class.name]
  end

  def get_image_tag
    Landingitem::IMAGE_TAGS[object.class.name]
  end

  def get_box_class
    box_class = " item " + object.categories.pluck(:name).join(" ") + " "
    box_class += object.class.name
    box_class += " always_show" if object.try(:always_show)

    box_class.downcase()
  end

  def expert_image_helper
    if object.is_a? Course
      link_to(image_tag(object.experts.first.avatar.url), profile_expert_path(object.experts.first))
    else
      expert = object.expert
      image = h.image_tag(expert.avatar.url)
      expert.is_staff ? (raw image) : (link_to image, profile_expert_path(expert))
    end
  end

  def expert_name_helper
    html = ""
    if object.is_a? Course
      object.experts.each do |expert|
        html << h.capture { link_to expert.name_with_inital, profile_expert_path(expert) }
        html << "  "
      end
    else
      expert = object.expert
      name = object.expert.name
      html = expert.is_staff ? (raw name) : (link_to name, profile_expert_path(expert))
    end
    html.html_safe
  end
end
