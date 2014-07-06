Baidu.collection.find({type:/^地产小区/}).each do |x|
        begin
          name = x["name"]
          next if name =~ /商铺$/
          next if name =~ /号楼$/
          next if name =~ /公司$/
          next if name =~ /招商处$/          
          next if name =~ /门$/
          next if name =~ /座$/
          next if name =~ /号$/
          next if name =~ /院$/
          next if name =~ /筹建处$/
          next if name =~ /销售中心$/
          next if name =~ /售楼/
          next if name =~ /大厦[^大]+$/  
          next if name =~ /）$/
          next if name =~ /\)$/
          next if name.length>12
          next if Shop.where({name:name}).count>0
          next if Shop.where({:t => 10, :name => /^#{name[0,6]}/}).count>0
          Shop.collection.database.session[:tmp].insert(x)
        rescue Exception =>e
                puts x.to_yaml
                puts e
        end
end

