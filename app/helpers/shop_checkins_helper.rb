# encoding: utf-8
module ShopCheckinsHelper


  def ban_link(uid)
    if session_shop.ban_user(uid)
      link_to '解除屏蔽', "/shop_checkins/unban?uid=#{uid}&page=#{params[:page]}&name=#{params[:name]}"
    else
      link_to '屏蔽', "/shop_checkins/do_ban?uid=#{uid}&page=#{params[:page]}&name=#{params[:name]}"
    end
  end

  def shop3_ban_link(uid)
    if session_shop.ban_user(uid)
      link_to '解除屏蔽', "/shop3_checkins/unban?uid=#{uid}&page=#{params[:page]}&name=#{params[:name]}"
    else
      link_to '屏蔽', "/shop3_checkins/do_ban?uid=#{uid}&page=#{params[:page]}&name=#{params[:name]}"
    end
  end

end
