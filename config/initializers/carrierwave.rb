require "rest-client"

module CarrierWave
  module Storage
    class Aliyun < Abstract
      
      class Connection
        
        def get(path)
          url = path_to_url(format_path(path))
          RestClient.get(url)
        end
      end
      
      class File
        def read
          oss_connection.get(@path)
        end

        def content_type
          "image/jpg"
        end
        
        def url
          "http://oss.aliyuncs.com/#{@uploader.aliyun_bucket}/#{@path}"
        end
        
      end
    end
  end
end      
          
CarrierWave.configure do |config|
  config.storage = :aliyun
  if ENV["RAILS_ENV"] != "production"
    config.aliyun_access_id = "sc1zhg0deulbspm7cmcns0um"
    config.aliyun_access_key = '26T2lFww3gsd+0OY8DsSFXj1eQ8='
  else
    # 发布环境的阿里云id和key, 不保存在版本控制系统中
    config.aliyun_access_id = ENV["ALIYUN_ACCESS_ID"]
    config.aliyun_access_key = ENV["ALIYUN_ACCESS_KEY"]
    config.aliyun_internal = true
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