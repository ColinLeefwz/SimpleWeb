# coding: utf-8
require 'test_helper'

class ShopTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test ".find_by_id 不存在的id返回nil" do
    assert_equal Shop.find_by_id('12345'), nil
  end
  
  test ".find_by_id 存在的id 能正确的查询" do
    assert_equal Shop.find_by_id('1').name, '测试1'
  end

  test '.loc_first loc数组的第一个元素是数组, 返回第一个元素' do
    shop = Shop.find_by_id(2)
    assert_equal shop.loc_first, [39.896445, 30.2359]
  end

  test '.loc_first loc数组的第一个元素不是数组, 返回loc' do
    shop = Shop.find_by_id(1)
    assert_equal shop.loc_first, [39.896445, 116.317378]
  end

  
end

