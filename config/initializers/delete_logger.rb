class ActiveRecord::Base
  
  def before_destroy
    return if self.class.name=='SimpleCaptchaData' || self.class.name=='DeleteLog'
    dlog=DeleteLog.new
    dlog.object_id=self.id
    dlog.model=self.class.name
    dlog.yaml=self.to_yaml
    dlog.save
  end

  @@null_obj = Object.new
  def @@null_obj.name
	return ""
  end

  def admin
	return nil unless self.respond_to? "admin_id"
	return @@null_obj if self.admin_id.nil?
	return Admin.find(self.admin_id)
  end

end