module WeiboUser
  extend RequestApi
  request_sina :login, nil
  USER=[{:n=>"2594426404@qq.com", :p=>"x123456", :u=>"510b58bcc90d8bff0c00083f"},
    {:n=>"2643617682@qq.com", :p=>"x123456", :u=>"513ebae8c90d8b5e01000082"},
    {:n=>"1806273807@qq.com", :p=>"x123456", :u=>"513ecdf0c90d8b5901000123"},
    {:n=>"2591409368@qq.com", :p=>"x123456", :u=>"513ec2e7c90d8b5e010000d1"},
    {:n=>"2553262913@qq.com", :p=>"x123456", :u=>"513ec89cc90d8b5b010000d1"},
    {:n=>"1613280358@qq.com", :p=>"x123456", :u=>"513ed1e7c90d8b590100016f"},
    {:n=>"2258491487@qq.com", :p=>"x123456", :u=>"5141764fc90d8bc67b0002b8"},
    {:n=>"2219713674@qq.com", :p=>"x123456", :u=>"5141790fc90d8bc67b0002db"},
    {:n=>"1961682732@qq.com", :p=>"x123456", :u=>"514179b1c90d8bc67b0002fb"},
    {:n=>"1239480146@qq.com", :p=>"x123456", :u=>"513ec9dac90d8b59010000fb"},
    {:n=>"1470600720@qq.com", :p=>"x123456", :u=>"51909244c90d8bc2ee00003e"},
    {:n=>"2589583903@qq.com", :p=>"x123456", :u=>"51413be6c90d8b681d00057d"},
    {:n=>"2824917653@qq.com", :p=>"x123456", :u=>"51413fd4c90d8b5215000561"},
    {:n=>"2306775877@qq.com", :p=>"x123456", :u=>"514143dbc90d8b52150005e3"},
    {:n=>"2573897676@qq.com", :p=>"x123456", :u=>"5141469ec90d8b681d000681"},
    {:n=>"1912801814@qq.com", :p=>"x123456", :u=>"51415eb0c90d8bc37b0001a0"},
    {:n=>"1465594939@qq.com", :p=>"x123456", :u=>"51416042c90d8bc97b00014a"},
    {:n=>"2589740980@qq.com", :p=>"x123456", :u=>"514162e9c90d8bc97b000187"},
    {:n=>"1437896684@qq.com", :p=>"x123456", :u=>"5141667fc90d8bc67b000186"},
    {:n=>"718857861@qq.com", :p=>"x123456", :u=>"514167e9c90d8bc37b0002d7"},
    {:n=>"2286287737@qq.com", :p=>"x123456", :u=>"51417b05c90d8bc37b000473"},
    {:n=>"1877262337@qq.com", :p=>"x123456", :u=>"51417e23c90d8bc37b00048f"},
    {:n=>"1841926434@qq.com", :p=>"x123456", :u=>"51417ee3c90d8bc37b000497"},
    {:n=>"1815395098@qq.com", :p=>"x123456", :u=>"51417f8cc90d8bc37b00049f"},
    {:n=>"1423719493@qq.com", :p=>"x123456", :u=>"51418667c90d8bc67b000421"},
    {:n=>"1853822066@qq.com", :p=>"x123456", :u=>"514186f3c90d8bc97b000511"},
    {:n=>"1423251767@qq.com", :p=>"x123456", :u=>"51418783c90d8bc97b000517"},
    {:n=>"1687968243@qq.com", :p=>"x123456", :u=>"51418836c90d8bc37b000567"},
    {:n=>"2565499813@qq.com", :p=>"x123456", :u=>"514188d4c90d8bc97b000569"},
    {:n=>"1472579921@qq.com", :p=>"x123456", :u=>"5141899fc90d8bc97b00056f"},
    {:n=>"2560301789@qq.com", :p=>"x123456", :u=>"519092c2c90d8b2747000038"},
    {:n=>"1686098281@qq.com", :p=>"x123456", :u=>"51418bf7c90d8bc37b0005d2"},
    {:n=>"1516614301@qq.com", :p=>"x123456", :u=>"51418cfdc90d8bc37b000644"},
    {:n=>"1463492806@qq.com", :p=>"x123456", :u=>"514190f8c90d8bc67b00054a"},
    {:n=>"1956075338@qq.com", :p=>"x123456", :u=>"5141921ec90d8bc97b00069d"},
    {:n=>"2590909387@qq.com", :p=>"x123456", :u=>"514196f6c90d8bc67b000584"},
    {:n=>"1785168280@qq.com", :p=>"x123456", :u=>"51419910c90d8bc67b0005a8"},
    {:n=>"2827738230@qq.com", :p=>"x123456", :u=>"514199a0c90d8bc97b000773"},
    {:n=>"1729818738@qq.com", :p=>"x123456", :u=>"51419a00c90d8bc67b0005b5"},
    {:n=>"2625344960@qq.com", :p=>"x123456", :u=>"51419b91c90d8bc37b000819"},
    {:n=>"2524546021@qq.com", :p=>"x123456", :u=>"51419c4cc90d8bc37b000826"},
    {:n=>"1642476925@qq.com", :p=>"x123456", :u=>"51419db8c90d8bc97b0007bd"},
    {:n=>"2312915974@qq.com", :p=>"x123456", :u=>"51419ec0c90d8bc97b0007c1"},
    {:n=>"2824380123@qq.com", :p=>"x123456", :u=>"51419fdbc90d8bc97b0007e7"},
    {:n=>"2824380123@qq.com", :p=>"x123456", :u=>"51419fdbc90d8bc97b0007e7"},
    {:n=>"kuhome_003@163.com", :p=>"111222333", :u=>"513e8c72c90d8b0b0a0002ea"},
    {:n=>"kuhome_004@163.com", :p=>"111222333", :u=>"513e8f16c90d8b9f7d0002be"},
    {:n=>"kuhome_005@163.com", :p=>"111222333", :u=>"513e9311c90d8b0b0a000348"},
    {:n=>"2692441587@qq.com", :p=>"111222333", :u=>"514285e7c90d8be76c0004a2"},
    {:n => '2692441587@qq.com', :p => 'x123456', :u => '51428dcfc90d8be76c0004cf'}
  ]

  #马甲帐号模拟登录
  def self.do_login(name, pass)
    login(:url => 'https://api.weibo.com/oauth2/access_token', :method => :post,
      :params => { :client_id => $sina_api_key, :client_secret => $sina_api_key_secret, :grant_type => 'password',
        :username => name, :password => pass})
  end

  def self.get_uid(name, pass)
    th = do_login(name, pass)
    return if th.nil?
    th['uid'] 
  end

  #马甲帐号设置登录token存到redis
  def self.set_token(name, pass, uid)
    return  if  $redis.get("wbtoken#{uid}")
    th = do_login(name, pass)
    return if th.nil?
    $redis.set("wbtoken#{uid}",th['access_token'])
  end

  #所有马甲的token到redis中
  def self.redis_token
    USER.each do |u|
      set_token(u[:n], u[:p], u[:u])
    end
  end

end