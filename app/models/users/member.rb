class Member < User
  def delete(object)
    object.destroy
  end

  def tutorial_video_sd_url
    if self.is_a? Expert
      return "https://s3-us-west-1.amazonaws.com/prodygia-videos/videos/62/sds/tutorial_expert_dashboard_kbps600.mp4"
    else
      return "https://s3-us-west-1.amazonaws.com/prodygia-videos/videos/61/sds/tutorial_member_dashboard_kbps600.mp4"
    end
  end

  def tutorial_video_hd_url
    if self.is_a? Expert
      return "https://s3-us-west-1.amazonaws.com/prodygia-videos/videos/62/hds/tutorial_expert_dashboard.mp4"
    else
      return "https://s3-us-west-1.amazonaws.com/prodygia-videos/videos/61/hds/tutorial_member_dashboard.mp4"
    end
  end

end
