class AdminCheckinsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {del: {"$exists" => false}}
    sort = {_id: -1}
    
    unless params[:start_at].blank?
      bobjectid = Time.parse(params[:start_at]).to_i.to_s(16).ljust(24,'0')
      hash.merge!(_id: {'$gt' => bobjectid})
    end

    unless params[:end_at].blank?
      eobjectid = Time.parse(params[:end_at]).end_of_day.to_i.to_s(16).ljust(24,'0')
      hash[:_id] ||= {}
      hash[:_id].merge!({'$lt' => eobjectid})
    end

    unless params[:user].blank?
      uids = User.where({name: /#{params[:user]}/}).map { |m| m._id  }
      hash.merge!(uid: {'$in' => uids})
    end

    unless params[:shop].blank? && params[:city].blank?
      sids = Shop.where({name: /#{params[:shop]}/, city: params[:city]}).map { |m| m._id  }
      hash.merge!(sid: {'$in' => sids})
    end

    hash.merge!({uid: params[:uid]})unless params[:uid].blank?
    
    unless params[:acc].blank?
      accs =  params[:acc].split(' ')
      if accs.count ==2
        hash.merge!({acc: {"$gte" => accs[0].to_i, "$lte" => accs[1].to_i }})
      else
        hash.merge!(acc: accs[0].to_i)
      end
    end

    unless params[:od].blank?
      ods =  params[:od].split(' ')
      if ods.count ==2
        hash.merge!({od: {"$gte" => ods[0].to_i, "$lte" => ods[1].to_i }})
      else
        hash.merge!(od: ods[0].to_i)
      end
    end


    hash.merge!(ip: /#{params[:ip]}/) unless params[:ip].blank?
    hash.merge!({sid: params[:sid]}) unless params[:sid].blank?

    unless params[:loc].blank?
      lo = params[:loc].split(',')
      hash.merge!({ lo: { "$within" => { "$center" => [lo, 0.1]} }}) if lo.length == 2
    end
    
    @checkins = paginate3("Checkin", params[:page], hash, sort  )
  end

  def show
    @checkin = Checkin.find(params[:id])
  end

  def ajaxbind
    checkin = Checkin.find(params[:id])
    ckb = CheckinBssidStat.new
    ckb._id = checkin.bssid
    ckb.shop_id = checkin.sid
    ckb.save
    render :json => {}
  end

  def ajaxdel
    @checkin = Checkin.find(params[:id])
    @checkin.update_attribute(:del, true)
    render :json => {}
  end
end