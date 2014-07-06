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
    ck.sid=996
    ck.save!
    assert_equal Checkin.first.sid, 996
    assert_equal Checkin.find_by_id(id).sid, 996     
    ck = Checkin.find_by_id(id)
    ck.sid=995
    ck.save!
    assert_equal Checkin.first.sid, 995 
  end
  
  test "cache update2" do  
    id = Checkin.first.id
    ck = Checkin.find_by_id(id)
    ck.update_attribute(:sid, 998)
    assert_equal 998, Checkin.first.sid
    assert_equal Checkin.find_by_id(id), Checkin.first
    assert_equal Checkin.find_by_id(id), Rails.cache.read(Checkin.first.my_cache_key)  
    ck = Checkin.find(id)
    ck.update_attributes({sid:996})
    assert_equal Checkin.find_by_id(id).sid, 996  
    ck = Checkin.find(id)
    ck.update_attributes({sid:995})
    assert_equal Checkin.find_by_id(id).sid, 995
  end
  
  test "cache update3" do  
    id = Checkin.first.id
    ck = Checkin.find_by_id(id)
    ck.update_attributes({sid:997})
    assert_equal 997, Checkin.first.sid
    assert_equal Checkin.find_by_id(id), Checkin.first
    assert_equal Checkin.find_by_id(id), Rails.cache.read(Checkin.first.my_cache_key)    
    ck.update_attributes({sid:996})
    assert_equal ck.sid, 996
    #assert_equal Checkin.find(id).sid, 996 #TODO: 这里为什么失败
    assert_equal Checkin.find_primary(id).sid, 996
    #为什么执行find_primary后就正常了？
    assert_equal Checkin.find(id).sid, 996 
  end

  test "cache update4" do  
    id = Checkin.first.id
    ck = Checkin.find_by_id(id)
    ck.update_attributes!({od:100, sid:996})
    assert_equal 996, Checkin.first.sid
    assert_equal 100, Checkin.first.od
    assert_equal Checkin.find_by_id(id), Checkin.first
    assert_equal Checkin.find_by_id(id), Rails.cache.read(Checkin.first.my_cache_key)    
    ck = Checkin.find(id)
    ck.update_attributes!({od:1, sid:1})
    assert_equal Checkin.find_by_id(id).od, 1
    assert_equal Checkin.find_by_id(id).sid, 1
    
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
