# encoding: utf-8

class NewUser
  @queue = :normal

  def self.perform(uid,sid,od)
    return if Rails.cache.read("NEWUSER#{uid}")
    Rails.cache.write("NEWUSER#{uid}", 1)
    ud=UserDevice.find_by_id(uid)
    ["502e6303421aa918ba000001","50446058421aa92042000002","50ffd0e5c90d8bf7480000b7","51b16477c90d8ba01f0000bb","51b5659dc90d8b511d00002f","51f9e3b9c90d8ba99d000002","51a4b135c90d8be50b000059"].each do |to|
      NewUser.notify(uid,sid, to, od, ud)
    end
    ["502e6303421aa918ba000079"].each do |to|
      NewUser.notify(uid,sid, to, od, ud, 2 )
    end
    ["51163b3ac90d8b90650001d5"].each do |to|
      NewUser.notify(uid,sid, to, od, ud, 2 )
    end
    ["50ea8be1c90d8bd530000020","513ecdf0c90d8b5901000123"].each do |to|
      NewUser.notify(uid,sid, to, od, ud, 0, "0571" )
    end
    ["516940f2c90d8b64f0000058"].each do |to|
      NewUser.notify(uid,sid, to, od, ud, 2, "0571" )
    end  

    if ud && ud.os_type==1
      ["51163b3ac90d8b90650001d5","5160f00fc90d8be23000007c","519d894dc90d8b83ee000008"].each do |to|
        NewUser.notify(uid,sid, to, od, ud)
      end
    end
    Resque.enqueue(NewUserWelcome, uid,sid,1)
    #Resque.enqueue_in(3.seconds, NewUserWelcome, uid,sid,2)
    #Resque.enqueue_in(6.seconds, NewUserWelcome, uid,sid,3)
    Resque.enqueue_in(10.seconds, NewUserWelcome, uid,sid,4) unless Shop.find_by_id(sid).city=="0571"
    if User.find(uid).gender
      Resque.enqueue_in(50.seconds, NewUserTalk, uid,sid,1)
      Resque.enqueue_in(55.seconds, NewUserTalk, uid,sid,2)
    end
  end
  
  def self.notify(uid,sid, to, od, ud, gender=0, city=nil)
    user = User.find(uid)
    if gender!=0
      return if user.gender!=gender
    end
    shop = Shop.find_primary(sid)
    if city
      return if city!=shop.city
    end
    if user.qq
      from="qq"
    elsif user.phone
      from="手机#{user.phone}"
    else
      from="微博"
    end
    if ud && ud.os_type==1
      ver = ud.ds[0][3]
      os = "#{ud.ds[0][1]},#{ver}"
    else
      os = ""
    end
    Xmpp.send_chat(uid,to,"#{user.show_gender}:#{od}:#{from}#{os} #{shop.name} #{shop.city_fullname}", "FEED#{$uuid.generate}", " NOLOG='1' NOPUSH='1' ")
  end
  
end
