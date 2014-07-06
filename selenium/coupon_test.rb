# coding: utf-8
require File.expand_path('../selenium_help', __FILE__)
class CouponTest < SeleniumTest

  def teardown
    coupons_index
    clear_coupons
    super
  end

  #跳到优惠券首页
  def coupons_index
    @driver.find_element(:link, '优惠券管理').click
  end

  # 跳转到签到优惠发布页
  def release_page(type)
    @driver.find_element(:link, '发布优惠券').click
    #鼠标移动到签到优惠发布框并点击
    ###1. 移动到签到发布框
    element = @driver.find_elements(:class, "box3inner")
    element = element[{checkin: 0, share: 1}[type]]
    @driver.mouse.move_to(element)
    sleep(3)
    ###2. 移动到“图文混排格式”链接上
    element = element.find_element(:class, "box3plane2")
    @driver.mouse.move_to(element)
    ###3 点击
    element.find_element(:link,"图文混排格式").click
  end

  def aa

        # @driver = Selenium::WebDriver.for :firefox
        # @driver.navigate.to "http://shop.dface.cn/shop3_login/login"
        # @driver.find_element(:name, 'id').send_keys "21836841"
        # @driver.find_element(:name, 'password').send_keys "123456"
        # @driver.find_element(:xpath, "//input[@type='submit']").click
        # @driver.navigate.to "http://shop.dface.cn/shop3_coupons/new"



     
   


  end

  def release_checkin
    release_page(:checkin)
  end

  def release_share
    release_page(:share)
  end

  #上传签到优惠券图片
  def checkin_upload
      @driver.find_element(:id, 'CropedImg').click
     @driver.execute_script("var obj = document.getElementsByName('photo')[0]; 
        obj.style.display='block'; obj.click()")
     img_path = File.expand_path("../..", __FILE__)+ "/public/images/test/test.jpg"
     @driver.first(:id, 'UpImgFile').send_keys('img_path')
     @driver.find_element(:id, 'Btn2').click
  end

  #清空所有的优惠券
  def clear_coupons
    # 删除已有的优惠券，
    @driver.find_elements(:class, 'del').each do |e|
      e.click;
      sleep(2)
      @driver.first(:id, 'DelBtn').click
      sleep(2)
    end
  end

  def test_login
    #登录
    @driver.navigate.to @host +"/shop_login/login"
    @driver.find_element(:name, 'id').rsend_keys "21836841"
    @driver.find_element(:name, 'password').rsend_keys "123456"
    @driver.find_element(:xpath, "//input[@type='submit']").click

    coupons_index #到优惠券首页
    clear_coupons #清空所有优惠券
    release_checkin #到new页发布优惠券

    #优惠券不上传图片
    sleep(3)
    @driver.find_element(:id, 'coupon_name').rsend_keys('测试每日签到')
    @driver.find_element(:id, 'coupon_desc').rsend_keys("测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券")
    @driver.find_element(:id, 'coupon_rule').send_keys("每日签到优惠")
    #上传图片
    #    checkin_upload
    @driver.first(:name, 'commit').click
    assert_equal @driver.find_element(:id, 'Box6Message').text, "请上传图片." 
    sleep(3)
    coupons_index #到优惠券首页
    assert_equal @driver.find_elements(:tag_name, "tr").count, 1  #优惠券个数是0

    #发布每日签到
    release_checkin #到new页发布优惠券
    sleep(3)
    @driver.find_element(:id, 'coupon_name').rsend_keys('测试每日签到')
    @driver.find_element(:id, 'coupon_desc').rsend_keys("测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券")
    @driver.find_element(:id, 'coupon_rule').send_keys("每日签到优惠")
    checkin_upload #上传图片
    @driver.first(:name, 'commit').click
    sleep(3)
    coupons_index #到优惠券首页
    assert_equal @driver.find_elements(:tag_name, "tr").count, 2  #优惠券个数是1
    sleep(3)

    #发布重复规则优惠券
    release_checkin #到new页发布优惠券
    @driver.find_element(:id, 'coupon_name').rsend_keys('测试每日签到')
    @driver.find_element(:id, 'coupon_desc').rsend_keys("测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券")
    @driver.find_element(:id, 'coupon_rule').send_keys("每日签到优惠")
    checkin_upload #上传图片
    @driver.first(:name, 'commit').click
    assert_equal @driver.current_url, @host+"/shop3_coupons/create"
    assert_equal @driver.find_element(:id, 'Box6Message').text, "该商家已有一张有效的每日签到优惠类型的优惠券."
    sleep(3)
    coupons_index
    assert_equal @driver.find_elements(:tag_name, "tr").count, 2  #优惠券个数是1
    sleep(3)


    ################################## 分享类优惠券发布
    # 分享优惠可以不用上传图片
    release_share #到分享new页发布优惠券
    @driver.find_element(:id, 'coupon_name').rsend_keys('首次分享优惠测试')
    @driver.find_element(:id, 'coupon_desc').rsend_keys("测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券")
    @driver.first(:name, 'commit').click
    sleep(3)
    coupons_index #到优惠券首页
    assert_equal @driver.find_elements(:tag_name, "tr").count, 3  #优惠券个数是0

    #分享优惠券只能发布一张有效的
    release_share #到分享new页发布优惠券
    sleep(2)
    @driver.find_element(:id, 'coupon_name').rsend_keys('首次分享优惠测试')
    @driver.find_element(:id, 'coupon_desc').rsend_keys("测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券")
    @driver.find_element(:id, 'coupon_rule').send_keys("每日分享优惠")
    sleep(3)
    @driver.first(:name, 'commit').click
    sleep(5)
    assert_equal @driver.find_element(:id, 'Box6Message').text, "该商家已有一张未停用分享类优惠券."
    coupons_index #到优惠券首页
    assert_equal @driver.find_elements(:tag_name, "tr").count, 3  #优惠券个数是2

    #删除分享优惠券
    element = @driver.all(:tag_name, "tr").last
    element = element.first(:class, 'del').click
    sleep(2)
    @driver.first(:id, 'DelBtn').click
    sleep(3)
    
    coupons_index #到优惠券首页
    assert_equal @driver.find_elements(:tag_name, "tr").count, 2  #优惠券个数是2


    #发布带图的分享优惠
    release_share #到分享new页发布优惠券
    @driver.find_element(:id, 'coupon_name').rsend_keys('首次分享优惠测试')
    @driver.find_element(:id, 'coupon_desc').rsend_keys("测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券\n测试优惠券")
    checkin_upload #上传图片
    @driver.first(:name, 'commit').click
    sleep(3)
    coupons_index #到优惠券首页
    assert_equal @driver.find_elements(:tag_name, "tr").count, 3  #优惠券个数是0

    ################################## end 分享类优惠券发布

    sleep(10)

  end
end