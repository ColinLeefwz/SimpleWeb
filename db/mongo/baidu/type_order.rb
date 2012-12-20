#Shop 中归整type 中包含<\\/font>的商家

Shop.where({type: /font>/}).each do |shop|
  shop.update_attribute(:type, shop.type.gsub(/<.*?>/,''))
end
