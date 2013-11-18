

categories = %w(macro business entrepreneurship tech culture)

categories.each do |c|
  Category.create(name: c)
end
