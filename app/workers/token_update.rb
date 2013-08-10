# encoding: utf-8

class TokenUpdate
  @queue = :normal

  def self.perform(id,pass)
    if pass.length>(1+64) #硬编码了token的长度：64
      ptoken = pass[-65..-1]
      pass = pass[0..-66]
      user = User.find_by_id(id)
      user = User.find_primary(id) if user.nil?
      return if user.password != pass
      if ptoken && (user.tk.nil? || user.tk != ptoken)
        #User.collection.find({_id:user._id}).update("$set" => {tk:ptoken}) 
        ptoken = ptoken[0,33] if ptoken[0]=="3" #个推的cid为32位
        if ptoken[0]=="4" #百度云推送
          len = ptoken.rindex(",")
          ptoken = ptoken[0,len]
        end
        user.update_attribute(:tk, ptoken)
        user.del_my_cache
      end
    end
  end
  
end
