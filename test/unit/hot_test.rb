# coding: utf-8
require 'test_helper'

class HotTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
	test "#show_shop_name" do
		before(:each) do
			@test_shop = Shop.new(id: 12, name: "test", city: "test", password: "123123123")
			@test_hot_shop = Hot.new(id: 10000, shop_id: 12)
			@test_shop.save
			@test_hot_shop.save
		end

		test "should return the wrong message" do
      assert_equal(@test_hot_shop.show_shop_name, "商家名称未找到")
		end
	end
end
