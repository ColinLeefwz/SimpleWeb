# coding: utf-8
require "test/unit"
require "rubygems"
require "selenium-webdriver"

class Selenium::WebDriver::Element
  def rsend_keys(*args)
    clear
    send_keys(args)
  end
end

class FaqTest < Test::Unit::TestCase

  def setup
    @host = "http://shop.dface.cn"
    if RUBY_PLATFORM =~ /mswin32/
      @driver = Selenium::WebDriver.for :ie
    else
      @driver = Selenium::WebDriver.for :firefox
    end

    #login
    @driver.navigate.to @host + "/shop3_login/login"
    @driver.find_element(:name, 'id').rsend_keys "21836841"
    @driver.find_element(:name, 'password').rsend_keys "123456"
    @driver.find_element(:class, 'btn').click
  end

  def teardown
    faqs_index
    clear_faqs
    @driver.quit
  end
  
  # 跳到问答系统主页
  def faqs_index
    @driver.find_element(:link, '问答系统').click
  end
  
  # 跳转到问答发布页面
  def release_new
    @driver.find_element(:link, '创建问答').click
  end

  # 上传问答系统图片
  def image_upload
    #隐藏元素不能操作， 先把文件输入框显示
    @driver.execute_script("document.getElementById('shop_faq_img').setAttribute('class', '')")
    #图片上传路径
    img_path = File.expand_path("../..",__FILE__) + "/public/imags/test/test.jpg"
    #图片上传
    @driver.find_element(:xpath, "//input[@id='shop_faq_img']").send_keys(img_path)
    #隐藏元素
    @driver.execute_script("document.getElementById('shop_faq_img').setAttribute('class', 'filebox1')")
  end
  
  # 清空所有的问答
  def clear_faqs
    @driver.find_element(:class, 'del2').each do |e|
      e.click
      sleep(2)
    end
  end
  
  # 添加链接
  def add_link
    # 点击添加链接按钮
    @driver.find_element(:id, 'shop_faq_link_rule_0').click
    @driver.find_element(:id, 'link1').rsend_keys 'http://www.baidu.com'
  end

  # 添加详情页
  def add_content
    @driver.find_element(:id, 'link2').rsend_keys '详情页标题'
    #添加图片
    @driver.find_element(:id, 'edui26_body').click
    @driver.find_element(:tag_name, 'span').last.click
    img_path = "http://dface.cn/images/test/test.jpg"
    @driver.find_element(:id, 'url').rsend_keys(img_path)
    @driver.find_element(:class, 'edui-label').click
    #添加文字
  end

  def test_login
    faqs_index # 跳到问答系统主页
    clear_faqs # 清空所有的问答
    release_new # 跳转到问答发布页面

    #问答系统不上传图片和第二层
    sleep(3)
    @driver.find_element(:id, 'Inputs1').rsend_keys('测试问答标题')
    @driver.find_element(:id, 'Inputs2').rsend_keys("问答简述,问答简述,问答简述,问答简述,问答简述")
    @driver.first(:name, 'Submit').click
    assert_equal @driver.current_url, @host+"/shop3_faq"
    assert_equal @driver.find_element(:class, 'box4plane2').count, 1 #问答个数为1

    clear_faqs
    
    #问答系统不输入问题或简述,问答字数限制3～12个
    sleep(3)
    release_new
    @driver.first(:name, 'Submit').click
    assert_equal @driver.current_url, @host+"/shop3_faq/new"

    @driver.find_element(:id, 'Inputs1').rsend_keys('测试') #问答字数少于3个
    @driver.first(:name, 'Submit').click
    assert_equal @driver.current_url, @host+"/shop3_faq/new"

    @driver.find_element(:id, 'Inputs1').rsend_keys('测试测试测试测试测试测试测') #问答字数多于12个
    @driver.first(:name, 'Submit').click
    assert_equal @driver.current_url, @host+"/shop3_faq/new"

    #问答上传图片、问题和简述
    sleep(3)
    @driver.find_element(:id, 'Inputs1').rsend_keys('测试问答标题')
    @driver.find_element(:id, 'Inputs2').rsend_keys("问答简述,问答简述,问答简述,问答简述,问答简述")
    image_upload #上传问答系统图片
    @driver.first(:name, 'Submit').click
    sleep(3)
    faqs_index
    assert_equal @driver.find_element(:class, 'box4plane2').count, 1 #问答个数为1

    clear_faqs

    #问答上传图片、问题、简述、链接
    sleep(3)
    @driver.find_element(:id, 'Inputs1').rsend_keys('测试问答标题')
    @driver.find_element(:id, 'Inputs2').rsend_keys("问答简述,问答简述,问答简述,问答简述,问答简述")
    image_upload #上传问答系统图片
    add_link # 添加链接
    @driver.first(:name, 'Submit').click
    assert_equal @driver.current_url, @host+"/shop3_faq"
    assert_equal @driver.find_element(:class, 'box4plane2').count, 1 #问答个数为1

    clear_faqs

    #问答上传图片、问题、简述、详情内容
    sleep(3)
    @driver.find_element(:id, 'Inputs1').rsend_keys('测试问答标题')
    @driver.find_element(:id, 'Inputs2').rsend_keys("问答简述,问答简述,问答简述,问答简述,问答简述")
    image_upload #上传问答系统图片
    add_content # 添加详情内容
    @driver.first(:name, 'Submit').click
    assert_equal @driver.current_url, @host+"/shop3_faq"
    assert_equal @driver.find_element(:class, 'box4plane2').count, 1 #问答个数为1

    clear_faqs
    
  end
end