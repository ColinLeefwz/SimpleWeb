CarrierWave.configure do |config|
  config.storage = :aliyun
  if ENV["RAILS_ENV"] != "production"
    config.aliyun_access_id = "sc1zhg0deulbspm7cmcns0um"
    config.aliyun_access_key = '26T2lFww3gsd+0OY8DsSFXj1eQ8='
  else
    # 发布环境的阿里云id和key, 不保存在版本控制系统中
    config.aliyun_access_id = ENV["ALIYUN_ACCESS_ID"]
    config.aliyun_access_key = ENV["ALIYUN_ACCESS_KEY"]
  end
end

module CarrierWave
  module MiniMagick
    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end
  end
end

CarrierWave::Backgrounder.configure do |c|
  # :delayed_job, :girl_friday, :sidekiq, :qu, :resque, or :qc
  c.backend = :resque
end