



File.open("migrate_category.yml", "w") do |f|
  Session.all.each do |s|
    f.write(s.id.to_s + ":" + s.category.to_s + "\n")
  end
end
