require 'test_helper'

class McategoryTest < ActiveSupport::TestCase
  test "leafs 有子类" do
    m = Mcategory.find_by_id(1)
    assert_equal [1,3,5], m.leafs.map { |m| m.id }
  end

  test 'leafs 没有子类' do
    m = Mcategory.find_by_id(5)
    assert_equal [5], m.leafs.map { |m| m.id }
  end

  test "Mcategory.unfold" do
    assert_equal Mcategory.unfold(3), [1,3,5]
  end
end