class Video < ActiveRecord::Base

  Attributes = {video_attributes: [:id, :cover, :SD_file_name, :SD_content_type, :SD_file_size, :SD_temp_path,  :HD_file_name, :HD_content_type, :HD_file_size, :HD_temp_path]}
  attr_accessor :SD_temp_path, :HD_temp_path

  belongs_to :videoable, polymorphic: true

  has_attached_file :cover
  has_attached_file :SD, path: ":class/:id/:attachment/:filename", default_url: ""
  has_attached_file :HD, path: ":class/:id/:attachment/:filename", default_url: ""

  after_initialize :get_current_path
  after_save :sd_paperclip_path, if: ->{@SD_temp_path.present?}
  after_save :hd_paperclip_path, if: ->{@HD_temp_path.present?}


  def available?
    self.SD_file_name.present? || self.HD_file_name.present?
  end


  private
  def get_current_path
    @SD_current_path = /videos\/\d+\/sds\/.+/.match CGI.unescape(self.SD.url)
    @HD_current_path = /videos\/\d+\/hds\/.+/.match CGI.unescape(self.HD.url)
  end

  
  #todo: add Exception Handle
  def sd_paperclip_path
    @bucket ||= AWS::S3.new.buckets[ENV["AWS_BUCKET"]]
    @bucket.objects[@SD_current_path].delete if @SD_current_path.present?

    expect_path = "videos/#{self.id}/sds/#{self.SD_file_name}"
    copy_and_delete(@SD_temp_path, expect_path)
  end


  def hd_paperclip_path
    @bucket ||= AWS::S3.new.buckets[ENV["AWS_BUCKET"]]
    @bucket.objects[@HD_current_path].delete if @HD_current_path.present?
    
    expect_path = "videos/#{self.id}/hds/#{self.HD_file_name}"
    copy_and_delete(@HD_temp_path, expect_path)
  end


  # helper methods
  def copy_and_delete(temp_path, expect_path)
    temp_path = chop_bucket CGI.unescape(temp_path)

    temp = @bucket.objects[temp_path]
    expect = @bucket.objects[expect_path]

    temp.copy_to(expect)
    temp.delete
  end

  def chop_bucket(path)
    return nil if path.blank?

    path = path.split("/")
    2.times{ path.shift() }
    path = path.join("/")
  end
end

