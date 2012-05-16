module RightsHelper
  
  def model_select
    File.open(lang_file) do |yf|
      yaml=YAML::load(yf)
      ms = yaml["zh-CN"]["activerecord"]["models"].sort
      ms.each do |m|
        begin
		m[1]=eval("#{m[0].camelcase}.human_name")
        rescue   Exception => error
		next
        end
        m[0]=m[0].pluralize
        m.reverse!
      end
#      Right.extra_models.each {|x| ms << x}
      ms
    end
  end
  
  def lang_file
    if ENV["RAILS_ENV"] == "production"
      '/home/dooo/bodu_server/config/locales/zh-CN.yml'
    else
      './config/locales/zh-CN.yml'
    end
  end
  
  def operation_select
    #[['all',"全部"],['readonly',"只读"],['edit',"编辑"],['destroy',"删除"]]
    ['all','readonly','new','edit','destroy']
  end
  
  
end
