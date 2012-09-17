# coding: utf-8
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test ".find2 find 不存在的id返回nil" do
    assert_equal User.find2('12345'), nil
  end

  test ".find2 find 存在的id 能正确的查询" do
    assert_equal User.find2("502e6303421aa918ba00007c").name, '袁乐天'
  end

end

