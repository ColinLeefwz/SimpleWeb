$Logger = Logger.new('log/weibo/sina_categorys.log', 0, 100 * 1024 * 1024)
class Category
  def self.preform
    SinaPoi.where({dt: {"$exists" => false} }).sort({_id: 1}).each do |poi|
      info = "poi_id: #{poi._id};"
      index = SinaCategorys::SINACATEGORY.find_index{ |c| c.include?(poi.category_name)  }
      if index
        info += "成功归为： #{index+1}"
        poi.update_attribute(:dt, index+1)
      else
        info += "failure."
      end
      $Logger.info(info)
    end
  end
end

Category.preform