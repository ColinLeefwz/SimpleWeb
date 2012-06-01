class Right < ActiveRecord::Base
  
  def admin
    Admin.find_by_id(admin_id)
  end

  def admin_name
    return "" if admin_id.nil?
    admin.name
  end
 
  def depart
    Depart.find_by_id(depart_id)
  end

  def depart_name
    return "" if depart_id.nil?
    depart.name
  end

  def role_name
    return "" if role_id.nil?
    role.name
  end

  def role
    Role.find_by_id(role_id)
  end 
  
  #  def self.extra_models
  #	[['团购销售数据','tuangou_datas']]
  #  end

  def model_name(s)
    #    Right.extra_models.each do |x|
    #     return x[0] if s==x[1]
    #    end
    begin
      eval("#{s.singularize.camelcase}.human_name")
    rescue   Exception => error
      ""
    end
  end

  def tables_s
    self.tables.split(";")
  end

  def model_names
    File.open(lang_file) do |yf|
      ms = YAML::load(yf)["zh-CN"]["activerecord"]["models"]
      tables_s.map{|x| ms[x]}.join(";")
    end
  end

  def lang_file
    if ENV["RAILS_ENV"] == "production"
      '/home/dooo/lianlian/config/locales/zh-CN.yml'
    else
      './config/locales/zh-CN.yml'
    end
  end

  def model_names_trim
    
    ret = model_names.mb_chars
    return ret if ret.length<30
    ret[0,30]+"..."
  end  

  def self.operation_name(action)
    if action=="new" || action=="create"
      return "new"
    elsif action=="edit" || action=="update"
      return "edit"
    elsif action=="destroy" || action=="delete"
      return "destroy" 
    else
      return "readonly" 
    end               
  end
  
  def self.check(user,model,action)
    return true if user.name=='root'
    matched=false
    Right.find(:all).each do |r|
      matched=true unless r.tables_s.index(model).nil?
      user_matched=false
      if r.admin
        user_matched=true if r.admin==user
      else
        if r.depart_id.nil? || r.depart == user.depart
          if r.role_id.nil? || user.roles.find_by_id(r.role.id)
            user_matched=true
          end
        end
      end
      if user_matched
        unless r.tables_s.index(model).nil?
          return true if (r.operate == "all" || r.operate == operation_name(action) )
        end
      end
    end
    return !matched
  end
      
end
