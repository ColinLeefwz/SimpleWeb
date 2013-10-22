# coding: utf-8
require 'test_helper'

class CityTest < ActiveSupport::TestCase


  def setup
    $redis.set("CityName00001","湖北;蕲春")
  end

  test "测试城市名称" do
    assert_equal "中国;湖北;蕲春" , City.cascade_name("00001")
    assert_equal "湖北;蕲春" , City.fullname("00001")
     assert_equal "湖北;蕲春" , City.pro_city_name("00001")
    assert_equal "蕲春" , City.city_name("00001")
  end
  

end
