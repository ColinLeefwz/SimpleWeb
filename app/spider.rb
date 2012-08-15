# coding: utf-8
require 'hpricot'
require 'open-uri'
require 'logger'

module Spider

  $LOG = Logger.new('job_log/spider.log', 0, 100 * 1024 * 1024)

  @Request_Headers = {"User-Agent" => "Mozilla/5.0 (X11; Linux i686; rv:2.0.1) Gecko/20100101 Firefox/4.0.1"}



  @DP = 'http://www.dianping.com'
  @DP_STR = "http://www.dianping.com/search/category/%d/0"
  @DP_HANGZHOU = 'http://www.dianping.com/search/category/3/0'
  @DP_HANGZHOU_C30 = 'http://www.dianping.com/search/category/3/30/g1493/g30g1493'
  @C_URLS = []
  @D_URLS = []

  def self.koubei
  end


  def self.suspend
    begin
      sleep(3 + rand(5))
    rescue
    end
  end

  # 读取城市ID下所有分类对应的URL
  def self.dp_cs_by_mcity_id(mcity_id)
    $LOG.info "def dp_cs_by_mcity_id(mcity_id=#{mcity_id})"
    mcity = Mcity.find_by_id(mcity_id)
    if mcity and !mcity.crawled
      @C_URLS << (@DP_STR % mcity.dp_id)
      @C_URLS.each {|url| dp_category(url, mcity.id)}
    end
  end

  # 据url和城市ID，读取城市下所有分类的URL
  def self.dp_category(url, mcity_id)
    $LOG.info "def dp_category(url=#{url}, mcity_id=#{mcity_id})"
    begin
      suspend
      doc = Hpricot(open(url,@Request_Headers))
      all_category = false
      nest_id = 0
      doc.search("ul[@class='navBlock']").each do |current|
        if current.search("li/ul/li/strong").inner_text.strip.index('全部频道') or current.search("li/a/strong").inner_text.strip.index('全部频道')
          current.search("li/ul/li/ul/li").each do |cur_li|
            if cur_li.search("a")[0] and cur_li.search("a")[0].inner_text.index(/«/).nil?
              category = Mcategory.find_by_id(cur_li.search("a")[0].get_attribute('href').split('/')[-1].split('g')[-1].to_i)
              category = Mcategory.new if category.nil?

              # 新的抓取 开始
              category_url = cur_li.search("a")[0].get_attribute('href')
              sp_url = category_url.split('/')[-2,2]
              category.nest_id = sp_url.first
              category.kb_url= "http://www.dianping.com" + category_url
              # 新的抓取结束



              category.id = cur_li.search("a")[0].get_attribute('href').split('/')[-1].split('g')[-1].to_i
              category.name = cur_li.search("a")[0].inner_text.strip.split(/\302\240/)[0].to_s
              #category.nest_id = cur_li.search("a")[0].get_attribute('href').split('/')[-1].split('g').length >= 3 ? cur_li.search("a")[0].get_attribute('href').split('/')[-1].split('g')[-2].to_i : nest_id
              category.save!
              mcity_mcategory = category.mcity_mcategory(mcity_id)
              mcity_mcategory = McityMcategory.new if mcity_mcategory.nil?
              mcity_mcategory.mcategory_id = category.id
              mcity_mcategory.mcity_id = mcity_id
              mcity_mcategory.mshop_count = cur_li.search("a/span[@class='num']").empty? ? doc.search("div[@class='guide']/span[@class='Color7']").inner_text.strip.split('(')[1].split(')')[0].to_i : cur_li.search("a/span[@class='num']").inner_text.strip.split('(')[1].split(')')[0].to_i
              mcity_mcategory.dp_url = ("%s%s" % [@DP, cur_li.search("a")[0].get_attribute('href')])
              mcity_mcategory.save!
              @C_URLS << mcity_mcategory.dp_url
            end
          end
        end
      end
    rescue Timeout::Error
      $LOG.error "dp_category open #{url} timed out... 5 minutes later and try again."
      sleep 5 * 60
      dp_category(url, mcity_id)
    rescue OpenURI::HTTPError => e
      $LOG.error "dp_category open #{url} returned an error. 1 minute later and try again. #{e.message}"
      sleep 1 * 60
      dp_category(url, mcity_id)
    rescue
      $LOG.error "dp_category open #{url} mcity_id#{mcity_id} returned an error. Ignored. #{$!}"
    else
      return nil
    end
  end

  # 读取城市ID下所有区域对应的URL，返回URL列表
  def self.dp_ds_by_mcity_id(mcity_id)
    $LOG.info "def dp_ds_by_mcity_id(mcity_id=#{mcity_id})"
    mcity = Mcity.find_by_id(mcity_id)
    if mcity and !mcity.crawled
      @D_URLS << (@DP_STR % mcity.dp_id)
      @D_URLS.each {|url| dp_district(url, mcity_id)}
    end
  end

  # 据区域ID和城市ID，查找无限级子区域和区域对应的URL，返回URL列表
  def self.dp_district(url, mcity_id)
    $LOG.info "def dp_district(url=#{url}, mcity_id=#{mcity_id})"
    mcity = Mcity.find_by_id(mcity_id)
    begin
      suspend
      doc = Hpricot(open(url,@Request_Headers))
      nest_id = 0
      md = Mdistrict.find_by_name(mcity.name.force_encoding("UTF-8").split('站')[0])
      if md
        nest_id = md.id
      else
        district = Mdistrict.new
        #        district.id = mcity_id
        district.name = mcity.name.force_encoding("UTF-8").split('站')[0]
        district.nest_id = nest_id
        district.save!
        nest_id = district.id
      end

      current = doc.search("ul[@class='navBlock navTab-cont navTab-cont-on']/li/ul[@class='bigCurrent']")
      current = doc.search("ul[@class='navBlock']/li/ul[@class='current']") if current.empty?
      current = doc.search("ul[@class='navBlock']/li/ul/li/ul[@class='current']") if current.empty?
      current = doc.search("div[@class='asideContainer']/ul[@class='navBlock']")[1].search("ul[@class='current']") if  current.empty?
      cdn = current.search("li").first.inner_text
      pmd = Mdistrict.find_by_name(cdn)
      current.search("li/ul/li").each do |cur_li|
        if cur_li.search("a")[0]
          district = Mdistrict.find_by_id(cur_li.search("a")[0].get_attribute('href').split('/')[-1].split('r')[-1].to_i)
          district = Mdistrict.new if district.nil?
          district.id = cur_li.search("a")[0].get_attribute('href').split('/')[-1].split('r')[-1].to_i
          district.name = cur_li.search("a")[0].inner_text.strip.split(/\302\240/)[0].to_s
          district.nest_id = pmd.try(:id) || nest_id
          #          district.nest_id = cur_li.search("a")[0].get_attribute('href').split('/')[-1].split('r').length >= 3 ? cur_li.search("a")[0].get_attribute('href').split('/')[-1].split('r')[-2].to_i : nest_id
          district.save!
          mcity_mdistrict = district.mcity_mdistrict(mcity_id)
          mcity_mdistrict = McityMdistrict.new if mcity_mdistrict.nil?
          mcity_mdistrict.mdistrict_id = district.id
          mcity_mdistrict.mcity_id = mcity_id
          mcity_mdistrict.mshop_count = cur_li.search("a/span[@class='num']").empty? ? doc.search("div[@class='guide']/span[@class='Color7']").inner_text.strip.split('(')[1].split(')')[0].to_i : cur_li.search("a/span[@class='num']").inner_text.strip.split('(')[1].split(')')[0].to_i
          mcity_mdistrict.dp_url = ("%s%s" % [@DP, cur_li.search("a")[0].get_attribute('href')])
          mcity_mdistrict.save!
          @D_URLS << mcity_mdistrict.dp_url
        end
      end

    rescue Timeout::Error
      $LOG.error "dp_district open #{url} timed out... 5 minutes later and try again."
      sleep 5 * 60
      dp_district(url, mcity_id)
    rescue OpenURI::HTTPError => e
      $LOG.error "dp_district open #{url} returned an error. 1 minute later and try again. #{e.message}"
      sleep 1 * 60
      dp_district(url, mcity_id)
    rescue
      $LOG.error "dp_district open #{url} returned an error. Ignored. #{$!}"
    else
      return nil
    end
  end

  # 根据城市分类对应的URL和城市ID，读取分类下所有商家
  @I = 0
  def self.dp_shop(city_category_url, mcity_id)
    $LOG.info "def dp_shop(city_category_url=#{city_category_url}, mcity_id=#{mcity_id})"
    begin
      suspend
      doc = Hpricot(open(city_category_url,@Request_Headers))
      dds = doc.search("#searchList")[0].search("dd")
      dds.each do |dd|
        detail = dd.search("ul[@class='detail']")
        unless detail.empty?
          shop = Mshop.find_by_dp_id(detail.search("li[@class='shopname']/a")[0].get_attribute('href').split('/')[2].split('#')[0].to_i)
          shop = Mshop.new() if shop.nil?
          Mshop.transaction do
            shop.name = detail.search("li[@class='shopname']/a")[0].inner_text
            shop.dp_id = detail.search("li[@class='shopname']/a")[0].get_attribute('href').split('/')[2].split('#')[0].to_i
            dt = detail.search("li[@class='address']")[0].inner_text.split(/\302\240/)
            if detail.search("li[@class='address']").search("a").empty?
              shop.address = dt[0]
            else
              shop.address = dt[0][dt[0].index(detail.search("li[@class='address']").search("a")[0].inner_text) + detail.search("li[@class='address']").search('a')[0].inner_text.length, dt[0].length] # address
            end
            shop.phone = dt[2].to_s        # phone
            shop.comment_count = dd.search("ul[@class=remark]/li").last.inner_text.to_i
            shop.mcity_id = mcity_id
            shop.save!
            @I = @I + 1
            unless detail.search("li[@class='address']").search("a").empty?
              district = Mdistrict.find_by_id(detail.search("li[@class='address']").search("a")[0].get_attribute('href').split('/')[-1].split('r')[1].to_i)
              if district && MshopMdistrict.find_by_mshop_id_and_mdistrict_id(shop.id, district.id).nil?
                shop_dis = MshopMdistrict.new()
                shop_dis.mshop_id = shop.id
                shop_dis.mdistrict_id = district.id
                shop_dis.save!
              end
            end
            detail.search("li[@class='tags']/a").each_with_index do |a, idx|
              if a.get_attribute('href').split('/')[-1].index('g')
                c_id = a.get_attribute('href').split('/')[-1].split('g')[1].to_i
                category = Mcategory.find_by_id(c_id)
                if category && MshopMcategory.find_by_mshop_id_and_mcategory_id(shop.id, category.id).nil?
                  shop_cat = MshopMcategory.new()
                  shop_cat.mshop_id = shop.id
                  shop_cat.mcategory_id = category.id
                  shop_cat.save!
                end
              elsif a.get_attribute('href').split('/')[-1].index('r')
                d_id = a.get_attribute('href').split('/')[-1].split('r')[1].to_i
                district = Mdistrict.find_by_id(d_id)    # district
                if district && MshopMdistrict.find_by_mshop_id_and_mdistrict_id(shop.id, district.id).nil?
                  shop_dis = MshopMdistrict.new()
                  shop_dis.mshop_id = shop.id
                  shop_dis.mdistrict_id = district.id
                  shop_dis.save!
                end
              end
            end
          end
        end
      end

      unless doc.search("div[@class='Pages']/a[@title='下一页']").empty?
        dp_shop("%s%s" % [@DP, doc.search("div[@class=Pages]/a[@title='下一页']")[0].get_attribute('href')], mcity_id)
      end
    rescue Timeout::Error
      $LOG.error "dp_shop open #{city_category_url} timed out... 5 minutes later and try again."
      sleep 5 * 60
      dp_shop(city_category_url, mcity_id)
    rescue OpenURI::HTTPError => e
      $LOG.error "dp_shop open #{city_category_url} returned an error. 1 minute later and try again. #{e.message}"
      sleep 1 * 60
      dp_shop(city_category_url, mcity_id)
    rescue
      $LOG.error "dp_shop open #{city_category_url} returned an error. Ignored. #{$!}"
    else
      return nil
    end
  end

  # 将10进制整数转为36进制
  def self.to_base36(value)
    $LOG.info "def to_base36(value=#{value})"
    raise TypeError, "%s is not a Fixnum" % value if value.class != Fixnum
    return '0' if value == 0
    sign = (value < 0 ? '-' : '')
    value = -value if value < 0
    result = []
    while value > 0
      value, mod = value.divmod(36)
      result << "0123456789abcdefghijklmnopqrstuvwxyz".split('')[mod]
    end
    return "%s%s" % [sign, result.reverse]
  end

  # 解析poi，返回[lat, lng]
  def self.decode_poi(poi)
    $LOG.info "def decode_poi(poi=#{poi})"
    poi = poi.split('')
    digi = 16
    add = 10
    plus = 7
    cha = 36
    i = -1
    h = 0
    b = ""
    j = poi.length
    g = poi[-1].ord
    poi = poi[0, j - 1]
    j -= 1
    0.upto(j - 1).each do |j_i|
      d = poi[j_i].to_i(cha) - add
      if d >= add
        d = d - plus
      end
      b += self.to_base36(d)
      if d > h
        i = j_i
        h = d
      end
    end
    a = b[0, i].to_i(digi)
    f = b[i + 1, b.length].to_i(digi)
    l = (a + f - g.to_i).to_f / 2
    k = (f - l).to_f / 100000
    l = l.to_f / 100000
    return [k, l]
  end

  # 根据商家ID读取点评网的位置信息并保存[lat, lng]
  def self.dp_shop_latlng(shop_id)
    $LOG.info "def dp_shop_latlng(shop_id=#{shop_id})"
    shop = Mshop.find_by_id(shop_id)
    if shop and shop.dp_id.to_i > 0
      begin
        suspend
        open(shop.dp_url,@Request_Headers) { |f|
          f.each_line do |line|
            return self.decode_poi(line.split(/'/)[1]) if line.index('poi')
          end
        }
      rescue Timeout::Error
        $LOG.error "dp_shop_latlng open #{shop.dp_url} timed out... 5 minutes later and try again."
        sleep 5 * 60
        dp_shop_latlng(shop_id)
      rescue OpenURI::HTTPError => e
        $LOG.error "dp_shop_latlng open #{shop.dp_url} returned an error. 1 minute later and try again. #{e.message}"
        sleep 1 * 60
        return nil
        #        dp_shop_latlng(shop_id)
      rescue
        $LOG.error "dp_shop_latlng open #{shop.dp_url} returned an error. Ignored. #{$!}"
      else
        return nil
      end
    else
      return nil
    end
  end

  # 将一个分类下的无限级子分类推入 @categories
  @categories = []
  def self.sub_categories(category)
    $LOG.info "def sub_categories(category=#{category})"
    if category.has_sub
      category.sub_categories.each { |c| sub_categories(c) }
    else
      @categories << category
    end
    return @categories
  end

  # 据分类ID和城市ID，查找无限级子分类和分类对应的URL，返回URL列表
  # (点评网每个分类最多只显示750个商家，当分类下的商家多于750时，会自动查找下一级行政区域并累加结果)
  @categories = []
  def self.dp_category_urls_by_category_id_mcity_id(category_id, mcity_id)
    $LOG.info "def dp_category_urls_by_category_id_mcity_id(category_id=#{category_id}, mcity_id=#{mcity_id})"
    mc = Mcategory.find_by_id(category_id)
    category_urls = []
    begin
      if mc
        mcs = self.sub_categories(mc)
        mcs.each_with_index do |mcat, idx|
          m = mcat.mcity_mcategory(mcity_id)
          if m
            if m.mshop_count <= 750
              category_urls << m.dp_url
            else
              # category 下的 districts
              suspend
              doc = Hpricot(open(m.dp_url,@Request_Headers))
              current = doc.search("ul[@class='navBlock navTab-cont navTab-cont-on']/li/ul[@class='bigCurrent']")
              current = doc.search("ul[@class='navBlock']/li/ul[@class='current']") if current.empty?
              current.search("li/ul/li").each do |cur_li|
                if cur_li.search("a")[0] and !cur_li.search("a/span[@class='num']").empty?
                  if cur_li.search("a/span[@class='num']").inner_text.strip.split('(')[1].split(')')[0].to_i <= 750
                    category_urls << ("%s%s" % [@DP, cur_li.search("a")[0].get_attribute('href')])
                  else
                    doc = Hpricot(open(m.dp_url,@Request_Headers))
                    current = doc.search("ul[@class='navBlock']/li/ul[@class='current']") if current.empty?
                    current.search("li/ul/li").each do |cur_li|
                      category_urls << ("%s%s" % [@DP, cur_li.search("a")[0].get_attribute('href')]) if cur_li.search("a")[0]

                    end
                  end
                end
              end
            end
          end
        end
      end
    rescue Timeout::Error
      $LOG.error "dp_shop open dp_category_urls_by_category_id_mcity_id(#{category_id}, #{mcity_id}) timed out... 5 minutes later and try again."
      sleep 5 * 60
      dp_category_urls_by_category_id_mcity_id(category_id, mcity_id)
    rescue OpenURI::HTTPError => e
      $LOG.error "dp_shop open dp_category_urls_by_category_id_mcity_id(#{category_id}, #{mcity_id}) returned an error... 1 minutes later and try again. #{e.message}"
      sleep 1 * 60
      dp_category_urls_by_category_id_mcity_id(category_id, mcity_id)
    rescue
      $LOG.error "dp_shop open dp_category_urls_by_category_id_mcity_id(#{category_id}, #{mcity_id}) returned an error. Ignored. #{$!}"
    end
    return category_urls
  end

  # 读取城市ID下的所有商家信息，包括频道、行政区和商家
  def self.dp_by_mcity_id(mcity_id)
    $LOG.info "def dp_by_mcity_id(mcity_id=#{mcity_id})"
    # 全部频道
    Spider.dp_cs_by_mcity_id(mcity_id)
    # 全部行政区
    Spider.dp_ds_by_mcity_id(mcity_id)
    Mcategory.find_all_by_nest_id(0, :order => 'updated_at').each do |c|
      # 频道下的商家列表
      Spider.dp_category_urls_by_category_id_mcity_id(c.id, mcity_id).each {|url| Spider.dp_shop(url, mcity_id)}
      cs = []
      if c.has_sub
        cs << c.sub_categories
      else
        cs << c
      end
      # 商家的地址latlng
      cs.flatten.each do |cat|
        cat.mshops.each do |shop|
          if shop.mcity_id > 0 and shop.mcity_id == mcity_id
            latlng = Spider.dp_shop_latlng(shop.id)
            if latlng
              shop.lat = latlng[0]
              shop.lng = latlng[1]
              shop.save!
            end
          end
        end
      end
    end
  end

  # 读取城市列表
  def self.cities(dp_id=1)
    $LOG.info "def cities(dp_id=#{dp_id})"
    dp_id = 1 if dp_id.to_i < 1
    # 每个ID尝试 5 次
    per_err = 0
    # 连续 50 个ID都不存在，表示商家列表结束
    i_err = 0
    while i_err < 50
      if per_err >= 5
        dp_id += 1
        per_err = 0
        next
      end
      url = "http://www.dianping.com/search/category/%d/0" % dp_id
      mcity = Mcity.find_by_id(dp_id)
      mcity = Mcity.new if mcity.nil?
      mcity.id = dp_id
      mcity.dp_id = dp_id
      begin
        suspend
        doc = Hpricot(open(url,@Request_Headers))
        if not doc.search("div[@class='aboutBox errorMessage']").empty?
          i_err += 1
          dp_id += 1
          next
        elsif not doc.search("div[@class='guide']/strong").empty?
          i_err = 0
          unless doc.search("div[@class='location']/a[@class='loc-btn']/span[@class='txt']").empty?
            mcity.name = doc.search("div[@class='location']/a[@class='loc-btn']/span[@class='txt']").inner_text
          end
          header_name = doc.search("div[@class='header']/a[@title='大众点评网']")
          unless header_name.empty?
            mcity.eng_name = header_name[0].get_attribute('onclick').split('_')[-1].split(/'/)[0].to_s
          end
          mcity.save!
          dp_id += 1
        else
          dp_id += 1
          next
        end
      rescue Timeout::Error
        per_err += 1
        i_err -= 1
        $LOG.error "cities open #{url} timed out... 5 minutes later and try again."
        sleep 5 * 60
        retry
      rescue OpenURI::HTTPError => e
        per_err += 1
        i_err -= 1
        $LOG.error "cities open #{url} returned an error. 1 minute later and try again. #{e.message}"
        sleep 1 * 60
        retry
      rescue
        per_err += 1
        i_err -= 1
        $LOG.error "cities open #{url} returned an error. Ignored. #{$!}"
        next
      end
    end
  end

  # 读取点评网商家信息，id.to_i > 0 读取指定城市，否则读取所有城市
  def self.dp(id=0)
    $LOG.info "def dp id=%d" % id
    mcities = []
    if id > 0
      mcities = Mcity.find(:all, :conditions => ["dp_id = ?", id], :order => "dp_id")
    else
      cities(id)
      mcities = Mcity.find(:all, :order => "dp_id")
    end
    mcities.each do |mcity|
      dp_by_mcity_id(mcity.id)
      mcity.update_attribute("crawled", true)
      @C_URLS.clear
      @D_URLS.clear
      $LOG.info "Crawled #{mcity.name}(#{mcity.id}), it has #{Mshop.count(:conditions => ['mcity_id = ?', mcity.id])} shops."
    end
    sleep 60
    $LOG.info "#{Time.now}, spider dp is completed!"
    exit
  end




  def self.categroies_capch(city_id)
    return nil unless city = Mcity.find_by_id(city_id)
    categroy_url =  "http://www.dianping.com/search/category/#{city.id}/0"
    suspend
    doc = Hpricot(open(categroy_url,@Request_Headers))
    categroy_doc = doc.search("div[@class='asideContainer'] ul[@class='navBlock'] ul[@class='bigCurrent']").first
    categroy_doc.search('ul li').each do |li|
      category_capch(li.search("a").first.get_attribute('href'),nil)
    end
  end

  def self.category_capch(url,nest_id)
    url = "http://www.dianping.com" + url
    suspend
    doc = Hpricot(open(url,@Request_Headers))
    $LOG.info "open url #{url}"
    ul = doc.search("div[@class='asideContainer'] ul[@class='current']")
    sp_url = url.split("/")[-2,2]
    if cate= Mcategory.find_by_id(sp_url.last.gsub('g','').to_i)
      cate.nest_id = nest_id || 0
      cate.kb_url = url
      cate.save!
      $LOG.info "id:#{cate.id}被更新"
    end

    sub_categroy = ul.search("li/ul")
    unless sub_categroy.empty?
      sub_categroy.search("li").each{|li| category_capch(li.search("a").first.get_attribute('href'),cate.id)}
    end
  end

  def self.cate_shop(city_id,category_ids=[])
    # 全部频道
    Spider.dp_cs_by_mcity_id(city_id)
    #纠正分类
    Spider::categroies_capch(city_id)
    # 全部行政区
    Spider.dp_ds_by_mcity_id(city_id)

    if category_ids.empty?
      rmc = Mcategory.find_all_by_nest_id(0).map{|m| m.id}
      category_ids = Mcategory.find_by_sql("SELECT m.id FROM mcategories m left join mcity_mcategories mm on m.id = mm.mcategory_id where mcity_id=#{city_id} and m.nest_id in (#{rmc.join(',')})").map{|m| m.id}
    end

    category_ids.each{|cate|  c_shop(cate.to_i,city_id) }
  end

  def self.c_shop(category_id,city_id)
    cate = Mcategory.find_by_id(category_id)
    mcity = Mcity.find_by_id(city_id)
    root = cate.root
    mc_leafs = cate.sleaf
    md_leafs = Mdistrict.find_by_name(mcity.name.force_encoding("UTF-8").split('站').first).sleaf
    mc_leafs.each do |mcl|
      md_leafs.each do |mdl|
        Spider.dp_shop("http://www.dianping.com/search/category/#{mcity.id}/#{root.id}/g#{mcl.id}r#{mdl.id}",city_id)
      end
    end
  end



end

# 文件被执行时运行 def self.dp(id=0)
if __FILE__ == $0 or $0 == 'script/runner'
  $LOG.info "__FILE__"
  $LOG.info "$0 %s " % $0
  if ARGV && ARGV.count > 0

    case ARGV[0].to_s
    when 'latlng'
      Mshop.where("lat =0").each do |shop|
        latlng = Spider.dp_shop_latlng(shop.id)
        if latlng
          shop.lat = latlng[0]
          shop.lng = latlng[1]
          shop.save!
        end
      end
      #纠正分类的数据
    when 'cate'
      ARGV.shift
      ARGV.each do |a|
        Spider::categroies_capch(a.to_i)
      end
      #按分类抓取城市的商家
    when 'cate_shop'
      Spider.cate_shop(ARGV[1].to_i,ARGV[2,ARGV.length-2])
    when "cate_shops"
      ARGV[1,ARGV.length-1].each { |city| Spider.cate_shop(city) }
    else
      $LOG.info ARGV
      puts "ARGV    %s" % ARGV
      Spider.dp(ARGV[0].to_i)
    end

  else
    $LOG.info "ARGV is nil"
    Spider.dp()
  end
end

