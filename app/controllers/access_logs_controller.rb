class AccessLogsController < ApplicationController
  before_filter :admin_authorize
  layout "admin"
  def initialize
    @menu_tag_id = 9
  end

  def index
    @access_logs = AccessLog.paginate(:all,:conditions => genCondition, :order => genOrder,:page => params[:page], :per_page =>100)
  end

  def show
    @delete_log = DeleteLog.find(params[:id])
  end


  private
  def genCondition
    s = ""
    h = Hash.new
    s_a = " and"
    if has_value params[:admin_id]
      s << " admin_id = :admin_id"
      h[:admin_id] = params[:admin_id]
      s << s_a
    end
    if has_value params[:shop_id]
      s << " shop_id = :shop_id"
      h[:shop_id] = params[:shop_id]
      s << s_a
    end
    if has_value params[:user_id]
      s << " user_id = :user_id"
      h[:user_id] = params[:user_id]
      s << s_a
    end
    if has_value params[:url]
      s << " (url like :url)"
      h[:url] = "%#{params[:url]}%";
      s << s_a
    end
    if has_value params[:agent_os]
      s << " agent_os like :agent_os "
      h[:agent_os] = "%#{params[:agent_os]}%"
      s << s_a
    end
    if has_value params[:referer]
      s << " (referer like :referer)"
      h[:referer] = "%#{params[:referer]}%";
      s << s_a
    end
    if has_value params[:ip]
      s << " (ip like :ip)"
      h[:ip] = "%#{params[:ip]}%";
      s << s_a
    end

    if has_value params[:beginday]
      s << " time >= :beginday"
      h[:beginday] = Date.parse params[:beginday]
      s << s_a
    end
    if has_value params[:endday]
      s << " time <= :endday"
      h[:endday] = Date.parse params[:endday]
      s << s_a
    end
    [s.gsub(/ and$/, ''), h]
  end

  def genOrder
    "created_at desc"
  end

end
