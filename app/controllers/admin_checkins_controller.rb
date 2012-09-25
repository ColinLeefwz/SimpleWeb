class AdminCheckinsController < ApplicationController
  include Paginate
  before_filter :admin_authorize
  layout "admin"

  def index
    hash = {}
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

    unless params[:shop].blank?
      sids = Shop.where({name: /#{params[:shop]}/}).map { |m| m._id  }
      hash.merge!(sid: {'$in' => sids})
    end

    hash.merge!(ip: /#{params[:ip]}/) unless params[:ip].blank?
    hash.merge!({ loc: { "$within" => { "$center" => [params[:loc], 0.1]} }}) unless params[:loc].blank?
    
    @checkins = paginate("Checkin", hash, sort , params[:page],20  )
  end
end