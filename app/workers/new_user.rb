# encoding: utf-8

class NewUser
  @queue = :normal

  def self.perform(uid,sid,od)
    ud=UserDevice.find_by_id(uid)
    ["502e6303421aa918ba000001","50446058421aa92042000002","50ffd0e5c90d8bf7480000b7","516940f2c90d8b64f0000058"].each do |to|
      NewUser.notify(uid,sid, to, od, ud)
    end
    ["502e6303421aa918ba000079"].each do |to|
      NewUser.notify(uid,sid, to, od, ud, 2 )
    end
    ["51163b3ac90d8b90650001d5"].each do |to|
      NewUser.notify(uid,sid, to, od, ud, 2 )
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
  
  def self.notify(uid,sid, to, od, ud, gender=0)
    user = User.find(uid)
    if gender!=0
      return if user.gender!=gender
    end
    shop = Shop.find_primary(sid)
    if user.qq
      from="qq"
    else
      from="微博"
    end
    if ud && ud.os_type==1
      ver = ud.ds[0][3]
      os = "#{ud.ds[0][1]},#{ver}"
    else
      os = ""
    end
    xmpp = Xmpp.chat(uid,to,"#{user.show_gender}:#{od}:#{from}#{os} #{shop.name} #{shop.city_fullname}")
    RestClient.post("http://#{$xmpp_ip}:5280/rest", xmpp) 
  end
  
end
