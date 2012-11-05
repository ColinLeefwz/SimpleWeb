CarrierWave.configure do |config|
  config.storage = :aliyun
  config.aliyun_access_id = "sc1zhg0deulbspm7cmcns0um"
  config.aliyun_access_key = '26T2lFww3gsd+0OY8DsSFXj1eQ8='
  # you need create this bucket first!
  #config.aliyun_bucket = "dface"
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