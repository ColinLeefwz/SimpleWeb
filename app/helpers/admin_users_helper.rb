# encoding: utf-8
module AdminUsersHelper

  def chat_img(text)
    if mat = text.match(/\[img:(.*)\]/)
      photo = Photo2.find_by_id(mat[1])
      return text if photo.nil?
      text = text.sub(mat[1],"<a href=#{photo} target='_blank'>#{mat[1]}</a><img src='#{photo.img.url(:t2)}' />" )
    end
    text
  end
end
