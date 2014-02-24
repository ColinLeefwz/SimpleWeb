class Video < ActiveRecord::Base
  belongs_to :videoable, polymorphic: true

  has_attached_file :cover
  has_attached_file :SD, path: ":class/:id/:attachment/:filename", default_url: ""
  has_attached_file :HD, path: ":class/:id/:attachment/:filename", default_url: ""

  after_initialize :get_current_path
  before_save :get_temp_path
  after_save :paperclip_path

  private
  def get_current_path
    @SD_current_path = /videos\/\d+\/sds\/.+/.match CGI.unescape(self.SD.url)
    @HD_current_path = /videos\/\d+\/hds\/.+/.match CGI.unescape(self.HD.url)
  end


  def get_temp_path
    @SD_temp_path = chop_bucket CGI.unescape(self.SD_temp_path || "")
    @HD_temp_path = chop_bucket CGI.unescape(self.HD_temp_path || "")

    self.SD_temp_path, self.HD_temp_path = nil, nil
  end

  def chop_bucket(path)
    return nil if path.blank?

    path = path.split("/")
    2.times{ path.shift() }
    path = path.join("/")
  end



  #todo: add Exception Handle
  def paperclip_path
    @bucket = AWS::S3.new.buckets[ENV["AWS_BUCKET"]]
    #SD
    if @SD_temp_path.present?
      @bucket.objects[@SD_current_path].delete if @SD_current_path.present?

      expect_path = "videos/#{self.id}/sds/#{self.SD_file_name}"
      copy_and_delete(@SD_temp_path, expect_path)
    end

    #HD
    if @HD_temp_path.present?
      @bucket.objects[@HD_current_path].delete if @HD_current_path.present?

      expect_path = "videos/#{self.id}/hds/#{self.HD_file_name}"
      copy_and_delete(@HD_temp_path, expect_path)
    end
  end


  def copy_and_delete(temp_path, expect_path)
    temp = @bucket.objects[temp_path]
    expect = @bucket.objects[expect_path]

    temp.copy_to(expect)
    temp.delete
  end
end

