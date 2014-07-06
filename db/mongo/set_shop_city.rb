puts Shop.where({city:nil}).count
Shop.where({city:nil}).each do |x| 
  next unless x.lo
  city = Shop.get_city(x.loc_first)
  x.set(:city,city) if city
end
puts Shop.where({city:nil}).count

