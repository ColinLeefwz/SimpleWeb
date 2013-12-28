# encoding: utf-8

class NewYearWishController < ApplicationController

  before_filter :photo_authorize, :except => [:list]

  def create
    result = { error: 1, message: "请勿重复祝福"}
    wish_limit do
      @wish.total += 1
      @wish.data << [params[:name], wish_filter];
      @wish.save
      url = "http://dface.cn/new_year_wish?id=#{params[:id]}"
      c = @wish.data.size
      title = if c == 30
        "你的人气爆棚！30个祝福已经集满！正式加入千元红包抢夺大军啦！祝福越多，中奖几率越高噢 #{url}"
      elsif c <= 3
        "#{params[:name]}给你发来一条新年祝福，赶快点我看看吧 #{url}"
      elsif c % 5 == 0 && c != 30
        "你有新的祝福，祝福数达到#{c}条，赶快点我看看吧 #{url}"
      end
      Resque.enqueue(XmppMsg, $gfuid, @wish.photo.user_id, title) unless title.nil?
      result = { error: 0, message: wish_filter}
    end
    return render :json => result
  end

  # 更新模版
  def update
    if is_owner?
      @wish.template = params[:template].to_i
      @wish.save
    end
    return render :json => 1
  end
  
  def index
    render :layout => false
  end

  # 检测用户是否登入
  def check_login_user
    return render :json => is_owner?.to_json
  end

  private

    def photo_authorize
      @wish = NewYearWish.find_by_id(params[:id])
      return render :text => "无效图片" if @wish.nil?
    end

    # 过滤敏感关键字
    def wish_filter
      unless @wish_filter
        file = Rails.root + "doc/触发限制词.txt"
        content = File.read(file).split.join("|")
        @wish_filter = params[:wish].gsub(Regexp.new(content), '*')
      end
      @wish_filter
    end

    # 判断是否是本人
    def is_owner?
      !params[:uid].nil? && (params[:uid] == @wish.photo_user.id.to_s)
    end

    # 多次祝福限制
    def wish_limit(&block)
      user_agent = request.env['HTTP_USER_AGENT']
      Rails.cache.fetch("NYD-#{real_ip}-#{Digest::MD5.hexdigest(user_agent)}", expires_in: 10.minutes) do
        block.call if block_given?
        1
      end
    end
end