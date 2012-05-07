require "compress.rb"

class ApplicationController < ActionController::Base
  include SslRequirement
  helper :all # include all helpers, all the time


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0ece657db3ad4f380b628ea9c23cb2d0'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  filter_parameter_logging :password


  after_filter OutputCompressionFilter

  #  before_filter :set_process_name_from_request
  #  after_filter :unset_process_name_from_request

  def set_process_name_from_request
    $0 = request.path[0,16]
  end

  def unset_process_name_from_request
    $0 = request.path[0,15] + "*"
  end

  around_filter :exception_catch if ENV["RAILS_ENV"] == "production"
  def exception_catch
    begin
      yield
    rescue  Exception => err
      logger.error "Internal Server Error: #{err.class.name}"
      err.backtrace[0,10].each {|x| logger.error x}
      err_str = err.to_s
      err_str = "抱歉,此页面不存在!" if err.class.name == "ActiveRecord::RecordNotFound"
      render(:file => "500.html.erb", :use_full_path => true, :locals => {:error_msg => err_str})
    end
  end

  around_filter :access_log if ENV["RAILS_ENV"] == "production"

  def user_agent_log(alog)
    begin
      if request.env['HTTP_USER_AGENT']
        agent              = Agent.new(request.env['HTTP_USER_AGENT'])
        alog.agent_name    = agent.name.to_s
        alog.agent_version = agent.version.to_s
        alog.agent_engine  = agent.engine.to_s
        alog.agent_os      = agent.os.to_s
        alog.agent = request.env['HTTP_USER_AGENT'] #if alog.agent_name.downcase=="unknown" || alog.agent_os.nil? || alog.agent_os.downcase=="unknown"
        alog.parse_unknown_agent if alog.agent_name.downcase=="unknown"
      end
    rescue Exception => err
      puts err
    end
  end

  def memo_original_url
    session[:o_uri] = request.request_uri unless request.request_uri =~ /\/login/
  end

  def admin_authorize
    unless Admin.find_by_id(session[:admin_id])
      flash[:notice] = "请登录"
      memo_original_url()
      redirect_to( :controller => "admin_login" , :action => "login")
    else
      redirect_to "/noright.htm" unless right_check
    end
  end

  def right_check
    model=self.controller_name
    flag = Right.check(session_admin,model,self.action_name)
    #save_operation_log(session_admin.id,model,self.action_name,flag)
    flag
  end

  def save_operation_log(admin_id,model,action,flag)
    log=OperationLog.new
    log.admin_id=admin_id
    log.model=model
    log.action=action
    log.object_id=params[:id]
    log.allow=flag
    log.save
  end

  def shop_authorize
    shop_login_by_imei
    unless Shop.find_by_id(session[:shop_id])
      flash[:notice] = "请登录"
      memo_original_url()
      redirect_to( :controller => "shop_login" , :action => "login")
    end
  end

  def shop_space_authorize_right
    shop_authorize
    controller = self.controller_name
    action = self.action_name
    controllers1 = ['shop_articles', 'shop_photos', 'shop_comments', 'shop_recycle']
    controllers2 = ['shop_menus', 'shop_tuangous', 'shop_space_discounts', 'shop_space_actions', "friendly_links"]
    actions1 = ['index', 'show']
    if session_shop.shop_template and session_shop.shop_template.flag == 1
      if controllers1.include?(controller)
      elsif controllers2.include?(controller)
      redirect_to "/shop_space_index/noright/0" unless actions1.include?(action)
      else
      redirect_to "/shop_space_index/noright/0"
        end
      elsif session_shop.shop_template and session_shop.shop_template.flag == 2
      redirect_to "/shop_space_index/noright/0" if !controllers1.include?(controller) && !controllers2.include?(controller)
    end
  end

  def shop_login_by_imei
    return if params[:imei].nil?
    Sms.log request.user_agent
    #"Mozilla/4.0 (compatible; MSIE 6.0; Windows CE; IEMobile 6.12)"
    #"Nokia5800 XpressMusic/UCWEB7.3.2.58/50/999"
    if(ENV["RAILS_ENV"] != "production" || request.user_agent.downcase.index("ucweb") || request.user_agent.downcase.index("iemobile") )
      shop = Shop.find_by_imei(params[:imei])
      unless shop.nil?
        session[:shop_id] = shop.id
        session[:shop_phone] = shop.phone
      else
        ss = Subshop.find_by_imei(params[:imei])
        unless ss.nil?
          session[:shop_id] = ss.shop_id
          session[:shop_phone] = ss.phone
        end
      end
    end
  end

  def shop_login_redirect(shop)
    session[:shop_id] = shop.id
    uri = session[:o_uri]
    session[:o_uri] = nil
    redirect_to( uri || {:controller => shop.shop_template_id.blank? ? "shop_login" : "shop_space_index", :action => "index"} )
  end

  def shuizhonghua
    if params[:id]
      @discount = Discount.find(params[:id])
      redirect_to( "http://www.1045ladio.com/") if (@discount && (@discount.name=='水中花150元现金券' || @discount.name=='水中花100元现金券'))
    end
  end

  def ksfmffsdg
    redirect_to( "/discountslist/show/"+PushDiscount.find(:last).discount_id.to_s) if (params[:id] && PushDiscount.find(:last) && params[:id] == PushDiscount.find(:last).discount_id.to_s)
  end

  def user_authorize
    if session_user.nil?
      flash[:notice] = "请登录"
      memo_original_url()
      redirect_to( :controller => "user_login" , :action => "login")
    end
  end

  def user_phone_confirmed
    unless session_user.confirmed?
      memo_original_url()
      redirect_to( :controller => "user_reg" , :action => "doconfirm")
    end
  end

  def user_login_redirect(user)
    session[:user_id] = user.id
    uri = session[:o_uri]
    session[:o_uri] = nil
    redirect_to( uri || {:controller => "user_login", :action => "index"} )
  end

  def session_user
    u=User.find_by_id(session[:user_id])
    u
  end

  def session_shop
    shop = Shop.find_by_id(session[:shop_id])
    return shop
  end

  def session_admin
    Admin.find_by_id(session[:admin_id])
  end

  def dyn_layout
    if session[:user_id]
      "user"
    elsif  session[:shop_id]
      "shop"
    elsif   session[:admin_id]
      "admin"
    else
      ""
    end
  end

  class TransactionFilter
    def filter(controller)
      return yield if controller.request.get?
      ActiveRecord::Base.transaction do
        yield
      end
    end
  end


  def transaction_filter(&block)
    TransactionFilter.new.filter(self, &block)
  end

  def to_pail(balance)
    (balance/Qdhbeer::QIANDAOHU_BEER_PRICE).to_i
  end

  #around_filter :transaction_filter


  def has_value(s)
    if s.nil?
      false
    elsif s.empty?
      false
    else
      true
    end
  end

  def is_radio107?
    true if session[:shop_id].to_s == "187"
    #    true if session[:shop_id].to_s == "152"
  end

  def change_other_user_phone_status(user)
    u = User.find(:first,:conditions => ["phone = ? and confirmed = true and id != ? ", user.phone,user.id])
    unless u.nil?
      if u.auto_register?
        u.update_attributes!( {:confirmed => false} )
        #TODO 最好将自动注册用户的下载和消费记录转移到新的帐号上，然后删除老的账户
      else
        u.update_attributes!( {:confirmed => false} )
      end
    end
  end


  def dooo_captcha_valid?
    return true if RAILS_ENV == 'test'
    if params[:captcha]
      return session[:captcha] == params[:captcha].strip.upcase
    else
      return false
    end
  end

def redirect_mobile(url = "http://m.1dooo.com")
  redirect_to url if /android.+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.match(request.user_agent) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-/i.match(request.user_agent[0..3])
end

  # before_filter :host_redirect_1dooo
  def self.env_layout(options={})
    if ENV["RAILS_ENV"] == "development"
#      layout "shop_space2", options
      layout "shop_space", options
    elsif ENV["RAILS_ENV"] == "production"
      layout "shop_space", options
    end
  end

  def host_redirect_1dooo
    return if "shop_space"==self.controller_name || "user_login"==self.controller_name || "user_login_by_phone"==self.controller_name || "user_reg"==self.controller_name || "user_like" == self.controller_name || "util" == self.controller_name || "seventh" == self.controller_name
    return if ENV["RAILS_ENV"] != "production"
    redirect_to request.url.sub(request.host,"www.1dooo.com") if (request.host!="www.1dooo.com" && request.host!="60.191.119.190")
  end

end

