# coding: utf-8
require 'test_helper'

class UserLogoTest < ActiveSupport::TestCase


  test "save!" do
    x = UserLogo.new
    assert_equal true, x.new_record?
    assert_equal true, x.save!
    assert_equal x.id, UserLogo.find(x.id).id
  end

end

