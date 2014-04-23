# coding: utf-8

module Shop3MenuHelper
  def mobile_articles_desc_by_category(category, limit=10)
    MobileArticle.by_sid(session[:shop_id]).by_category(category).desc.limit(limit)
  end
end