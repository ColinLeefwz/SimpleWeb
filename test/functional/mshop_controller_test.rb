# coding: utf-8

require 'test_helper'

class MshopControllerTest < ActionController::TestCase
=begin
  # Replace this with your real tests.
  test "nearby 经纬度查询" do
    get :nearby, :lat => 30.2829754, :lng => 120.1337336
    assert_equal([1,2,3], assigns["mshops"].map{|m| m.id})
  end

  test "nearby 经纬度加类别查询" do
    get :nearby, :lat => 30.2829754, :lng => 120.1337336, :mcategory_id => 3
    assert_equal([1,2], assigns["mshops"].map{|m| m.id}.sort)
  end

  test "nearby 经纬度加名称查询" do
    get :nearby, :lat => 30.2829754, :lng => 120.1337336, :name=> '川香'
    assert_equal Mshop.find_all_by_id([2]), assigns["mshops"]
  end

  test "nearby 经纬度加类别加名称查询" do
    get :nearby, :lat => 30.2829754, :lng => 120.1337336, :mcategory_id => 3, :name=> '川香'
    assert_equal Mshop.find_all_by_id([2]), assigns["mshops"]
  end
=end  

end
