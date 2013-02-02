# coding: utf-8
require 'test_helper'

class ShopTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test ".find_by_id 不存在的id返回nil" do
    {:a => "\360\237\230\204"}.to_json.to_s == "{\"a\":\"😄\"}"
    {:a => "\360\237\230\204"}.to_json == "{\"a\":\"😄\"}"
    assert_equal Shop.find_by_id('12345'), nil
  end
  
  test ".find_by_id 存在的id 能正确的查询" do
    assert_equal Shop.find_by_id('1').name, '测试1'
  end

  
end

