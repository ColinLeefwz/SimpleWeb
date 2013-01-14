# coding: utf-8

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class LocateTest < ActiveSupport::TestCase
  

  def test_locate1
    puts ENV["RAILS_ENV"] 
    ss = Shop.new.find_shops([ 30.282204, 120.11528 ], 300, "122.235.138.18", "502e6303421aa918ba000001")
    assert_equal 20325453, ss[0]["_id"]
    assert_equal "浙江科技产业大厦", ss[0]["name"]
    assert ss.length>20
    assert ss.find{|x| x["name"] =~ /号院$/}.nil?
    assert ss.find{|x| x["name"] =~ /机构$/}.nil?
  end


  def test_locate2
    ss = Shop.new.find_shops([30.284666, 120.118805], 65, "115.199.110.63", "50446058421aa92042000002")
    assert_equal 5725522, ss[0]["_id"]
    assert_equal "苑苑·美容美发文二路店", ss[0]["name"]
  end
  
  def test_locate3
    ss = Shop.new.find_shops([30.27169, 120.158607], 65, "211.140.18.108", "")
    assert_equal 21000012, ss[0]["_id"]
    assert_equal "杭州百货大楼", ss[0]["name"]
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
    ss = Shop.new.find_shops([30.2815, 120.120285], 65, "115.205.239.246", "50bc20fcc90d8ba33600004b")
    assert_equal 21000003, ss[0]["_id"]
    assert_equal "弄堂里(万塘店)", ss[0]["name"]
  end  

  def test_locate7
    ss = Shop.new.find_shops([30.319336, 120.107246], 65, "211.140.18.114", "")
    assert_equal 9241603, ss[0]["_id"]
    assert_equal "杭州汽车北站", ss[0]["name"]
  end  

  def test_locate8
    ss = Shop.new.find_shops([30.26222, 120.089729], 30, "", "")
    assert_equal 1222273, ss[0]["_id"]
    assert_equal "福云咖啡", ss[0]["name"]
  end  
  
  def test_locate9
    ss = Shop.new.find_shops([30.276918, 120.15477], 85, "", "")
    shop = ss[0,6].find {|x| x["name"]=="星巴克咖啡华浙店"}
    assert_equal "星巴克咖啡华浙店", shop["name"]
  end        

  def test_locate10
    ss = Shop.new.find_shops([30.77376203, 114.208263] , 50, "", "")
    assert ss[0]["name"].index("天河机场")>=0
  end  

  def test_locate11
    ss = Shop.new.find_shops([30.290083, 120.117851], 65, "211.140.18.110", "")
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
    assert_equal "顺旺基中式快餐益乐路", ss[0]["name"]
    assert ss.find {|x| x["name"] =~ /直通车教育中心/ }.nil?
    assert ss[0,3].find {|x| x["name"] =~ /正大医院/ }.nil?
  end 
  
  def test_locate15
    ss = Shop.new.find_shops([30.262188, 120.190781], 65, "", "50446058421aa92042000002")
    assert ss[0,3].find {|x| x["name"] =~ /张生记/ }
  end
  
  
  
  
  def test_shop_similar
    #21612350	赛百味锦绣天地店 10442749	锦绣天地
    assert Shop.similarity_by_id(21612350,10442749)<55
    
    #6551580	糖果KTV	6550857	糖果KTV·CLUB	
    assert Shop.similarity_by_id(6551580,	6550857)>65
    
  	#10464431	斯坦福2平方		0571	西湖紫金港路与振华路交会处
  	#10447006	斯坦福2(平方)		0571	西湖杭大路44号
    assert Shop.similarity_by_id(10464431,	10447006)<52
    
    #6551618	Co·Co CLUB   6556964	COCO酒吧
    assert Shop.similarity_by_id(6551618,	6556964)>70

  	#2036714	豪尚豪宾馆  2032593	杭州豪尚豪旅馆  2032175	杭州豪尚豪客房
    assert Shop.similarity_by_id(2036714,	2032593)>70
    assert Shop.similarity_by_id(2036714,	2032175)>70
    assert Shop.similarity_by_id(2032593,	2032175)>70    
    
    # 7039803	西湖区名苑幼儿园	
    # 7032968	西湖区名苑幼儿园青苑园区 
    # 7053052	名苑幼儿园	
    # 7048974	名苑幼儿园青苑园区
    assert Shop.similarity_by_id(7039803,	7032968)==0  
    assert Shop.similarity_by_id(7039803,	7053052)>70
    assert Shop.similarity_by_id(7032968,	7048974)>70
    assert Shop.similarity_by_id(7053052,	7048974)==0  
    
    assert Shop.similarity(Shop.collection.find({"_id" => 7032968}).first,	Shop.collection.find({"_id" => 7048974}).first)>70
    
  end
  
end
