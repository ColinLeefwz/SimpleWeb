# coding: utf-8
#用户设备

class UserDsStat
  include Mongoid::Document
  field :_id , type: Date
  field :data, type: Hash #{"360" : 17, xiaomi" : 2}

  def self.ds_stat(day_ago = 1)
    day_ago.downto(1) do |ag|

	  	time = Time.now - ag.days
	  	begin_id = time.beginning_of_day.to_i.to_s(16).ljust(24, '0')
	  	end_id = time.end_of_day.to_i.to_s(16).ljust(24, '0')
	  	data ={}
	  	UserDevice.where({_id: {"$gte" => begin_id, "$lte" => end_id}}).sort(_id: -1).each do |ud|
	  		ds = ud.ds.first
	  		next if ud.user.head_logo_id.blank?
	  		next if ds.nil?
	  		next if ds.length <= 4
	  		data[ds.last] = (data[ds.last]||0) +1
	  	end
	  	user_ds_stat = UserDsStat.new(data: data)
	  	user_ds_stat._id = time.to_date
	  	user_ds_stat.save
  	end
  end


end
