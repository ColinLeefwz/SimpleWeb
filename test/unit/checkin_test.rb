# coding: utf-8
require 'test_helper'

class CheckinTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    reload('checkins.js')
  end

  test "find_primary 取id" do
    checkin = Checkin.find_primary('50598b371d41c8c11a000002')
    assert_equal checkin.id.to_s, '50598b371d41c8c11a000002'
  end
end
