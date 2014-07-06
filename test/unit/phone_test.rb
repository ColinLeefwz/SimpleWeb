# coding: utf-8
require 'test_helper'

class PhoneTest < ActiveSupport::TestCase

  include PhoneUtil 


  test "手机号码的有效性" do
    assert_equal true, valid_phone("15868870051")
    assert_equal true, valid_phone("000007777777")
    assert_equal false, valid_phone("1586887005")
    assert_equal false, valid_phone("05868870051")
    
  end
  

end
