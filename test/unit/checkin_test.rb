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
  
  def time(&block)
    start =  Time.now.to_f
    yield
    endt =  Time.now.to_f
    endt-start
  end
  
  test "cache find" do
    id = Checkin.first.id
    assert_equal Checkin.find_by_id(id), Checkin.first
    assert_equal Checkin.find_by_id(id), Rails.cache.read(Checkin.first.my_cache_key)
    assert_equal Checkin.find(id), Rails.cache.read(Checkin.first.my_cache_key)
    t1 = time { 3.times{Checkin.find_by_id(id)}}
    t2 = time { 3.times{Checkin.first}}    
    assert t2>t1
  end

  test "cache update" do  
    id = Checkin.first.id
    ck = Checkin.find_by_id(id)
    ck.sid=999
    ck.save!
    assert_equal 999, Checkin.first.sid
    assert_equal Checkin.find_by_id(id), Checkin.first
    assert_equal Checkin.find_by_id(id), Rails.cache.read(Checkin.first.my_cache_key)    
  end

  test "cache destroy" do  
    id = Checkin.first.id
    ck = Checkin.find_by_id(id)  
    assert_difference('Checkin.count', -1) do
      ck.destroy
    end
    assert_equal Rails.cache.read(ck.my_cache_key), nil
    assert_equal Checkin.find_by_id(id), nil
  end


  test "cache delete" do  
    id = Checkin.first.id
    ck = Checkin.find_by_id(id)  
    assert_difference('Checkin.count', -1) do
      ck.delete #delete方法不调用回调，导致缓存无法清除
    end
    assert Rails.cache.read(ck.my_cache_key)!=nil
  end
  
    
end
