# encoding: utf-8
module ShopCheckinsHelper
  def img_gender(gender)
    case gender
    when 1
      image_tag("../images/sign6.jpg")
    when 2
      image_tag("../images/sign7.jpg")
    end
  end

  def age(birthday)
    return if birthday.blank?
    l = Time.now.to_date
    b = birthday
    a = l.year-b.year
    a-1 if "#{l.month}#{l.day}" < "#{b.month}#{b.day}"
  end

end
