

IO.readlines("migrate_category.yml").each do |line|
  record = line.split(":") 
  session_id = record[0].to_i
  session_category = record[1].to_s
  
  s = Session.find(session_id)
  s.categories << session_category
  s.save
end
