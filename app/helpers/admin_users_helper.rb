# encoding: utf-8
module AdminUsersHelper

  def chat_img(text)
    if mat = text.match(/\[img:(.*)\]/)
      text = text.sub(mat[1],"<a href=#{Photo2.find(mat[1]).img} target='_blank'>#{mat[1]}</a><img src='#{Photo2.find(mat[1]).img.url(:t2)}' />" )
    end
    text
  end
end
