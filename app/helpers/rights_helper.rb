module RightsHelper
  
  def model_select
    File.open(lang_file) do |yf|
      ms = YAML::load(yf)["zh-CN"]["activerecord"]["models"].sort
      ms.map{|m| m.reverse! }
    end
  end
  
  def lang_file
    if ENV["RAILS_ENV"] == "production"
      '/home/dooo/lianlian/config/locales/zh-CN.yml'
    else
      './config/locales/zh-CN.yml'
    end
  end
  
  def operation_select
    #[['all',"全部"],['readonly',"只读"],['edit',"编辑"],['destroy',"删除"]]
    ['all','readonly','new','edit','destroy']
  end

  
  
end
