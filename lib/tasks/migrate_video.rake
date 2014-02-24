
task :migrate_videos => :environment do
  s3 = AWS::S3.new
  bucket = s3.buckets[ENV["AWS_BUCKET"]]

  video_types = %w(VideoInterview Announcement IntroVideo).freeze

  video_types.each do |type|

    (type.constantize).all.each do |t|

      if t.is_a? IntroVideo
        video = Video.new
        video.videoable_type = t.introable_type
        video.videoable_id = t.introable_id
      else
        video = t.build_video
      end

      video.SD_file_name = t.attached_video_sd_file_name
      video.SD_content_type = t.attached_video_sd_content_type 
      video.SD_file_size = t.attached_video_sd_file_size 
      video.SD_updated_at = t.attached_video_sd_updated_at 

      video.HD_file_name = t.attached_video_hd_file_name 
      video.HD_content_type = t.attached_video_hd_content_type 
      video.HD_file_size = t.attached_video_hd_file_size 
      video.HD_updated_at = t.attached_video_hd_updated_at 

      video.cover_file_name = t.cover_file_name 
      video.cover_content_type = t.cover_content_type 
      video.cover_file_size = t.cover_file_size 
      video.cover_updated_at = t.cover_updated_at 

      video.save

      # SD Video
      current_sd_path = /#{t.to_s.underscore.pluralize}\/.+/.match CGI.unescape(t.sd_url || "")
      current_sd_object = bucket.objects[current_sd_path]
      expect_sd_path = "videos/#{video.id}/sds/#{video.SD_file_name}"
      expect_sd_object = bucket.objects[expect_sd_path]
      current_sd_object.copy_to expect_sd_object if (current_sd_path.present? && current_sd_object.exists?)

      # HD Video
      current_hd_path = /#{t.to_s.underscore.pluralize}\/.+/.match CGI.unescape(t.hd_url || "")
      current_hd_object = bucket.objects[current_hd_path]
      expect_hd_path = "videos/#{video.id}/hds/#{video.HD_file_name}"
      expect_hd_object = bucket.objects[expect_hd_path]
      current_hd_object.copy_to expect_hd_object if (current_hd_path.present? && current_hd_object.exists?)

      # Cover
      current_cover_path = /#{t.to_s.underscore.pluralize}\/covers\/.+/.match CGI.unescape(t.cover.url || "")
      current_cover_object = bucket.objects[current_cover_path]
      expect_cover_path = "videos/covers/#{video.id}/original/#{video.cover_file_name}"
      expect_cover_object = bucket.objects[expect_cover_path]
      current_cover_object.copy_to expect_cover_object if (current_cover_path.present? && current_cover_object.exists?)
    end
  end
end


task :migrate_sections => :environment do 
  s3 = AWS::S3.new
  bucket = s3.buckets[ENV["AWS_BUCKET"]]

  Section.all.each do |section|
    sd_resource = Resource.find_by(section_id: section.id, video_definition: "SD")
    if sd_resource.present?
      video = Video.new
      video.videoable_type = "Section"
      video.videoable_id = section.id
      video.SD_file_name = sd_resource.attached_file_file_name
      video.SD_content_type = sd_resource.attached_file_content_type
      video.SD_file_size = sd_resource.attached_file_file_size
      video.SD_updated_at = sd_resource.attached_file_updated_at
      video.save

      current_sd_path = /resources\/attached_files\/.+/.match CGI.unescape(sd_resource.attached_file.url || "")
      current_sd_object = bucket.objects[current_sd_path]
      expect_sd_path = "videos/#{video.id}/sds/#{video.SD_file_name}"
      expect_sd_object = bucket.objects[expect_sd_path]
      current_sd_object.copy_to expect_sd_object if (current_sd_path.present? && current_sd_object.exists?)
    end


    hd_resource = Resource.find_by(section_id: section.id, video_definition: "HD")
    if hd_resource.present?
      video = Video.new
      video.videoable_type = "Section"
      video.videoable_id = section.id
      video.HD_file_name = hd_resource.attached_file_file_name
      video.HD_content_type = hd_resource.attached_file_content_type
      video.HD_file_size = hd_resource.attached_file_file_size
      video.HD_updated_at = hd_resource.attached_file_updated_at
      video.save

      current_hd_path = /resources\/attached_files\/.+/.match CGI.unescape(hd_resource.attached_file.url || "")
      current_hd_object = bucket.objects[current_hd_path]
      expect_hd_path = "videos/#{video.id}/hds/#{video.HD_file_name}"
      expect_hd_object = bucket.objects[expect_hd_path]
      current_hd_object.copy_to expect_hd_object if (current_hd_path.present? && current_hd_object.exists?)
    end
    
  end
end

