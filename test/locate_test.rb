# coding: utf-8

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

`rm -rf tmp/cache/` #清除缓存

class LocateTest < ActiveSupport::TestCase
  
  def test_json
    ss = Shop.new.find_shops([ 32.192425, 120.803238 ], 5, nil)
    ss.map{|x| x.safe_output_with_users}.to_json
    ss = Shop.new.find_shops([ 30.282204, 120.11528 ], 300, "502e6303421aa918ba000001")
    ss.map{|x| x.safe_output_with_users}.to_json
  end
  
  def test_wifi
    ss = Shop.new.find_shops([30.279564, 120.108803], 50, "502e6303421aa918ba000001", "0:23:89:71:6f:c4")
    assert ss[-1].name != "宝珍大馇粥"
  end
  
  
  def test_locate1
    puts ENV["RAILS_ENV"] 
    ss = Shop.new.find_shops([ 30.282204, 120.11528 ], 300, "502e6303421aa918ba000001")
    assert_equal 20325453, ss[0]["_id"]
    assert_equal "浙江科技产业大厦", ss[0]["name"]
    assert ss.length>20
    assert ss.find{|x| x["name"] =~ /号院$/}.nil?
    assert ss.find{|x| x["name"] =~ /机构$/}.nil?
  end


  def test_locate2
    ss = Shop.new.find_shops([30.284666, 120.118805], 65, "50446058421aa92042000002")
    assert ss.find{|x| x["name"] =~ /苑苑·美容美发文二路店/}
  end
  
  def test_locate3
    ss = Shop.new.find_shops([30.27169, 120.158607], 65, "")
    assert_equal 21000012, ss[0]["_id"]
    assert_equal "杭州百货大楼", ss[0]["name"]
    assert ss.find {|x| x["name"] =~ /珠宝/ }.nil?
    assert ss.length>20
  end

  def test_locate4
    ss = Shop.new.find_shops([30.23394306, 115.4124525 ], 100, "", "")
    assert_equal 7015674, ss[0]["_id"]
    assert_equal "蕲春一中", ss[0]["name"]
  end  

  def test_locate5
    ss = Shop.new.find_shops([30.243870639999997, 115.42569350000001], 100, "", "")
    assert_equal 21814399, ss[0]["_id"]
    assert_equal "百家仓储购物广场", ss[0]["name"]
  end  

  def test_locate6
    ss = Shop.new.find_shops([30.2815, 120.120285], 65, "50bc20fcc90d8ba33600004b")
    assert_equal 21000003, ss[0]["_id"]
    assert_equal "弄堂里(万塘店)", ss[0]["name"]
  end  

  def test_locate7
    ss = Shop.new.find_shops([30.319336, 120.107246], 65, "")
    assert_equal 9241603, ss[0]["_id"]
    assert_equal "杭州汽车北站", ss[0]["name"]
  end  

  def test_locate8
    ss = Shop.new.find_shops([30.26222, 120.089729], 30, "")
    assert_equal 1222273, ss[0]["_id"]
    assert_equal "福云咖啡", ss[0]["name"]
  end  
  
  def test_locate9
    ss = Shop.new.find_shops([30.276918, 120.15477], 85, "")
    shop = ss[0,6].find {|x| x["name"]=="星巴克咖啡华浙店"}
    assert_equal "星巴克咖啡华浙店", shop["name"]
  end        

  def test_locate10
    ss = Shop.new.find_shops([30.77376203, 114.208263] , 50, "")
    assert ss[0,3].find {|x| x["name"] =~ /天河机场/ }
    #assert ss[0]["name"].index("天河机场")>=0
  end  

  def test_locate11
    ss = Shop.new.find_shops([30.290083, 120.117851], 65, "")
    assert_equal 21828370, ss[0]["_id"]
    assert_equal "物美大卖场文一店", ss[0]["name"]
  end  

  def test_locate12
    ss = Shop.new.find_shops([30.279968, 120.111618], 5, "", "")
    assert ss[0]["name"].index("名苑幼儿园")>=0
  end  
  
  def test_locate13
    ss = Shop.new.find_shops([30.286594, 120.115089], 65, "", "")
    assert_equal 7661568, ss[0]["_id"]
    assert_equal "浙江省立同德医院", ss[0]["name"]
    assert ss.find {|x| x["name"] =~ /咨询服务/ }.nil?
    assert ss.find {|x| x["name"] =~ /物业顾问/ }.nil?
  end  

  def test_locate14
    ss = Shop.new.find_shops([30.28053, 120.1096], 65, "", "")
    assert_equal 21626790, ss[0]["_id"]
    assert_equal "可佳基中式快餐益乐路", ss[0]["name"]
    assert ss.find {|x| x["name"] =~ /直通车教育中心/ }.nil?
    assert ss[0,3].find {|x| x["name"] =~ /正大医院/ }.nil?
  end 
  
  def test_locate15
    ss = Shop.new.find_shops([30.262188, 120.190781], 65, "50446058421aa92042000002")
    assert ss[0,3].find {|x| x["name"] =~ /张生记/ }
  end
  
  def test_locate16
    ss = Shop.new.find_shops([30.249882, 120.159645], 65, "" , "38:22:d6:87:5f:f0" )
    assert_equal 21624918, ss[0]["_id"]
    ss = Shop.new.find_shops([30.249849, 120.159599], 65, "" , "38:22:d6:87:5f:f0" )
    assert_equal 21624918, ss[0]["_id"]
  end

  def test_locate17
    ss = Shop.new.find_shops([30.281, 120.110], 65, "502e6303421aa918ba000001" )
    assert ss.find {|x| x["name"] =~ /台北街头/ }
  end
    
  def test_bssid
    s0 = Shop.new.find_shops([ 30.279758, 120.107895 ], 100, "" , nil ,true)[0]
    s1 = Shop.new.find_shops([ 30.279758, 120.107895 ], 100, "" , "0:23:89:71:6f:c4" ,true)[0]
    assert s0[2] > s1[2]
  end
  
  def test_wifi_aboard
    Shop.new.find_shops([ 33.665527, -112.581947 ], 100, "" , nil ,true)
    Shop.new.find_shops([ 43.841984, -79.398109 ], 100, "" , nil ,true)
  end
    
  
  def test_shop_similar
    #21612350	赛百味锦绣天地店 10442749	锦绣天地
    assert Shop.similarity_by_id(21612350,10442749)<55
    
    #6551580	糖果KTV	6550857	糖果KTV·CLUB	
    assert Shop.similarity_by_id(6551580,	6550857)>65
    
    #6551618	Co·Co CLUB   6556964	COCO酒吧
    assert Shop.similarity_by_id(6551618,	6556964)>68

  	#2036714	豪尚豪宾馆  2032593	杭州豪尚豪旅馆  2032175	杭州豪尚豪客房
    
    # 7039803	西湖区名苑幼儿园	
    # 7032968	西湖区名苑幼儿园青苑园区 
    # 7053052	名苑幼儿园	
    # 7048974	名苑幼儿园青苑园区
        
    #国美电器公主坟店 - 苏宁电器公主坟店
    assert Shop.similarity_by_id(2408713,2447317)<56
    #海拉尔贝尔大酒店(呼伦贝尔) - 海拉尔凯顿大酒店(呼伦贝尔)
    assert Shop.similarity_by_id(8475,1642617)<63
    
    #布尔津旅游宾馆 - 阿勒泰旅游宾馆 ??
  end
  
end
